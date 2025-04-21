<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.blog_website.model.User" %>
<%@ page import="com.example.blog_website.model.Article" %>
<%@ page import="com.example.blog_website.model.Category" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  // Check if user is logged in and is an admin
  User currentUser = (User) session.getAttribute("user");
  if (currentUser == null || currentUser.getRole() != User.UserRole.ADMIN) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }

  // Get data from request attributes
  List<Article> recentArticles = (List<Article>) request.getAttribute("recentArticles");
  Integer totalPosts = (Integer) request.getAttribute("totalPosts");
  Integer totalComments = (Integer) request.getAttribute("totalComments");
  Integer totalCategories = (Integer) request.getAttribute("totalCategories");
  Integer totalUsers = (Integer) request.getAttribute("totalUsers");

  // Format date
  SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Blog Admin Dashboard</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin_panel/dashboard.css">
</head>
<body>
<div class="dashboard">
  <!-- Sidebar -->
  <aside class="sidebar">
    <div class="logo">
      <h2>BlogAdmin</h2>
    </div>
    <nav class="menu">
      <div class="menu-item active">
        <span class="menu-icon">📊</span>
        Dashboard
      </div>
      <div class="menu-item">
        <span class="menu-icon">📝</span>
        Posts
      </div>
      <div class="menu-item">
        <span class="menu-icon">🗂️</span>
        Categories
      </div>
      <div class="menu-item">
        <span class="menu-icon">👥</span>
        Users
      </div>
      <!-- Comments and Settings have been removed -->
    </nav>
  </aside>

  <!-- Main Content -->
  <main class="main-content">
    <!-- Header -->
    <header class="header">
      <div class="header-search">
        <input type="text" class="search-input" placeholder="Search...">
      </div>
      <div class="header-user">
        <span><%= currentUser.getUsername() %></span>
        <div class="user-avatar"><%= currentUser.getUsername().substring(0, 1).toUpperCase() %></div>
        <!-- User Dropdown Menu -->
        <div class="user-dropdown" id="userDropdown" style="display: none;">
          <div class="dropdown-item">
            <div class="dropdown-icon">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                <circle cx="12" cy="7" r="4"></circle>
              </svg>
            </div>
            <div class="dropdown-text">Profile</div>
          </div>
          <div class="dropdown-item">
            <a href="${pageContext.request.contextPath}/logout" style="text-decoration: none; color: inherit;">
              <div class="dropdown-icon">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                  <polyline points="16 17 21 12 16 7"></polyline>
                  <line x1="21" y1="12" x2="9" y2="12"></line>
                </svg>
              </div>
              <div class="dropdown-text">Sign out</div>
            </a>
          </div>
        </div>
      </div>
    </header>

    <!-- Content Area -->
    <div class="content">
      <div class="page-title">
        <h1>Dashboard</h1>
        <a href="${pageContext.request.contextPath}/admin/articles/new" class="btn">+ New Post</a>
      </div>

      <!-- Stats Cards -->
      <div class="stats-cards">
        <div class="stat-card">
          <h3>Total Posts</h3>
          <div class="value"><%= totalPosts != null ? totalPosts : 0 %></div>
        </div>
        <div class="stat-card">
          <h3>Comments</h3>
          <div class="value"><%= totalComments != null ? totalComments : 0 %></div>
        </div>
        <div class="stat-card">
          <h3>Categories</h3>
          <div class="value"><%= totalCategories != null ? totalCategories : 0 %></div>
        </div>
        <div class="stat-card">
          <h3>Users</h3>
          <div class="value"><%= totalUsers != null ? totalUsers : 0 %></div>
        </div>
      </div>

      <!-- Recent Posts -->
      <div class="posts-list">
        <h2>Recent Posts</h2>
        <table class="table">
          <thead>
          <tr>
            <th>Title</th>
            <th>Author</th>
            <th>Category</th>
            <th>Date</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
          </thead>
          <tbody>
          <%
            if (recentArticles != null && !recentArticles.isEmpty()) {
              for (Article article : recentArticles) {
                String categoryName = "Uncategorized";
                if (article.getCategories() != null && !article.getCategories().isEmpty()) {
                  categoryName = article.getCategories().get(0).getName();
                }

                String authorName = "Unknown";
                if (article.getAuthor() != null) {
                  authorName = article.getAuthor().getUsername();
                }

                String formattedDate = "";
                if (article.getPublicationDate() != null) {
                  formattedDate = dateFormat.format(article.getPublicationDate());
                }

                // Determine status (this is a placeholder - you might want to add a status field to Article)
                String status = "published"; // Default status
          %>
          <tr>
            <td><%= article.getTitle() %></td>
            <td><%= authorName %></td>
            <td><%= categoryName %></td>
            <td><%= formattedDate %></td>
            <td><span class="status <%= status %>"><%= status.substring(0, 1).toUpperCase() + status.substring(1) %></span></td>
            <td>
              <a href="${pageContext.request.contextPath}/admin/articles/edit?id=<%= article.getId() %>" class="action-btn edit-btn">Edit</a>
              <a href="${pageContext.request.contextPath}/admin/articles/delete?id=<%= article.getId() %>" class="action-btn delete-btn" onclick="return confirm('Are you sure you want to delete this article?')">Delete</a>
            </td>
          </tr>
          <%
            }
          } else {
          %>
          <tr>
            <td colspan="6" style="text-align: center;">No articles found</td>
          </tr>
          <% } %>
          </tbody>
        </table>
      </div>
    </div>
  </main>
</div>
<script src="${pageContext.request.contextPath}/assets/js/admin_panel/dashboard.js"></script>
</body>
</html>
