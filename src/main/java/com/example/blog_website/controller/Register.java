package com.example.blog_website.controller;

import com.example.blog_website.model.User;
import com.example.blog_website.services.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

public class Register extends HttpServlet {
    private AuthService authService;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Forward to registration page
        request.getRequestDispatcher("/WEB-INF/view/register/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate input
        if (username == null || username.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty()) {

            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("/WEB-INF/view/register/register.jsp").forward(request, response);
            return;
        }

        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("/WEB-INF/view/register/register.jsp").forward(request, response);
            return;
        }

        try {
            // Register the user
            User user = authService.registerUser(username, email, password);

            // No need to set profile info as we don't have firstName and lastName
            // If needed, profile info can be updated later

            // Set success message as request attribute for the login page
            request.setAttribute("successMessage", "Registration successful! Please login to continue.");

            // Redirect to login page
            request.getRequestDispatcher("/WEB-INF/view/login/login.jsp").forward(request, response);
        } catch (SQLException e) {
            // Handle database errors
            if (e.getMessage().contains("Duplicate entry") && e.getMessage().contains("username")) {
                request.setAttribute("error", "Username already exists");
            } else if (e.getMessage().contains("Duplicate entry") && e.getMessage().contains("email")) {
                request.setAttribute("error", "Email already exists");
            } else {
                request.setAttribute("error", "An error occurred: " + e.getMessage());
            }
            request.getRequestDispatcher("/WEB-INF/view/register/register.jsp").forward(request, response);
        } catch (Exception e) {
            // Handle other errors
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/register/register.jsp").forward(request, response);
        }
    }
}
