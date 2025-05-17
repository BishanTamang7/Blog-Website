package com.example.blog_website.controllers.auth;

import com.example.blog_website.services.AuthServices;
import com.example.blog_website.utils.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "LoginServlet", value = {"/LoginServlet", "/login"})
public class LoginServlet extends HttpServlet {
    private AuthServices authServices;

    @Override
    public void init() throws ServletException {
        authServices = new AuthServices();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // If user is already logged in, redirect to appropriate dashboard
        if (authServices.isLoggedIn(request)) {
            if (authServices.isAdmin(request)) {
                response.sendRedirect(request.getContextPath() + "/admin/admin-dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/user/user-dashboard");
            }
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validate input
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        // Authenticate user
        boolean isAuthenticated = authServices.authenticateUser(email, password, request);

        if (isAuthenticated) {
            // Redirect to appropriate dashboard based on role
            if (authServices.isAdmin(request)) {
                response.sendRedirect(request.getContextPath() + "/admin/admin-dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/user/user-dashboard");
            }
        } else {
            // Authentication failed, show error message
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }
}
