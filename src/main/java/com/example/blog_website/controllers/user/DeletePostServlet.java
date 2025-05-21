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

@WebServlet("/user/delete-post")
public class DeletePostServlet extends HttpServlet {

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
                request.getSession().setAttribute("errorMessage", "Post not found or you don't have permission to delete it.");
                response.sendRedirect(request.getContextPath() + "/user/draft");
                return;
            }
            
            // Determine if the post is a draft or published
            boolean isDraft = "DRAFT".equals(post.getStatus());
            
            // Delete the post
            boolean deleted = blogPostDAO.deletePost(postId, user.getId());
            
            if (deleted) {
                // Post deleted successfully
                request.getSession().setAttribute("successMessage", "Post deleted successfully.");
                
                // Redirect to the appropriate page based on the post status
                if (isDraft) {
                    response.sendRedirect(request.getContextPath() + "/user/draft");
                } else {
                    response.sendRedirect(request.getContextPath() + "/user/my-stories");
                }
            } else {
                // Error deleting post
                request.getSession().setAttribute("errorMessage", "An error occurred while deleting the post. Please try again.");
                
                // Redirect to the appropriate page based on the post status
                if (isDraft) {
                    response.sendRedirect(request.getContextPath() + "/user/draft");
                } else {
                    response.sendRedirect(request.getContextPath() + "/user/my-stories");
                }
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