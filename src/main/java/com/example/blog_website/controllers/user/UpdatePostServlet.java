package com.example.blog_website.controllers.user;

import com.example.blog_website.dao.BlogPostDAO;
import com.example.blog_website.dao.CategoryDAO;
import com.example.blog_website.models.BlogPost;
import com.example.blog_website.models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/user/update-post")
public class UpdatePostServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the user from the session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get the post ID from the request
        String postIdStr = request.getParameter("id");
        if (postIdStr == null || postIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user/draft");
            return;
        }
        
        try {
            int postId = Integer.parseInt(postIdStr);
            
            // Get the post from the database
            BlogPostDAO blogPostDAO = new BlogPostDAO();
            BlogPost post = blogPostDAO.getPostById(postId);
            
            // Check if the post exists and belongs to the current user
            if (post == null || post.getAuthorId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/user/draft");
                return;
            }
            
            // Check if the post is a draft (only drafts can be edited)
            if (!"DRAFT".equals(post.getStatus())) {
                request.getSession().setAttribute("errorMessage", "Only draft posts can be edited.");
                response.sendRedirect(request.getContextPath() + "/user/draft");
                return;
            }
            
            // Get all categories for the dropdown
            CategoryDAO categoryDAO = new CategoryDAO();
            request.setAttribute("categories", categoryDAO.getAllCategories());
            
            // Set the post in the request
            request.setAttribute("post", post);
            
            // Forward to the edit post page
            request.getRequestDispatcher("/WEB-INF/views/user/edit-post.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/user/draft");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the user from the session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get form data
        String postIdStr = request.getParameter("postId");
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String categoryIdStr = request.getParameter("categoryId");
        String action = request.getParameter("action");
        
        // Validate post ID
        if (postIdStr == null || postIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/user/draft");
            return;
        }
        
        try {
            int postId = Integer.parseInt(postIdStr);
            
            // Get the post from the database
            BlogPostDAO blogPostDAO = new BlogPostDAO();
            BlogPost post = blogPostDAO.getPostById(postId);
            
            // Check if the post exists and belongs to the current user
            if (post == null || post.getAuthorId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/user/draft");
                return;
            }
            
            // Check if the post is a draft (only drafts can be edited)
            if (!"DRAFT".equals(post.getStatus())) {
                request.getSession().setAttribute("errorMessage", "Only draft posts can be edited.");
                response.sendRedirect(request.getContextPath() + "/user/draft");
                return;
            }
            
            // Validate input
            boolean hasError = false;
            
            if (title == null || title.trim().isEmpty() || title.length() < 3 || title.length() > 255) {
                request.setAttribute("titleError", "Title must be between 3 and 255 characters");
                hasError = true;
            }
            
            if (content == null || content.trim().isEmpty()) {
                request.setAttribute("contentError", "Content cannot be empty");
                hasError = true;
            }
            
            if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                request.setAttribute("categoryError", "Please select a category");
                hasError = true;
            }
            
            // If there are validation errors, redisplay the form with error messages
            if (hasError) {
                CategoryDAO categoryDAO = new CategoryDAO();
                request.setAttribute("categories", categoryDAO.getAllCategories());
                request.setAttribute("post", post);
                request.getRequestDispatcher("/WEB-INF/views/user/edit-post.jsp").forward(request, response);
                return;
            }
            
            // Update the post
            post.setTitle(title);
            post.setContent(content);
            post.setCategoryId(Integer.parseInt(categoryIdStr));
            
            // Set the status based on the action
            if ("publish".equals(action)) {
                post.setStatus("PUBLISHED");
                post.setPublishedAt(new java.sql.Timestamp(System.currentTimeMillis()));
            }
            
            // Save the updated post to the database
            boolean updated = blogPostDAO.updatePost(post);
            
            if (updated) {
                // Post updated successfully
                if ("publish".equals(action)) {
                    // Redirect to my stories page with success message
                    request.getSession().setAttribute("successMessage", "Your post has been published successfully!");
                    response.sendRedirect(request.getContextPath() + "/user/my-stories");
                } else {
                    // Redirect to drafts page with success message
                    request.getSession().setAttribute("successMessage", "Your draft has been updated successfully!");
                    response.sendRedirect(request.getContextPath() + "/user/draft");
                }
            } else {
                // Error updating post
                request.setAttribute("errorMessage", "An error occurred while updating your post. Please try again.");
                CategoryDAO categoryDAO = new CategoryDAO();
                request.setAttribute("categories", categoryDAO.getAllCategories());
                request.setAttribute("post", post);
                request.getRequestDispatcher("/WEB-INF/views/user/edit-post.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid post ID or category selected. Please try again.");
            response.sendRedirect(request.getContextPath() + "/user/draft");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/user/draft");
        }
    }
}