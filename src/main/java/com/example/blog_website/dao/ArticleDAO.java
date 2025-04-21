package com.example.blog_website.dao;

import com.example.blog_website.model.Article;
import com.example.blog_website.model.Category;
import com.example.blog_website.model.User;
import java.sql.SQLException;
import java.util.List;
import java.util.Date;

/**
 * Data Access Object interface for Article entity
 * Provides methods to interact with the Articles table in the database
 */
public interface ArticleDAO {

    /**
     * Creates a new article in the database
     * 
     * @param article The Article object to be saved
     * @return The saved Article object with generated ID
     * @throws SQLException If a database error occurs
     */
    Article createArticle(Article article) throws SQLException;

    /**
     * Finds an article by ID
     * 
     * @param id The article ID to search for
     * @return The Article object if found, null otherwise
     * @throws SQLException If a database error occurs
     */
    Article findById(Long id) throws SQLException;

    /**
     * Updates an existing article in the database
     * 
     * @param article The Article object with updated information
     * @return The updated Article object
     * @throws SQLException If a database error occurs
     */
    Article updateArticle(Article article) throws SQLException;

    /**
     * Deletes an article from the database
     * 
     * @param id The ID of the article to delete
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    boolean deleteArticle(Long id) throws SQLException;

    /**
     * Gets all articles from the database
     * 
     * @return List of all articles
     * @throws SQLException If a database error occurs
     */
    List<Article> getAllArticles() throws SQLException;

    /**
     * Gets articles by author
     * 
     * @param authorId The ID of the author
     * @return List of articles by the specified author
     * @throws SQLException If a database error occurs
     */
    List<Article> getArticlesByAuthor(Long authorId) throws SQLException;

    /**
     * Gets articles by category
     * 
     * @param categoryId The ID of the category
     * @return List of articles in the specified category
     * @throws SQLException If a database error occurs
     */
    List<Article> getArticlesByCategory(Long categoryId) throws SQLException;

    /**
     * Gets articles published between two dates
     * 
     * @param startDate The start date
     * @param endDate The end date
     * @return List of articles published between the specified dates
     * @throws SQLException If a database error occurs
     */
    List<Article> getArticlesByDateRange(Date startDate, Date endDate) throws SQLException;

    /**
     * Adds a category to an article
     * 
     * @param articleId The ID of the article
     * @param categoryId The ID of the category to add
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    boolean addCategoryToArticle(Long articleId, Long categoryId) throws SQLException;

    /**
     * Removes a category from an article
     * 
     * @param articleId The ID of the article
     * @param categoryId The ID of the category to remove
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    boolean removeCategoryFromArticle(Long articleId, Long categoryId) throws SQLException;

    /**
     * Gets categories for an article
     * 
     * @param articleId The ID of the article
     * @return List of categories for the specified article
     * @throws SQLException If a database error occurs
     */
    List<Category> getCategoriesForArticle(Long articleId) throws SQLException;
}