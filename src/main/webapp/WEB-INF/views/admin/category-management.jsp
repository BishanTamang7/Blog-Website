<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>InsightHub Admin - Category Management</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin.css">
  <style>
    .pagination {
      display: flex;
      justify-content: center;
      gap: 5px;
    }
    .page-link {
      padding: 5px 10px;
      border: 1px solid #ddd;
      border-radius: 4px;
      text-decoration: none;
      color: var(--primary-color);
      background-color: #fff;
      transition: all 0.3s ease;
    }
    .page-link:hover {
      background-color: #f5f5f5;
    }
    .page-link.active {
      background-color: var(--primary-color);
      color: white;
      border-color: var(--primary-color);
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
      <a href="${pageContext.request.contextPath}/admin/post-management" class="menu-item">
        <i class="fas fa-file-alt"></i>
        <span>Post Management</span>
      </a>
      <a href="${pageContext.request.contextPath}/admin/category-management" class="menu-item active">
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
      <h1 class="page-title">Category Management</h1>
      <button class="btn btn-primary" data-modal="add-category-modal">
        <i class="fas fa-folder-plus"></i> Add New Category
      </button>
    </div>

    <!-- Category Stats -->
    <div class="stats-container">
      <div class="row" style="display: flex; gap: 20px; flex-wrap: wrap;">
        <!-- Total Categories -->
        <div class="card" style="flex: 1; min-width: 200px;">
          <div style="display: flex; align-items: center;">
            <div style="background-color: rgba(52, 152, 219, 0.1); padding: 15px; border-radius: 50%; margin-right: 15px;">
              <i class="fas fa-tags" style="font-size: 24px; color: var(--primary-color);"></i>
            </div>
            <div>
              <h3 style="margin: 0; font-size: 24px;">${totalCategories}</h3>
              <p style="margin: 5px 0 0; color: var(--text-light);">Total Categories</p>
            </div>
          </div>
        </div>

        <!-- Most Popular Category -->
        <div class="card" style="flex: 1; min-width: 200px;">
          <div style="display: flex; align-items: center;">
            <div style="background-color: rgba(46, 204, 113, 0.1); padding: 15px; border-radius: 50%; margin-right: 15px;">
              <i class="fas fa-star" style="font-size: 24px; color: var(--success-color);"></i>
            </div>
            <div>
              <h3 style="margin: 0; font-size: 24px;">${mostPopularCategory}</h3>
              <p style="margin: 5px 0 0; color: var(--text-light);">Most Popular</p>
            </div>
          </div>
        </div>

        <!-- Most Posts -->
        <div class="card" style="flex: 1; min-width: 200px;">
          <div style="display: flex; align-items: center;">
            <div style="background-color: rgba(243, 156, 18, 0.1); padding: 15px; border-radius: 50%; margin-right: 15px;">
              <i class="fas fa-file-alt" style="font-size: 24px; color: var(--warning-color);"></i>
            </div>
            <div>
              <h3 style="margin: 0; font-size: 24px;">${mostPopularCategoryPostCount}</h3>
              <p style="margin: 5px 0 0; color: var(--text-light);">Most Blog Posts</p>
            </div>
          </div>
        </div>

        <!-- Least Posts -->
        <div class="card" style="flex: 1; min-width: 200px;">
          <div style="display: flex; align-items: center;">
            <div style="background-color: rgba(231, 76, 60, 0.1); padding: 15px; border-radius: 50%; margin-right: 15px;">
              <i class="fas fa-file-alt" style="font-size: 24px; color: var(--danger-color);"></i>
            </div>
            <div>
              <h3 style="margin: 0; font-size: 24px;">${postsInArt}</h3>
              <p style="margin: 5px 0 0; color: var(--text-light);">Posts in Data Science</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Category Distribution Chart -->
    <div class="card mt-20">
      <div class="card-header">
        <h2 class="card-title">Category Distribution</h2>
      </div>
      <div style="padding: 20px;">
        <!-- Simple bar chart representation -->
        <div style="display: flex; flex-direction: column; gap: 15px;">
          <% 
            java.util.List<java.util.Map<String, Object>> categoryDistribution = 
                (java.util.List<java.util.Map<String, Object>>) request.getAttribute("categoryDistribution");

            // Pagination variables
            int itemsPerPage = 4;
            int currentPage = 1;

            // Get the current page from request parameter
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            if (categoryDistribution != null && !categoryDistribution.isEmpty()) {
                int totalCategories = categoryDistribution.size();
                int totalPages = (int) Math.ceil((double) totalCategories / itemsPerPage);

                // Ensure current page is within valid range
                if (currentPage > totalPages) currentPage = totalPages;

                // Calculate start and end indices for the current page
                int startIndex = (currentPage - 1) * itemsPerPage;
                int endIndex = Math.min(startIndex + itemsPerPage, totalCategories);

                // Display only categories for the current page
                for (int i = startIndex; i < endIndex; i++) {
                    java.util.Map<String, Object> category = categoryDistribution.get(i);
          %>
            <div>
              <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                <span><%= category.get("name") %></span>
                <span><%= category.get("postCount") %> posts (<%= category.get("percentage") %>%)</span>
              </div>
              <div style="height: 20px; background-color: #f0f0f0; border-radius: 5px;">
                <div style="height: 100%; width: <%= category.get("percentage") %>%; background-color: <%= category.get("color") %>; border-radius: 5px;"></div>
              </div>
            </div>
          <% 
                }

                // Add pagination controls if there are multiple pages
                if (totalPages > 1) {
          %>
            <div style="display: flex; justify-content: center; margin-top: 20px;">
              <div class="pagination">
                <% if (currentPage > 1) { %>
                  <a href="${pageContext.request.contextPath}/admin/category-management?page=<%= currentPage - 1 %>" class="page-link">&laquo; Previous</a>
                <% } %>

                <% for (int i = 1; i <= totalPages; i++) { %>
                  <a href="${pageContext.request.contextPath}/admin/category-management?page=<%= i %>" 
                     class="page-link <%= (i == currentPage) ? "active" : "" %>"><%= i %></a>
                <% } %>

                <% if (currentPage < totalPages) { %>
                  <a href="${pageContext.request.contextPath}/admin/category-management?page=<%= currentPage + 1 %>" class="page-link">Next &raquo;</a>
                <% } %>
              </div>
            </div>
          <% 
                }
            } else {
          %>
            <div>
              <p>No categories with posts found.</p>
            </div>
          <% } %>
        </div>
      </div>
    </div>

    <!-- Category Management Table -->
    <div class="card mt-20">
      <div class="card-header">
        <h2 class="card-title">Category List</h2>
        <div class="search-filter-container">
          <div class="search-box">
            <input type="text" class="search-input" id="categories-table-search" placeholder="Search categories...">
            <button class="search-btn"><i class="fas fa-search"></i></button>
          </div>
        </div>
      </div>
      <div class="table-responsive">
        <table class="data-table" id="categories-table">
          <thead>
          <tr>
            <th data-sort="name">Category Name</th>
            <th data-sort="description">Description</th>
            <th data-sort="posts">Posts</th>
            <th>Actions</th>
          </tr>
          </thead>
          <tbody>
          <% 
            java.util.List<com.example.blog_website.models.Category> categories = 
                (java.util.List<com.example.blog_website.models.Category>) request.getAttribute("categories");
            if (categories != null && !categories.isEmpty()) {
                for (com.example.blog_website.models.Category category : categories) {
          %>
            <tr>
              <td><%= category.getName() %></td>
              <td><%= category.getDescription() %></td>
              <td><%= new com.example.blog_website.dao.CategoryDAO().getPostCountByCategoryName(category.getName()) %></td>
              <td>
                <div class="action-buttons">
                  <button class="btn btn-sm btn-primary" data-modal="edit-category-modal" data-category-id="<%= category.getId() %>">Edit</button>
                  <button class="btn btn-sm btn-danger" data-modal="delete-category-modal" data-category-id="<%= category.getId() %>">Delete</button>
                </div>
              </td>
            </tr>
          <% 
                }
            } else {
          %>
            <tr>
              <td colspan="4" class="text-center">No categories found. Add a new category to get started.</td>
            </tr>
          <% } %>
          </tbody>
        </table>
      </div>

      <!-- Add pagination controls for category list if there are multiple pages -->
      <% if (request.getAttribute("totalPages") != null && (Integer)request.getAttribute("totalPages") > 1) { 
           int categoryListCurrentPage = (Integer)request.getAttribute("currentPage");
           int categoryListTotalPages = (Integer)request.getAttribute("totalPages");
      %>
      <div style="display: flex; justify-content: center; margin-top: 20px;">
        <div class="pagination">
          <% if (categoryListCurrentPage > 1) { %>
            <a href="${pageContext.request.contextPath}/admin/category-management?page=<%= categoryListCurrentPage - 1 %>" class="page-link">&laquo; Previous</a>
          <% } %>

          <% for (int i = 1; i <= categoryListTotalPages; i++) { %>
            <a href="${pageContext.request.contextPath}/admin/category-management?page=<%= i %>" 
               class="page-link <%= (i == categoryListCurrentPage) ? "active" : "" %>"><%= i %></a>
          <% } %>

          <% if (categoryListCurrentPage < categoryListTotalPages) { %>
            <a href="${pageContext.request.contextPath}/admin/category-management?page=<%= categoryListCurrentPage + 1 %>" class="page-link">Next &raquo;</a>
          <% } %>
        </div>
      </div>
      <% } %>
    </div>
  </main>
</div>

<!-- Add Category Modal -->
<div class="modal-overlay" id="add-category-modal">
  <div class="modal">
    <div class="modal-header">
      <h3 class="modal-title">Add New Category</h3>
      <button class="modal-close">&times;</button>
    </div>
    <div class="modal-body">
      <form class="demo-form" id="add-category-form">
        <div class="form-group">
          <label for="category-name" class="form-label">Category Name</label>
          <input type="text" id="category-name" class="form-control" required>
        </div>
        <div class="form-group">
          <label for="category-description" class="form-label">Description</label>
          <textarea id="category-description" class="form-control" rows="4" required></textarea>
        </div>
        <div class="form-group">
          <label for="category-slug" class="form-label">Slug</label>
          <input type="text" id="category-slug" class="form-control">
          <small class="form-text">Leave empty to generate automatically from name</small>
        </div>
      </form>
    </div>
    <div class="modal-footer">
      <button class="btn btn-outline modal-cancel">Cancel</button>
      <button class="btn btn-primary" id="add-category-submit">Add Category</button>
    </div>
  </div>
</div>

<!-- Edit Category Modal -->
<div class="modal-overlay" id="edit-category-modal">
  <div class="modal">
    <div class="modal-header">
      <h3 class="modal-title">Edit Category</h3>
      <button class="modal-close">&times;</button>
    </div>
    <div class="modal-body">
      <form class="demo-form" id="edit-category-form">
        <input type="hidden" id="edit-category-id">
        <div class="form-group">
          <label for="edit-category-name" class="form-label">Category Name</label>
          <input type="text" id="edit-category-name" class="form-control" required>
        </div>
        <div class="form-group">
          <label for="edit-category-description" class="form-label">Description</label>
          <textarea id="edit-category-description" class="form-control" rows="4" required></textarea>
        </div>
        <div class="form-group">
          <label for="edit-category-slug" class="form-label">Slug</label>
          <input type="text" id="edit-category-slug" class="form-control">
        </div>
      </form>
    </div>
    <div class="modal-footer">
      <button class="btn btn-outline modal-cancel">Cancel</button>
      <button class="btn btn-primary" id="edit-category-submit">Save Changes</button>
    </div>
  </div>
</div>

<!-- Delete Category Modal -->
<div class="modal-overlay" id="delete-category-modal">
  <div class="modal">
    <div class="modal-header">
      <h3 class="modal-title">Delete Category</h3>
      <button class="modal-close">&times;</button>
    </div>
    <div class="modal-body">
      <input type="hidden" id="delete-category-id">
      <p>Are you sure you want to delete this category?</p>
    </div>
    <div class="modal-footer">
      <button class="btn btn-outline modal-cancel">Cancel</button>
      <button class="btn btn-danger" id="delete-category-submit">Delete Category</button>
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
    initDataTable('categories-table');

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

    // Auto-generate slug from category name
    const categoryName = document.getElementById('category-name');
    const categorySlug = document.getElementById('category-slug');

    if (categoryName && categorySlug) {
      categoryName.addEventListener('input', function() {
        categorySlug.value = this.value
                .toLowerCase()
                .replace(/[^a-z0-9]+/g, '-')
                .replace(/(^-|-$)/g, '');
      });
    }

    // Add Category Form Submission
    const addCategorySubmit = document.getElementById('add-category-submit');
    if (addCategorySubmit) {
      addCategorySubmit.addEventListener('click', function() {
        const name = document.getElementById('category-name').value;
        const description = document.getElementById('category-description').value;

        if (!name || !description) {
          showNotification('Please fill in all required fields', 'error');
          return;
        }

        // In a real application, this would make an API call
        createCategory({
          name: name,
          description: description
        });

        // Close modal
        document.getElementById('add-category-modal').classList.remove('active');

        // Reset form
        document.getElementById('add-category-form').reset();
      });
    }

    // Edit Category Form Submission
    const editCategorySubmit = document.getElementById('edit-category-submit');
    if (editCategorySubmit) {
      editCategorySubmit.addEventListener('click', function() {
        const id = document.getElementById('edit-category-id').value;
        const name = document.getElementById('edit-category-name').value;
        const description = document.getElementById('edit-category-description').value;

        if (!id || !name || !description) {
          showNotification('Please fill in all required fields', 'error');
          return;
        }

        // Make API call to update category
        updateCategory({
          id: id,
          name: name,
          description: description
        });
      });
    }

    // Delete Category Form Submission
    const deleteCategorySubmit = document.getElementById('delete-category-submit');
    if (deleteCategorySubmit) {
      deleteCategorySubmit.addEventListener('click', function() {
        const categoryId = document.getElementById('delete-category-id').value;

        if (!categoryId) {
          showNotification('Category ID is required', 'error');
          return;
        }

        // Make API call to delete category
        deleteCategory(categoryId);
      });
    }

    // Function to create a new category
    function createCategory(categoryData) {
      const formData = new FormData();
      formData.append('name', categoryData.name);
      formData.append('description', categoryData.description);

      fetch('${pageContext.request.contextPath}/admin/category/create', {
        method: 'POST',
        body: formData
      })
              .then(response => {
                if (!response.ok) {
                  throw new Error('Network response was not ok: ' + response.statusText);
                }
                return response.json();
              })
              .then(data => {
                if (data.success) {
                  showNotification(data.message, 'success');
                  // Reload the page to show the updated category list
                  setTimeout(() => {
                    window.location.reload();
                  }, 1000);
                } else {
                  console.error('Server error:', data.message);
                  showNotification(data.message, 'error');
                }
              })
              .catch(error => {
                console.error('Error:', error);
                showNotification('An error occurred while creating the category: ' + error.message, 'error');
              });
    }

    // Function to update a category
    function updateCategory(categoryData) {
      const formData = new FormData();
      formData.append('id', categoryData.id);
      formData.append('name', categoryData.name);
      formData.append('description', categoryData.description);

      fetch('${pageContext.request.contextPath}/admin/category/update', {
        method: 'POST',
        body: formData
      })
              .then(response => response.json())
              .then(data => {
                if (data.success) {
                  showNotification(data.message, 'success');
                  // Close modal
                  document.getElementById('edit-category-modal').classList.remove('active');
                  // Reload the page to show the updated category list
                  setTimeout(() => {
                    window.location.reload();
                  }, 1000);
                } else {
                  showNotification(data.message, 'error');
                }
              })
              .catch(error => {
                console.error('Error:', error);
                showNotification('An error occurred while updating the category', 'error');
              });
    }

    // Function to delete a category
    function deleteCategory(categoryId) {
      const formData = new FormData();
      formData.append('id', categoryId);

      fetch('${pageContext.request.contextPath}/admin/category/delete', {
        method: 'POST',
        body: formData
      })
              .then(response => response.json())
              .then(data => {
                if (data.success) {
                  showNotification(data.message, 'success');
                  // Close modal
                  document.getElementById('delete-category-modal').classList.remove('active');
                  // Reload the page to show the updated category list
                  setTimeout(() => {
                    window.location.reload();
                  }, 1000);
                } else {
                  showNotification(data.message, 'error');
                }
              })
              .catch(error => {
                console.error('Error:', error);
                showNotification('An error occurred while deleting the category', 'error');
              });
    }

    // Set category ID and populate form when opening edit modal
    const editButtons = document.querySelectorAll('[data-modal="edit-category-modal"]');
    editButtons.forEach(button => {
      button.addEventListener('click', function() {
        const categoryId = this.getAttribute('data-category-id');
        document.getElementById('edit-category-id').value = categoryId;

        // In a real application, you would fetch category data from an API
        // For demo purposes, we'll just use the data from the table row
        const row = this.closest('tr');
        document.getElementById('edit-category-name').value = row.cells[0].textContent;
        document.getElementById('edit-category-description').value = row.cells[1].textContent;
        document.getElementById('edit-category-slug').value = row.cells[0].textContent
                .toLowerCase()
                .replace(/[^a-z0-9]+/g, '-')
                .replace(/(^-|-$)/g, '');
      });
    });

    // Set category ID when opening delete modal
    const deleteButtons = document.querySelectorAll('[data-modal="delete-category-modal"]');
    deleteButtons.forEach(button => {
      button.addEventListener('click', function() {
        const categoryId = this.getAttribute('data-category-id');
        document.getElementById('delete-category-id').value = categoryId;
      });
    });
  });
</script>
</body>
</html>
