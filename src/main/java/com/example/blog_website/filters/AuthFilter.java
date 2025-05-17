package com.example.blog_website.filters;

import com.example.blog_website.utils.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Filter for authentication and authorization
 * Protects URLs under /admin/* and /user/*
 * Redirects to login page if not logged in
 * Redirects to appropriate dashboard if trying to access another role's dashboard
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/admin/*", "/user/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code, if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Check if user is logged in
        if (!SessionUtil.isLoggedIn(httpRequest)) {
            // User is not logged in, redirect to login page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/LoginServlet");
            return;
        }

        // User is logged in, check if they're trying to access the correct area
        String requestURI = httpRequest.getRequestURI();
        String userRole = SessionUtil.getUserRole(httpRequest);

        // Check if admin is trying to access user area or user is trying to access admin area
        if (requestURI.contains("/admin/") && !"ADMIN".equals(userRole)) {
            // User is trying to access admin area, redirect to user dashboard
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/user/user-dashboard");
            return;
        } else if (requestURI.contains("/user/") && "ADMIN".equals(userRole)) {
            // Admin is trying to access user area, redirect to admin dashboard
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/admin/admin-dashboard");
            return;
        }

        // User is authorized to access the requested resource
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup code, if needed
    }
}