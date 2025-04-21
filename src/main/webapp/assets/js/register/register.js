document.addEventListener('DOMContentLoaded', function() {
    const registerForm = document.querySelector('.register-form');
    const usernameInput = document.getElementById('username');
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const termsCheckbox = document.getElementById('terms');
    const strengthBar = document.querySelector('.strength-bar');
    const strengthText = document.querySelector('.strength-text');
    const togglePasswordBtns = document.querySelectorAll('.toggle-password');

    // Toggle password visibility
    togglePasswordBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            const passwordField = this.previousElementSibling;
            const type = passwordField.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordField.setAttribute('type', type);

            // Toggle the text
            this.textContent = type === 'password' ? 'Show' : 'Hide';
        });
    });

    passwordInput.addEventListener('input', checkPasswordStrength);

    function checkPasswordStrength() {
        const password = passwordInput.value;
        let strength = 0;

        if (password.length >= 8) strength++;
        if (password.match(/([a-z].*[A-Z])|([A-Z].*[a-z])/)) strength++;
        if (password.match(/[0-9]/)) strength++;
        if (password.match(/[!,%,&,@,#,$,^,*,?,_,~]/)) strength++;

        const styles = [
            { width: '0%', color: '#e0e0e0', text: 'Password strength' },
            { width: '25%', color: '#e53935', text: 'Weak' },
            { width: '50%', color: '#ff9800', text: 'Fair' },
            { width: '75%', color: '#fdd835', text: 'Good' },
            { width: '100%', color: '#4caf50', text: 'Strong' }
        ];

        strengthBar.style.width = styles[strength].width;
        strengthBar.style.backgroundColor = styles[strength].color;
        strengthText.textContent = styles[strength].text;
    }

    confirmPasswordInput.addEventListener('input', function() {
        if (passwordInput.value && confirmPasswordInput.value) {
            if (passwordInput.value !== confirmPasswordInput.value) {
                displayError(confirmPasswordInput, 'Passwords do not match');
            } else {
                const errorMessage = confirmPasswordInput.parentElement.querySelector('.error-message');
                if (errorMessage) errorMessage.remove();
                confirmPasswordInput.style.borderColor = '#4caf50';
            }
        }
    });

    function validateEmail(email) {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(email);
    }

    registerForm.addEventListener('submit', function(e) {
        e.preventDefault(); // Prevent default submission initially
        resetErrors();
        let isValid = true;

        if (!usernameInput.value.trim()) {
            displayError(usernameInput, 'Username is required');
            isValid = false;
        }

        if (!emailInput.value) {
            displayError(emailInput, 'Email is required');
            isValid = false;
        } else if (!validateEmail(emailInput.value)) {
            displayError(emailInput, 'Please enter a valid email address');
            isValid = false;
        }

        if (!passwordInput.value) {
            displayError(passwordInput, 'Password is required');
            isValid = false;
        } else if (passwordInput.value.length < 8) {
            displayError(passwordInput, 'Password must be at least 8 characters');
            isValid = false;
        }

        if (!confirmPasswordInput.value) {
            displayError(confirmPasswordInput, 'Please confirm your password');
            isValid = false;
        } else if (passwordInput.value !== confirmPasswordInput.value) {
            displayError(confirmPasswordInput, 'Passwords do not match');
            isValid = false;
        }

        if (!termsCheckbox.checked) {
            displayError(termsCheckbox, 'You must agree to the Terms of Service');
            isValid = false;
        }

        // If form is valid, explicitly submit the form
        if (isValid) {
            registerForm.submit();
        }
    });

    function displayError(input, message) {
        const formGroup = input.parentElement;
        const existingError = formGroup.querySelector('.error-message');
        if (existingError) existingError.remove();

        const errorMessage = document.createElement('p');
        errorMessage.className = 'error-message';
        errorMessage.textContent = message;
        formGroup.appendChild(errorMessage);

        if (input !== termsCheckbox) {
            input.style.borderColor = '#e53935';
        }
    }

    function resetErrors() {
        const errorMessages = document.querySelectorAll('.error-message');
        errorMessages.forEach(error => error.remove());

        const inputs = [usernameInput, emailInput, passwordInput, confirmPasswordInput];
        inputs.forEach(input => {
            input.style.borderColor = 'rgba(0, 0, 0, 0.15)';
        });
    }

    // Function removed as we're now using server-side registration
});
