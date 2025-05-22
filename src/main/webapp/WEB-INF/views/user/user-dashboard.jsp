<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
    <title>InsightHub</title>
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

        .alert {
            padding: 15px;
            margin: 0 auto 20px auto;
            border-radius: 4px;
            text-align: center;
            width: 40%;
            position: fixed;
            top: 80px;
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
            max-width: 1200px;
            margin: 0 auto;
            padding: 80px 20px 20px 20px; /* Increased top padding to account for fixed navbar */
            width: 100%;
        }

        /* Section heading styles */
        .main-content h1 {
            font-size: 32px;
            font-weight: 700;
            color: #333;
            margin-bottom: 10px;
        }

        .section-description {
            font-size: 16px;
            color: #6c757d;
            margin-bottom: 30px;
        }

        /* Post card styles */
        .posts-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .post-card {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .post-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .post-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .post-title a {
            color: #333;
            text-decoration: none;
        }

        .post-title a:hover {
            color: #4F46E5;
        }

        .post-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 15px;
            color: #6c757d;
            font-size: 14px;
        }

        .post-author, .post-date, .post-category, .post-views {
            display: flex;
            align-items: center;
        }

        .post-meta i {
            margin-right: 5px;
        }

        .post-excerpt {
            font-size: 16px;
            line-height: 1.5;
            color: #495057;
            margin-bottom: 20px;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
        }

        .post-actions {
            display: flex;
            justify-content: flex-end;
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

        /* Empty state styles */
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
            margin-top: 20px;
        }

        .empty-state-icon {
            font-size: 48px;
            color: #6c757d;
            margin-bottom: 16px;
        }

        .empty-state-title {
            font-size: 24px;
            font-weight: 600;
            color: #343a40;
            margin-bottom: 8px;
        }

        .empty-state-message {
            font-size: 16px;
            color: #6c757d;
            margin-bottom: 24px;
        }

        .btn-create {
            display: inline-block;
            padding: 10px 20px;
            background-color: #4F46E5;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-weight: 500;
            transition: background-color 0.3s;
        }

        .btn-create:hover {
            background-color: #4338CA;
        }

        /* Pagination styles */
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 30px;
            gap: 10px;
        }

        .pagination-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 8px 12px;
            background-color: #f8f9fa;
            color: #495057;
            border-radius: 4px;
            text-decoration: none;
            transition: background-color 0.3s;
        }

        .pagination-link:hover {
            background-color: #e9ecef;
        }

        .pagination-link.active {
            background-color: #4F46E5;
            color: white;
        }

        .pagination-link i {
            font-size: 12px;
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

<!-- Main Content Area -->
<main class="main-content">
    <h1>Discover Insights</h1>
    <p class="section-description">Explore the latest blog posts from our community</p>

    <c:choose>
        <c:when test="${empty publishedPosts}">
            <div class="empty-state">
                <div class="empty-state-icon">
                    <i class="fas fa-book"></i>
                </div>
                <h2 class="empty-state-title">No Published Stories Yet</h2>
                <p class="empty-state-message">Be the first to share your insights with the community!</p>
                <a href="${pageContext.request.contextPath}/user/create-post" class="btn-create">
                    <i class="fas fa-plus"></i> Create Your First Post
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="posts-container">
                <c:forEach items="${publishedPosts}" var="post">
                    <div class="post-card">
                        <h2 class="post-title">
                            <a href="${pageContext.request.contextPath}/user/view-post?id=${post.id}">${post.title}</a>
                        </h2>
                        <div class="post-meta">
                            <div class="post-author">
                                <i class="fas fa-user"></i> ${post.author}
                            </div>
                            <div class="post-date">
                                <i class="fas fa-calendar-alt"></i>
                                <fmt:formatDate value="${post.createdAt}" pattern="MMM dd, yyyy" />
                            </div>
                            <div class="post-category">
                                <i class="fas fa-folder"></i>
                                ${post.category}
                            </div>
                            <div class="post-views">
                                <i class="fas fa-eye"></i>
                                ${post.views} views
                            </div>
                        </div>
                        <div class="post-excerpt">
                            ${fn:substring(post.content, 0, 200)}...
                        </div>
                        <div class="post-actions">
                            <a href="${pageContext.request.contextPath}/user/view-post?id=${post.id}" class="btn btn-primary">
                                Read More
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <c:if test="${currentPage > 1}">
                        <a href="${pageContext.request.contextPath}/user/user-dashboard?page=${currentPage - 1}" class="pagination-link">
                            <i class="fas fa-chevron-left"></i> Previous
                        </a>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${currentPage == i}">
                                <span class="pagination-link active">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/user/user-dashboard?page=${i}" class="pagination-link">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <a href="${pageContext.request.contextPath}/user/user-dashboard?page=${currentPage + 1}" class="pagination-link">
                            Next <i class="fas fa-chevron-right"></i>
                        </a>
                    </c:if>
                </div>
            </c:if>
        </c:otherwise>
    </c:choose>
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
