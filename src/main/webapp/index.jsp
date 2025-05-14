<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>InsightHub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/landing-page.css">
</head>
<body>
<header>
    <div class="logo"><a href="${pageContext.request.contextPath}/index.jsp">InsightHub</a></div>
    <div class="nav-links">
        <a href="#">Our story</a>
        <a href="#" class="write-link">Write</a>
        <a href="${pageContext.request.contextPath}/LoginServlet">Login</a>
        <a href="${pageContext.request.contextPath}/RegisterServlet">Register</a>
    </div>
</header>

<section class="hero">
    <div class="hero-text">
        <h1>Stay curious.</h1>
        <p>Discover stories, thinking, and expertise from writers on any topic.</p>
        <a href="#" class="start-reading-btn">Start reading</a>
    </div>
    <div class="hero-image">
        <div class="green-design">
            <div class="flower"></div>
            <div class="green-block"></div>
            <div class="hand"></div>
        </div>
    </div>
</section>

<!-- Login Message Modal -->
<div id="loginModal" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>
        <h2>Sign in required</h2>
        <p>Please login to access this feature.</p>
        <div class="modal-buttons">
            <a href="${pageContext.request.contextPath}/LoginServlet" class="modal-login-btn">Login</a>
            <a href="${pageContext.request.contextPath}/RegisterServlet" class="modal-register-btn">Register</a>
        </div>
    </div>
</div>

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

<script src="${pageContext.request.contextPath}/assets/js/landing-page.js"></script>
</body>
</html>