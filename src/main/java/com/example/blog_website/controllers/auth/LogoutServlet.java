package com.example.blog_website.controllers.auth;

import com.example.blog_website.services.AuthServices;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "LogoutServlet", value = "/logout")
public class LogoutServlet extends HttpServlet {
    private AuthServices authServices;

    @Override
    public void init() throws ServletException {
        authServices = new AuthServices();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Logout the user
        authServices.logoutUser(request);

        // Redirect to home page
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle POST requests the same way as GET
        doGet(request, response);
    }
}
