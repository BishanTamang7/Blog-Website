package com.example.blog_website.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.logging.Logger;

@WebServlet(name = "LogoutServlet", value = "/logout")
public class LogoutServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(LogoutServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the current session
        HttpSession session = request.getSession(false);

        // If session exists, invalidate it
        if (session != null) {
            // Log the user logout event
            Object userObj = session.getAttribute("user");
            if (userObj != null) {
                logger.info("User logged out: " + userObj);
            }

            // Invalidate the session
            session.invalidate();
        }

        // Clear any authentication cookies
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("JSESSIONID")) {
                    cookie.setMaxAge(0);
                    cookie.setPath("/");
                    response.addCookie(cookie);
                    break;
                }
            }
        }

        // Redirect to the index page with a message parameter instead of using session
        String contextPath = request.getContextPath();

        // Set the message as a request attribute
        request.setAttribute("message", "You have been successfully logged out");

        // Forward to index.jsp instead of redirect
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Call doGet to handle POST requests the same way
        doGet(request, response);
    }
}
