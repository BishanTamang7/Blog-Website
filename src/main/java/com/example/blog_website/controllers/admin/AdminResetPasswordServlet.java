package com.example.blog_website.controllers.admin;

import com.example.blog_website.services.UserService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.Map;

@WebServlet(name = "AdminResetPasswordServlet", value = "/admin/reset-password")
public class AdminResetPasswordServlet extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        String userIdStr = request.getParameter("id");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");

        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\":false,\"error\":\"User ID is required\"}");
            return;
        }

        // Validate passwords match
        if (!newPassword.equals(confirmNewPassword)) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\":false,\"error\":\"Passwords do not match\"}");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);

            // Reset password
            Map<String, Object> result = userService.resetUserPassword(userId, newPassword);

            // Return JSON response
            response.setContentType("application/json");
            if ((boolean) result.get("success")) {
                response.getWriter().write("{\"success\":true}");
            } else {
                // Format errors as JSON
                StringBuilder errorJson = new StringBuilder("{\"success\":false,\"errors\":{");
                Map<String, String> errors = (Map<String, String>) result.get("errors");
                boolean first = true;
                for (Map.Entry<String, String> error : errors.entrySet()) {
                    if (!first) {
                        errorJson.append(",");
                    }
                    first = false;
                    errorJson.append("\"").append(error.getKey()).append("\":\"").append(error.getValue()).append("\"");
                }
                errorJson.append("}}");
                response.getWriter().write(errorJson.toString());
            }
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\":false,\"error\":\"Invalid user ID\"}");
        }
    }
}