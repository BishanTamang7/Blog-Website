package com.example.blog_website.controllers.user;

import com.example.blog_website.dao.UserDAO;
import com.example.blog_website.models.User;
import com.example.blog_website.utils.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {
    private static final Pattern PASSWORD_PATTERN = Pattern.compile("^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$");
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Forward to change password page
        request.getRequestDispatcher("/WEB-INF/views/user/change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the user from the session
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get form data
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate form data
        Map<String, String> errors = validatePasswordData(user, oldPassword, newPassword, confirmPassword);

        // If there are validation errors, redirect back to change password page with errors
        if (!errors.isEmpty()) {
            for (Map.Entry<String, String> error : errors.entrySet()) {
                request.setAttribute(error.getKey(), error.getValue());
            }
            request.setAttribute("errorMessage", "Please fix the errors below.");
            request.getRequestDispatcher("/WEB-INF/views/user/change-password.jsp").forward(request, response);
            return;
        }

        // Hash the new password
        String hashedPassword = PasswordUtil.hashPassword(newPassword);

        // Update the password in the database
        boolean updated = userDAO.updateUserPassword(user.getId(), hashedPassword);

        if (updated) {
            // Update the user object in the session
            user.setPassword(hashedPassword);
            request.getSession().setAttribute("user", user);
            request.setAttribute("successMessage", "Password changed successfully!");
        } else {
            request.setAttribute("errorMessage", "Failed to change password. Please try again.");
        }

        // Redirect back to change password page
        request.getRequestDispatcher("/WEB-INF/views/user/change-password.jsp").forward(request, response);
    }

    private Map<String, String> validatePasswordData(User user, String oldPassword, String newPassword, String confirmPassword) {
        Map<String, String> errors = new HashMap<>();

        // Validate old password
        if (oldPassword == null || oldPassword.trim().isEmpty()) {
            errors.put("oldPasswordError", "Current password is required");
        } else if (!PasswordUtil.verifyPassword(oldPassword, user.getPassword())) {
            errors.put("oldPasswordError", "Current password is incorrect");
        }

        // Validate new password
        if (newPassword == null || newPassword.trim().isEmpty()) {
            errors.put("newPasswordError", "New password is required");
        } else if (!PASSWORD_PATTERN.matcher(newPassword).matches()) {
            errors.put("newPasswordError", "Password must be at least 8 characters and contain letters and numbers");
        }

        // Validate confirm password
        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            errors.put("confirmPasswordError", "Confirm password is required");
        } else if (!confirmPassword.equals(newPassword)) {
            errors.put("confirmPasswordError", "Passwords do not match");
        }

        return errors;
    }
}