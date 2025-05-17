package com.example.blog_website.controllers.auth;

import com.example.blog_website.services.UserService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.Map;

@WebServlet(name = "RegisterServlet", value = "/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form parameters
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Register the user
        Map<String, Object> result = userService.registerUser(username, email, password, confirmPassword);

        if ((Boolean) result.get("success")) {
            // Registration successful, redirect to login page with success message
            response.sendRedirect(request.getContextPath() + "/LoginServlet?success=Registration successful! Please login with your credentials.");
        } else {
            // Registration failed, show error message
            Map<String, String> errors = (Map<String, String>) result.get("errors");

            // Set error messages as request attributes
            for (Map.Entry<String, String> error : errors.entrySet()) {
                request.setAttribute(error.getKey() + "Error", error.getValue());
            }

            // Set a general error message
            if (errors.containsKey("general")) {
                request.setAttribute("error", errors.get("general"));
            } else if (errors.containsKey("email") && errors.get("email").equals("Email already exists")) {
                request.setAttribute("error", "Email already exists. Please use a different email address.");
            } else if (errors.containsKey("username") && errors.get("username").equals("Username already exists")) {
                request.setAttribute("error", "Username already exists. Please choose a different username.");
            } else {
                request.setAttribute("error", "Registration failed. Please check the form for errors.");
            }

            // Forward back to the registration page
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }
}
