package com.example.blog_website.dao;

import com.example.blog_website.models.Category;
import com.example.blog_website.utils.DbConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CategoryDAO {

    /**
     * Inserts a new category into the database
     * @param category the category to insert
     * @return the ID of the inserted category, or -1 if the insertion failed
     */
    public int insertCategory(Category category) {
        String sql = "INSERT INTO categories (name, description, created_by) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, category.getName());
            stmt.setString(2, category.getDescription());
            stmt.setInt(3, category.getCreatedBy());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                return -1;
            }

            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            } else {
                return -1;
            }
        } catch (SQLException e) {
            System.err.println("Error inserting category: " + e.getMessage());
            return -1;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Gets all categories from the database
     * @return a list of all categories
     */
    public List<Category> getAllCategories() {
        String sql = "SELECT * FROM categories ORDER BY name ASC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Category> categories = new ArrayList<>();

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }

            return categories;
        } catch (SQLException e) {
            System.err.println("Error getting all categories: " + e.getMessage());
            return categories;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Gets categories with pagination
     * @param page the page number (1-based)
     * @param itemsPerPage the number of items per page
     * @return a list of categories for the specified page
     */
    public List<Category> getPaginatedCategories(int page, int itemsPerPage) {
        String sql = "SELECT * FROM categories ORDER BY name ASC LIMIT ? OFFSET ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Category> categories = new ArrayList<>();

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, itemsPerPage);
            stmt.setInt(2, (page - 1) * itemsPerPage);
            rs = stmt.executeQuery();

            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }

            return categories;
        } catch (SQLException e) {
            System.err.println("Error getting paginated categories: " + e.getMessage());
            return categories;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Gets a category by ID
     * @param id the category ID to search for
     * @return the category if found, null otherwise
     */
    public Category getCategoryById(int id) {
        String sql = "SELECT * FROM categories WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToCategory(rs);
            }

            return null;
        } catch (SQLException e) {
            System.err.println("Error getting category by ID: " + e.getMessage());
            return null;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Updates a category in the database
     * @param category the category to update
     * @return true if the update was successful, false otherwise
     */
    public boolean updateCategory(Category category) {
        String sql = "UPDATE categories SET name = ?, description = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, category.getName());
            stmt.setString(2, category.getDescription());
            stmt.setInt(3, category.getId());

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error updating category: " + e.getMessage());
            return false;
        } finally {
            closeResources(conn, stmt, null);
        }
    }

    /**
     * Deletes a category from the database
     * @param categoryId the ID of the category to delete
     * @return true if the deletion was successful, false otherwise
     */
    public boolean deleteCategory(int categoryId) {
        String sql = "DELETE FROM categories WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, categoryId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting category: " + e.getMessage());
            return false;
        } finally {
            closeResources(conn, stmt, null);
        }
    }

    /**
     * Maps a ResultSet to a Category object
     * @param rs the ResultSet to map
     * @return the mapped Category object
     * @throws SQLException if an error occurs while accessing the ResultSet
     */
    private Category mapResultSetToCategory(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setId(rs.getInt("id"));
        category.setName(rs.getString("name"));
        category.setDescription(rs.getString("description"));
        category.setCreatedBy(rs.getInt("created_by"));
        category.setCreatedAt(rs.getTimestamp("created_at"));
        category.setUpdatedAt(rs.getTimestamp("updated_at"));
        return category;
    }

    /**
     * Gets the total count of categories
     * @return the count of all categories
     */
    public int getCategoryCount() {
        String sql = "SELECT COUNT(*) FROM categories";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

            return 0;
        } catch (SQLException e) {
            System.err.println("Error getting category count: " + e.getMessage());
            return 0;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Gets category distribution data with percentages
     * @return a list of maps containing category data with percentages
     */
    public List<Map<String, Object>> getCategoryDistribution() {
        Map<Integer, Integer> postCountByCategory = new BlogPostDAO().getPostCountByCategory();
        int totalPosts = 0;
        for (Integer count : postCountByCategory.values()) {
            totalPosts += count;
        }

        List<Map<String, Object>> distribution = new ArrayList<>();

        // Define colors for categories
        String[] colors = {
                "#3498db", "#2ecc71", "#f39c18", "#e74c3c", "#9b59b6",
                "#1abc9c", "#d35400", "#34495e", "#16a085", "#c0392b"
        };

        try {
            List<Category> categories = getAllCategories();
            int colorIndex = 0;

            for (Category category : categories) {
                Map<String, Object> categoryData = new HashMap<>();
                int postCount = postCountByCategory.getOrDefault(category.getId(), 0);
                int percentage = totalPosts > 0 ? (postCount * 100) / totalPosts : 0;

                categoryData.put("id", category.getId());
                categoryData.put("name", category.getName());
                categoryData.put("postCount", postCount);
                categoryData.put("percentage", percentage);
                categoryData.put("color", colors[colorIndex % colors.length]);

                distribution.add(categoryData);
                colorIndex++;
            }

            return distribution;
        } catch (Exception e) {
            System.err.println("Error getting category distribution: " + e.getMessage());
            return distribution;
        }
    }

    /**
     * Gets the name of the most active category
     * @return the name of the most active category, or "None" if no categories exist
     */
    public String getMostActiveCategoryName() {
        int categoryId = new BlogPostDAO().getMostActiveCategoryId();
        if (categoryId == -1) {
            return "None";
        }

        Category category = getCategoryById(categoryId);
        return category != null ? category.getName() : "Unknown";
    }

    /**
     * Gets the post count of the most active category
     * @return the post count of the most active category, or 0 if no categories exist
     */
    public int getMostActiveCategoryPostCount() {
        int categoryId = new BlogPostDAO().getMostActiveCategoryId();
        if (categoryId == -1) {
            return 0;
        }

        Map<Integer, Integer> postCountByCategory = new BlogPostDAO().getPostCountByCategory();
        return postCountByCategory.getOrDefault(categoryId, 0);
    }

    /**
     * Gets the number of posts in a category by category name
     * @param categoryName the name of the category
     * @return the number of posts in the category, or 0 if the category doesn't exist
     */
    public int getPostCountByCategoryName(String categoryName) {
        String sql = "SELECT id FROM categories WHERE name = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, categoryName);
            rs = stmt.executeQuery();

            if (rs.next()) {
                int categoryId = rs.getInt("id");
                Map<Integer, Integer> postCountByCategory = new BlogPostDAO().getPostCountByCategory();
                return postCountByCategory.getOrDefault(categoryId, 0);
            }

            return 0;
        } catch (SQLException e) {
            System.err.println("Error getting post count by category name: " + e.getMessage());
            return 0;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Closes database resources
     * @param conn the Connection to close
     * @param stmt the PreparedStatement to close
     * @param rs the ResultSet to close
     */
    private void closeResources(Connection conn, PreparedStatement stmt, ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                System.err.println("Error closing ResultSet: " + e.getMessage());
            }
        }

        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                System.err.println("Error closing PreparedStatement: " + e.getMessage());
            }
        }

        DbConnectionUtil.closeConnection(conn);
    }
}
