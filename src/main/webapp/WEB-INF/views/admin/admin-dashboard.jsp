<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>InsightHub Admin - Dashboard</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
<div class="admin-container">
  <!-- Sidebar Navigation -->
  <aside class="sidebar">
    <div class="sidebar-header">
      <h2>InsightHub</h2>
      <p>Admin Dashboard</p>
    </div>
    <nav class="sidebar-menu">
      <a href="${pageContext.request.contextPath}/admin/admin-dashboard" class="menu-item active">
        <i class="fas fa-tachometer-alt"></i>
        <span>Dashboard</span>
      </a>
      <a href="${pageContext.request.contextPath}/admin/user-management" class="menu-item">
        <i class="fas fa-users"></i>
        <span>User Management</span>
      </a>
      <a href="${pageContext.request.contextPath}/admin/post-management" class="menu-item">
        <i class="fas fa-file-alt"></i>
        <span>Post Management</span>
      </a>
      <a href="${pageContext.request.contextPath}/admin/category-management" class="menu-item">
        <i class="fas fa-tags"></i>
        <span>Category Management</span>
      </a>
      <a href="${pageContext.request.contextPath}/admin/report-management" class="menu-item">
        <i class="fas fa-chart-bar"></i>
        <span>Reports</span>
      </a>
      <a href="#" class="menu-item" id="logout-btn">
        <i class="fas fa-sign-out-alt"></i>
        <span>Logout</span>
      </a>
    </nav>
  </aside>

  <!-- Main Content -->
  <main class="main-content">
    <div class="page-header">
      <h1 class="page-title">Dashboard Overview</h1>
      <div class="user-info">
        <span>Welcome, ${sessionScope.username}</span>
      </div>
    </div>

    <!-- Stats Overview -->
    <div class="stats-container">
      <div class="row" style="display: flex; gap: 20px; flex-wrap: wrap;">
        <!-- Users Stat -->
        <div class="card" style="flex: 1; min-width: 200px;">
          <div style="display: flex; align-items: center;">
            <div style="background-color: rgba(52, 152, 219, 0.1); padding: 15px; border-radius: 50%; margin-right: 15px;">
              <i class="fas fa-users" style="font-size: 24px; color: var(--primary-color);"></i>
            </div>
            <div>
              <h3 style="margin: 0; font-size: 24px;">${totalUsers}</h3>
              <p style="margin: 5px 0 0; color: var(--text-light);">Total Users</p>
            </div>
          </div>
        </div>

        <!-- Posts Stat -->
        <div class="card" style="flex: 1; min-width: 200px;">
          <div style="display: flex; align-items: center;">
            <div style="background-color: rgba(46, 204, 113, 0.1); padding: 15px; border-radius: 50%; margin-right: 15px;">
              <i class="fas fa-file-alt" style="font-size: 24px; color: var(--success-color);"></i>
            </div>
            <div>
              <h3 style="margin: 0; font-size: 24px;">${totalPosts}</h3>
              <p style="margin: 5px 0 0; color: var(--text-light);">Total Posts</p>
            </div>
          </div>
        </div>

        <!-- Categories Stat -->
        <div class="card" style="flex: 1; min-width: 200px;">
          <div style="display: flex; align-items: center;">
            <div style="background-color: rgba(243, 156, 18, 0.1); padding: 15px; border-radius: 50%; margin-right: 15px;">
              <i class="fas fa-tags" style="font-size: 24px; color: var(--warning-color);"></i>
            </div>
            <div>
              <h3 style="margin: 0; font-size: 24px;">${totalCategories}</h3>
              <p style="margin: 5px 0 0; color: var(--text-light);">Categories</p>
            </div>
          </div>
        </div>

        <!-- Most Active Category -->
        <div class="card" style="flex: 1; min-width: 200px;">
          <div style="display: flex; align-items: center;">
            <div style="background-color: rgba(231, 76, 60, 0.1); padding: 15px; border-radius: 50%; margin-right: 15px;">
              <i class="fas fa-fire" style="font-size: 24px; color: var(--danger-color);"></i>
            </div>
            <div>
              <h3 style="margin: 0; font-size: 24px;">${mostActiveCategory}</h3>
              <p style="margin: 5px 0 0; color: var(--text-light);">Most Active Category</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Recent Activity -->
    <div class="row" style="display: flex; gap: 20px; margin-top: 30px; flex-wrap: wrap;">
      <!-- Recent Posts -->
      <div class="card" style="flex: 2; min-width: 300px;">
        <div class="card-header">
          <h2 class="card-title">Recent Posts</h2>
          <a href="${pageContext.request.contextPath}/admin/post-management" class="btn btn-sm btn-outline">View All</a>
        </div>
        <table class="data-table">
          <thead>
          <tr>
            <th>Title</th>
            <th>Author</th>
            <th>Category</th>
            <th>Date</th>
            <th>Views</th>
          </tr>
          </thead>
          <tbody>
          <!-- Loop through recent posts -->
          <% if (request.getAttribute("recentPosts") != null) { %>
          <c:forEach var="post" items="${recentPosts}">
            <tr>
              <td>${post.title}</td>
              <td>${post.author}</td>
              <td>${post.category}</td>
              <td>${post.createdAt}</td>
              <td>${post.views}</td>
            </tr>
          </c:forEach>
          <% } else { %>
          <tr>
            <td colspan="5">No recent posts found</td>
          </tr>
          <% } %>
          </tbody>
        </table>
      </div>

      <!-- Recent Users -->
      <div class="card" style="flex: 1; min-width: 300px;">
        <div class="card-header">
          <h2 class="card-title">New Users</h2>
          <a href="${pageContext.request.contextPath}/admin/user-management" class="btn btn-sm btn-outline">View All</a>
        </div>
        <ul style="list-style: none; padding: 0;">
          <!-- Loop through new users -->
          <% if (request.getAttribute("newUsers") != null) { %>
          <c:forEach var="user" items="${newUsers}">
            <li style="padding: 12px 0; border-bottom: 1px solid var(--border-color); display: flex; align-items: center;">
              <div style="width: 40px; height: 40px; background-color: #3498db; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; margin-right: 15px;">${user.initials}</div>
              <div>
                <h4 style="margin: 0;">${user.username}</h4>
                <p style="margin: 5px 0 0; color: var(--text-light); font-size: 0.9rem;">Joined: ${user.joinedAgo}</p>
              </div>
            </li>
          </c:forEach>
          <% } else { %>
          <li style="padding: 12px 0;">No new users found</li>
          <% } %>
        </ul>
      </div>
    </div>

    <!-- Category Distribution -->
    <div class="row" style="display: flex; gap: 20px; margin-top: 30px; flex-wrap: wrap;">
      <div class="card" style="flex: 1; min-width: 300px;">
        <div class="card-header">
          <h2 class="card-title">Posts by Category</h2>
        </div>
        <div style="padding: 20px;">
          <!-- Simple bar chart representation -->
          <div style="display: flex; flex-direction: column; gap: 15px;">
            <!-- Loop through category distribution -->
            <% if (request.getAttribute("categoryDistribution") != null) { %>
            <c:forEach var="category" items="${categoryDistribution}">
              <div>
                <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                  <span>${category.name}</span>
                  <span>${category.percentage}%</span>
                </div>
                <div style="height: 10px; background-color: #f0f0f0; border-radius: 5px;">
                  <div style="height: 100%; width: ${category.percentage}%; background-color: ${category.color}; border-radius: 5px;"></div>
                </div>
              </div>
            </c:forEach>
            <% } else { %>
            <div>No category data available</div>
            <% } %>
          </div>
        </div>
      </div>

      <!-- Quick Actions -->
      <div class="card" style="flex: 1; min-width: 300px;">
        <div class="card-header">
          <h2 class="card-title">Quick Actions</h2>
        </div>
        <div style="padding: 20px; display: flex; flex-direction: column; gap: 15px;">
          <a href="${pageContext.request.contextPath}/admin/user-management" class="btn btn-primary" style="text-align: center;">
            <i class="fas fa-user-plus"></i> Add New User
          </a>
          <a href="${pageContext.request.contextPath}/admin/post-management" class="btn btn-success" style="text-align: center;">
            <i class="fas fa-file-medical"></i> Create New Post
          </a>
          <a href="${pageContext.request.contextPath}/admin/category-management" class="btn btn-warning" style="text-align: center;">
            <i class="fas fa-folder-plus"></i> Add New Category
          </a>
          <a href="${pageContext.request.contextPath}/admin/report-management" class="btn btn-danger" style="text-align: center;">
            <i class="fas fa-chart-line"></i> Generate Reports
          </a>
        </div>
      </div>
    </div>
  </main>
</div>

<!-- Logout Confirmation Modal -->
<div class="modal-overlay" id="logout-modal">
  <div class="modal">
    <div class="modal-header">
      <h3 class="modal-title">Confirm Logout</h3>
      <button class="modal-close">&times;</button>
    </div>
    <div class="modal-body">
      <p>Are you sure you want to logout from the admin dashboard?</p>
    </div>
    <div class="modal-footer">
      <button class="btn btn-outline modal-cancel">Cancel</button>
      <button class="btn btn-danger" id="confirm-logout">Logout</button>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/admin/admin.js"></script>
<script>
  // Initialize logout functionality
  document.addEventListener('DOMContentLoaded', function() {
    const logoutBtn = document.getElementById('logout-btn');
    const logoutModal = document.getElementById('logout-modal');
    const confirmLogout = document.getElementById('confirm-logout');
    const modalClose = document.querySelector('.modal-close');
    const modalCancel = document.querySelector('.modal-cancel');

    logoutBtn.addEventListener('click', function(e) {
      e.preventDefault();
      logoutModal.classList.add('active');
    });

    confirmLogout.addEventListener('click', function() {
      // Redirect to the LogoutServlet
      window.location.href = '${pageContext.request.contextPath}/logout';
    });

    // Close modal when clicking the X or Cancel button
    modalClose.addEventListener('click', function() {
      logoutModal.classList.remove('active');
    });

    modalCancel.addEventListener('click', function() {
      logoutModal.classList.remove('active');
    });
  });
</script>
</body>
</html>
