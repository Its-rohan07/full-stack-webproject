-- ShopEase Database Schema
-- ICT203 Assessment 3
-- Import this file via phpMyAdmin or MySQL CLI

CREATE DATABASE IF NOT EXISTS shopease CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE shopease;

-- =====================
-- USERS TABLE
-- =====================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin', 'customer') NOT NULL DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =====================
-- PRODUCTS TABLE
-- =====================
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_qty INT NOT NULL DEFAULT 0,
    category VARCHAR(100),
    image_url VARCHAR(255) DEFAULT 'placeholder.png',
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL
);

-- =====================
-- ORDERS TABLE
-- =====================
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    status ENUM('pending', 'confirmed', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    total_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (updated_by) REFERENCES users(user_id) ON DELETE SET NULL
);

-- =====================
-- ORDER ITEMS TABLE
-- =====================
CREATE TABLE order_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT
);

-- =====================
-- ACTIVITY LOG TABLE
-- =====================
CREATE TABLE activity_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(100) NOT NULL,
    entity VARCHAR(50),
    entity_id INT,
    details TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- =====================
-- FAQ KNOWLEDGE BASE (AI Feature)
-- =====================
CREATE TABLE faq_kb (
    faq_id INT AUTO_INCREMENT PRIMARY KEY,
    question VARCHAR(255) NOT NULL,
    answer TEXT NOT NULL,
    category VARCHAR(100),
    keywords VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================
-- SEED DATA
-- =====================

-- Demo Users (passwords: Admin@123 and User@123)
INSERT INTO users (name, email, password_hash, role) VALUES
('Admin User', 'admin@shopease.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin'),
('John Customer', 'user@shopease.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'customer');
-- Note: Above hashes are for 'password' — update with correct hashes in production.
-- To generate: php -r "echo password_hash('Admin@123', PASSWORD_DEFAULT);"

-- Sample Products
INSERT INTO products (name, description, price, stock_qty, category, created_by) VALUES
('Wireless Headphones', 'Premium noise-cancelling over-ear headphones with 30hr battery life.', 129.99, 25, 'Electronics', 1),
('Running Shoes', 'Lightweight mesh running shoes with cushioned sole. Available in multiple sizes.', 89.99, 40, 'Footwear', 1),
('Coffee Maker', 'Programmable 12-cup drip coffee maker with thermal carafe.', 59.99, 15, 'Kitchen', 1),
('Yoga Mat', 'Non-slip 6mm thick exercise mat with carrying strap.', 34.99, 30, 'Sports', 1),
('Backpack', '30L waterproof daypack with laptop compartment.', 49.99, 20, 'Bags', 1),
('Desk Lamp', 'LED adjustable desk lamp with USB charging port.', 39.99, 18, 'Electronics', 1);

-- FAQ Knowledge Base Entries
INSERT INTO faq_kb (question, answer, category, keywords) VALUES
('How do I place an order?', 'Browse our catalogue, click "Add to Cart" on a product, review your cart and click "Place Order". You will receive a confirmation on screen.', 'Orders', 'order place buy purchase cart'),
('How can I track my order?', 'Log in to your account and go to "My Orders". You will see the current status of each order: Pending, Confirmed, Shipped, or Delivered.', 'Orders', 'track order status shipping'),
('Can I cancel my order?', 'Orders can be cancelled while they are in "Pending" status. Go to My Orders and click the Cancel button. Once shipped, cancellation is not possible.', 'Orders', 'cancel order refund'),
('What is your return policy?', 'We accept returns within 30 days of delivery for unused items in original packaging. Contact our support team to initiate a return.', 'Returns', 'return refund policy exchange'),
('How do I create an account?', 'Click "Register" at the top of the page. Fill in your name, email, and a secure password. You will be logged in immediately after registration.', 'Account', 'register account sign up create'),
('I forgot my password. What do I do?', 'On the login page, click "Forgot Password" and enter your registered email. You will receive a reset link.', 'Account', 'forgot password reset login'),
('What payment methods do you accept?', 'We currently accept credit/debit cards and bank transfers. Payment is processed securely at checkout.', 'Payment', 'payment method card bank transfer'),
('How long does shipping take?', 'Standard shipping takes 3-5 business days. Express shipping (1-2 days) is available at checkout for an additional fee.', 'Shipping', 'shipping delivery time days'),
('Is my personal data safe?', 'Yes. We use secure encryption for all data and never share your personal information with third parties. See our Privacy Policy for details.', 'Privacy', 'data privacy security personal information'),
('How do I update my account details?', 'Log in and go to your Profile page. You can update your name and email there. For password changes, use the Change Password option.', 'Account', 'update profile account details edit'),
('Do you offer bulk discounts?', 'Yes! For orders over 10 units of the same product, contact us for a custom quote. Admin can apply discounts to your account.', 'Pricing', 'bulk discount wholesale pricing'),
('What if an item is out of stock?', 'Out-of-stock items are marked on the catalogue. You can check back later as stock is regularly updated by our admin team.', 'Products', 'out of stock availability'),
('How do I contact support?', 'Use the Help Assistant on any page, or email us at support@shopease.com. Our team responds within 1 business day.', 'Support', 'contact support help email'),
('Can I change my order after placing it?', 'Order modifications are not currently supported through the portal. Please contact support immediately and we will assist if the order is still pending.', 'Orders', 'change modify order edit'),
('Are prices inclusive of tax?', 'All displayed prices are inclusive of GST. No additional charges are added at checkout beyond any chosen shipping options.', 'Pricing', 'tax gst price inclusive');
