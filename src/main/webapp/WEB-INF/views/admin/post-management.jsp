<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>InsightHub Admin - Post Management</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin.css">
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
          <c:forEach var="post" items="${posts}">
            <tr>
              <td>${post.title}</td>
              <td>${post.author}</td>
              <td>${post.category}</td>
              <td><fmt:formatDate value="${post.createdAt}" pattern="yyyy-MM-dd" /></td>
              <td>
                <c:choose>
                  <c:when test="${post.status eq 'PUBLISHED'}">
                    <span class="badge badge-success">Published</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge badge-warning">Draft</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>${post.views}</td>
              <td>
                <div class="action-buttons">
                  <button class="btn btn-sm btn-primary" data-modal="view-post-modal" data-post-id="${post.id}">View</button>
                  <button class="btn btn-sm btn-danger" data-modal="delete-post-modal" data-post-id="${post.id}">Delete</button>
                </div>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
      <div class="pagination">
        <c:if test="${currentPage > 1}">
          <a href="?page=${currentPage - 1}" class="pagination-item">Previous</a>
        </c:if>

        <c:forEach begin="1" end="${totalPages}" var="i">
          <c:choose>
            <c:when test="${currentPage == i}">
              <span class="pagination-item active">${i}</span>
            </c:when>
            <c:otherwise>
              <a href="?page=${i}" class="pagination-item">${i}</a>
            </c:otherwise>
          </c:choose>
        </c:forEach>

        <c:if test="${currentPage < totalPages}">
          <a href="?page=${currentPage + 1}" class="pagination-item">Next</a>
        </c:if>
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
          <p>React is a popular JavaScript library for building user interfaces, particularly single-page applications. It's used for handling the view layer for web and mobile apps. React allows us to create reusable UI components.</p>

          <h3>Why React?</h3>
          <ul>
            <li>Declarative: React makes it painless to create interactive UIs.</li>
            <li>Component-Based: Build encapsulated components that manage their own state.</li>
            <li>Learn Once, Write Anywhere: React can also render on the server using Node.</li>
          </ul>

          <h3>Getting Started</h3>
          <p>To get started with React, you need to have Node.js installed on your machine. Then, you can create a new React application using Create React App:</p>

          <pre><code>npx create-react-app my-app
cd my-app
npm start</code></pre>

          <p>This will set up a new React application and start a development server. You can now start building your application!</p>
        </div>
      </div>
    </div>
    <div class="modal-footer">
      <button class="btn btn-outline modal-cancel">Close</button>
      <a href="#" class="btn btn-primary" id="view-on-site">View on Site</a>
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
      <p>Are you sure you want to delete this post? This action cannot be undone.</p>
      <div class="alert alert-warning">
        <i class="fas fa-exclamation-triangle"></i> Warning: All comments associated with this post will also be deleted.
      </div>
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

        // Set the view on site link
        document.getElementById('view-on-site').href = `${pageContext.request.contextPath}/post?id=${postId}`;
      });
    });

    // Delete Post Form Submission
    const deletePostSubmit = document.getElementById('delete-post-submit');
    deletePostSubmit.addEventListener('click', function() {
      const postId = document.getElementById('delete-post-id').value;

      // In a real application, this would make an API call
      deletePost(postId);

      // Remove the row from the table
      const row = document.querySelector(`[data-post-id="${postId}"]`).closest('tr');
      row.remove();

      // Close modal
      document.getElementById('delete-post-modal').classList.remove('active');
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
