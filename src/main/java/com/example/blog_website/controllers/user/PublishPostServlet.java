package com.example.blog_website.controllers.user;

import com.example.blog_website.dao.BlogPostDAO;
import com.example.blog_website.models.BlogPost;
import com.example.blog_website.models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/user/publish-post")
public class PublishPostServlet extends HttpServlet {

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
                request.getSession().setAttribute("errorMessage", "Post not found or you don't have permission to publish it.");
                response.sendRedirect(request.getContextPath() + "/user/draft");
                return;
            }
            
            // Check if the post is a draft
            if (!"DRAFT".equals(post.getStatus())) {
                request.getSession().setAttribute("errorMessage", "This post is already published.");
                response.sendRedirect(request.getContextPath() + "/user/draft");
                return;
            }
            
            // Update the post status to published
            post.setStatus("PUBLISHED");
            post.setPublishedAt(new Timestamp(System.currentTimeMillis()));
            
            // Save the updated post to the database
            boolean updated = blogPostDAO.updatePost(post);
            
            if (updated) {
                // Post published successfully
                request.getSession().setAttribute("successMessage", "Your post has been published successfully!");
                response.sendRedirect(request.getContextPath() + "/user/my-stories");
            } else {
                // Error publishing post
                request.getSession().setAttribute("errorMessage", "An error occurred while publishing your post. Please try again.");
                response.sendRedirect(request.getContextPath() + "/user/draft");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid post ID. Please try again.");
            response.sendRedirect(request.getContextPath() + "/user/draft");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/user/draft");
        }
    }
}