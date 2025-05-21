package com.example.blog_website.controllers.admin;

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

@WebServlet("/admin/delete-post")
public class AdminDeletePostServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the admin user from the session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in and is an admin
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get the post ID from the request
        String postIdStr = request.getParameter("id");
        if (postIdStr == null || postIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/post-management");
            return;
        }
        
        try {
            int postId = Integer.parseInt(postIdStr);
            
            // Get the post from the database
            BlogPostDAO blogPostDAO = new BlogPostDAO();
            BlogPost post = blogPostDAO.getPostById(postId);
            
            // Check if the post exists
            if (post == null) {
                request.getSession().setAttribute("errorMessage", "Post not found.");
                response.sendRedirect(request.getContextPath() + "/admin/post-management");
                return;
            }
            
            // Delete the post (admin can delete any post regardless of author)
            boolean deleted = blogPostDAO.deletePost(postId, post.getAuthorId());
            
            if (deleted) {
                // Post deleted successfully
                request.getSession().setAttribute("successMessage", "Post deleted successfully.");
            } else {
                // Error deleting post
                request.getSession().setAttribute("errorMessage", "An error occurred while deleting the post. Please try again.");
            }
            
            // Redirect back to post management
            response.sendRedirect(request.getContextPath() + "/admin/post-management");
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid post ID. Please try again.");
            response.sendRedirect(request.getContextPath() + "/admin/post-management");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/post-management");
        }
    }
}