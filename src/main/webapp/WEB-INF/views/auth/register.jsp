<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - InsightHub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth/register.css">
</head>
<body>
<header>
    <div class="logo"><a href="${pageContext.request.contextPath}/index.jsp">InsightHub</a></div>
</header>

<main class="register-container">
    <div class="register-box">
        <h1>Join The InsightHub</h1>
        <p class="register-subtitle">Create an account to personalize your experience and start sharing your ideas.</p>

        <% if (request.getAttribute("error") != null) { %>
        <div class="error-message">
            <%= request.getAttribute("error") %>
        </div>
        <% } %>

        <form class="register-form" action="${pageContext.request.contextPath}/RegisterServlet" method="post" id="registerForm">
            <div class="form-group">
                <input type="text" id="username" name="username" placeholder="Username" required>
                <span class="error-text" id="username-error"></span>
            </div>
            <div class="form-group">
                <input type="email" id="email" name="email" placeholder="Email" required>
                <span class="error-text" id="email-error"></span>
            </div>
            <div class="form-group password-field">
                <input type="password" id="password" name="password" placeholder="Password (at least 8 characters)" required>
                <span class="toggle-password">Show</span>
                <div class="password-strength">
                    <div class="strength-bar"></div>
                    <span class="strength-text">Password strength</span>
                </div>
                <span class="error-text" id="password-error"></span>
            </div>
            <div class="form-group password-field">
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm password" required>
                <span class="toggle-password">Show</span>
                <span class="error-text" id="confirmPassword-error"></span>
            </div>
            <div class="form-group terms">
                <input type="checkbox" id="terms" required>
                <label for="terms">I agree to the <a href="#" class="terms-link">Terms of Service</a> and <a href="#" class="terms-link">Privacy Policy</a></label>
                <span class="error-text" id="terms-error"></span>
            </div>
            <button type="submit" class="register-btn">Create account</button>
        </form>

        <div class="login-prompt">
            <p>Already have an account? <a href="${pageContext.request.contextPath}/LoginServlet">Login</a></p>
        </div>
    </div>
    <div class="background-design">
        <div class="flower"></div>
        <div class="green-block"></div>
        <div class="hand"></div>
    </div>
</main>

<footer>
    <div class="footer-links">
        <a href="#">Help</a>
        <a href="#">Status</a>
        <a href="#">About</a>
        <a href="#">Blog</a>
        <a href="#">Privacy</a>
        <a href="#">Terms</a>
    </div>
</footer>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('registerForm');
        const username = document.getElementById('username');
        const email = document.getElementById('email');
        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirmPassword');
        const terms = document.getElementById('terms');

        // Toggle password visibility
        const toggleButtons = document.querySelectorAll('.toggle-password');
        toggleButtons.forEach(button => {
            button.addEventListener('click', function() {
                const passwordField = this.previousElementSibling;
                if (passwordField.type === 'password') {
                    passwordField.type = 'text';
                    this.textContent = 'Hide';
                } else {
                    passwordField.type = 'password';
                    this.textContent = 'Show';
                }
            });
        });

        // Password strength meter
        password.addEventListener('input', function() {
            const strengthBar = document.querySelector('.strength-bar');
            const strengthText = document.querySelector('.strength-text');
            const value = this.value;

            let strength = 0;
            if (value.length >= 8) strength += 1;
            if (value.match(/[a-z]+/)) strength += 1;
            if (value.match(/[A-Z]+/)) strength += 1;
            if (value.match(/[0-9]+/)) strength += 1;
            if (value.match(/[^a-zA-Z0-9]+/)) strength += 1;

            switch (strength) {
                case 0:
                    strengthBar.style.width = '0%';
                    strengthBar.style.backgroundColor = '#f00';
                    strengthText.textContent = 'Very Weak';
                    break;
                case 1:
                    strengthBar.style.width = '20%';
                    strengthBar.style.backgroundColor = '#f00';
                    strengthText.textContent = 'Weak';
                    break;
                case 2:
                    strengthBar.style.width = '40%';
                    strengthBar.style.backgroundColor = '#ff8c00';
                    strengthText.textContent = 'Fair';
                    break;
                case 3:
                    strengthBar.style.width = '60%';
                    strengthBar.style.backgroundColor = '#ffcc00';
                    strengthText.textContent = 'Good';
                    break;
                case 4:
                    strengthBar.style.width = '80%';
                    strengthBar.style.backgroundColor = '#9acd32';
                    strengthText.textContent = 'Strong';
                    break;
                case 5:
                    strengthBar.style.width = '100%';
                    strengthBar.style.backgroundColor = '#008000';
                    strengthText.textContent = 'Very Strong';
                    break;
            }
        });

        // Form validation
        form.addEventListener('submit', function(e) {
            let isValid = true;

            // Clear previous errors
            document.querySelectorAll('.error-text').forEach(error => {
                error.textContent = '';
            });

            // Validate username
            if (username.value.trim() === '') {
                document.getElementById('username-error').textContent = 'Username is required';
                isValid = false;
            } else if (username.value.length < 3 || username.value.length > 50) {
                document.getElementById('username-error').textContent = 'Username must be between 3 and 50 characters';
                isValid = false;
            }

            // Validate email
            if (email.value.trim() === '') {
                document.getElementById('email-error').textContent = 'Email is required';
                isValid = false;
            } else if (!isValidEmail(email.value)) {
                document.getElementById('email-error').textContent = 'Invalid email format';
                isValid = false;
            }

            // Validate password
            if (password.value.trim() === '') {
                document.getElementById('password-error').textContent = 'Password is required';
                isValid = false;
            } else if (password.value.length < 8) {
                document.getElementById('password-error').textContent = 'Password must be at least 8 characters';
                isValid = false;
            } else if (!isValidPassword(password.value)) {
                document.getElementById('password-error').textContent = 'Password must contain at least one letter and one number';
                isValid = false;
            }

            // Validate confirm password
            if (confirmPassword.value.trim() === '') {
                document.getElementById('confirmPassword-error').textContent = 'Confirm password is required';
                isValid = false;
            } else if (password.value !== confirmPassword.value) {
                document.getElementById('confirmPassword-error').textContent = 'Passwords do not match';
                isValid = false;
            }

            // Validate terms
            if (!terms.checked) {
                document.getElementById('terms-error').textContent = 'You must agree to the terms';
                isValid = false;
            }

            if (!isValid) {
                e.preventDefault();
            }
        });

        function isValidEmail(email) {
            const emailRegex = /^[A-Za-z0-9+_.-]+@(.+)$/;
            return emailRegex.test(email);
        }

        function isValidPassword(password) {
            const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;
            return passwordRegex.test(password);
        }
    });
</script>
</body>
</html>
