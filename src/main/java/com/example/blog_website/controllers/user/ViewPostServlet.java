package com.example.blog_website.controllers.user;

import com.example.blog_website.dao.BlogPostDAO;
import com.example.blog_website.dao.UserDAO;
import com.example.blog_website.dao.CategoryDAO;
import com.example.blog_website.models.BlogPost;
import com.example.blog_website.models.Category;
import com.example.blog_website.models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/user/view-post")
public class ViewPostServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the post ID from the request parameters
        String postIdParam = request.getParameter("id");

        if (postIdParam == null || postIdParam.isEmpty()) {
            // If no post ID is provided, redirect to my-stories page
            response.sendRedirect(request.getContextPath() + "/user/my-stories");
            return;
        }

        try {
            int postId = Integer.parseInt(postIdParam);

            // Get the blog post from the database
            BlogPostDAO blogPostDAO = new BlogPostDAO();
            BlogPost post = blogPostDAO.getPostById(postId);

            if (post == null) {
                // If post doesn't exist, redirect to my-stories page
                response.sendRedirect(request.getContextPath() + "/user/my-stories");
                return;
            }

            // Get the user session
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");

            if (currentUser == null) {
                // If user is not logged in, redirect to login page
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Increment the view count only if the viewer is not the author
            if (post.getAuthorId() != currentUser.getId()) {
                post.incrementViewCount();
                blogPostDAO.updateViewCount(post.getId(), post.getViewCount());
            }

            // Get the author information
            UserDAO userDAO = new UserDAO();
            User author = userDAO.getUserById(post.getAuthorId());

            // Get the category information
            CategoryDAO categoryDAO = new CategoryDAO();
            Category category = categoryDAO.getCategoryById(post.getCategoryId());
            String categoryName = category != null ? category.getName() : "Uncategorized";

            // Set attributes for the JSP
            request.setAttribute("post", post);
            request.setAttribute("author", author);
            request.setAttribute("categoryName", categoryName);

            // Forward to the view post page
            request.getRequestDispatcher("/WEB-INF/views/user/view-post.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            // If post ID is not a valid number, redirect to my-stories page
            response.sendRedirect(request.getContextPath() + "/user/my-stories");
        }
    }
}
