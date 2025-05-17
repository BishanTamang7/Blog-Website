<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
      <div>
        <button class="btn btn-outline" id="export-report-btn">
          <i class="fas fa-file-export"></i> Export Report
        </button>
        <button class="btn btn-primary" id="refresh-report-btn">
          <i class="fas fa-sync-alt"></i> Refresh Data
        </button>
      </div>
    </div>

    <!-- Report Filters -->
    <div class="card">
      <div class="card-header">
        <h2 class="card-title">Report Filters</h2>
      </div>
      <div class="card-body" style="padding: 20px;">
        <form id="report-filters" style="display: flex; flex-wrap: wrap; gap: 20px;">
          <div class="form-group" style="flex: 1; min-width: 200px;">
            <label for="report-type" class="form-label">Report Type</label>
            <select id="report-type" class="form-control">
              <option value="user-activity">User Activity</option>
              <option value="content-performance">Content Performance</option>
              <option value="category-distribution">Category Distribution</option>
              <option value="traffic-sources">Traffic Sources</option>
            </select>
          </div>
          <div class="form-group" style="flex: 1; min-width: 200px;">
            <label for="date-range" class="form-label">Date Range</label>
            <select id="date-range" class="form-control">
              <option value="7">Last 7 Days</option>
              <option value="30" selected>Last 30 Days</option>
              <option value="90">Last 90 Days</option>
              <option value="365">Last Year</option>
              <option value="custom">Custom Range</option>
            </select>
          </div>
          <div class="form-group" style="flex: 1; min-width: 200px;">
            <label for="data-grouping" class="form-label">Group By</label>
            <select id="data-grouping" class="form-control">
              <option value="day">Day</option>
              <option value="week" selected>Week</option>
              <option value="month">Month</option>
            </select>
          </div>
          <div style="flex-basis: 100%; display: flex; justify-content: flex-end;">
            <button type="button" class="btn btn-primary" id="generate-report-btn">
              <i class="fas fa-chart-line"></i> Generate Report
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Most Active Users Report -->
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
              <th>Rank</th>
              <th>User</th>
              <th>Posts</th>
              <th>Comments</th>
              <th>Last Active</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td>1</td>
              <td>John Doe</td>
              <td>24</td>
              <td>156</td>
              <td>Today</td>
            </tr>
            <tr>
              <td>2</td>
              <td>Jane Smith</td>
              <td>18</td>
              <td>92</td>
              <td>Yesterday</td>
            </tr>
            <tr>
              <td>3</td>
              <td>Mike Johnson</td>
              <td>15</td>
              <td>78</td>
              <td>2 days ago</td>
            </tr>
            <tr>
              <td>4</td>
              <td>Sarah Williams</td>
              <td>12</td>
              <td>64</td>
              <td>3 days ago</td>
            </tr>
            <tr>
              <td>5</td>
              <td>Alex Brown</td>
              <td>10</td>
              <td>42</td>
              <td>1 week ago</td>
            </tr>
            </tbody>
          </table>
        </div>
        <div class="chart-container" style="margin-top: 30px;">
          <!-- User Activity Chart (Simplified Representation) -->
          <div style="display: flex; height: 300px; align-items: flex-end; gap: 20px; padding-bottom: 30px; border-bottom: 1px solid #ddd;">
            <div style="flex: 1; display: flex; flex-direction: column; align-items: center;">
              <div style="width: 50px; background-color: var(--primary-color); height: 80%;"></div>
              <span style="margin-top: 10px;">John</span>
            </div>
            <div style="flex: 1; display: flex; flex-direction: column; align-items: center;">
              <div style="width: 50px; background-color: var(--primary-color); height: 65%;"></div>
              <span style="margin-top: 10px;">Jane</span>
            </div>
            <div style="flex: 1; display: flex; flex-direction: column; align-items: center;">
              <div style="width: 50px; background-color: var(--primary-color); height: 55%;"></div>
              <span style="margin-top: 10px;">Mike</span>
            </div>
            <div style="flex: 1; display: flex; flex-direction: column; align-items: center;">
              <div style="width: 50px; background-color: var(--primary-color); height: 45%;"></div>
              <span style="margin-top: 10px;">Sarah</span>
            </div>
            <div style="flex: 1; display: flex; flex-direction: column; align-items: center;">
              <div style="width: 50px; background-color: var(--primary-color); height: 35%;"></div>
              <span style="margin-top: 10px;">Alex</span>
            </div>
          </div>
          <div style="text-align: center; margin-top: 10px; color: var(--text-light);">
            User Activity (Combined Posts and Comments)
          </div>
        </div>
      </div>
    </div>

    <!-- Posts per Category Report -->
    <div class="card mt-20" id="category-distribution-report">
      <div class="card-header">
        <h2 class="card-title">Posts per Category</h2>
        <span class="report-date">All Time</span>
      </div>
      <div class="card-body" style="padding: 20px;">
        <div class="table-responsive">
          <table class="data-table">
            <thead>
            <tr>
              <th>Category</th>
              <th>Posts</th>
              <th>Percentage</th>
              <th>Avg. Views</th>
              <th>Trend</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td>Technology</td>
              <td>156</td>
              <td>45%</td>
              <td>1,245</td>
              <td><i class="fas fa-arrow-up" style="color: var(--success-color);"></i> 12%</td>
            </tr>
            <tr>
              <td>Lifestyle</td>
              <td>87</td>
              <td>25%</td>
              <td>987</td>
              <td><i class="fas fa-arrow-up" style="color: var(--success-color);"></i> 8%</td>
            </tr>
            <tr>
              <td>Education</td>
              <td>52</td>
              <td>15%</td>
              <td>1,102</td>
              <td><i class="fas fa-arrow-up" style="color: var(--success-color);"></i> 5%</td>
            </tr>
            <tr>
              <td>Travel</td>
              <td>35</td>
              <td>10%</td>
              <td>1,876</td>
              <td><i class="fas fa-arrow-down" style="color: var(--danger-color);"></i> 3%</td>
            </tr>
            <tr>
              <td>Food</td>
              <td>10</td>
              <td>3%</td>
              <td>654</td>
              <td><i class="fas fa-equals" style="color: var(--text-light);"></i> 0%</td>
            </tr>
            <tr>
              <td>Art</td>
              <td>8</td>
              <td>2%</td>
              <td>432</td>
              <td><i class="fas fa-arrow-up" style="color: var(--success-color);"></i> 2%</td>
            </tr>
            </tbody>
          </table>
        </div>
        <div class="chart-container" style="margin-top: 30px;">
          <!-- Category Distribution Chart (Simplified Pie Chart Representation) -->
          <div style="position: relative; width: 300px; height: 300px; margin: 0 auto; border-radius: 50%; background: conic-gradient(
                            var(--primary-color) 0% 45%,
                            var(--success-color) 45% 70%,
                            var(--warning-color) 70% 85%,
                            var(--danger-color) 85% 95%,
                            #9b59b6 95% 98%,
                            #1abc9c 98% 100%
                        );"></div>
          <div style="display: flex; justify-content: center; flex-wrap: wrap; gap: 20px; margin-top: 30px;">
            <div style="display: flex; align-items: center;">
              <div style="width: 20px; height: 20px; background-color: var(--primary-color); margin-right: 10px;"></div>
              <span>Technology (45%)</span>
            </div>
            <div style="display: flex; align-items: center;">
              <div style="width: 20px; height: 20px; background-color: var(--success-color); margin-right: 10px;"></div>
              <span>Lifestyle (25%)</span>
            </div>
            <div style="display: flex; align-items: center;">
              <div style="width: 20px; height: 20px; background-color: var(--warning-color); margin-right: 10px;"></div>
              <span>Education (15%)</span>
            </div>
            <div style="display: flex; align-items: center;">
              <div style="width: 20px; height: 20px; background-color: var(--danger-color); margin-right: 10px;"></div>
              <span>Travel (10%)</span>
            </div>
            <div style="display: flex; align-items: center;">
              <div style="width: 20px; height: 20px; background-color: #9b59b6; margin-right: 10px;"></div>
              <span>Food (3%)</span>
            </div>
            <div style="display: flex; align-items: center;">
              <div style="width: 20px; height: 20px; background-color: #1abc9c; margin-right: 10px;"></div>
              <span>Art (2%)</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Most Viewed Posts Report -->
    <div class="card mt-20" id="content-performance-report">
      <div class="card-header">
        <h2 class="card-title">Most Viewed Posts</h2>
        <span class="report-date">Last 30 Days</span>
      </div>
      <div class="card-body" style="padding: 20px;">
        <div class="table-responsive">
          <table class="data-table">
            <thead>
            <tr>
              <th>Rank</th>
              <th>Post Title</th>
              <th>Author</th>
              <th>Category</th>
              <th>Views</th>
              <th>Avg. Time on Page</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td>1</td>
              <td>The Future of AI</td>
              <td>Mike Johnson</td>
              <td>Technology</td>
              <td>3,542</td>
              <td>4:32</td>
            </tr>
            <tr>
              <td>2</td>
              <td>Travel Destinations 2023</td>
              <td>Alex Brown</td>
              <td>Travel</td>
              <td>3,210</td>
              <td>5:18</td>
            </tr>
            <tr>
              <td>3</td>
              <td>Mastering JavaScript</td>
              <td>Sarah Williams</td>
              <td>Education</td>
              <td>2,876</td>
              <td>7:45</td>
            </tr>
            <tr>
              <td>4</td>
              <td>10 Tips for Healthy Living</td>
              <td>Jane Smith</td>
              <td>Lifestyle</td>
              <td>2,154</td>
              <td>3:21</td>
            </tr>
            <tr>
              <td>5</td>
              <td>Getting Started with React</td>
              <td>John Doe</td>
              <td>Technology</td>
              <td>1,987</td>
              <td>6:12</td>
            </tr>
            </tbody>
          </table>
        </div>
        <div class="chart-container" style="margin-top: 30px;">
          <!-- Post Views Chart (Simplified Line Chart Representation) -->
          <div style="height: 300px; position: relative; padding: 20px 0;">
            <!-- Y-axis labels -->
            <div style="position: absolute; left: 0; top: 0; bottom: 0; width: 50px; display: flex; flex-direction: column; justify-content: space-between; align-items: flex-end; padding-right: 10px;">
              <span>4K</span>
              <span>3K</span>
              <span>2K</span>
              <span>1K</span>
              <span>0</span>
            </div>

            <!-- Chart area -->
            <div style="margin-left: 50px; height: 100%; border-left: 1px solid #ddd; border-bottom: 1px solid #ddd; position: relative;">
              <!-- Line representing views -->
              <svg width="100%" height="100%" style="position: absolute; top: 0; left: 0;">
                <polyline points="
                                        0,80
                                        20%,60
                                        40%,20
                                        60%,40
                                        80%,30
                                        100%,50
                                    " style="fill:none; stroke:var(--primary-color); stroke-width:3;"/>
              </svg>

              <!-- X-axis labels -->
              <div style="position: absolute; bottom: -30px; left: 0; right: 0; display: flex; justify-content: space-between;">
                <span>May 1</span>
                <span>May 7</span>
                <span>May 14</span>
                <span>May 21</span>
                <span>May 28</span>
                <span>Jun 4</span>
              </div>
            </div>
          </div>
          <div style="text-align: center; margin-top: 40px; color: var(--text-light);">
            Post Views Over Time (Top 5 Posts Combined)
          </div>
        </div>
      </div>
    </div>

    <!-- Traffic Sources Report -->
    <div class="card mt-20" id="traffic-sources-report">
      <div class="card-header">
        <h2 class="card-title">Traffic Sources</h2>
        <span class="report-date">Last 30 Days</span>
      </div>
      <div class="card-body" style="padding: 20px;">
        <div class="table-responsive">
          <table class="data-table">
            <thead>
            <tr>
              <th>Source</th>
              <th>Sessions</th>
              <th>Percentage</th>
              <th>Avg. Session Duration</th>
              <th>Bounce Rate</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td>Organic Search</td>
              <td>12,456</td>
              <td>42%</td>
              <td>3:24</td>
              <td>32%</td>
            </tr>
            <tr>
              <td>Direct</td>
              <td>8,765</td>
              <td>30%</td>
              <td>4:12</td>
              <td>28%</td>
            </tr>
            <tr>
              <td>Social Media</td>
              <td>4,321</td>
              <td>15%</td>
              <td>2:45</td>
              <td>45%</td>
            </tr>
            <tr>
              <td>Referral</td>
              <td>2,876</td>
              <td>10%</td>
              <td>3:18</td>
              <td>35%</td>
            </tr>
            <tr>
              <td>Email</td>
              <td>987</td>
              <td>3%</td>
              <td>5:32</td>
              <td>15%</td>
            </tr>
            </tbody>
          </table>
        </div>
        <div class="chart-container" style="margin-top: 30px;">
          <!-- Traffic Sources Chart (Simplified Donut Chart Representation) -->
          <div style="position: relative; width: 300px; height: 300px; margin: 0 auto; border-radius: 50%; background: conic-gradient(
                            var(--primary-color) 0% 42%,
                            var(--success-color) 42% 72%,
                            var(--warning-color) 72% 87%,
                            var(--danger-color) 87% 97%,
                            #9b59b6 97% 100%
                        );">
            <!-- Inner circle to create donut effect -->
            <div style="position: absolute; width: 150px; height: 150px; background-color: white; border-radius: 50%; top: 50%; left: 50%; transform: translate(-50%, -50%);"></div>
          </div>
          <div style="display: flex; justify-content: center; flex-wrap: wrap; gap: 20px; margin-top: 30px;">
            <div style="display: flex; align-items: center;">
              <div style="width: 20px; height: 20px; background-color: var(--primary-color); margin-right: 10px;"></div>
              <span>Organic Search (42%)</span>
            </div>
            <div style="display: flex; align-items: center;">
              <div style="width: 20px; height: 20px; background-color: var(--success-color); margin-right: 10px;"></div>
              <span>Direct (30%)</span>
            </div>
            <div style="display: flex; align-items: center;">
              <div style="width: 20px; height: 20px; background-color: var(--warning-color); margin-right: 10px;"></div>
              <span>Social Media (15%)</span>
            </div>
            <div style="display: flex; align-items: center;">
              <div style="width: 20px; height: 20px; background-color: var(--danger-color); margin-right: 10px;"></div>
              <span>Referral (10%)</span>
            </div>
            <div style="display: flex; align-items: center;">
              <div style="width: 20px; height: 20px; background-color: #9b59b6; margin-right: 10px;"></div>
              <span>Email (3%)</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>

<!-- Export Report Modal -->
<div class="modal-overlay" id="export-report-modal">
  <div class="modal">
    <div class="modal-header">
      <h3 class="modal-title">Export Report</h3>
      <button class="modal-close">&times;</button>
    </div>
    <div class="modal-body">
      <form class="demo-form" id="export-report-form">
        <div class="form-group">
          <label for="export-format" class="form-label">Export Format</label>
          <select id="export-format" class="form-control">
            <option value="pdf">PDF</option>
            <option value="excel">Excel</option>
            <option value="csv">CSV</option>
          </select>
        </div>
        <div class="form-group">
          <label for="export-reports" class="form-label">Reports to Include</label>
          <div class="form-check">
            <input type="checkbox" id="export-user-activity" checked>
            <label for="export-user-activity">User Activity</label>
          </div>
          <div class="form-check">
            <input type="checkbox" id="export-category-distribution" checked>
            <label for="export-category-distribution">Posts per Category</label>
          </div>
          <div class="form-check">
            <input type="checkbox" id="export-content-performance" checked>
            <label for="export-content-performance">Most Viewed Posts</label>
          </div>
          <div class="form-check">
            <input type="checkbox" id="export-traffic-sources" checked>
            <label for="export-traffic-sources">Traffic Sources</label>
          </div>
        </div>
        <div class="form-group">
          <label for="export-date-range" class="form-label">Date Range</label>
          <select id="export-date-range" class="form-control">
            <option value="7">Last 7 Days</option>
            <option value="30" selected>Last 30 Days</option>
            <option value="90">Last 90 Days</option>
            <option value="365">Last Year</option>
            <option value="custom">Custom Range</option>
          </select>
        </div>
      </form>
    </div>
    <div class="modal-footer">
      <button class="btn btn-outline modal-cancel">Cancel</button>
      <button class="btn btn-primary" id="export-report-submit">Export</button>
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

    // Report Type Change Handler
    const reportType = document.getElementById('report-type');
    reportType.addEventListener('change', function() {
      // In a real application, this would show/hide different report sections
      const selectedReport = this.value;
      document.querySelectorAll('[id$="-report"]').forEach(report => {
        report.style.display = 'none';
      });
      document.getElementById(selectedReport + '-report').style.display = 'block';
    });

    // Generate Report Button
    const generateReportBtn = document.getElementById('generate-report-btn');
    generateReportBtn.addEventListener('click', function() {
      // In a real application, this would fetch new data based on filters
      showNotification('Report generated successfully!', 'success');

      // Update report date display
      const dateRange = document.getElementById('date-range').value;
      let dateText = 'Last 30 Days';

      switch(dateRange) {
        case '7':
          dateText = 'Last 7 Days';
          break;
        case '90':
          dateText = 'Last 90 Days';
          break;
        case '365':
          dateText = 'Last Year';
          break;
        case 'custom':
          dateText = 'Custom Range';
          break;
      }

      document.querySelectorAll('.report-date').forEach(span => {
        span.textContent = dateText;
      });
    });

    // Export Report Button
    const exportReportBtn = document.getElementById('export-report-btn');
    exportReportBtn.addEventListener('click', function() {
      document.getElementById('export-report-modal').classList.add('active');
    });

    // Export Report Submit
    const exportReportSubmit = document.getElementById('export-report-submit');
    exportReportSubmit.addEventListener('click', function() {
      // In a real application, this would generate and download the report
      showNotification('Report exported successfully!', 'success');

      // Close modal
      document.getElementById('export-report-modal').classList.remove('active');
    });

    // Refresh Report Button
    const refreshReportBtn = document.getElementById('refresh-report-btn');
    refreshReportBtn.addEventListener('click', function() {
      // In a real application, this would refresh the data
      showNotification('Report data refreshed!', 'success');
    });

    // Initialize with the first report type selected
    reportType.dispatchEvent(new Event('change'));
  });
</script>
</body>
</html>
