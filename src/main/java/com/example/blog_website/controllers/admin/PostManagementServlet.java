package com.example.blog_website.controllers.admin;

import com.example.blog_website.dao.BlogPostDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "PostManagementServlet", value = "/admin/post-management")
public class PostManagementServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BlogPostDAO blogPostDAO = new BlogPostDAO();

        // Get post statistics
        int totalPosts = blogPostDAO.getTotalPostCount();
        int publishedPosts = blogPostDAO.getPublishedPostCount();
        int draftPosts = blogPostDAO.getDraftPostCount();
        int totalViews = blogPostDAO.getTotalViewCount();

        // Get page parameters
        int page = 1;
        int pageSize = 10;
        String statusFilter = null;

        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }

            String statusParam = request.getParameter("status");
            if (statusParam != null && !statusParam.isEmpty()) {
                if (statusParam.equalsIgnoreCase("published")) {
                    statusFilter = "PUBLISHED";
                } else if (statusParam.equalsIgnoreCase("draft")) {
                    statusFilter = "DRAFT";
                }
            }
        } catch (NumberFormatException e) {
            // Use default values if parameters are invalid
        }

        // Get posts for the current page
        List<Map<String, Object>> posts = blogPostDAO.getAllPosts(page, pageSize, statusFilter);

        // Set attributes for the JSP
        request.setAttribute("totalPosts", totalPosts);
        request.setAttribute("publishedPosts", publishedPosts);
        request.setAttribute("draftPosts", draftPosts);
        request.setAttribute("totalViews", totalViews);
        request.setAttribute("posts", posts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", (int) Math.ceil((double) totalPosts / pageSize));

        request.getRequestDispatcher("/WEB-INF/views/admin/post-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle post actions if needed
        doGet(request, response);
    }
}
