package com.example.blog_website.dao;

import com.example.blog_website.model.Category;
import com.example.blog_website.model.Article;
import java.sql.SQLException;
import java.util.List;

/**
 * Data Access Object interface for Category entity
 * Provides methods to interact with the Categories table in the database
 */
public interface CategoryDAO {

    /**
     * Creates a new category in the database
     * 
     * @param category The Category object to be saved
     * @return The saved Category object with generated ID
     * @throws SQLException If a database error occurs
     */
    Category createCategory(Category category) throws SQLException;

    /**
     * Finds a category by ID
     * 
     * @param id The category ID to search for
     * @return The Category object if found, null otherwise
     * @throws SQLException If a database error occurs
     */
    Category findById(Long id) throws SQLException;

    /**
     * Finds a category by name
     * 
     * @param name The category name to search for
     * @return The Category object if found, null otherwise
     * @throws SQLException If a database error occurs
     */
    Category findByName(String name) throws SQLException;

    /**
     * Updates an existing category in the database
     * 
     * @param category The Category object with updated information
     * @return The updated Category object
     * @throws SQLException If a database error occurs
     */
    Category updateCategory(Category category) throws SQLException;

    /**
     * Deactivates a category (sets is_active to FALSE)
     * 
     * @param id The ID of the category to deactivate
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    boolean deactivateCategory(Long id) throws SQLException;

    /**
     * Gets all active categories from the database
     * 
     * @return List of all active categories
     * @throws SQLException If a database error occurs
     */
    List<Category> getAllCategories() throws SQLException;

    /**
     * Gets articles for a category
     * 
     * @param categoryId The ID of the category
     * @return List of articles in the specified category
     * @throws SQLException If a database error occurs
     */
    List<Article> getArticlesForCategory(Long categoryId) throws SQLException;
}