package com.example.blog_website.controllers.admin;

import com.example.blog_website.models.User;
import com.example.blog_website.services.UserService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.Map;

@WebServlet(name = "AdminEditUserServlet", urlPatterns = {"/admin/edit-user"})
public class AdminEditUserServlet extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get user ID from request
        String userIdStr = request.getParameter("id");
        System.out.println("[DEBUG] AdminEditUserServlet doGet - Raw user ID parameter: " + userIdStr);

        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            System.out.println("[DEBUG] AdminEditUserServlet doGet - User ID is null or empty");
            response.setContentType("application/json");
            response.getWriter().write("{\"success\":false,\"error\":\"User ID is required\"}");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            System.out.println("[DEBUG] AdminEditUserServlet doGet - Parsed User ID: " + userId);

            // Get current user from session for comparison
            HttpSession session = request.getSession(false);
            User currentUser = null;
            if (session != null && session.getAttribute("user") != null) {
                currentUser = (User) session.getAttribute("user");
                System.out.println("[DEBUG] AdminEditUserServlet doGet - Current user from session: " +
                        currentUser.getId() + ", " + currentUser.getUsername());
            }

            User user = userService.getUserById(userId);

            if (user == null) {
                System.out.println("[DEBUG] AdminEditUserServlet doGet - User not found for ID: " + userId);
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":false,\"error\":\"User not found\"}");
                return;
            }

            System.out.println("[DEBUG] AdminEditUserServlet doGet - Retrieved user: " + user.getId() + ", " + user.getUsername() + ", " + user.getEmail() + ", " + user.getRole());

            // Check if the retrieved user is the same as the current user
            if (currentUser != null && user.getId() == currentUser.getId()) {
                System.out.println("[DEBUG] AdminEditUserServlet doGet - WARNING: Retrieved user is the same as current user!");
            }

            // Return user data as JSON
            response.setContentType("application/json");
            String jsonResponse = "{\"success\":true,\"user\":{" +
                    "\"id\":" + user.getId() + "," +
                    "\"username\":\"" + user.getUsername() + "\"," +
                    "\"email\":\"" + user.getEmail() + "\"," +
                    "\"role\":\"" + user.getRole() + "\"," +
                    "\"status\":\"" + user.getStatus() + "\"" +
                    "}}";
            System.out.println("[DEBUG] AdminEditUserServlet doGet - JSON response: " + jsonResponse);
            response.getWriter().write(jsonResponse);
        } catch (NumberFormatException e) {
            System.out.println("[DEBUG] AdminEditUserServlet doGet - Invalid user ID: " + userIdStr);
            response.setContentType("application/json");
            response.getWriter().write("{\"success\":false,\"error\":\"Invalid user ID\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        String userIdStr = request.getParameter("id");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        String status = request.getParameter("status");

        System.out.println("[DEBUG] AdminEditUserServlet doPost - Received parameters: id=" + userIdStr +
                ", username=" + username + ", email=" + email + ", role=" + role + ", status=" + status);

        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            System.out.println("[DEBUG] AdminEditUserServlet doPost - User ID is required");
            response.setContentType("application/json");
            response.getWriter().write("{\"success\":false,\"error\":\"User ID is required\"}");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            System.out.println("[DEBUG] AdminEditUserServlet doPost - Parsed user ID: " + userId);

            // Update user
            Map<String, Object> result = userService.updateUser(userId, username, email, role, status);
            System.out.println("[DEBUG] AdminEditUserServlet doPost - Update result: " + result);

            // Return JSON response
            response.setContentType("application/json");
            if ((boolean) result.get("success")) {
                System.out.println("[DEBUG] AdminEditUserServlet doPost - Update successful");
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
                System.out.println("[DEBUG] AdminEditUserServlet doPost - Update failed with errors: " + errors);
                response.getWriter().write(errorJson.toString());
            }
        } catch (NumberFormatException e) {
            System.out.println("[DEBUG] AdminEditUserServlet doPost - Invalid user ID: " + userIdStr);
            response.setContentType("application/json");
            response.getWriter().write("{\"success\":false,\"error\":\"Invalid user ID\"}");
        }
    }
}
