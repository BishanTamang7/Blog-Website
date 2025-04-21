package com.example.blog_website.dao.impl;

import com.example.blog_website.dao.ArticleDAO;
import com.example.blog_website.model.Article;
import com.example.blog_website.model.Category;
import com.example.blog_website.model.User;
import com.example.blog_website.util.DbConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Implementation of the ArticleDAO interface
 * Provides concrete methods to interact with the Articles table in the database
 */
public class ArticleDAOImpl implements ArticleDAO {

    /**
     * Creates a new article in the database
     *
     * @param article The Article object to be saved
     * @return The saved Article object with generated ID
     * @throws SQLException If a database error occurs
     */
    @Override
    public Article createArticle(Article article) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet generatedKeys = null;

        try {
            connection = DbConnectionUtil.getConnection();

            // Insert new article
            String query = "INSERT INTO Articles (title, content, user_id, publication_date, status) VALUES (?, ?, ?, ?, ?)";
            statement = connection.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS);
            statement.setString(1, article.getTitle());
            statement.setString(2, article.getContent());
            statement.setLong(3, article.getAuthor().getId());
            
            // Convert Java util.Date to SQL Timestamp
            Timestamp publicationTimestamp = new Timestamp(article.getPublicationDate().getTime());
            statement.setTimestamp(4, publicationTimestamp);
            
            statement.setString(5, "published"); // Default status

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating article failed, no rows affected.");
            }

            // Get the generated ID
            generatedKeys = statement.getGeneratedKeys();
            if (generatedKeys.next()) {
                article.setId((long) generatedKeys.getInt(1));
                
                // Add categories if any
                if (article.getCategories() != null && !article.getCategories().isEmpty()) {
                    for (Category category : article.getCategories()) {
                        addCategoryToArticle(article.getId(), category.getId());
                    }
                }
                
                return article;
            } else {
                throw new SQLException("Creating article failed, no ID obtained.");
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
     * Finds an article by ID
     *
     * @param id The article ID to search for
     * @return The Article object if found, null otherwise
     * @throws SQLException If a database error occurs
     */
    @Override
    public Article findById(Long id) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            connection = DbConnectionUtil.getConnection();

            // Query to get article by ID
            String query = "SELECT a.id, a.title, a.content, a.user_id, a.publication_date, a.status, " +
                          "u.id as author_id, u.username, u.email, u.password, u.role " +
                          "FROM Articles a " +
                          "JOIN Users u ON a.user_id = u.id " +
                          "WHERE a.id = ?";
            statement = connection.prepareStatement(query);
            statement.setLong(1, id);

            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                Article article = mapResultSetToArticle(resultSet);
                
                // Get categories for this article
                article.setCategories(getCategoriesForArticle(id));
                
                return article;
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

    /**
     * Updates an existing article in the database
     *
     * @param article The Article object with updated information
     * @return The updated Article object
     * @throws SQLException If a database error occurs
     */
    @Override
    public Article updateArticle(Article article) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        try {
            connection = DbConnectionUtil.getConnection();

            // Update article information
            String query = "UPDATE Articles SET title = ?, content = ?, user_id = ?, publication_date = ? WHERE id = ?";
            statement = connection.prepareStatement(query);
            statement.setString(1, article.getTitle());
            statement.setString(2, article.getContent());
            statement.setLong(3, article.getAuthor().getId());
            
            // Convert Java util.Date to SQL Timestamp
            Timestamp publicationTimestamp = new Timestamp(article.getPublicationDate().getTime());
            statement.setTimestamp(4, publicationTimestamp);
            
            statement.setLong(5, article.getId());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Updating article failed, no rows affected.");
            }
            
            // Update categories
            // First, remove all existing category associations
            removeAllCategoriesFromArticle(article.getId());
            
            // Then add the current categories
            if (article.getCategories() != null) {
                for (Category category : article.getCategories()) {
                    addCategoryToArticle(article.getId(), category.getId());
                }
            }

            return article;
        } finally {
            // Close resources
            if (statement != null) {
                try { statement.close(); } catch (SQLException e) { /* Ignore */ }
            }
            DbConnectionUtil.closeConnection(connection);
        }
    }

    /**
     * Removes all categories from an article
     *
     * @param articleId The ID of the article
     * @throws SQLException If a database error occurs
     */
    private void removeAllCategoriesFromArticle(Long articleId) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        try {
            connection = DbConnectionUtil.getConnection();

            // Delete all category associations for this article
            String query = "DELETE FROM Article_Categories WHERE article_id = ?";
            statement = connection.prepareStatement(query);
            statement.setLong(1, articleId);

            statement.executeUpdate();
        } finally {
            // Close resources
            if (statement != null) {
                try { statement.close(); } catch (SQLException e) { /* Ignore */ }
            }
            DbConnectionUtil.closeConnection(connection);
        }
    }

    /**
     * Deletes an article from the database
     *
     * @param id The ID of the article to delete
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    @Override
    public boolean deleteArticle(Long id) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        try {
            connection = DbConnectionUtil.getConnection();

            // First, remove all category associations
            removeAllCategoriesFromArticle(id);
            
            // Then delete the article
            String query = "DELETE FROM Articles WHERE id = ?";
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
     * Gets all articles from the database
     *
     * @return List of all articles
     * @throws SQLException If a database error occurs
     */
    @Override
    public List<Article> getAllArticles() throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<Article> articles = new ArrayList<>();

        try {
            connection = DbConnectionUtil.getConnection();

            // Query to get all articles with author information
            String query = "SELECT a.id, a.title, a.content, a.user_id, a.publication_date, a.status, " +
                          "u.id as author_id, u.username, u.email, u.password, u.role " +
                          "FROM Articles a " +
                          "JOIN Users u ON a.user_id = u.id " +
                          "ORDER BY a.publication_date DESC";
            statement = connection.prepareStatement(query);

            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                Article article = mapResultSetToArticle(resultSet);
                
                // Get categories for this article
                article.setCategories(getCategoriesForArticle(article.getId()));
                
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
     * Gets articles by author
     *
     * @param authorId The ID of the author
     * @return List of articles by the specified author
     * @throws SQLException If a database error occurs
     */
    @Override
    public List<Article> getArticlesByAuthor(Long authorId) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<Article> articles = new ArrayList<>();

        try {
            connection = DbConnectionUtil.getConnection();

            // Query to get articles by author
            String query = "SELECT a.id, a.title, a.content, a.user_id, a.publication_date, a.status, " +
                          "u.id as author_id, u.username, u.email, u.password, u.role " +
                          "FROM Articles a " +
                          "JOIN Users u ON a.user_id = u.id " +
                          "WHERE a.user_id = ? " +
                          "ORDER BY a.publication_date DESC";
            statement = connection.prepareStatement(query);
            statement.setLong(1, authorId);

            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                Article article = mapResultSetToArticle(resultSet);
                
                // Get categories for this article
                article.setCategories(getCategoriesForArticle(article.getId()));
                
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
     * Gets articles by category
     *
     * @param categoryId The ID of the category
     * @return List of articles in the specified category
     * @throws SQLException If a database error occurs
     */
    @Override
    public List<Article> getArticlesByCategory(Long categoryId) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<Article> articles = new ArrayList<>();

        try {
            connection = DbConnectionUtil.getConnection();

            // Query to get articles by category
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
                
                // Get categories for this article
                article.setCategories(getCategoriesForArticle(article.getId()));
                
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
     * Gets articles published between two dates
     *
     * @param startDate The start date
     * @param endDate The end date
     * @return List of articles published between the specified dates
     * @throws SQLException If a database error occurs
     */
    @Override
    public List<Article> getArticlesByDateRange(Date startDate, Date endDate) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<Article> articles = new ArrayList<>();

        try {
            connection = DbConnectionUtil.getConnection();

            // Query to get articles by date range
            String query = "SELECT a.id, a.title, a.content, a.user_id, a.publication_date, a.status, " +
                          "u.id as author_id, u.username, u.email, u.password, u.role " +
                          "FROM Articles a " +
                          "JOIN Users u ON a.user_id = u.id " +
                          "WHERE a.publication_date BETWEEN ? AND ? " +
                          "ORDER BY a.publication_date DESC";
            statement = connection.prepareStatement(query);
            statement.setTimestamp(1, new Timestamp(startDate.getTime()));
            statement.setTimestamp(2, new Timestamp(endDate.getTime()));

            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                Article article = mapResultSetToArticle(resultSet);
                
                // Get categories for this article
                article.setCategories(getCategoriesForArticle(article.getId()));
                
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
     * Adds a category to an article
     *
     * @param articleId The ID of the article
     * @param categoryId The ID of the category to add
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    @Override
    public boolean addCategoryToArticle(Long articleId, Long categoryId) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        try {
            connection = DbConnectionUtil.getConnection();

            // Insert article-category association
            String query = "INSERT INTO Article_Categories (article_id, category_id) VALUES (?, ?)";
            statement = connection.prepareStatement(query);
            statement.setLong(1, articleId);
            statement.setLong(2, categoryId);

            int affectedRows = statement.executeUpdate();

            return affectedRows > 0;
        } catch (SQLException e) {
            // Ignore duplicate entry errors (if the association already exists)
            if (e.getErrorCode() == 1062) { // MySQL duplicate entry error code
                return true;
            }
            throw e;
        } finally {
            // Close resources
            if (statement != null) {
                try { statement.close(); } catch (SQLException e) { /* Ignore */ }
            }
            DbConnectionUtil.closeConnection(connection);
        }
    }

    /**
     * Removes a category from an article
     *
     * @param articleId The ID of the article
     * @param categoryId The ID of the category to remove
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    @Override
    public boolean removeCategoryFromArticle(Long articleId, Long categoryId) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        try {
            connection = DbConnectionUtil.getConnection();

            // Delete article-category association
            String query = "DELETE FROM Article_Categories WHERE article_id = ? AND category_id = ?";
            statement = connection.prepareStatement(query);
            statement.setLong(1, articleId);
            statement.setLong(2, categoryId);

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
     * Gets categories for an article
     *
     * @param articleId The ID of the article
     * @return List of categories for the specified article
     * @throws SQLException If a database error occurs
     */
    @Override
    public List<Category> getCategoriesForArticle(Long articleId) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<Category> categories = new ArrayList<>();

        try {
            connection = DbConnectionUtil.getConnection();

            // Query to get categories for an article
            String query = "SELECT c.id, c.name, c.description " +
                          "FROM Categories c " +
                          "JOIN Article_Categories ac ON c.id = ac.category_id " +
                          "WHERE ac.article_id = ? AND c.is_active = TRUE";
            statement = connection.prepareStatement(query);
            statement.setLong(1, articleId);

            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                Category category = new Category();
                category.setId((long) resultSet.getInt("id"));
                category.setName(resultSet.getString("name"));
                category.setDescription(resultSet.getString("description"));
                
                categories.add(category);
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
}