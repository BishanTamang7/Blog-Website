<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Registration</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/register/register.css">
</head>
<body>
<div class="container">
  <div class="logo">
    <h1>Admin<span>Panel</span></h1>
  </div>
  <form class="register-form" action="${pageContext.request.contextPath}/signup" method="post">
    <div class="form-header">
      <h2>Create Admin Account</h2>
      <p>Fill in the details below to register</p>
    </div>

    <% if(request.getAttribute("error") != null) { %>
    <div class="error-message">
      <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <div class="input-group">
      <label for="username">Username</label>
      <input type="text" id="username" name="username" class="input-field" placeholder="Choose a username" required>
    </div>

    <div class="input-group">
      <label for="email">Email Address</label>
      <input type="email" id="email" name="email" class="input-field" placeholder="Enter your email address" required>
    </div>

    <div class="form-row">
      <div class="input-group">
        <label for="password">Password</label>
        <input type="password" id="password" name="password" class="input-field" placeholder="Create a password" required>
      </div>

      <div class="input-group">
        <label for="confirmPassword">Confirm Password</label>
        <input type="password" id="confirmPassword" name="confirmPassword" class="input-field" placeholder="Confirm your password" required>
      </div>
    </div>

    <div class="checkbox-group">
      <input type="checkbox" id="terms" required>
      <label for="terms">I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a></label>
    </div>

    <button type="submit" class="btn">Register Now</button>

    <div class="form-footer">
      Already have an account? <a href="${pageContext.request.contextPath}/login">Login</a>
    </div>
  </form>
</div>

<script src="${pageContext.request.contextPath}/assets/js/register/register.js"></script>
</body>
</html>
