package com.example.blog_website.controllers.admin;

import com.example.blog_website.dao.CategoryDAO;
import com.example.blog_website.models.Category;
import com.example.blog_website.models.User;
import com.example.blog_website.utils.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(name = "CategoryManagementServlet", urlPatterns = {
        "/admin/category-management",
        "/admin/category/create",
        "/admin/category/update",
        "/admin/category/delete",
        "/admin/category/get"
})
@MultipartConfig
public class CategoryManagementServlet extends HttpServlet {
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getServletPath();

        if (pathInfo.equals("/admin/category/get")) {
            // Handle get category by ID
            handleGetCategory(request, response);
        } else {
            // Load all categories for the main page
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);

            // Get real-time data for dashboard
            int totalCategories = categoryDAO.getCategoryCount();
            String mostPopularCategory = categoryDAO.getMostActiveCategoryName();
            int mostPopularCategoryPostCount = categoryDAO.getMostActiveCategoryPostCount();
            int postsInArt = categoryDAO.getPostCountByCategoryName("Art");
            List<Map<String, Object>> categoryDistribution = categoryDAO.getCategoryDistribution();

            // Set attributes for the dashboard
            request.setAttribute("totalCategories", totalCategories);
            request.setAttribute("mostPopularCategory", mostPopularCategory);
            request.setAttribute("mostPopularCategoryPostCount", mostPopularCategoryPostCount);
            request.setAttribute("postsInArt", postsInArt);
            request.setAttribute("categoryDistribution", categoryDistribution);

            request.getRequestDispatcher("/WEB-INF/views/admin/category-management.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getServletPath();

        switch (pathInfo) {
            case "/admin/category/create":
                handleCreateCategory(request, response);
                break;
            case "/admin/category/update":
                handleUpdateCategory(request, response);
                break;
            case "/admin/category/delete":
                handleDeleteCategory(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    private void handleCreateCategory(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            // Get form parameters from multipart request
            Part namePart = request.getPart("name");
            Part descriptionPart = request.getPart("description");

            String name = null;
            String description = null;

            if (namePart != null) {
                name = readPartContent(namePart);
            }

            if (descriptionPart != null) {
                description = readPartContent(descriptionPart);
            }

            // Validate input
            if (name == null || name.trim().isEmpty() || description == null || description.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"Name and description are required\"}");
                return;
            }

            // Get current user from session
            User currentUser = SessionUtil.getCurrentUser(request);

            if (currentUser == null) {
                out.print("{\"success\": false, \"message\": \"User not authenticated\"}");
                return;
            }

            // Create category object
            Category category = new Category(name, description, currentUser.getId());

            // Insert category
            int categoryId = categoryDAO.insertCategory(category);

            if (categoryId > 0) {
                out.print("{\"success\": true, \"message\": \"Category created successfully\", \"categoryId\": " + categoryId + "}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to create category. Please check if a category with this name already exists.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log the full stack trace for debugging
            out.print("{\"success\": false, \"message\": \"An error occurred while creating the category: " + e.getMessage() + "\"}");
        }
    }

    // Helper method to read content from a Part
    private String readPartContent(Part part) throws IOException {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(part.getInputStream()))) {
            return reader.lines().collect(Collectors.joining());
        }
    }

    private void handleUpdateCategory(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            // Get form parameters from multipart request
            Part idPart = request.getPart("id");
            Part namePart = request.getPart("name");
            Part descriptionPart = request.getPart("description");

            String idStr = null;
            String name = null;
            String description = null;

            if (idPart != null) {
                idStr = readPartContent(idPart);
            }

            if (namePart != null) {
                name = readPartContent(namePart);
            }

            if (descriptionPart != null) {
                description = readPartContent(descriptionPart);
            }

            // Validate input
            if (idStr == null || idStr.trim().isEmpty() || name == null || name.trim().isEmpty() ||
                    description == null || description.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"ID, name, and description are required\"}");
                return;
            }

            int id = Integer.parseInt(idStr);

            // Get existing category
            Category category = categoryDAO.getCategoryById(id);

            if (category == null) {
                out.print("{\"success\": false, \"message\": \"Category not found\"}");
                return;
            }

            // Update category
            category.setName(name);
            category.setDescription(description);

            boolean updated = categoryDAO.updateCategory(category);

            if (updated) {
                out.print("{\"success\": true, \"message\": \"Category updated successfully\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to update category\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid category ID\"}");
        } catch (Exception e) {
            out.print("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
        }
    }

    private void handleDeleteCategory(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            // Get category ID from multipart request
            Part idPart = request.getPart("id");

            String idStr = null;

            if (idPart != null) {
                idStr = readPartContent(idPart);
            }

            // Validate input
            if (idStr == null || idStr.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"Category ID is required\"}");
                return;
            }

            int id = Integer.parseInt(idStr);

            // Delete category
            boolean deleted = categoryDAO.deleteCategory(id);

            if (deleted) {
                out.print("{\"success\": true, \"message\": \"Category deleted successfully\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to delete category\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid category ID\"}");
        } catch (Exception e) {
            out.print("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
        }
    }

    private void handleGetCategory(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            // Get category ID - for GET requests, we still use getParameter
            String idStr = request.getParameter("id");

            // Validate input
            if (idStr == null || idStr.trim().isEmpty()) {
                out.print("{\"success\": false, \"message\": \"Category ID is required\"}");
                return;
            }

            int id = Integer.parseInt(idStr);

            // Get category
            Category category = categoryDAO.getCategoryById(id);

            if (category != null) {
                // Convert category to JSON
                String json = "{\"success\": true, \"category\": {" +
                        "\"id\": " + category.getId() + "," +
                        "\"name\": \"" + category.getName() + "\"," +
                        "\"description\": \"" + category.getDescription() + "\"" +
                        "}}";
                out.print(json);
            } else {
                out.print("{\"success\": false, \"message\": \"Category not found\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid category ID\"}");
        } catch (Exception e) {
            out.print("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
        }
    }
}
