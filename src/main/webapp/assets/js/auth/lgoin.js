document.addEventListener('DOMContentLoaded', function() {
    const loginForm = document.querySelector('.login-form');
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const togglePassword = document.querySelector('.toggle-password');

    // Toggle password visibility
    togglePassword.addEventListener('click', function() {
        const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordInput.setAttribute('type', type);

        // Toggle the text
        this.textContent = type === 'password' ? 'Show' : 'Hide';
    });

    // Simple validation function
    function validateEmail(email) {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(email);
    }

    // Form submission
    loginForm.addEventListener('submit', function(e) {
        // Reset error messages
        resetErrors();

        // Validate inputs
        let isValid = true;

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
        }

        // If validation fails, prevent form submission
        if (!isValid) {
            e.preventDefault();
        } else {
            // Show loading state
            const loginBtn = document.querySelector('.login-btn');
            loginBtn.textContent = 'Signing in...';
            loginBtn.disabled = true;
        }
    });

    // Display error message
    function displayError(input, message) {
        const formGroup = input.parentElement;
        const errorMessage = document.createElement('p');
        errorMessage.className = 'error-message';
        errorMessage.textContent = message;
        formGroup.appendChild(errorMessage);

        input.style.borderColor = '#e53935';
    }

    // Reset all error messages
    function resetErrors() {
        const errorMessages = document.querySelectorAll('.error-message');
        errorMessages.forEach(error => error.remove());

        const inputs = [emailInput, passwordInput];
        inputs.forEach(input => {
            input.style.borderColor = 'rgba(0, 0, 0, 0.15)';
        });
    }
});
