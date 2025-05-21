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

@WebServlet("/user/create-post")
public class CreatePostServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the user from the session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get all categories for the dropdown
        CategoryDAO categoryDAO = new CategoryDAO();
        request.setAttribute("categories", categoryDAO.getAllCategories());

        // Forward to the create post page
        request.getRequestDispatcher("/WEB-INF/views/user/create-post.jsp").forward(request, response);
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
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String categoryIdStr = request.getParameter("categoryId");
        String action = request.getParameter("action");

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
            request.getRequestDispatcher("/WEB-INF/views/user/create-post.jsp").forward(request, response);
            return;
        }

        try {
            // Create a new blog post
            BlogPost post = new BlogPost();
            post.setTitle(title);
            post.setContent(content);
            post.setAuthorId(user.getId());
            post.setCategoryId(Integer.parseInt(categoryIdStr));

            // Set the status based on the action
            if ("publish".equals(action)) {
                post.setStatus("PUBLISHED");
                post.setPublishedAt(new java.sql.Timestamp(System.currentTimeMillis()));
            } else {
                post.setStatus("DRAFT");
            }

            // Save the post to the database
            BlogPostDAO blogPostDAO = new BlogPostDAO();
            int postId = blogPostDAO.createPost(post);

            if (postId > 0) {
                // Post created successfully
                if ("publish".equals(action)) {
                    // Redirect to my stories page with success message
                    request.getSession().setAttribute("successMessage", "Your post has been published successfully!");
                    response.sendRedirect(request.getContextPath() + "/user/my-stories");
                } else {
                    // Redirect to drafts page with success message
                    request.getSession().setAttribute("successMessage", "Your draft has been saved successfully!");
                    response.sendRedirect(request.getContextPath() + "/user/draft");
                }
            } else {
                // Error creating post
                request.setAttribute("errorMessage", "An error occurred while creating your post. Please try again.");
                CategoryDAO categoryDAO = new CategoryDAO();
                request.setAttribute("categories", categoryDAO.getAllCategories());
                request.getRequestDispatcher("/WEB-INF/views/user/create-post.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid category selected. Please try again.");
            CategoryDAO categoryDAO = new CategoryDAO();
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/WEB-INF/views/user/create-post.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());
            CategoryDAO categoryDAO = new CategoryDAO();
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/WEB-INF/views/user/create-post.jsp").forward(request, response);
        }
    }
}
