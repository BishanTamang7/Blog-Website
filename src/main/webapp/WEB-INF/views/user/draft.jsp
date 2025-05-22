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
    <title>InsightHub - My Drafts</title>
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

        /* Drafts Table */
        .drafts-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .drafts-table th, 
        .drafts-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }

        .drafts-table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #495057;
        }

        .drafts-table tr:last-child td {
            border-bottom: none;
        }

        .drafts-table tr:hover {
            background-color: #f8f9fa;
        }

        .action-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
            margin-right: 5px;
        }

        .btn-edit {
            background-color: #6c757d;
            color: white;
        }

        .btn-edit:hover {
            background-color: #5a6268;
        }

        .btn-delete {
            background-color: #dc3545;
            color: white;
        }

        .btn-delete:hover {
            background-color: #c82333;
        }

        .btn-publish {
            background-color: #28a745;
            color: white;
        }

        .btn-publish:hover {
            background-color: #218838;
        }

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

        .header-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .status-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            text-transform: uppercase;
            background-color: #e9ecef;
            color: #495057;
        }

        .status-draft {
            background-color: #e9ecef;
            color: #495057;
        }

        .actions-cell {
            display: flex;
            gap: 5px;
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

<!-- Main Content -->
<main class="main-content">
    <div class="header-actions">
        <h1>My Drafts</h1>
        <a href="${pageContext.request.contextPath}/user/create-post" class="btn-create">
            <i class="fas fa-plus"></i> Create New Post
        </a>
    </div>

    <c:choose>
        <c:when test="${empty draftPosts}">
            <div class="empty-state">
                <div class="empty-state-icon">
                    <i class="fas fa-edit"></i>
                </div>
                <h2 class="empty-state-title">No Drafts Yet</h2>
                <p class="empty-state-message">Start writing and save your ideas as drafts to work on them later.</p>
                <a href="${pageContext.request.contextPath}/user/create-post" class="btn-create">
                    <i class="fas fa-plus"></i> Create New Draft
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <table class="drafts-table">
                <thead>
                    <tr>
                        <th>Title</th>
                        <th>Date</th>
                        <th>Category</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${draftPosts}" var="post">
                        <tr>
                            <td>${post.title}</td>
                            <td><fmt:formatDate value="${post.createdAt}" pattern="MMM dd, yyyy" /></td>
                            <td>${post.category}</td>
                            <td><span class="status-badge status-draft">Draft</span></td>
                            <td class="actions-cell">
                                <a href="${pageContext.request.contextPath}/user/edit-post?id=${post.id}" class="action-btn btn-edit">
                                    <i class="fas fa-edit"></i> Edit
                                </a>
                                <button class="action-btn btn-delete" onclick="confirmDelete(${post.id})">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                                <button class="action-btn btn-publish" onclick="confirmPublish(${post.id})">
                                    <i class="fas fa-paper-plane"></i> Publish
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</main>

<!-- Delete Draft Modal -->
<div class="modal-overlay" id="delete-draft-modal">
  <div class="modal">
    <div class="modal-header">
      <h3 class="modal-title">Delete Draft</h3>
      <button class="modal-close">&times;</button>
    </div>
    <div class="modal-body">
      <input type="hidden" id="delete-draft-id">
      <p>Are you sure you want to delete this draft?</p>
    </div>
    <div class="modal-footer">
      <button class="btn btn-outline modal-cancel">Cancel</button>
      <button class="btn btn-danger" id="delete-draft-submit">Delete Draft</button>
    </div>
  </div>
</div>

<style>
  /* Modal Styles */
  .modal-overlay {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 1050;
    justify-content: center;
    align-items: center;
  }

  .modal-overlay.active {
    display: flex;
  }

  .modal {
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    width: 100%;
    max-width: 500px;
    overflow: hidden;
  }

  .modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px 20px;
    border-bottom: 1px solid #e0e0e0;
  }

  .modal-title {
    margin: 0;
    font-size: 18px;
    font-weight: 600;
  }

  .modal-close {
    background: none;
    border: none;
    font-size: 24px;
    cursor: pointer;
    color: #6c757d;
  }

  .modal-body {
    padding: 20px;
  }

  .modal-footer {
    display: flex;
    justify-content: flex-end;
    padding: 15px 20px;
    border-top: 1px solid #e0e0e0;
    gap: 10px;
  }

  .btn {
    padding: 8px 16px;
    border-radius: 4px;
    font-weight: 500;
    cursor: pointer;
    border: none;
  }

  .btn-outline {
    background-color: transparent;
    border: 1px solid #6c757d;
    color: #6c757d;
  }

  .btn-danger {
    background-color: #dc3545;
    color: white;
  }

  .alert-warning {
    background-color: #fff3cd;
    color: #856404;
    padding: 12px;
    border-radius: 4px;
    margin-top: 10px;
    display: flex;
    align-items: center;
    gap: 10px;
  }
</style>

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
    // JavaScript to toggle the profile dropdown menu and handle alerts
    document.addEventListener('DOMContentLoaded', function() {
        const profileButton = document.getElementById('profileButton');
        const writeButton = document.querySelector('.write-button');

        // Toggle dropdown when profile button is clicked
        profileButton.addEventListener('click', function(event) {
            this.classList.toggle('active');
            event.stopPropagation();
        });

        // Add click event to write button to navigate to create-post page
        writeButton.addEventListener('click', function() {
            window.location.href = '${pageContext.request.contextPath}/user/create-post';
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

    // Function to show delete draft modal
    function confirmDelete(postId) {
        document.getElementById('delete-draft-id').value = postId;
        document.getElementById('delete-draft-modal').classList.add('active');
    }

    // Function to confirm post publishing
    function confirmPublish(postId) {
        if (confirm('Are you sure you want to publish this draft? It will be visible to all users.')) {
            window.location.href = '${pageContext.request.contextPath}/user/publish-post?id=' + postId;
        }
    }

    // Set up modal functionality
    document.addEventListener('DOMContentLoaded', function() {
        const deleteModal = document.getElementById('delete-draft-modal');
        const closeButtons = deleteModal.querySelectorAll('.modal-close, .modal-cancel');
        const deleteSubmitButton = document.getElementById('delete-draft-submit');

        // Close modal when clicking close button or cancel button
        closeButtons.forEach(button => {
            button.addEventListener('click', function() {
                deleteModal.classList.remove('active');
            });
        });

        // Close modal when clicking outside the modal
        deleteModal.addEventListener('click', function(event) {
            if (event.target === deleteModal) {
                deleteModal.classList.remove('active');
            }
        });

        // Handle delete confirmation
        deleteSubmitButton.addEventListener('click', function() {
            const postId = document.getElementById('delete-draft-id').value;
            window.location.href = '${pageContext.request.contextPath}/user/delete-post?id=' + postId;
        });
    });
</script>
</body>
</html>
