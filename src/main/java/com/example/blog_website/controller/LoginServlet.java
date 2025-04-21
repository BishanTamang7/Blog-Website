package com.example.blog_website.controller;

import com.example.blog_website.model.User;
import com.example.blog_website.services.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class LoginServlet extends HttpServlet {
    private AuthService authService;

    @Override
    public void init() throws ServletException {
        super.init();
        authService = new AuthService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Forward to login page
        request.getRequestDispatcher("/WEB-INF/view/login/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        boolean rememberMe = request.getParameter("remember") != null;

        try {
            User user = authService.authenticateUser(email, password);

            if (user != null) {
                // Create session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                if (rememberMe) {
                    // Set session timeout to a week (in seconds)
                    session.setMaxInactiveInterval(7 * 24 * 60 * 60);
                }

                // Redirect to home page
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                // Authentication failed
                request.setAttribute("error", "Invalid email or password");
                request.getRequestDispatcher("/WEB-INF/view/login/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // Handle exceptions
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/login/login.jsp").forward(request, response);
        }
    }
}