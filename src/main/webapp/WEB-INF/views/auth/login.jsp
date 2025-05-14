<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - InsightHub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth/login.css">
</head>
<body>
<header>
    <div class="logo"><a href="${pageContext.request.contextPath}/index.jsp">InsightHub</a></div>
</header>

<main class="login-container">
    <div class="login-box">
        <h1>Sign In</h1>
        <p class="login-subtitle">Welcome back. Sign in to access your personalized experience.</p>

        <%
            String errorMsg = null;
            if(request.getAttribute("error") != null) {
                errorMsg = (String) request.getAttribute("error");
            } else if(request.getParameter("error") != null) {
                errorMsg = request.getParameter("error");
            }

            if(errorMsg != null) {
        %>
        <div class="error-alert">
            <%= errorMsg %>
        </div>
        <% } %>

        <%
            String successMsg = null;
            if(request.getAttribute("success") != null) {
                successMsg = (String) request.getAttribute("success");
            } else if(request.getParameter("success") != null) {
                successMsg = request.getParameter("success");
            }

            if(successMsg != null) {
        %>
        <div class="success-alert" style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 5px; margin-bottom: 15px;">
            <%= successMsg %>
        </div>
        <% } %>

        <form class="login-form" action="${pageContext.request.contextPath}/LoginServlet" method="post">
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
            <button type="submit" class="login-btn">Login</button>
        </form>

        <div class="signup-prompt">
            <p>No account? <a href="${pageContext.request.contextPath}/RegisterServlet">Create one</a></p>
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

<script src="${pageContext.request.contextPath}/assets/js/auth/lgoin.js"></script>
</body>
</html>
