package com.example.blog_website.dao;

import com.example.blog_website.model.User;
import java.sql.SQLException;
import java.util.List;

/**
 * Data Access Object interface for User entity
 * Provides methods to interact with the Users table in the database
 */
public interface UserDAO {

    /**
     * Creates a new user in the database
     * 
     * @param user The User object to be saved
     * @return The saved User object with generated ID
     * @throws SQLException If a database error occurs
     */
    User createUser(User user) throws SQLException;

    /**
     * Finds a user by email
     * 
     * @param email The email to search for
     * @return The User object if found, null otherwise
     * @throws SQLException If a database error occurs
     */
    User findByEmail(String email) throws SQLException;

    /**
     * Finds a user by username
     * 
     * @param username The username to search for
     * @return The User object if found, null otherwise
     * @throws SQLException If a database error occurs
     */
    User findByUsername(String username) throws SQLException;

    /**
     * Finds a user by ID
     * 
     * @param id The user ID to search for
     * @return The User object if found, null otherwise
     * @throws SQLException If a database error occurs
     */
    User findById(Long id) throws SQLException;

    /**
     * Updates an existing user in the database
     * 
     * @param user The User object with updated information
     * @return The updated User object
     * @throws SQLException If a database error occurs
     */
    User updateUser(User user) throws SQLException;

    /**
     * Deactivates a user (sets is_active to FALSE)
     * 
     * @param id The ID of the user to deactivate
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    boolean deactivateUser(Long id) throws SQLException;

    /**
     * Gets all active users from the database
     * 
     * @return List of all active users
     * @throws SQLException If a database error occurs
     */
    List<User> getAllUsers() throws SQLException;
}
