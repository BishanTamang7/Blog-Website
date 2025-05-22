<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.example.blog_website.services.ReportService" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>InsightHub Admin - Report Generation</title>
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
      <a href="${pageContext.request.contextPath}/admin/post-management" class="menu-item">
        <i class="fas fa-file-alt"></i>
        <span>Post Management</span>
      </a>
      <a href="${pageContext.request.contextPath}/admin/category-management" class="menu-item">
        <i class="fas fa-tags"></i>
        <span>Category Management</span>
      </a>
      <a href="${pageContext.request.contextPath}/admin/report-management" class="menu-item active">
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
      <h1 class="page-title">Report Generation</h1>
    </div>

    <!-- Report Filters - Simplified -->
    <div class="card">
      <div class="card-header">
        <h2 class="card-title">Select Report</h2>
      </div>
      <div class="card-body" style="padding: 20px;">
        <form id="report-filters" style="display: flex; flex-wrap: wrap; gap: 20px; align-items: flex-end;">
          <div class="form-group" style="flex: 2; min-width: 200px;">
            <label for="report-type" class="form-label">Report Type</label>
            <select id="report-type" class="form-control">
              <option value="user-activity">User Activity</option>
              <option value="category-distribution">Category Distribution</option>
            </select>
          </div>
          <div class="form-group" style="flex: 1; min-width: 200px;">
            <label for="date-range" class="form-label">Time Period</label>
            <select id="date-range" class="form-control">
              <option value="30" selected>Last 30 Days</option>
              <option value="90">Last 90 Days</option>
              <option value="365">Last Year</option>
            </select>
          </div>
        </form>
      </div>
    </div>

    <!-- Most Active Users Report - Simplified -->
    <div class="card mt-20" id="user-activity-report">
      <div class="card-header">
        <h2 class="card-title">Most Active Users</h2>
        <span class="report-date">Last 30 Days</span>
      </div>
      <div class="card-body" style="padding: 20px;">
        <div class="table-responsive">
          <table class="data-table">
            <thead>
            <tr>
              <th>User</th>
              <th>Total Activity</th>
              <th>Last Active</th>
            </tr>
            </thead>
            <tbody>
            <% 
            List<Map<String, Object>> activeUsers = (List<Map<String, Object>>) request.getAttribute("activeUsers");
            if (activeUsers != null && !activeUsers.isEmpty()) {
                for (Map<String, Object> user : activeUsers) {
                    String username = (String) user.get("username");
                    int postCount = (int) user.get("postCount");
                    int totalActivity = (int) user.get("totalActivity");
                    Date lastActive = (Date) user.get("lastActive");
                    String lastActiveStr = com.example.blog_website.services.ReportService.formatRelativeDate(lastActive);
            %>
            <tr>
              <td><%= username %></td>
              <td><%= totalActivity %> (<%= postCount %> posts)</td>
              <td><%= lastActiveStr %></td>
            </tr>
            <% 
                }
            } else {
            %>
            <tr>
              <td colspan="3" class="text-center">No active users found</td>
            </tr>
            <% } %>
            </tbody>
          </table>
        </div>
        <!-- Simple horizontal bar chart -->
        <div style="margin-top: 30px; padding: 0 20px;">
          <% 
          if (activeUsers != null && !activeUsers.isEmpty()) {
              // Find the maximum activity to calculate percentages
              int maxActivity = 0;
              for (Map<String, Object> user : activeUsers) {
                  int activity = (int) user.get("totalActivity");
                  if (activity > maxActivity) {
                      maxActivity = activity;
                  }
              }

              // Display bar chart for each user
              for (Map<String, Object> user : activeUsers) {
                  String username = (String) user.get("username");
                  int activity = (int) user.get("totalActivity");
                  int percentage = maxActivity > 0 ? (activity * 100) / maxActivity : 0;
          %>
          <div style="margin-bottom: 20px; display: flex; align-items: center;">
            <span style="width: 100px;"><%= username %></span>
            <div style="flex-grow: 1; height: 25px; background-color: #f0f0f0; border-radius: 4px;">
              <div style="width: <%= percentage %>%; height: 100%; background-color: var(--primary-color); border-radius: 4px;"></div>
            </div>
            <span style="width: 50px; text-align: right; margin-left: 10px;"><%= activity %></span>
          </div>
          <% 
              }
          } else {
          %>
          <div style="text-align: center; padding: 20px;">
            <p>No activity data available</p>
          </div>
          <% } %>
        </div>
      </div>
    </div>

    <!-- Posts per Category Report - Simplified -->
    <div class="card mt-20" id="category-distribution-report">
      <div class="card-header">
        <h2 class="card-title">Posts per Category</h2>
        <span class="report-date">All Time</span>
      </div>
      <div class="card-body" style="padding: 20px;">
        <!-- Simple horizontal bar chart with integrated data -->
        <div style="padding: 0 20px;">
          <% 
          List<Map<String, Object>> categoryDistribution = (List<Map<String, Object>>) request.getAttribute("categoryDistribution");
          if (categoryDistribution != null && !categoryDistribution.isEmpty()) {
              for (Map<String, Object> category : categoryDistribution) {
                  String name = (String) category.get("name");
                  int postCount = (int) category.get("postCount");
                  int percentage = (int) category.get("percentage");
                  String color = (String) category.get("color");

                  // Set minimum width for very small percentages
                  String displayWidth = percentage < 3 ? "min-width: 80px;" : "";
          %>
          <div style="margin-bottom: 20px; display: flex; align-items: center;">
            <span style="width: 100px; font-weight: bold;"><%= name %></span>
            <div style="flex-grow: 1; height: 30px; background-color: #f0f0f0; border-radius: 4px; position: relative;">
              <div style="width: <%= percentage %>%; height: 100%; background-color: <%= color %>; border-radius: 4px; display: flex; align-items: center; padding-left: 10px; color: white; <%= displayWidth %>">
                <%= postCount %> posts (<%= percentage %>%)
              </div>
            </div>
            <span style="width: 80px; text-align: right; margin-left: 10px;">
              <i class="fas fa-circle" style="color: <%= color %>;"></i>
            </span>
          </div>
          <% 
              }
          } else {
          %>
          <div style="text-align: center; padding: 20px;">
            <p>No category data available</p>
          </div>
          <% } %>
        </div>

        <div style="margin-top: 20px; text-align: center; color: var(--text-light);">
          <% 
          Integer totalPosts = (Integer) request.getAttribute("totalPosts");
          Integer averageViews = (Integer) request.getAttribute("averageViews");
          %>
          <p>Total Posts: <%= totalPosts != null ? totalPosts : 0 %> | Average Views per Post: <%= averageViews != null ? averageViews : 0 %></p>
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
  document.addEventListener('DOMContentLoaded', function() {
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

    // Report Type Change Handler - Simplified
    const reportType = document.getElementById('report-type');
    reportType.addEventListener('change', function() {
      // Hide all reports first
      document.querySelectorAll('[id$="-report"]').forEach(report => {
        report.style.display = 'none';
      });

      // Show the selected report
      const selectedReport = this.value;
      document.getElementById(selectedReport + '-report').style.display = 'block';
    });

    // Update report date display and fetch new data when date range changes
    const dateRange = document.getElementById('date-range');
    dateRange.addEventListener('change', function() {
      let dateText = 'Last 30 Days';

      if (this.value === '90') {
        dateText = 'Last 90 Days';
      } else if (this.value === '365') {
        dateText = 'Last Year';
      }

      document.querySelectorAll('.report-date').forEach(span => {
        span.textContent = dateText;
      });

      // Send AJAX request to update the data
      fetch('${pageContext.request.contextPath}/admin/report-management', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'dateRange=' + this.value
      })
      .then(response => response.text())
      .then(html => {
        // Parse the HTML response
        const parser = new DOMParser();
        const doc = parser.parseFromString(html, 'text/html');

        // Extract the user activity report section from the response
        const newUserActivityReport = doc.getElementById('user-activity-report');
        // Extract the category distribution report section from the response
        const newCategoryDistributionReport = doc.getElementById('category-distribution-report');

        // Replace the current user activity report with the new one
        if (newUserActivityReport) {
          document.getElementById('user-activity-report').innerHTML = newUserActivityReport.innerHTML;
        }

        // Replace the current category distribution report with the new one
        if (newCategoryDistributionReport) {
          document.getElementById('category-distribution-report').innerHTML = newCategoryDistributionReport.innerHTML;
        }
      })
      .catch(error => {
        console.error('Error updating report data:', error);
      });
    });


    // Initialize with the first report type selected
    reportType.dispatchEvent(new Event('change'));
  });
</script>
</body>
</html>
