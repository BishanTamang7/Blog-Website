<%--
  Created by IntelliJ IDEA.
  User: Acer
  Date: 4/19/2025
  Time: 4:25 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - The Daily Idea</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/register/register.css">
</head>
<body>
<header>
    <div class="logo"><a href="${pageContext.request.contextPath}/index.jsp">The Daily Idea</a></div>
</header>

<main class="register-container">
    <div class="register-box">
        <h1>Join The Daily Idea</h1>
        <p class="register-subtitle">Create an account to personalize your experience and start sharing your ideas.</p>

        <form class="register-form" action="${pageContext.request.contextPath}/signup" method="post">
            <% if(request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
            <% } %>
            <div class="form-group">
                <input type="text" id="username" name="username" placeholder="Username" required>
            </div>
            <div class="form-group">
                <input type="email" id="email" name="email" placeholder="Email" required>
            </div>
            <div class="form-group password-field">
                <input type="password" id="password" name="password" placeholder="Password (at least 8 characters)" required>
                <span class="toggle-password">Show</span>
                <div class="password-strength">
                    <div class="strength-bar"></div>
                    <span class="strength-text">Password strength</span>
                </div>
            </div>
            <div class="form-group password-field">
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm password" required>
                <span class="toggle-password">Show</span>
            </div>
            <div class="form-group terms">
                <input type="checkbox" id="terms" name="terms" required>
                <label for="terms">I agree to the <a href="#" class="terms-link">Terms of Service</a> and <a href="#" class="terms-link">Privacy Policy</a></label>
            </div>
            <button type="submit" class="register-btn">Create account</button>
        </form>

        <div class="login-prompt">
            <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a></p>
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

<script src="${pageContext.request.contextPath}/assets/js/register/register.js"></script>
</body>
</html>