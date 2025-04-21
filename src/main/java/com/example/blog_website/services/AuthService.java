package com.example.blog_website.services;

import com.example.blog_website.dao.UserDAO;
import com.example.blog_website.dao.impl.UserDAOImpl;
import com.example.blog_website.model.User;
import com.example.blog_website.util.DbConnectionUtil;
import com.example.blog_website.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AuthService {

    private final UserDAO userDAO;

    public AuthService() {
        this.userDAO = new UserDAOImpl();
    }

    /**
     * Authenticates a user with the given email and password
     *
     * @param email The user's email
     * @param password The user's password
     * @return The authenticated User object, or null if authentication fails
     * @throws SQLException If a database error occurs
     */
    public User authenticateUser(String email, String password) throws SQLException {
        // Find user by email
        User user = userDAO.findByEmail(email);

        // If user exists and password is correct, return the user
        if (user != null && PasswordUtil.verifyPassword(password, user.getPassword())) {
            return user;
        }

        // Authentication failed
        return null;
    }

    /**
     * Registers a new user
     *
     * @param username The user's username
     * @param email The user's email
     * @param password The user's password (will be hashed)
     * @return The newly created User object
     * @throws SQLException If a database error occurs
     */
    public User registerUser(String username, String email, String password) throws SQLException {
        // Hash the password
        String hashedPassword = PasswordUtil.hashPassword(password);

        // Create a new User object
        User user = new User(username, hashedPassword, email);
        user.setRole(User.UserRole.AUTHOR); // Default role for new users

        // Use the UserDAO to create the user in the database
        return userDAO.createUser(user);
    }

    /**
     * Updates a user's profile information
     *
     * @param user The user with updated profile information
     * @return The updated User object
     * @throws SQLException If a database error occurs
     */
    public User updateUserProfile(User user) throws SQLException {
        return userDAO.updateUser(user);
    }
}