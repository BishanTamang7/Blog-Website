package com.example.blog_website.controllers.admin;

import com.example.blog_website.dao.BlogPostDAO;
import com.example.blog_website.dao.CategoryDAO;
import com.example.blog_website.dao.UserDAO;
import com.example.blog_website.models.User;
import com.example.blog_website.utils.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminDashboardServlet", value = "/admin/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in and is an admin
        if (!SessionUtil.isLoggedIn(request)) {
            // User is not logged in, redirect to login page with error message
            response.sendRedirect(request.getContextPath() + "/login?error=Please login to access this page");
            return;
        }

        if (!SessionUtil.isAdmin(request)) {
            // User is logged in but not an admin, redirect to login page with error message
            response.sendRedirect(request.getContextPath() + "/login?error=You do not have permission to access this page");
            return;
        }

        // User is logged in and is an admin, fetch actual dashboard data
        try {
            // Initialize DAOs
            UserDAO userDAO = new UserDAO();
            BlogPostDAO blogPostDAO = new BlogPostDAO();
            CategoryDAO categoryDAO = new CategoryDAO();

            // Get dashboard statistics
            int totalUsers = userDAO.getUserCountByRole(null); // Get count of all users
            int totalPosts = blogPostDAO.getTotalPostCount();
            int totalCategories = categoryDAO.getCategoryCount();
            String mostActiveCategory = categoryDAO.getMostActiveCategoryName();

            // Set dashboard statistics
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalPosts", totalPosts);
            request.setAttribute("totalCategories", totalCategories);
            request.setAttribute("mostActiveCategory", mostActiveCategory);

            // Get recent posts (limit to 5)
            List<Map<String, Object>> recentPosts = blogPostDAO.getRecentPosts(5);
            request.setAttribute("recentPosts", recentPosts);

            // Get new users (limit to 5)
            List<User> allUsers = userDAO.getAllUsers();
            List<Map<String, Object>> newUsers = new ArrayList<>();

            // Process only the first 5 users
            int count = 0;
            for (User user : allUsers) {
                if (count >= 5) break;

                Map<String, Object> userData = new HashMap<>();
                userData.put("username", user.getUsername());

                // Calculate initials
                String initials = "";
                if (user.getFirstName() != null && !user.getFirstName().isEmpty()) {
                    initials += user.getFirstName().charAt(0);
                }
                if (user.getLastName() != null && !user.getLastName().isEmpty()) {
                    initials += user.getLastName().charAt(0);
                }
                if (initials.isEmpty()) {
                    initials = user.getUsername().substring(0, 1).toUpperCase();
                }
                userData.put("initials", initials);

                // Calculate time since joined
                Timestamp createdAt = user.getCreatedAt();
                String joinedAgo = "Just now";
                if (createdAt != null) {
                    LocalDateTime created = createdAt.toLocalDateTime();
                    LocalDateTime now = LocalDateTime.now();
                    long days = ChronoUnit.DAYS.between(created, now);

                    if (days > 30) {
                        joinedAgo = (days / 30) + " months ago";
                    } else if (days > 0) {
                        joinedAgo = days + " days ago";
                    } else {
                        long hours = ChronoUnit.HOURS.between(created, now);
                        if (hours > 0) {
                            joinedAgo = hours + " hours ago";
                        } else {
                            long minutes = ChronoUnit.MINUTES.between(created, now);
                            if (minutes > 0) {
                                joinedAgo = minutes + " minutes ago";
                            }
                        }
                    }
                }
                userData.put("joinedAgo", joinedAgo);

                newUsers.add(userData);
                count++;
            }
            request.setAttribute("newUsers", newUsers);

            // Get category distribution
            List<Map<String, Object>> categoryDistribution = categoryDAO.getCategoryDistribution();
            request.setAttribute("categoryDistribution", categoryDistribution);

            // Forward to admin dashboard
            request.getRequestDispatcher("/WEB-INF/views/admin/admin-dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            // Log the error
            getServletContext().log("Error in admin dashboard", e);

            // Set error message
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());

            // Forward to admin dashboard with error
            request.getRequestDispatcher("/WEB-INF/views/admin/admin-dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirect POST requests to GET
        response.sendRedirect(request.getContextPath() + "/admin/admin-dashboard");
    }
}
