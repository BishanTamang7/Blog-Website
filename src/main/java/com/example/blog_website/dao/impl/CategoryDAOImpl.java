package com.example.blog_website.dao.impl;

import com.example.blog_website.dao.CategoryDAO;
import com.example.blog_website.model.Article;
import com.example.blog_website.model.Category;
import com.example.blog_website.model.User;
import com.example.blog_website.util.DbConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Implementation of the CategoryDAO interface
 * Provides concrete methods to interact with the Categories table in the database
 */
public class CategoryDAOImpl implements CategoryDAO {

    /**
     * Creates a new category in the database
     *
     * @param category The Category object to be saved
     * @return The saved Category object with generated ID
     * @throws SQLException If a database error occurs
     */
    @Override
    public Category createCategory(Category category) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet generatedKeys = null;

        try {
            connection = DbConnectionUtil.getConnection();

            // Insert new category
            String query = "INSERT INTO Categories (name, description) VALUES (?, ?)";
            statement = connection.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS);
            statement.setString(1, category.getName());
            statement.setString(2, category.getDescription());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating category failed, no rows affected.");
            }

            // Get the generated ID
            generatedKeys = statement.getGeneratedKeys();
            if (generatedKeys.next()) {
                category.setId((long) generatedKeys.getInt(1));
                return category;
            } else {
                throw new SQLException("Creating category failed, no ID obtained.");
            }
        } finally {
            // Close resources
            if (generatedKeys != null) {
                try { generatedKeys.close(); } catch (SQLException e) { /* Ignore */ }
            }
            if (statement != null) {
                try { statement.close(); } catch (SQLException e) { /* Ignore */ }
            }
            DbConnectionUtil.closeConnection(connection);
        }
    }

    /**
     * Finds a category by ID
     *
     * @param id The category ID to search for
     * @return The Category object if found, null otherwise
     * @throws SQLException If a database error occurs
     */
    @Override
    public Category findById(Long id) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            connection = DbConnectionUtil.getConnection();

            // Query to get category by ID
            String query = "SELECT id, name, description FROM Categories WHERE id = ? AND is_active = TRUE";
            statement = connection.prepareStatement(query);
            statement.setLong(1, id);

            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return mapResultSetToCategory(resultSet);
            }

            return null;
        } finally {
            // Close resources
            if (resultSet != null) {
                try { resultSet.close(); } catch (SQLException e) { /* Ignore */ }
            }
            if (statement != null) {
                try { statement.close(); } catch (SQLException e) { /* Ignore */ }
            }
            DbConnectionUtil.closeConnection(connection);
        }
    }

    /**
     * Finds a category by name
     *
     * @param name The category name to search for
     * @return The Category object if found, null otherwise
     * @throws SQLException If a database error occurs
     */
    @Override
    public Category findByName(String name) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            connection = DbConnectionUtil.getConnection();

            // Query to get category by name
            String query = "SELECT id, name, description FROM Categories WHERE name = ? AND is_active = TRUE";
            statement = connection.prepareStatement(query);
            statement.setString(1, name);

            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return mapResultSetToCategory(resultSet);
            }

            return null;
        } finally {
            // Close resources
            if (resultSet != null) {
                try { resultSet.close(); } catch (SQLException e) { /* Ignore */ }
            }
            if (statement != null) {
                try { statement.close(); } catch (SQLException e) { /* Ignore */ }
            }
            DbConnectionUtil.closeConnection(connection);
        }
    }

    /**
     * Maps a ResultSet to a Category object
     *
     * @param resultSet The ResultSet containing category data
     * @return The mapped Category object
     * @throws SQLException If a database error occurs
     */
    private Category mapResultSetToCategory(ResultSet resultSet) throws SQLException {
        Category category = new Category();
        category.setId((long) resultSet.getInt("id"));
        category.setName(resultSet.getString("name"));
        category.setDescription(resultSet.getString("description"));
        return category;
    }

    /**
     * Updates an existing category in the database
     *
     * @param category The Category object with updated information
     * @return The updated Category object
     * @throws SQLException If a database error occurs
     */
    @Override
    public Category updateCategory(Category category) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        try {
            connection = DbConnectionUtil.getConnection();

            // Update category information
            String query = "UPDATE Categories SET name = ?, description = ? WHERE id = ? AND is_active = TRUE";
            statement = connection.prepareStatement(query);
            statement.setString(1, category.getName());
            statement.setString(2, category.getDescription());
            statement.setLong(3, category.getId());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Updating category failed, no rows affected.");
            }

            return category;
        } finally {
            // Close resources
            if (statement != null) {
                try { statement.close(); } catch (SQLException e) { /* Ignore */ }
            }
            DbConnectionUtil.closeConnection(connection);
        }
    }

    /**
     * Deactivates a category (sets is_active to FALSE)
     *
     * @param id The ID of the category to deactivate
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    @Override
    public boolean deactivateCategory(Long id) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        try {
            connection = DbConnectionUtil.getConnection();

            // Deactivate category
            String query = "UPDATE Categories SET is_active = FALSE WHERE id = ?";
            statement = connection.prepareStatement(query);
            statement.setLong(1, id);

            int affectedRows = statement.executeUpdate();

            return affectedRows > 0;
        } finally {
            // Close resources
            if (statement != null) {
                try { statement.close(); } catch (SQLException e) { /* Ignore */ }
            }
            DbConnectionUtil.closeConnection(connection);
        }
    }

    /**
     * Gets all active categories from the database
     *
     * @return List of all active categories
     * @throws SQLException If a database error occurs
     */
    @Override
    public List<Category> getAllCategories() throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<Category> categories = new ArrayList<>();

        try {
            connection = DbConnectionUtil.getConnection();

            // Query to get all active categories
            String query = "SELECT id, name, description FROM Categories WHERE is_active = TRUE ORDER BY name";
            statement = connection.prepareStatement(query);

            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                categories.add(mapResultSetToCategory(resultSet));
            }

            return categories;
        } finally {
            // Close resources
            if (resultSet != null) {
                try { resultSet.close(); } catch (SQLException e) { /* Ignore */ }
            }
            if (statement != null) {
                try { statement.close(); } catch (SQLException e) { /* Ignore */ }
            }
            DbConnectionUtil.closeConnection(connection);
        }
    }

    /**
     * Gets articles for a category
     *
     * @param categoryId The ID of the category
     * @return List of articles in the specified category
     * @throws SQLException If a database error occurs
     */
    @Override
    public List<Article> getArticlesForCategory(Long categoryId) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<Article> articles = new ArrayList<>();

        try {
            connection = DbConnectionUtil.getConnection();

            // Query to get articles for a category
            String query = "SELECT a.id, a.title, a.content, a.user_id, a.publication_date, a.status, " +
                          "u.id as author_id, u.username, u.email, u.password, u.role " +
                          "FROM Articles a " +
                          "JOIN Users u ON a.user_id = u.id " +
                          "JOIN Article_Categories ac ON a.id = ac.article_id " +
                          "WHERE ac.category_id = ? " +
                          "ORDER BY a.publication_date DESC";
            statement = connection.prepareStatement(query);
            statement.setLong(1, categoryId);

            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                Article article = mapResultSetToArticle(resultSet);
                articles.add(article);
            }

            return articles;
        } finally {
            // Close resources
            if (resultSet != null) {
                try { resultSet.close(); } catch (SQLException e) { /* Ignore */ }
            }
            if (statement != null) {
                try { statement.close(); } catch (SQLException e) { /* Ignore */ }
            }
            DbConnectionUtil.closeConnection(connection);
        }
    }

    /**
     * Maps a ResultSet to an Article object
     *
     * @param resultSet The ResultSet containing article data
     * @return The mapped Article object
     * @throws SQLException If a database error occurs
     */
    private Article mapResultSetToArticle(ResultSet resultSet) throws SQLException {
        Article article = new Article();
        article.setId((long) resultSet.getInt("id"));
        article.setTitle(resultSet.getString("title"));
        article.setContent(resultSet.getString("content"));
        
        // Map author
        User author = new User();
        author.setId((long) resultSet.getInt("author_id"));
        author.setUsername(resultSet.getString("username"));
        author.setEmail(resultSet.getString("email"));
        author.setPassword(resultSet.getString("password"));
        
        // Map role
        String roleStr = resultSet.getString("role");
        if ("ADMIN".equalsIgnoreCase(roleStr)) {
            author.setRole(User.UserRole.ADMIN);
        } else if ("AUTHOR".equalsIgnoreCase(roleStr)) {
            author.setRole(User.UserRole.AUTHOR);
        } else {
            author.setRole(User.UserRole.READER);
        }
        
        article.setAuthor(author);
        
        // Map publication date
        Timestamp timestamp = resultSet.getTimestamp("publication_date");
        if (timestamp != null) {
            article.setPublicationDate(new Date(timestamp.getTime()));
        }
        
        return article;
    }
}