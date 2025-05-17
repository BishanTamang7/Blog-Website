package com.example.blog_website.controllers.admin;

import com.example.blog_website.models.User;
import com.example.blog_website.services.UserService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "UserManagementServlet", value = "/admin/user-management")
public class UserManagementServlet extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get filter parameter
        String filter = request.getParameter("filter");
        List<User> users;

        // Get users based on filter
        if (filter != null) {
            switch (filter) {
                case "admin":
                    users = userService.getUsersByRole("ADMIN");
                    break;
                case "user":
                    users = userService.getUsersByRole("USER");
                    break;
                default:
                    users = userService.getAllUsers();
                    break;
            }
        } else {
            users = userService.getAllUsers();
        }

        request.setAttribute("users", users);
        request.setAttribute("currentFilter", filter != null ? filter : "all");

        // Get user statistics
        Map<String, Integer> userStats = userService.getUserStats();
        request.setAttribute("totalUsers", userStats.get("totalUsers"));
        request.setAttribute("adminUsers", userStats.get("adminUsers"));
        request.setAttribute("regularUsers", userStats.get("regularUsers"));
        request.setAttribute("newUsersThisMonth", userStats.get("newUsersThisMonth"));

        // Forward to the user management page
        request.getRequestDispatcher("/WEB-INF/views/admin/user-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // This servlet only handles GET requests for listing users
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
}
