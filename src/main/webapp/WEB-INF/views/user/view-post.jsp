<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.example.blog_website.models.User" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <title>${post.title} - InsightHub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user/user-dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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

        /* Main Content */
        .main-content {
            flex: 1;
            max-width: 800px;
            margin: 0 auto;
            padding: 80px 20px 20px 20px; /* Increased top padding to account for fixed navbar */
            width: 100%;
        }

        /* Post Container */
        .post-container {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-bottom: 30px;
        }

        .post-header {
            margin-bottom: 20px;
        }

        .post-title {
            font-size: 32px;
            font-weight: 700;
            color: #333;
            margin-bottom: 10px;
        }

        .post-meta {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            color: #6c757d;
            font-size: 14px;
        }

        .post-author {
            display: flex;
            align-items: center;
            margin-right: 20px;
        }

        .author-avatar {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background-color: #4F46E5;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            margin-right: 8px;
            font-size: 12px;
        }

        .post-date, .post-category, .post-views {
            margin-right: 20px;
            display: flex;
            align-items: center;
        }

        .post-meta i {
            margin-right: 5px;
        }

        .post-content {
            font-size: 18px;
            line-height: 1.6;
            color: #333;
            margin-bottom: 30px;
        }

        .post-content p {
            margin-bottom: 20px;
        }

        .post-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
        }

        .btn {
            padding: 8px 16px;
            border-radius: 4px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: background-color 0.3s;
        }

        .btn-primary {
            background-color: #4F46E5;
            color: white;
            border: none;
        }

        .btn-primary:hover {
            background-color: #4338CA;
        }

        .btn-outline {
            background-color: transparent;
            border: 1px solid #6c757d;
            color: #6c757d;
        }

        .btn-outline:hover {
            background-color: #f8f9fa;
        }

        .btn i {
            margin-right: 5px;
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
            <form action="${pageContext.request.contextPath}/search" method="get">
                <input type="text" class="search-input" name="keyword" placeholder="Search">
                <button type="submit" style="display:none;">Search</button>
            </form>
        </div>
    </div>

    <div class="right-elements">
        <div class="write-button">
            <a href="${pageContext.request.contextPath}/user/create-post" style="text-decoration: none; color: inherit; display: flex; align-items: center; gap: 8px;">
                <svg class="write-icon svg-icon" viewBox="0 0 24 24">
                    <path d="M14 4a.5.5 0 0 0 0-1v1zm7 6a.5.5 0 0 0-1 0h1zm-7-7H4v1h10V3zM3 4v16h1V4H3zm1 17h16v-1H4v1zm17-1V10h-1v10h1zm-1 1a1 1 0 0 0 1-1h-1v1zM3 20a1 1 0 0 0 1 1v-1H3zM4 3a1 1 0 0 0-1 1h1V3z"></path>
                    <path d="M17.5 4.5l-8.46 8.46a.25.25 0 0 0-.06.1l-.82 2.47c-.07.2.12.38.31.31l2.47-.82a.25.25 0 0 0 .1-.06L19.5 6.5m-2-2l2.32-2.32c.1-.1.26-.1.36 0l1.64 1.64c.1.1.1.26 0 .36L19.5 6.5"></path>
                </svg>
                <span class="write-text">Write</span>
            </a>
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

<!-- Main Content -->
<main class="main-content">
    <div class="post-container">
        <div class="post-header">
            <h1 class="post-title">${post.title}</h1>
            <div class="post-meta">
                <div class="post-author">
                    <div class="author-avatar">
                        <c:choose>
                            <c:when test="${author.profileImage != null && !author.profileImage.isEmpty()}">
                                <img src="${pageContext.request.contextPath}/${author.profileImage}" alt="${author.firstName}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
                            </c:when>
                            <c:otherwise>
                                ${author.firstName.substring(0, 1).toUpperCase()}
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <span>${author.firstName} ${author.lastName}</span>
                </div>
                <div class="post-date">
                    <i class="fas fa-calendar-alt"></i>
                    <fmt:formatDate value="${post.publishedAt}" pattern="MMM dd, yyyy" />
                </div>
                <div class="post-category">
                    <i class="fas fa-folder"></i>
                    ${categoryName}
                </div>
                <div class="post-views">
                    <i class="fas fa-eye"></i>
                    ${post.viewCount} views
                </div>
            </div>
        </div>

        <div class="post-content">
            ${post.content}
        </div>

        <div class="post-actions">
            <a href="${pageContext.request.contextPath}/user/user-dashboard" class="btn btn-outline">
                <i class="fas fa-arrow-left"></i> Back
            </a>

            <c:if test="${user.id == post.authorId}">
                <a href="${pageContext.request.contextPath}/user/edit-post?id=${post.id}" class="btn btn-primary">
                    <i class="fas fa-edit"></i> Edit Post
                </a>
            </c:if>
        </div>
    </div>
</main>

<!-- Compact Footer -->
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
    // JavaScript to toggle the profile dropdown menu
    document.addEventListener('DOMContentLoaded', function() {
        const profileButton = document.getElementById('profileButton');

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
    });
</script>
</body>
</html>
