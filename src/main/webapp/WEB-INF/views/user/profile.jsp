<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.blog_website.models.User" %>
<%
    User user = (User) session.getAttribute("user");
    String initial = user.getFirstName() != null && !user.getFirstName().isEmpty() ? 
        user.getFirstName().substring(0, 1) : 
        user.getUsername().substring(0, 1);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>InsightHub - Profile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user/user-dashboard.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
        }

        body {
            background-color: #fff;
            min-height: 100vh;
            padding: 20px;
        }

        .alert {
            padding: 15px;
            margin: 0 auto 20px auto;
            border-radius: 4px;
            text-align: center;
            width: 40%;
            position: fixed;
            top: 120px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 1000;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #333;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }

        .form-control:focus {
            border-color: #4F46E5;
            outline: none;
        }

        .error-text {
            color: #dc3545;
            font-size: 14px;
            margin-top: 5px;
        }


        /* Navbar fixed positioning */
        .navbar {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 1000;
            background-color: white;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        /* Override profile dropdown positioning for fixed navbar */
        .profile-dropdown {
            position: absolute;
            top: 45px;
            right: 0;
            z-index: 1001; /* Higher than navbar to ensure it appears on top */
        }

        /* Main Profile Content */
        .main-content {
            flex: 1;
            max-width: 1200px;
            margin: 0 auto;
            padding: 80px 20px 20px 20px; /* Increased top padding to account for fixed navbar */
            width: 100%;
        }

        /* Profile Header Section */
        .profile-header {
            display: flex;
            align-items: flex-start;
            gap: 40px;
            margin-bottom: 40px;
            padding: 30px;
            background-color: #fafafa;
            border-radius: 8px;
            border: 1px solid rgba(230, 230, 230, 0.75);
        }

        .profile-image-container {
            flex-shrink: 0;
        }

        .profile-image {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background-color: #6B7280;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            font-weight: bold;
        }

        .profile-info {
            flex: 1;
        }

        .profile-name {
            font-size: 32px;
            font-weight: bold;
            color: rgba(41, 41, 41, 1);
            margin-bottom: 8px;
        }

        .profile-email {
            font-size: 16px;
            color: rgba(117, 117, 117, 1);
            margin-bottom: 16px;
        }

        .profile-bio {
            font-size: 16px;
            color: rgba(80, 80, 80, 1);
            line-height: 1.6;
            margin-bottom: 20px;
        }

        .profile-meta {
            display: flex;
            gap: 24px;
            margin-bottom: 20px;
        }

        .meta-item {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .meta-number {
            font-size: 24px;
            font-weight: bold;
            color: rgba(41, 41, 41, 1);
        }

        .meta-label {
            font-size: 14px;
            color: rgba(117, 117, 117, 1);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .profile-actions {
            display: flex;
            gap: 12px;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 6px;
            border: none;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background-color: #4F46E5;
            color: white;
        }

        .btn-primary:hover {
            background-color: #4338CA;
        }

        .btn-secondary {
            background-color: white;
            color: rgba(41, 41, 41, 1);
            border: 1px solid rgba(230, 230, 230, 1);
        }

        .btn-secondary:hover {
            background-color: rgba(240, 240, 240, 1);
        }

        .btn-icon {
            width: 16px;
            height: 16px;
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 15px;
        }

        .stat-card {
            background-color: white;
            border: 1px solid rgba(230, 230, 230, 0.75);
            border-radius: 8px;
            padding: 24px;
            transition: box-shadow 0.2s ease;
        }

        .stat-card:hover {
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .stat-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
        }

        .stat-title {
            font-size: 16px;
            font-weight: 600;
            color: rgba(41, 41, 41, 1);
        }

        .stat-icon {
            width: 24px;
            height: 24px;
            opacity: 0.7;
        }

        .stat-value {
            font-size: 28px;
            font-weight: bold;
            color: rgba(41, 41, 41, 1);
            margin-bottom: 4px;
        }

        .stat-description {
            font-size: 14px;
            color: rgba(117, 117, 117, 1);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .profile-header {
                flex-direction: column;
                text-align: center;
                gap: 20px;
            }

            .profile-meta {
                justify-content: center;
            }

            .profile-actions {
                justify-content: center;
            }

            .stats-grid {
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            }
        }

        @media (max-width: 576px) {
            .main-content {
                padding: 20px 10px;
            }

            .profile-header {
                padding: 20px;
            }

            .profile-name {
                font-size: 24px;
            }

            .stat-card {
                padding: 16px;
            }
        }
    </style>
</head>
<body>
<!-- Header/Navigation Bar -->
<nav class="navbar">
    <div class="logo"><a href="${pageContext.request.contextPath}/user/user-dashboard">InsightHub</a></div>

    <div class="search-container">
        <div class="search-bar">
            <svg class="search-icon svg-icon" viewBox="0 0 24 24">
                <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"></path>
            </svg>
            <input type="text" class="search-input" placeholder="Search">
        </div>
    </div>

    <div class="right-elements">
        <div class="write-button">
            <svg class="write-icon svg-icon" viewBox="0 0 24 24">
                <path d="M14 4a.5.5 0 0 0 0-1v1zm7 6a.5.5 0 0 0-1 0h1zm-7-7H4v1h10V3zM3 4v16h1V4H3zm1 17h16v-1H4v1zm17-1V10h-1v10h1zm-1 1a1 1 0 0 0 1-1h-1v1zM3 20a1 1 0 0 0 1 1v-1H3zM4 3a1 1 0 0 0-1 1h1V3z"></path>
                <path d="M17.5 4.5l-8.46 8.46a.25.25 0 0 0-.06.1l-.82 2.47c-.07.2.12.38.31.31l2.47-.82a.25.25 0 0 0 .1-.06L19.5 6.5m-2-2l2.32-2.32c.1-.1.26-.1.36 0l1.64 1.64c.1.1.1.26 0 .36L19.5 6.5"></path>
            </svg>
            <span class="write-text">Write</span>
        </div>

        <div class="profile" id="profileButton">
            <% 
            if (user.getProfileImage() != null && !user.getProfileImage().isEmpty()) {
            %>
                <img src="${pageContext.request.contextPath}/<%= user.getProfileImage() %>" alt="Profile" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
            <% } else { %>
                <%= initial.toUpperCase() %>
            <% } %>
            <!-- Profile Dropdown Menu -->
            <div class="profile-dropdown">
                <a href="${pageContext.request.contextPath}/profile" class="dropdown-item">
                    <svg class="dropdown-icon svg-icon" viewBox="0 0 24 24">
                        <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm-2-9h4v4h-4v-4zm0-6h4v4h-4V5z"></path>
                    </svg>
                    Profile
                </a>
                <a href="${pageContext.request.contextPath}/user/draft" class="dropdown-item">
                    <svg class="dropdown-icon svg-icon" viewBox="0 0 24 24">
                        <path d="M19 5v14H5V5h14m0-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 9h-2V8h2v4zm0 4h-2v-2h2v2z"></path>
                    </svg>
                    Draft
                </a>
                <a href="${pageContext.request.contextPath}/user/my-stories" class="dropdown-item">
                    <svg class="dropdown-icon svg-icon" viewBox="0 0 24 24">
                        <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V5h14v14zM7 10h2v7H7v-7zm4-3h2v10h-2V7zm4 6h2v4h-2v-4z"></path>
                    </svg>
                    My Stories
                </a>
                <div class="dropdown-divider"></div>
                <a href="${pageContext.request.contextPath}/logout" class="dropdown-item">
                    <svg class="dropdown-icon svg-icon" viewBox="0 0 24 24">
                        <path d="M10.09 15.59L11.5 17l5-5-5-5-1.41 1.41L12.67 11H3v2h9.67l-2.58 2.59zM19 3H5c-1.11 0-2 .9-2 2v4h2V5h14v14H5v-4H3v4c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z"></path>
                    </svg>
                    Sign out
                </a>
            </div>
        </div>
    </div>
</nav>

<!-- Display success or error messages if any -->
<% if (request.getAttribute("successMessage") != null) { %>
    <div class="alert alert-success">
        <%= request.getAttribute("successMessage") %>
    </div>
<% } %>
<% if (request.getAttribute("errorMessage") != null) { %>
    <div class="alert alert-danger">
        <%= request.getAttribute("errorMessage") %>
    </div>
<% } %>

<!-- Main Profile Content -->
<main class="main-content">
    <!-- Profile Header Section -->
    <section class="profile-header">

        <div class="profile-image-container">
            <div class="profile-image">
                <% 
                    if (user.getProfileImage() != null && !user.getProfileImage().isEmpty()) {
                %>
                    <img src="${pageContext.request.contextPath}/<%= user.getProfileImage() %>" alt="Profile Image" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
                <% } else { %>
                    <%= initial.toUpperCase() %>
                <% } %>
            </div>
        </div>

        <div class="profile-info">
            <h1 class="profile-name">
                <% 
                    String fullName = "";
                    if (user.getFirstName() != null && !user.getFirstName().isEmpty()) {
                        fullName += user.getFirstName();
                    }
                    if (user.getLastName() != null && !user.getLastName().isEmpty()) {
                        fullName += " " + user.getLastName();
                    }
                    if (fullName.trim().isEmpty()) {
                        fullName = user.getUsername();
                    }
                %>
                <%= fullName %>
            </h1>
            <p class="profile-email"><%= user.getEmail() %></p>
            <p class="profile-bio">
                <%= user.getBio() != null ? user.getBio() : "No bio provided yet." %>
            </p>

            <div class="profile-meta">
                <div class="meta-item">
                    <span class="meta-number">${publishedPosts}</span>
                    <span class="meta-label">Posts</span>
                </div>
                <div class="meta-item">
                    <span class="meta-number">${totalViews}</span>
                    <span class="meta-label">Views</span>
                </div>
            </div>

            <div class="profile-actions">
                <a href="${pageContext.request.contextPath}/edit-profile" class="btn btn-primary">
                    <svg class="btn-icon" viewBox="0 0 24 24">
                        <path fill="currentColor" d="M14 4a.5.5 0 0 0 0-1v1zm7 6a.5.5 0 0 0-1 0h1zm-7-7H4v1h10V3zM3 4v16h1V4H3zm1 17h16v-1H4v1zm17-1V10h-1v10h1zm-1 1a1 1 0 0 0 1-1h-1v1zM3 20a1 1 0 0 0 1 1v-1H3zM4 3a1 1 0 0 0-1 1h1V3z"></path>
                        <path fill="currentColor" d="M17.5 4.5l-8.46 8.46a.25.25 0 0 0-.06.1l-.82 2.47c-.07.2.12.38.31.31l2.47-.82a.25.25 0 0 0 .1-.06L19.5 6.5m-2-2l2.32-2.32c.1-.1.26-.1.36 0l1.64 1.64c.1.1.1.26 0 .36L19.5 6.5"></path>
                    </svg>
                    Edit Profile
                </a>
                <a href="${pageContext.request.contextPath}/change-password" class="btn btn-secondary">
                    <svg class="btn-icon" viewBox="0 0 24 24">
                        <path fill="currentColor" d="M12 17c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm6-9h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zM8.9 6c0-1.71 1.39-3.1 3.1-3.1s3.1 1.39 3.1 3.1v2H8.9V6zM18 20H6V10h12v10z"></path>
                    </svg>
                    Change Password
                </a>
            </div>
        </div>
    </section>


    <!-- Stats Grid -->
    <section class="stats-grid">
        <div class="stat-card">
            <div class="stat-header">
                <span class="stat-title">Total Views</span>
                <svg class="stat-icon" viewBox="0 0 24 24">
                    <path fill="currentColor" d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"></path>
                </svg>
            </div>
            <div class="stat-value">${totalViews}</div>
            <div class="stat-description">Total views across all posts</div>
        </div>

        <div class="stat-card">
            <div class="stat-header">
                <span class="stat-title">Published Posts</span>
                <svg class="stat-icon" viewBox="0 0 24 24">
                    <path fill="currentColor" d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"></path>
                </svg>
            </div>
            <div class="stat-value">${publishedPosts}</div>
            <div class="stat-description">Stories shared with the community</div>
        </div>

        <div class="stat-card">
            <div class="stat-header">
                <span class="stat-title">Member Since</span>
                <svg class="stat-icon" viewBox="0 0 24 24">
                    <path fill="currentColor" d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V8h14v11zM7 10h5v5H7z"></path>
                </svg>
            </div>
            <div class="stat-value">${memberSince}</div>
            <div class="stat-description">Part of the InsightHub community</div>
        </div>
    </section>
</main>

<!-- Compact Footer with Left-aligned Links -->
<footer class="footer">
    <div class="footer-container">
        <ul class="footer-links">
            <li class="footer-link"><a href="#">About</a></li>
            <li class="footer-link"><a href="#">Help</a></li>
            <li class="footer-link"><a href="#">Privacy</a></li>
            <li class="footer-link"><a href="#">Terms</a></li>
            <li class="footer-link"><a href="#">Careers</a></li>
            <li class="footer-link"><a href="#">Contact</a></li>
        </ul>

        <div class="footer-right">
            <div class="footer-social">
                <!-- Twitter/X Icon -->
                <svg class="social-icon svg-icon" viewBox="0 0 24 24">
                    <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"></path>
                </svg>

                <!-- Facebook Icon -->
                <svg class="social-icon svg-icon" viewBox="0 0 24 24">
                    <path d="M9.198 21.5h4v-8.01h3.604l.396-3.98h-4V7.5a1 1 0 0 1 1-1h3v-4h-3a5 5 0 0 0-5 5v2.01h-2l-.396 3.98h2.396v8.01Z"></path>
                </svg>

                <!-- LinkedIn Icon -->
                <svg class="social-icon svg-icon" viewBox="0 0 24 24">
                    <path d="M19 3a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14m-.5 15.5v-5.3a3.26 3.26 0 0 0-3.26-3.26c-.85 0-1.84.52-2.32 1.3v-1.11h-2.79v8.37h2.79v-4.93c0-.77.62-1.4 1.39-1.4a1.4 1.4 0 0 1 1.4 1.4v4.93h2.79M6.88 8.56a1.68 1.68 0 0 0 1.68-1.68c0-.93-.75-1.69-1.68-1.69a1.69 1.69 0 0 0-1.69 1.69c0 .93.76 1.68 1.69 1.68m1.39 9.94v-8.37H5.5v8.37h2.77z"></path>
                </svg>
            </div>
            <div class="copyright">
                © 2025 InsightHub
            </div>
        </div>
    </div>
</footer>
<script>
    // JavaScript to toggle the profile dropdown menu and handle alerts
    document.addEventListener('DOMContentLoaded', function() {
        const profileButton = document.getElementById('profileButton');
        const writeButton = document.querySelector('.write-button');

        // Add click event to write button to navigate to create-post page
        writeButton.addEventListener('click', function() {
            window.location.href = '${pageContext.request.contextPath}/user/create-post';
        });

        // Toggle dropdown when profile button is clicked
        profileButton.addEventListener('click', function(event) {
            this.classList.toggle('active');
            event.stopPropagation();
        });

        // Close dropdown when clicking elsewhere on the page
        document.addEventListener('click', function(event) {
            if (!profileButton.contains(event.target)) {
                profileButton.classList.remove('active');
            }
        });

        // Auto-hide alerts after 4 seconds
        const alerts = document.querySelectorAll('.alert');
        if (alerts.length > 0) {
            setTimeout(function() {
                alerts.forEach(function(alert) {
                    alert.style.opacity = '1';
                    alert.style.transition = 'opacity 0.5s ease';

                    // Fade out
                    alert.style.opacity = '0';

                    // Remove from DOM after fade completes
                    setTimeout(function() {
                        alert.remove();
                    }, 500);
                });
            }, 4000); // 4 seconds
        }
    });
</script>
</body>
</html>
