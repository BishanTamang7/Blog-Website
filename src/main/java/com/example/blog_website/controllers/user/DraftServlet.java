package com.example.blog_website.controllers.user;

import com.example.blog_website.dao.BlogPostDAO;
import com.example.blog_website.models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/user/draft")
public class DraftServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the user from the session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check for success message in session
        String successMessage = (String) request.getSession().getAttribute("successMessage");
        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
            // Remove from session after transferring to request
            request.getSession().removeAttribute("successMessage");
        }

        // Get the user's draft posts
        BlogPostDAO blogPostDAO = new BlogPostDAO();
        List<Map<String, Object>> draftPosts = blogPostDAO.getPostsByUser(user.getId(), "DRAFT");

        // Set the draft posts in the request
        request.setAttribute("draftPosts", draftPosts);

        // Forward to the draft page
        request.getRequestDispatcher("/WEB-INF/views/user/draft.jsp").forward(request, response);
    }
}
