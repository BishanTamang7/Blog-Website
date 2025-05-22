package com.example.blog_website.controllers.admin;

import com.example.blog_website.services.ReportService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ReportManagementServlet", value = "/admin/report-management")
public class ReportManagementServlet extends HttpServlet {
    private final ReportService reportService = new ReportService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get most active users (default to 30 days)
        List<Map<String, Object>> activeUsers = reportService.getMostActiveUsers(5, 30);
        request.setAttribute("activeUsers", activeUsers);

        // Get category distribution
        List<Map<String, Object>> categoryDistribution = reportService.getCategoryDistribution();
        request.setAttribute("categoryDistribution", categoryDistribution);

        // Get total posts and average views
        int totalPosts = reportService.getTotalPosts();
        int averageViews = reportService.getAverageViewsPerPost();
        request.setAttribute("totalPosts", totalPosts);
        request.setAttribute("averageViews", averageViews);

        request.getRequestDispatcher("/WEB-INF/views/admin/report-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle date range changes via AJAX if needed
        String dateRange = request.getParameter("dateRange");
        int days = 30; // Default

        if (dateRange != null) {
            days = Integer.parseInt(dateRange);
        }

        List<Map<String, Object>> activeUsers = reportService.getMostActiveUsers(5, days);
        request.setAttribute("activeUsers", activeUsers);

        // Update category distribution data as well
        List<Map<String, Object>> categoryDistribution = reportService.getCategoryDistribution();
        request.setAttribute("categoryDistribution", categoryDistribution);

        // Update total posts and average views
        int totalPosts = reportService.getTotalPosts();
        int averageViews = reportService.getAverageViewsPerPost();
        request.setAttribute("totalPosts", totalPosts);
        request.setAttribute("averageViews", averageViews);

        request.getRequestDispatcher("/WEB-INF/views/admin/report-management.jsp").forward(request, response);
    }
}
