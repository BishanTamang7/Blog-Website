<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Login</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login/login.css">
</head>
<body>
<div class="container">
  <div class="logo">
    <h1>Admin<span>Panel</span></h1>
  </div>
  <form class="login-form" action="${pageContext.request.contextPath}/login" method="post">
    <div class="form-header">
      <h2>Admin Login</h2>
      <p>Enter your credentials to access the dashboard</p>
    </div>

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

    <div class="input-group">
      <label for="email">Email</label>
      <input type="email" id="email" name="email" class="input-field" placeholder="Enter your email" required>
    </div>

    <div class="input-group">
      <label for="password">Password</label>
      <input type="password" id="password" name="password" class="input-field" placeholder="Enter your password" required>
    </div>

    <div class="remember-forgot">
      <div class="remember-me">
        <input type="checkbox" id="remember" name="remember">
        <label for="remember">Remember me</label>
      </div>

      <div class="forgot-password">
        <a href="#">Forgot password?</a>
      </div>
    </div>

    <button type="submit" class="btn">Login</button>

    <div class="form-footer">
      Don't have an account? <a href="${pageContext.request.contextPath}/signup">Register</a>
    </div>
  </form>
</div>
<script src="${pageContext.request.contextPath}/assets/js/login/login.js"></script>
</body>
</html>
