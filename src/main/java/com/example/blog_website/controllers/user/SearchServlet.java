package com.example.blog_website.controllers.user;

import com.example.blog_website.dao.BlogPostDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet(name = "SearchServlet", value = "/search")
public class SearchServlet extends HttpServlet {
    private BlogPostDAO blogPostDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        blogPostDAO = new BlogPostDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get search keyword
        String keyword = request.getParameter("keyword");
        
        // Get pagination parameters
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

        List<Map<String, Object>> searchResults = new ArrayList<>();
        int totalResults = 0;
        
        // Only search if keyword is provided
        if (keyword != null && !keyword.trim().isEmpty()) {
            // Search for posts matching the keyword
            searchResults = blogPostDAO.searchPosts(keyword.trim(), page, pageSize);
            
            // For simplicity, we're not implementing a count method for search results
            // In a real application, you would create a method to count total search results
            // For now, we'll just assume there are no more pages if results are less than pageSize
            totalResults = searchResults.size() < pageSize ? searchResults.size() : pageSize * page + 1;
        }
        
        int totalPages = (int) Math.ceil((double) totalResults / pageSize);
        
        // Set attributes for the JSP
        request.setAttribute("keyword", keyword);
        request.setAttribute("searchResults", searchResults);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        // Forward to search results page
        request.getRequestDispatcher("/WEB-INF/views/user/search-results.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirect POST requests to GET
        String keyword = request.getParameter("keyword");
        response.sendRedirect(request.getContextPath() + "/search?keyword=" + (keyword != null ? keyword : ""));
    }
}