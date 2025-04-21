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
    <title>Login - The Daily Idea</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login/login.css">
</head>
<body>
<header>
    <div class="logo"><a href="${pageContext.request.contextPath}/index.jsp">The Daily Idea</a></div>
</header>

<main class="login-container">
    <div class="login-box">
        <h1>Sign In</h1>
        <p class="login-subtitle">Welcome back. Sign in to access your personalized experience.</p>

        <form class="login-form" action="${pageContext.request.contextPath}/login" method="post">
            <% if(request.getAttribute("successMessage") != null) { %>
            <div class="success-message">
                <%= request.getAttribute("successMessage") %>
            </div>
            <% } %>
            <% if(request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
            <% } %>
            <div class="form-group">
                <input type="email" id="email" name="email" placeholder="Email" required>
            </div>
            <div class="form-group password-field">
                <input type="password" id="password" name="password" placeholder="Password" required>
                <span class="toggle-password">Show</span>
            </div>
            <div class="form-actions">
                <div class="remember-me">
                    <input type="checkbox" id="remember" name="remember">
                    <label for="remember">Remember me</label>
                </div>
                <a href="#" class="forgot-password">Forgot password?</a>
            </div>
            <button type="submit" class="login-btn">Sign in</button>
        </form>

        <div class="signup-prompt">
            <p>No account? <a href="${pageContext.request.contextPath}/signup">Create one</a></p>
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

<script src="${pageContext.request.contextPath}/assets/js/login/login.js"></script>
</body>
</html>
