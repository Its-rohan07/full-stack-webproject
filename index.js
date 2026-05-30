// validation.js — Client-side form validation
// ShopEase | ICT203 Assessment 3
// Uses Bootstrap 5 validation classes

document.addEventListener('DOMContentLoaded', function () {

    // Generic Bootstrap validation for all forms with novalidate
    const forms = document.querySelectorAll('form[novalidate]');
    forms.forEach(function (form) {
        form.addEventListener('submit', function (event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        });
    });

    // Extra: confirm password match on register form
    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        const password = document.getElementById('password');
        const confirm  = document.getElementById('confirm_password');

        confirm.addEventListener('input', function () {
            if (password.value !== confirm.value) {
                confirm.setCustomValidity('Passwords do not match.');
            } else {
                confirm.setCustomValidity('');
            }
        });
        password.addEventListener('input', function () {
            if (confirm.value && password.value !== confirm.value) {
                confirm.setCustomValidity('Passwords do not match.');
            } else {
                confirm.setCustomValidity('');
            }
        });
    }

    // Extra: price must be > 0 on product form
    const priceInput = document.getElementById('price');
    if (priceInput) {
        priceInput.addEventListener('input', function () {
            if (parseFloat(this.value) <= 0) {
                this.setCustomValidity('Price must be greater than zero.');
            } else {
                this.setCustomValidity('');
            }
        });
    }

    // Extra: quantity must not exceed max on order form
    const qtyInput = document.getElementById('quantity');
    if (qtyInput) {
        qtyInput.addEventListener('input', function () {
            const max = parseInt(this.getAttribute('max'));
            const val = parseInt(this.value);
            if (val > max) {
                this.setCustomValidity(`Max available stock is ${max}.`);
            } else if (val < 1) {
                this.setCustomValidity('Quantity must be at least 1.');
            } else {
                this.setCustomValidity('');
            }
        });
    }
});
