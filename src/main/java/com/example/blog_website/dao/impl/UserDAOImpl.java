package com.example.blog_website.dao.impl;

import com.example.blog_website.dao.UserDAO;
import com.example.blog_website.model.User;
import com.example.blog_website.model.User.UserRole;
import com.example.blog_website.util.DbConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementation of the UserDAO interface
 * Provides concrete methods to interact with the Users table in the database
 */
public class UserDAOImpl implements UserDAO {

    /**
     * Creates a new user in the database
     *
     * @param user The User object to be saved
     * @return The saved User object with generated ID
     * @throws SQLException If a database error occurs
     */
    @Override
    public User createUser(User user) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet generatedKeys = null;

        try {
            connection = DbConnectionUtil.getConnection();

            // Insert new user
            String query = "INSERT INTO Users (username, email, password, role) VALUES (?, ?, ?, ?)";
            statement = connection.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS);
            statement.setString(1, user.getUsername());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getPassword());

            // Map UserRole enum to database role string
            String roleStr = "writer"; // Default role
            if (user.getRole() == UserRole.ADMIN) {
                roleStr = "admin";
            }
            statement.setString(4, roleStr);

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating user failed, no rows affected.");
            }

            // Get the generated ID
            generatedKeys = statement.getGeneratedKeys();
            if (generatedKeys.next()) {
                user.setId((long) generatedKeys.getInt(1));
                return user;
            } else {
                throw new SQLException("Creating user failed, no ID obtained.");
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
     * Finds a user by email
     *
     * @param email The email to search for
     * @return The User object if found, null otherwise
     * @throws SQLException If a database error occurs
     */
    @Override
    public User findByEmail(String email) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            connection = DbConnectionUtil.getConnection();

            // Query to get user by email
            String query = "SELECT id, username, email, password, role FROM Users WHERE email = ? AND is_active = TRUE";
            statement = connection.prepareStatement(query);
            statement.setString(1, email);

            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return mapResultSetToUser(resultSet);
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
     * Finds a user by username
     *
     * @param username The username to search for
     * @return The User object if found, null otherwise
     * @throws SQLException If a database error occurs
     */
    @Override
    public User findByUsername(String username) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            connection = DbConnectionUtil.getConnection();

            // Query to get user by username
            String query = "SELECT id, username, email, password, role FROM Users WHERE username = ? AND is_active = TRUE";
            statement = connection.prepareStatement(query);
            statement.setString(1, username);

            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return mapResultSetToUser(resultSet);
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
     * Maps a ResultSet to a User object
     *
     * @param resultSet The ResultSet containing user data
     * @return The mapped User object
     * @throws SQLException If a database error occurs
     */
    private User mapResultSetToUser(ResultSet resultSet) throws SQLException {
        User user = new User();
        user.setId((long) resultSet.getInt("id"));
        user.setUsername(resultSet.getString("username"));
        user.setEmail(resultSet.getString("email"));
        user.setPassword(resultSet.getString("password"));

        // Map database role to UserRole enum
        String roleStr = resultSet.getString("role");
        if ("admin".equalsIgnoreCase(roleStr)) {
            user.setRole(UserRole.ADMIN);
        } else if ("writer".equalsIgnoreCase(roleStr)) {
            user.setRole(UserRole.AUTHOR);
        } else {
            user.setRole(UserRole.READER);
        }

        return user;
    }

    /**
     * Finds a user by ID
     *
     * @param id The user ID to search for
     * @return The User object if found, null otherwise
     * @throws SQLException If a database error occurs
     */
    @Override
    public User findById(Long id) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            connection = DbConnectionUtil.getConnection();

            // Query to get user by ID
            String query = "SELECT id, username, email, password, role FROM Users WHERE id = ? AND is_active = TRUE";
            statement = connection.prepareStatement(query);
            statement.setLong(1, id);

            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return mapResultSetToUser(resultSet);
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
     * Updates an existing user in the database
     *
     * @param user The User object with updated information
     * @return The updated User object
     * @throws SQLException If a database error occurs
     */
    @Override
    public User updateUser(User user) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        try {
            connection = DbConnectionUtil.getConnection();

            // Update user information
            String query = "UPDATE Users SET username = ?, email = ?, password = ?, role = ? WHERE id = ? AND is_active = TRUE";
            statement = connection.prepareStatement(query);
            statement.setString(1, user.getUsername());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getPassword());

            // Map UserRole enum to database role string
            String roleStr = "writer"; // Default role
            if (user.getRole() == UserRole.ADMIN) {
                roleStr = "admin";
            }
            statement.setString(4, roleStr);
            statement.setLong(5, user.getId());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Updating user failed, no rows affected.");
            }

            return user;
        } finally {
            // Close resources
            if (statement != null) {
                try { statement.close(); } catch (SQLException e) { /* Ignore */ }
            }
            DbConnectionUtil.closeConnection(connection);
        }
    }

    /**
     * Deactivates a user (sets is_active to FALSE)
     *
     * @param id The ID of the user to deactivate
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    @Override
    public boolean deactivateUser(Long id) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        try {
            connection = DbConnectionUtil.getConnection();

            // Deactivate user
            String query = "UPDATE Users SET is_active = FALSE WHERE id = ?";
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
     * Gets all active users from the database
     *
     * @return List of all active users
     * @throws SQLException If a database error occurs
     */
    @Override
    public List<User> getAllUsers() throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<User> users = new ArrayList<>();

        try {
            connection = DbConnectionUtil.getConnection();

            // Query to get all active users
            String query = "SELECT id, username, email, password, role FROM Users WHERE is_active = TRUE";
            statement = connection.prepareStatement(query);

            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                users.add(mapResultSetToUser(resultSet));
            }

            return users;
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
