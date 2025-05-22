<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>InsightHub Admin - Post Management</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin.css">
  <style>
    .alert {
      padding: 15px;
      margin: 0 0 20px 0;
      border-radius: 4px;
      text-align: center;
      position: relative;
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
  </style>
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
      <a href="${pageContext.request.contextPath}/admin/admin-dashboard" class="menu-item">
        <i class="fas fa-tachometer-alt"></i>
        <span>Dashboard</span>
      </a>
      <a href="${pageContext.request.contextPath}/admin/user-management" class="menu-item">
        <i class="fas fa-users"></i>
        <span>User Management</span>
      </a>
      <a href="${pageContext.request.contextPath}/admin/post-management" class="menu-item active">
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
    <!-- Display success or error messages if any -->
    <% if (session.getAttribute("successMessage") != null) { %>
      <div class="alert alert-success">
        <%= session.getAttribute("successMessage") %>
        <% session.removeAttribute("successMessage"); %>
      </div>
    <% } %>
    <% if (session.getAttribute("errorMessage") != null) { %>
      <div class="alert alert-danger">
        <%= session.getAttribute("errorMessage") %>
        <% session.removeAttribute("errorMessage"); %>
      </div>
    <% } %>

    <div class="page-header">
      <h1 class="page-title">Post Management</h1>
    </div>

    <!-- Post Stats -->
    <div class="stats-container">
      <div class="row" style="display: flex; gap: 20px; flex-wrap: wrap;">
        <!-- Total Posts -->
        <div class="card" style="flex: 1; min-width: 200px;">
          <div style="display: flex; align-items: center;">
            <div style="background-color: rgba(52, 152, 219, 0.1); padding: 15px; border-radius: 50%; margin-right: 15px;">
              <i class="fas fa-file-alt" style="font-size: 24px; color: var(--primary-color);"></i>
            </div>
            <div>
              <h3 style="margin: 0; font-size: 24px;">${totalPosts}</h3>
              <p style="margin: 5px 0 0; color: var(--text-light);">Total Posts</p>
            </div>
          </div>
        </div>

        <!-- Published Posts -->
        <div class="card" style="flex: 1; min-width: 200px;">
          <div style="display: flex; align-items: center;">
            <div style="background-color: rgba(46, 204, 113, 0.1); padding: 15px; border-radius: 50%; margin-right: 15px;">
              <i class="fas fa-check-circle" style="font-size: 24px; color: var(--success-color);"></i>
            </div>
            <div>
              <h3 style="margin: 0; font-size: 24px;">${publishedPosts}</h3>
              <p style="margin: 5px 0 0; color: var(--text-light);">Published</p>
            </div>
          </div>
        </div>

        <!-- Draft Posts -->
        <div class="card" style="flex: 1; min-width: 200px;">
          <div style="display: flex; align-items: center;">
            <div style="background-color: rgba(243, 156, 18, 0.1); padding: 15px; border-radius: 50%; margin-right: 15px;">
              <i class="fas fa-edit" style="font-size: 24px; color: var(--warning-color);"></i>
            </div>
            <div>
              <h3 style="margin: 0; font-size: 24px;">${draftPosts}</h3>
              <p style="margin: 5px 0 0; color: var(--text-light);">Drafts</p>
            </div>
          </div>
        </div>

        <!-- Total Views -->
        <div class="card" style="flex: 1; min-width: 200px;">
          <div style="display: flex; align-items: center;">
            <div style="background-color: rgba(231, 76, 60, 0.1); padding: 15px; border-radius: 50%; margin-right: 15px;">
              <i class="fas fa-eye" style="font-size: 24px; color: var(--danger-color);"></i>
            </div>
            <div>
              <h3 style="margin: 0; font-size: 24px;">${totalViews}</h3>
              <p style="margin: 5px 0 0; color: var(--text-light);">Total Views</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Post Management Table -->
    <div class="card mt-20">
      <div class="card-header">
        <h2 class="card-title">Post List</h2>
        <div class="search-filter-container">
          <div class="search-box">
            <input type="text" class="search-input" id="posts-table-search" placeholder="Search posts...">
            <button class="search-btn"><i class="fas fa-search"></i></button>
          </div>
          <select class="filter-dropdown">
            <option value="all">All Posts</option>
            <option value="published">Published</option>
            <option value="draft">Drafts</option>
          </select>
        </div>
      </div>
      <div class="table-responsive">
        <table class="data-table" id="posts-table">
          <thead>
          <tr>
            <th data-sort="title">Title</th>
            <th data-sort="author">Author</th>
            <th data-sort="category">Category</th>
            <th data-sort="date">Date</th>
            <th data-sort="status">Status</th>
            <th data-sort="views">Views</th>
            <th>Actions</th>
          </tr>
          </thead>
          <tbody>
          <% 
            java.util.List<java.util.Map<String, Object>> posts = 
                (java.util.List<java.util.Map<String, Object>>) request.getAttribute("posts");
            if (posts != null) {
                for (java.util.Map<String, Object> post : posts) {
                    String status = (String) post.get("status");
          %>
            <tr>
              <td><%= post.get("title") %></td>
              <td><%= post.get("author") %></td>
              <td><%= post.get("category") %></td>
              <td><%= post.get("createdAt") != null ? post.get("createdAt").toString().split(" ")[0] : "" %></td>
              <td>
                <% if ("PUBLISHED".equals(status)) { %>
                    <span class="badge badge-success">Published</span>
                <% } else { %>
                    <span class="badge badge-warning">Draft</span>
                <% } %>
              </td>
              <td><%= post.get("views") %></td>
              <td>
                <div class="action-buttons">
                  <button class="btn btn-sm btn-primary" data-modal="view-post-modal" data-post-id="<%= post.get("id") %>" data-post-content="<%= post.get("content") %>">View</button>
                  <button class="btn btn-sm btn-danger" data-modal="delete-post-modal" data-post-id="<%= post.get("id") %>">Delete</button>
                </div>
              </td>
            </tr>
          <% 
                }
            }
          %>
          </tbody>
        </table>
      </div>
      <div class="pagination">
        <% 
          Integer currentPage = (Integer) request.getAttribute("currentPage");
          Integer totalPages = (Integer) request.getAttribute("totalPages");

          if (currentPage != null && currentPage > 1) {
        %>
          <a href="?page=<%= currentPage - 1 %>" class="pagination-item">Previous</a>
        <% } %>

        <% 
          if (currentPage != null && totalPages != null && currentPage < totalPages) {
        %>
          <a href="?page=<%= currentPage + 1 %>" class="pagination-item">Next</a>
        <% } %>
      </div>
    </div>
  </main>
</div>

<!-- View Post Modal -->
<div class="modal-overlay" id="view-post-modal">
  <div class="modal">
    <div class="modal-header">
      <h3 class="modal-title">View Post</h3>
      <button class="modal-close">&times;</button>
    </div>
    <div class="modal-body">
      <input type="hidden" id="view-post-id">
      <div class="post-details">
        <h2 id="post-title">Getting Started with React</h2>
        <div class="post-meta">
          <span><strong>Author:</strong> <span id="post-author">John Doe</span></span>
          <span><strong>Category:</strong> <span id="post-category">Technology</span></span>
          <span><strong>Date:</strong> <span id="post-date">2023-06-15</span></span>
          <span><strong>Status:</strong> <span id="post-status" class="badge badge-success">Published</span></span>
          <span><strong>Views:</strong> <span id="post-views">1,245</span></span>
        </div>
        <div class="post-content" id="post-content">
          <!-- Post content will be loaded dynamically -->
        </div>
      </div>
    </div>
    <div class="modal-footer">
      <button class="btn btn-outline modal-cancel">Close</button>
    </div>
  </div>
</div>

<!-- Delete Post Modal -->
<div class="modal-overlay" id="delete-post-modal">
  <div class="modal">
    <div class="modal-header">
      <h3 class="modal-title">Delete Post</h3>
      <button class="modal-close">&times;</button>
    </div>
    <div class="modal-body">
      <input type="hidden" id="delete-post-id">
      <p>Are you sure you want to delete this post?</p>
    </div>
    <div class="modal-footer">
      <button class="btn btn-outline modal-cancel">Cancel</button>
      <button class="btn btn-danger" id="delete-post-submit">Delete Post</button>
    </div>
  </div>
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
  document.addEventListener('DOMContentLoaded', function() {
    // Initialize data table
    initDataTable('posts-table');

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

    // Initialize logout functionality
    const logoutBtn = document.getElementById('logout-btn');
    const logoutModal = document.getElementById('logout-modal');
    const confirmLogout = document.getElementById('confirm-logout');

    logoutBtn.addEventListener('click', function(e) {
      e.preventDefault();
      logoutModal.classList.add('active');
    });

    confirmLogout.addEventListener('click', function() {
      // Redirect to the LogoutServlet
      window.location.href = '${pageContext.request.contextPath}/logout';
    });

    // View Post Modal
    const viewButtons = document.querySelectorAll('[data-modal="view-post-modal"]');
    viewButtons.forEach(button => {
      button.addEventListener('click', function() {
        const postId = this.getAttribute('data-post-id');
        const postContent = this.getAttribute('data-post-content');
        document.getElementById('view-post-id').value = postId;

        // Get data from the table row
        const row = this.closest('tr');
        document.getElementById('post-title').textContent = row.cells[0].textContent;
        document.getElementById('post-author').textContent = row.cells[1].textContent;
        document.getElementById('post-category').textContent = row.cells[2].textContent;
        document.getElementById('post-date').textContent = row.cells[3].textContent;
        document.getElementById('post-status').textContent = row.cells[4].textContent.trim();
        document.getElementById('post-status').className = row.cells[4].querySelector('.badge').className;
        document.getElementById('post-views').textContent = row.cells[5].textContent;

        // Set the post content
        document.getElementById('post-content').innerHTML = postContent;
      });
    });

    // Delete Post Form Submission
    const deletePostSubmit = document.getElementById('delete-post-submit');
    deletePostSubmit.addEventListener('click', function() {
      const postId = document.getElementById('delete-post-id').value;

      // Redirect to the AdminDeletePostServlet
      window.location.href = '${pageContext.request.contextPath}/admin/delete-post?id=' + postId;
    });

    // Set post ID when opening delete modal
    const deleteButtons = document.querySelectorAll('[data-modal="delete-post-modal"]');
    deleteButtons.forEach(button => {
      button.addEventListener('click', function() {
        const postId = this.getAttribute('data-post-id');
        document.getElementById('delete-post-id').value = postId;
      });
    });

  });
</script>
</body>
</html>
