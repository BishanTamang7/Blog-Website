package com.example.blog_website.controllers.admin;

import com.example.blog_website.services.UserService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.Map;

@WebServlet(name = "AdminCreateUserServlet", value = "/admin/create-user")
public class AdminCreateUserServlet extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form data
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");

        // Validate passwords match
        if (!password.equals(confirmPassword)) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\":false,\"error\":\"Passwords do not match\"}");
            return;
        }

        // Create user
        Map<String, Object> result = userService.createUser(username, email, password, role);

        // Return JSON response
        response.setContentType("application/json");
        if ((boolean) result.get("success")) {
            response.getWriter().write("{\"success\":true,\"userId\":" + result.get("userId") + "}");
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
    }
}