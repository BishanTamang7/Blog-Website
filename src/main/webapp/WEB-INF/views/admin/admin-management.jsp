<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>InsightHub Admin - Dashboard</title>
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
            <a href="${pageContext.request.contextPath}/admin/admin-dashboard" class="menu-item active">
                <i class="fas fa-tachometer-alt"></i>
                <span>Dashboard</span>
            </a>
            <a href="${pageContext.request.contextPath}/UserManagementServlet" class="menu-item">
                <i class="fas fa-users"></i>
                <span>User Management</span>
            </a>
            <a href="${pageContext.request.contextPath}/PostManagementServlet" class="menu-item">
                <i class="fas fa-file-alt"></i>
                <span>Post Management</span>
            </a>
            <a href="${pageContext.request.contextPath}/CategoryManagementServlet" class="menu-item">
                <i class="fas fa-tags"></i>
                <span>Category Management</span>
            </a>
            <a href="${pageContext.request.contextPath}/ReportManagementServlet" class="menu-item">
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
                <span>Welcome, Admin</span>
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
                            <h3 style="margin: 0; font-size: 24px;">125</h3>
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
                            <h3 style="margin: 0; font-size: 24px;">348</h3>
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
                            <h3 style="margin: 0; font-size: 24px;">12</h3>
                            <p style="margin: 5px 0 0; color: var(--text-light);">Categories</p>
                        </div>
                    </div>
                </div>

                <!-- Views Stat -->
                <div class="card" style="flex: 1; min-width: 200px;">
                    <div style="display: flex; align-items: center;">
                        <div style="background-color: rgba(231, 76, 60, 0.1); padding: 15px; border-radius: 50%; margin-right: 15px;">
                            <i class="fas fa-eye" style="font-size: 24px; color: var(--danger-color);"></i>
                        </div>
                        <div>
                            <h3 style="margin: 0; font-size: 24px;">15.2K</h3>
                            <p style="margin: 5px 0 0; color: var(--text-light);">Total Views</p>
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
                    <a href="${pageContext.request.contextPath}/PostManagementServlet" class="btn btn-sm btn-outline">View All</a>
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
                    <tr>
                        <td>Getting Started with React</td>
                        <td>John Doe</td>
                        <td>Technology</td>
                        <td>2023-06-15</td>
                        <td>1,245</td>
                    </tr>
                    <tr>
                        <td>10 Tips for Healthy Living</td>
                        <td>Jane Smith</td>
                        <td>Lifestyle</td>
                        <td>2023-06-12</td>
                        <td>987</td>
                    </tr>
                    <tr>
                        <td>The Future of AI</td>
                        <td>Mike Johnson</td>
                        <td>Technology</td>
                        <td>2023-06-10</td>
                        <td>2,341</td>
                    </tr>
                    <tr>
                        <td>Mastering JavaScript</td>
                        <td>Sarah Williams</td>
                        <td>Education</td>
                        <td>2023-06-08</td>
                        <td>1,876</td>
                    </tr>
                    <tr>
                        <td>Travel Destinations 2023</td>
                        <td>Alex Brown</td>
                        <td>Travel</td>
                        <td>2023-06-05</td>
                        <td>3,210</td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <!-- Recent Users -->
            <div class="card" style="flex: 1; min-width: 300px;">
                <div class="card-header">
                    <h2 class="card-title">New Users</h2>
                    <a href="${pageContext.request.contextPath}/UserManagementServlet" class="btn btn-sm btn-outline">View All</a>
                </div>
                <ul style="list-style: none; padding: 0;">
                    <li style="padding: 12px 0; border-bottom: 1px solid var(--border-color); display: flex; align-items: center;">
                        <div style="width: 40px; height: 40px; background-color: #3498db; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; margin-right: 15px;">JD</div>
                        <div>
                            <h4 style="margin: 0;">John Doe</h4>
                            <p style="margin: 5px 0 0; color: var(--text-light); font-size: 0.9rem;">Joined: 2 days ago</p>
                        </div>
                    </li>
                    <li style="padding: 12px 0; border-bottom: 1px solid var(--border-color); display: flex; align-items: center;">
                        <div style="width: 40px; height: 40px; background-color: #2ecc71; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; margin-right: 15px;">JS</div>
                        <div>
                            <h4 style="margin: 0;">Jane Smith</h4>
                            <p style="margin: 5px 0 0; color: var(--text-light); font-size: 0.9rem;">Joined: 3 days ago</p>
                        </div>
                    </li>
                    <li style="padding: 12px 0; border-bottom: 1px solid var(--border-color); display: flex; align-items: center;">
                        <div style="width: 40px; height: 40px; background-color: #e74c3c; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; margin-right: 15px;">MJ</div>
                        <div>
                            <h4 style="margin: 0;">Mike Johnson</h4>
                            <p style="margin: 5px 0 0; color: var(--text-light); font-size: 0.9rem;">Joined: 5 days ago</p>
                        </div>
                    </li>
                    <li style="padding: 12px 0; border-bottom: 1px solid var(--border-color); display: flex; align-items: center;">
                        <div style="width: 40px; height: 40px; background-color: #f39c12; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; margin-right: 15px;">SW</div>
                        <div>
                            <h4 style="margin: 0;">Sarah Williams</h4>
                            <p style="margin: 5px 0 0; color: var(--text-light); font-size: 0.9rem;">Joined: 1 week ago</p>
                        </div>
                    </li>
                    <li style="padding: 12px 0; display: flex; align-items: center;">
                        <div style="width: 40px; height: 40px; background-color: #9b59b6; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; margin-right: 15px;">AB</div>
                        <div>
                            <h4 style="margin: 0;">Alex Brown</h4>
                            <p style="margin: 5px 0 0; color: var(--text-light); font-size: 0.9rem;">Joined: 2 weeks ago</p>
                        </div>
                    </li>
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
                        <div>
                            <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                                <span>Technology</span>
                                <span>45%</span>
                            </div>
                            <div style="height: 10px; background-color: #f0f0f0; border-radius: 5px;">
                                <div style="height: 100%; width: 45%; background-color: var(--primary-color); border-radius: 5px;"></div>
                            </div>
                        </div>
                        <div>
                            <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                                <span>Lifestyle</span>
                                <span>25%</span>
                            </div>
                            <div style="height: 10px; background-color: #f0f0f0; border-radius: 5px;">
                                <div style="height: 100%; width: 25%; background-color: var(--success-color); border-radius: 5px;"></div>
                            </div>
                        </div>
                        <div>
                            <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                                <span>Education</span>
                                <span>15%</span>
                            </div>
                            <div style="height: 10px; background-color: #f0f0f0; border-radius: 5px;">
                                <div style="height: 100%; width: 15%; background-color: var(--warning-color); border-radius: 5px;"></div>
                            </div>
                        </div>
                        <div>
                            <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                                <span>Travel</span>
                                <span>10%</span>
                            </div>
                            <div style="height: 10px; background-color: #f0f0f0; border-radius: 5px;">
                                <div style="height: 100%; width: 10%; background-color: var(--danger-color); border-radius: 5px;"></div>
                            </div>
                        </div>
                        <div>
                            <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                                <span>Other</span>
                                <span>5%</span>
                            </div>
                            <div style="height: 10px; background-color: #f0f0f0; border-radius: 5px;">
                                <div style="height: 100%; width: 5%; background-color: #9b59b6; border-radius: 5px;"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="card" style="flex: 1; min-width: 300px;">
                <div class="card-header">
                    <h2 class="card-title">Quick Actions</h2>
                </div>
                <div style="padding: 20px; display: flex; flex-direction: column; gap: 15px;">
                    <a href="${pageContext.request.contextPath}/UserManagementServlet" class="btn btn-primary" style="text-align: center;">
                        <i class="fas fa-user-plus"></i> Add New User
                    </a>
                    <a href="${pageContext.request.contextPath}/PostManagementServlet" class="btn btn-success" style="text-align: center;">
                        <i class="fas fa-file-medical"></i> Create New Post
                    </a>
                    <a href="${pageContext.request.contextPath}/CategoryManagementServlet" class="btn btn-warning" style="text-align: center;">
                        <i class="fas fa-folder-plus"></i> Add New Category
                    </a>
                    <a href="${pageContext.request.contextPath}/ReportManagementServlet" class="btn btn-danger" style="text-align: center;">
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

        logoutBtn.addEventListener('click', function(e) {
            e.preventDefault();
            logoutModal.classList.add('active');
        });

        confirmLogout.addEventListener('click', function() {
            // Redirect to the LogoutServlet
            window.location.href = '${pageContext.request.contextPath}/logout';
        });
    });
</script>
</body>
</html>
