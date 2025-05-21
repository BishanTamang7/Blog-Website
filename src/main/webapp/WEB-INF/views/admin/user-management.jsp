<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>InsightHub Admin - User Management</title>
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
      <a href="${pageContext.request.contextPath}/admin/user-management" class="menu-item active">
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
      <h1 class="page-title">User Management</h1>
      <button class="btn btn-primary" data-modal="add-user-modal">
        <i class="fas fa-user-plus"></i> Add New User
      </button>
    </div>

    <!-- User Stats -->
    <div class="stats-container">
      <div class="row" style="display: flex; gap: 20px; flex-wrap: wrap;">
        <!-- Total Users -->
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

        <!-- Admin Users -->
        <div class="card" style="flex: 1; min-width: 200px;">
          <div style="display: flex; align-items: center;">
            <div style="background-color: rgba(231, 76, 60, 0.1); padding: 15px; border-radius: 50%; margin-right: 15px;">
              <i class="fas fa-user-shield" style="font-size: 24px; color: var(--danger-color);"></i>
            </div>
            <div>
              <h3 style="margin: 0; font-size: 24px;">${adminUsers}</h3>
              <p style="margin: 5px 0 0; color: var(--text-light);">Admin Users</p>
            </div>
          </div>
        </div>

        <!-- Regular Users -->
        <div class="card" style="flex: 1; min-width: 200px;">
          <div style="display: flex; align-items: center;">
            <div style="background-color: rgba(46, 204, 113, 0.1); padding: 15px; border-radius: 50%; margin-right: 15px;">
              <i class="fas fa-user" style="font-size: 24px; color: var(--success-color);"></i>
            </div>
            <div>
              <h3 style="margin: 0; font-size: 24px;">${regularUsers}</h3>
              <p style="margin: 5px 0 0; color: var(--text-light);">Regular Users</p>
            </div>
          </div>
        </div>

        <!-- New Users (This Month) -->
        <div class="card" style="flex: 1; min-width: 200px;">
          <div style="display: flex; align-items: center;">
            <div style="background-color: rgba(243, 156, 18, 0.1); padding: 15px; border-radius: 50%; margin-right: 15px;">
              <i class="fas fa-user-plus" style="font-size: 24px; color: var(--warning-color);"></i>
            </div>
            <div>
              <h3 style="margin: 0; font-size: 24px;">${newUsersThisMonth}</h3>
              <p style="margin: 5px 0 0; color: var(--text-light);">New This Month</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- User Management Table -->
    <div class="card mt-20">
      <div class="card-header">
        <h2 class="card-title">User List</h2>
        <div class="search-filter-container">
          <div class="search-box">
            <input type="text" class="search-input" id="users-table-search" placeholder="Search users...">
            <button class="search-btn"><i class="fas fa-search"></i></button>
          </div>
          <select class="filter-dropdown" id="user-filter">
            <option value="all" ${currentFilter == 'all' ? 'selected' : ''}>All Users</option>
            <option value="admin" ${currentFilter == 'admin' ? 'selected' : ''}>Admin Users</option>
            <option value="user" ${currentFilter == 'user' ? 'selected' : ''}>Regular Users</option>
          </select>
        </div>
      </div>
      <div class="table-responsive">
        <table class="data-table" id="users-table">
          <thead>
          <tr>
            <th data-sort="username">Username</th>
            <th data-sort="email">Email</th>
            <th data-sort="role">Role</th>
            <th data-sort="date">Registration Date</th>
            <th>Actions</th>
          </tr>
          </thead>
          <tbody>
          <% 
            java.util.List<com.example.blog_website.models.User> users = 
                (java.util.List<com.example.blog_website.models.User>) request.getAttribute("users");
            if (users != null && !users.isEmpty()) {
                for (com.example.blog_website.models.User user : users) {
          %>
            <tr>
              <td><%= user.getUsername() %></td>
              <td><%= user.getEmail() %></td>
              <td>
                <span class="badge <%= "ADMIN".equals(user.getRole()) ? "badge-primary" : "badge-success" %>">
                    <%= user.getRole() %>
                </span>
              </td>
              <td><%= user.getCreatedAt() %></td>
              <td>
                <div class="action-buttons">
                  <button class="btn btn-sm btn-primary" data-modal="edit-user-modal" data-user-id="<%= user.getId() %>">Edit</button>
                  <button class="btn btn-sm btn-warning" data-modal="reset-password-modal" data-user-id="<%= user.getId() %>">Reset Password</button>
                  <button class="btn btn-sm btn-danger" data-modal="delete-user-modal" data-user-id="<%= user.getId() %>">Delete</button>
                </div>
              </td>
            </tr>
          <% 
                }
            } else {
          %>
            <tr>
              <td colspan="5">No users found</td>
            </tr>
          <% } %>
          </tbody>
        </table>
      </div>
    </div>
  </main>
</div>

<!-- Add User Modal -->
<div class="modal-overlay" id="add-user-modal">
  <div class="modal">
    <div class="modal-header">
      <h3 class="modal-title">Add New User</h3>
      <button class="modal-close">&times;</button>
    </div>
    <div class="modal-body">
      <form class="demo-form compact-form" id="add-user-form">
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
          <div class="form-group" style="margin-bottom: 10px;">
            <label for="username" class="form-label">Username</label>
            <input type="text" id="username" class="form-control" required>
          </div>
          <div class="form-group" style="margin-bottom: 10px;">
            <label for="email" class="form-label">Email</label>
            <input type="email" id="email" class="form-control" required>
          </div>
        </div>
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
          <div class="form-group" style="margin-bottom: 10px;">
            <label for="password" class="form-label">Password</label>
            <input type="password" id="password" class="form-control" required>
          </div>
          <div class="form-group" style="margin-bottom: 10px;">
            <label for="confirm-password" class="form-label">Confirm Password</label>
            <input type="password" id="confirm-password" class="form-control" required>
          </div>
        </div>
        <div class="form-group" style="margin-bottom: 10px;">
          <label for="role" class="form-label">Role</label>
          <select id="role" class="form-control">
            <option value="user">User</option>
            <option value="admin">Admin</option>
          </select>
        </div>
      </form>
    </div>
    <div class="modal-footer">
      <button class="btn btn-outline modal-cancel">Cancel</button>
      <button class="btn btn-primary" id="add-user-submit">Add User</button>
    </div>
  </div>
</div>

<!-- Edit User Modal -->
<div class="modal-overlay" id="edit-user-modal">
  <div class="modal">
    <div class="modal-header">
      <h3 class="modal-title">Edit User</h3>
      <button class="modal-close">&times;</button>
    </div>
    <div class="modal-body">
      <form class="demo-form compact-form" id="edit-user-form">
        <input type="hidden" id="edit-user-id">
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
          <div class="form-group">
            <label for="edit-username" class="form-label">Username</label>
            <input type="text" id="edit-username" class="form-control" required>
          </div>
          <div class="form-group">
            <label for="edit-email" class="form-label">Email</label>
            <input type="email" id="edit-email" class="form-control" required>
          </div>
        </div>
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
          <div class="form-group">
            <label for="edit-role" class="form-label">Role</label>
            <select id="edit-role" class="form-control">
              <option value="user">User</option>
              <option value="admin">Admin</option>
            </select>
          </div>
          <div class="form-group">
            <label class="form-label">Account Status</label>
            <div>
              <label class="switch">
                <input type="checkbox" id="edit-status" checked>
                <span class="slider"></span>
              </label>
              <span id="status-text" style="margin-left: 10px;">Active</span>
            </div>
          </div>
        </div>
      </form>
    </div>
    <div class="modal-footer">
      <button class="btn btn-outline modal-cancel">Cancel</button>
      <button class="btn btn-primary" id="edit-user-submit">Save Changes</button>
    </div>
  </div>
</div>

<!-- Reset Password Modal -->
<div class="modal-overlay" id="reset-password-modal">
  <div class="modal">
    <div class="modal-header">
      <h3 class="modal-title">Reset User Password</h3>
      <button class="modal-close">&times;</button>
    </div>
    <div class="modal-body">
      <form class="demo-form compact-form" id="reset-password-form">
        <input type="hidden" id="reset-user-id">
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
          <div class="form-group">
            <label for="new-password" class="form-label">New Password</label>
            <div class="password-input-container">
              <input type="password" id="new-password" class="form-control" required>
              <button type="button" class="password-toggle-btn" onclick="togglePasswordVisibility('new-password')">
                <svg class="eye-icon" viewBox="0 0 24 24">
                  <path class="eye-open" d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"></path>
                  <path class="eye-closed" d="M12 7c2.76 0 5 2.24 5 5 0 .65-.13 1.26-.36 1.83l2.92 2.92c1.51-1.26 2.7-2.89 3.43-4.75-1.73-4.39-6-7.5-11-7.5-1.4 0-2.74.25-3.98.7l2.16 2.16C10.74 7.13 11.35 7 12 7zM2 4.27l2.28 2.28.46.46C3.08 8.3 1.78 10.02 1 12c1.73 4.39 6 7.5 11 7.5 1.55 0 3.03-.3 4.38-.84l.42.42L19.73 22 21 20.73 3.27 3 2 4.27zM7.53 9.8l1.55 1.55c-.05.21-.08.43-.08.65 0 1.66 1.34 3 3 3 .22 0 .44-.03.65-.08l1.55 1.55c-.67.33-1.41.53-2.2.53-2.76 0-5-2.24-5-5 0-.79.2-1.53.53-2.2zm4.31-.78l3.15 3.15.02-.16c0-1.66-1.34-3-3-3l-.17.01z"></path>
                </svg>
              </button>
            </div>
          </div>
          <div class="form-group">
            <label for="confirm-new-password" class="form-label">Confirm New Password</label>
            <div class="password-input-container">
              <input type="password" id="confirm-new-password" class="form-control" required>
              <button type="button" class="password-toggle-btn" onclick="togglePasswordVisibility('confirm-new-password')">
                <svg class="eye-icon" viewBox="0 0 24 24">
                  <path class="eye-open" d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"></path>
                  <path class="eye-closed" d="M12 7c2.76 0 5 2.24 5 5 0 .65-.13 1.26-.36 1.83l2.92 2.92c1.51-1.26 2.7-2.89 3.43-4.75-1.73-4.39-6-7.5-11-7.5-1.4 0-2.74.25-3.98.7l2.16 2.16C10.74 7.13 11.35 7 12 7zM2 4.27l2.28 2.28.46.46C3.08 8.3 1.78 10.02 1 12c1.73 4.39 6 7.5 11 7.5 1.55 0 3.03-.3 4.38-.84l.42.42L19.73 22 21 20.73 3.27 3 2 4.27zM7.53 9.8l1.55 1.55c-.05.21-.08.43-.08.65 0 1.66 1.34 3 3 3 .22 0 .44-.03.65-.08l1.55 1.55c-.67.33-1.41.53-2.2.53-2.76 0-5-2.24-5-5 0-.79.2-1.53.53-2.2zm4.31-.78l3.15 3.15.02-.16c0-1.66-1.34-3-3-3l-.17.01z"></path>
                </svg>
              </button>
            </div>
          </div>
        </div>
        <div class="form-group">
          <div class="form-check">
            <input type="checkbox" id="force-password-change" class="form-check-input">
            <label for="force-password-change" class="form-check-label">Force user to change password on next login</label>
          </div>
        </div>
      </form>
    </div>
    <div class="modal-footer">
      <button class="btn btn-outline modal-cancel">Cancel</button>
      <button class="btn btn-warning" id="reset-password-submit">Reset Password</button>
    </div>
  </div>
</div>

<!-- Delete User Modal -->
<div class="modal-overlay" id="delete-user-modal">
  <div class="modal">
    <div class="modal-header">
      <h3 class="modal-title">Delete User</h3>
      <button class="modal-close">&times;</button>
    </div>
    <div class="modal-body">
      <input type="hidden" id="delete-user-id">
      <p>Are you sure you want to delete this user?</p>
    </div>
    <div class="modal-footer">
      <button class="btn btn-outline modal-cancel">Cancel</button>
      <button class="btn btn-danger" id="delete-user-submit">Delete User</button>
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
    // Debug context path
    console.log("[DEBUG] Context path:", "${pageContext.request.contextPath}");

    // Initialize data table
    initDataTable('users-table');

    // Handle user filter dropdown change
    const userFilter = document.getElementById('user-filter');
    userFilter.addEventListener('change', function() {
      const selectedFilter = this.value;
      window.location.href = '${pageContext.request.contextPath}/admin/user-management?filter=' + selectedFilter;
    });

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

    // Add User Form Submission
    const addUserSubmit = document.getElementById('add-user-submit');
    addUserSubmit.addEventListener('click', function() {
      const username = document.getElementById('username').value;
      const email = document.getElementById('email').value;
      const password = document.getElementById('password').value;
      const confirmPassword = document.getElementById('confirm-password').value;
      const role = document.getElementById('role').value;

      if (!username || !email || !password || !confirmPassword) {
        showNotification('Please fill in all required fields', 'error');
        return;
      }

      if (password !== confirmPassword) {
        showNotification('Passwords do not match', 'error');
        return;
      }

      // Create URL parameters
      const params = new URLSearchParams();
      params.append('username', username);
      params.append('email', email);
      params.append('password', password);
      params.append('confirmPassword', confirmPassword);
      params.append('role', role);

      // Make API call to create user
      fetch('${pageContext.request.contextPath}/admin/create-user', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
      })
              .then(response => response.json())
              .then(data => {
                if (data.success) {
                  showNotification('User created successfully!', 'success');
                  // Delay reload to allow user to see the notification
                  setTimeout(() => {
                    // Reload page to show new user
                    window.location.reload();
                  }, 3000); // 3 seconds delay
                } else {
                  let errorMessage = 'Failed to create user';
                  if (data.error) {
                    errorMessage = data.error;
                  } else if (data.errors) {
                    errorMessage = Object.values(data.errors).join(', ');
                  }
                  showNotification(errorMessage, 'error');
                }
              })
              .catch(error => {
                console.error('Error creating user:', error);
                showNotification('An error occurred while creating the user', 'error');
              });

      // Close modal
      document.getElementById('add-user-modal').classList.remove('active');

      // Reset form
      document.getElementById('add-user-form').reset();
    });

    // Edit User Status Toggle
    const editStatus = document.getElementById('edit-status');
    const statusText = document.getElementById('status-text');

    editStatus.addEventListener('change', function() {
      statusText.textContent = this.checked ? 'Active' : 'Inactive';
    });

    // Edit User Form Submission
    const editUserSubmit = document.getElementById('edit-user-submit');
    editUserSubmit.addEventListener('click', function() {
      const userId = document.getElementById('edit-user-id').value;
      const username = document.getElementById('edit-username').value;
      const email = document.getElementById('edit-email').value;
      const role = document.getElementById('edit-role').value;
      const status = document.getElementById('edit-status').checked ? 'ACTIVE' : 'INACTIVE';

      console.log("[DEBUG] Edit User Form Submission - Form values:", {
        userId,
        username,
        email,
        role,
        status
      });

      if (!username || !email) {
        console.log("[DEBUG] Edit User Form Submission - Missing required fields");
        showNotification('Please fill in all required fields', 'error');
        return;
      }

      // Create URL parameters
      const params = new URLSearchParams();
      params.append('id', userId);
      params.append('username', username);
      params.append('email', email);
      params.append('role', role);
      params.append('status', status);

      console.log("[DEBUG] Edit User Form Submission - Sending parameters:", params.toString());

      // Make API call to update user
      fetch('${pageContext.request.contextPath}/admin/edit-user', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
      })
              .then(response => response.json())
              .then(data => {
                console.log("[DEBUG] Edit User Form Submission - Response:", data);
                if (data.success) {
                  console.log("[DEBUG] Edit User Form Submission - Update successful");
                  showNotification('User updated successfully!', 'success');
                  // Reload page to show updated user
                  window.location.reload();
                } else {
                  let errorMessage = 'Failed to update user';
                  if (data.error) {
                    errorMessage = data.error;
                  } else if (data.errors) {
                    errorMessage = Object.values(data.errors).join(', ');
                  }
                  console.log("[DEBUG] Edit User Form Submission - Update failed:", errorMessage);
                  showNotification(errorMessage, 'error');
                }
              })
              .catch(error => {
                console.error('[DEBUG] Error updating user:', error);
                showNotification('An error occurred while updating the user', 'error');
              });

      // Close modal
      document.getElementById('edit-user-modal').classList.remove('active');
      console.log("[DEBUG] Edit User Form Submission - Modal closed");
    });

    // Reset Password Form Submission
    const resetPasswordSubmit = document.getElementById('reset-password-submit');
    resetPasswordSubmit.addEventListener('click', function() {
      const userId = document.getElementById('reset-user-id').value;
      const newPassword = document.getElementById('new-password').value;
      const confirmNewPassword = document.getElementById('confirm-new-password').value;

      if (!newPassword || !confirmNewPassword) {
        showNotification('Please fill in all required fields', 'error');
        return;
      }

      if (newPassword !== confirmNewPassword) {
        showNotification('Passwords do not match', 'error');
        return;
      }

      // Create URL parameters
      const params = new URLSearchParams();
      params.append('id', userId);
      params.append('newPassword', newPassword);
      params.append('confirmNewPassword', confirmNewPassword);

      // Make API call to reset password
      fetch('${pageContext.request.contextPath}/admin/reset-password', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
      })
              .then(response => response.json())
              .then(data => {
                if (data.success) {
                  showNotification('Password reset successfully!', 'success');
                } else {
                  let errorMessage = 'Failed to reset password';
                  if (data.error) {
                    errorMessage = data.error;
                  } else if (data.errors) {
                    errorMessage = Object.values(data.errors).join(', ');
                  }
                  showNotification(errorMessage, 'error');
                }
              })
              .catch(error => {
                console.error('Error resetting password:', error);
                showNotification('An error occurred while resetting the password', 'error');
              });

      // Close modal
      document.getElementById('reset-password-modal').classList.remove('active');

      // Reset form
      document.getElementById('reset-password-form').reset();
    });

    // Delete User Form Submission
    const deleteUserSubmit = document.getElementById('delete-user-submit');
    deleteUserSubmit.addEventListener('click', function() {
      const userId = document.getElementById('delete-user-id').value;

      // Create URL parameters
      const params = new URLSearchParams();
      params.append('id', userId);

      // Make API call to delete user
      fetch('${pageContext.request.contextPath}/admin/delete-user', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
      })
              .then(response => response.json())
              .then(data => {
                if (data.success) {
                  showNotification('User deleted successfully!', 'success');
                  // Delay reload to allow user to see the notification
                  setTimeout(() => {
                    // Reload page to update user list
                    window.location.reload();
                  }, 3000); // 3 seconds delay
                } else {
                  let errorMessage = 'Failed to delete user';
                  if (data.error) {
                    errorMessage = data.error;
                  } else if (data.errors) {
                    errorMessage = Object.values(data.errors).join(', ');
                  }
                  showNotification(errorMessage, 'error');
                }
              })
              .catch(error => {
                console.error('Error deleting user:', error);
                showNotification('An error occurred while deleting the user', 'error');
              });

      // Close modal
      document.getElementById('delete-user-modal').classList.remove('active');
    });

    // Set user ID when opening modals
    const userActionButtons = document.querySelectorAll('[data-user-id]');
    userActionButtons.forEach(button => {
      button.addEventListener('click', function() {
        const userId = this.getAttribute('data-user-id');
        const modalId = this.getAttribute('data-modal');

        if (modalId === 'edit-user-modal') {
          document.getElementById('edit-user-id').value = userId;

          // Fetch user data from server
          console.log("[DEBUG] Fetching user data for ID:", userId);
          console.log("[DEBUG] User ID type:", typeof userId);

          // Ensure userId is a number
          const userIdNum = parseInt(userId, 10);
          console.log("[DEBUG] Parsed user ID:", userIdNum);

          // Ensure we have a valid ID parameter
          const contextPath = "${pageContext.request.contextPath}";
          const fullPath = window.location.origin + contextPath + "/admin/edit-user";
          const url = new URL(fullPath);
          url.searchParams.append('id', userIdNum);
          console.log("[DEBUG] Context path:", contextPath);
          console.log("[DEBUG] Full path:", fullPath);
          console.log("[DEBUG] Fetch URL:", url.toString());

          // Make sure to include credentials and proper headers
          fetch(url.toString(), {
            method: 'GET',
            credentials: 'same-origin',
            headers: {
              'Accept': 'application/json'
            }
          })
                  .then(response => {
                    console.log("[DEBUG] Response status:", response.status);
                    return response.json();
                  })
                  .then(data => {
                    console.log("[DEBUG] Received data from server:", data);
                    if (data.success) {
                      const user = data.user;
                      console.log("[DEBUG] User data:", user);
                      document.getElementById('edit-username').value = user.username;
                      document.getElementById('edit-email').value = user.email;
                      document.getElementById('edit-role').value = user.role.toLowerCase();
                      document.getElementById('edit-status').checked = user.status === 'ACTIVE';
                      document.getElementById('status-text').textContent = user.status === 'ACTIVE' ? 'Active' : 'Inactive';
                      console.log("[DEBUG] Form populated with user data");
                    } else {
                      let errorMessage = 'Failed to load user data';
                      if (data.error) {
                        errorMessage = data.error;
                      }
                      console.log("[DEBUG] Error loading user data:", errorMessage);
                      showNotification(errorMessage, 'error');
                    }
                  })
                  .catch(error => {
                    console.error('Error loading user data:', error);
                    showNotification('An error occurred while loading user data', 'error');
                  });
        } else if (modalId === 'reset-password-modal') {
          document.getElementById('reset-user-id').value = userId;
        } else if (modalId === 'delete-user-modal') {
          document.getElementById('delete-user-id').value = userId;
        }
      });
    });
  });
</script>
</body>
</html>
