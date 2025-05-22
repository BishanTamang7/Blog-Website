package com.example.blog_website.controllers.user;

import com.example.blog_website.dao.BlogPostDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "UserDashboardServlet", value = "/user/user-dashboard")
public class UserDashboardServlet extends HttpServlet {
    private BlogPostDAO blogPostDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        blogPostDAO = new BlogPostDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get published blog posts with pagination
        int page = 1;
        int pageSize = 10;

        // Get page parameter if provided
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                // Invalid page parameter, use default
            }
        }

        // Get published posts
        List<Map<String, Object>> publishedPosts = blogPostDAO.getAllPosts(page, pageSize, "PUBLISHED");
        request.setAttribute("publishedPosts", publishedPosts);

        // Get total count for pagination
        int totalPosts = blogPostDAO.getPublishedPostCount();
        int totalPages = (int) Math.ceil((double) totalPosts / pageSize);

        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/WEB-INF/views/user/user-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
