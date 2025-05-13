package com.example.blog_website.dao;

import com.example.blog_website.models.User;
import com.example.blog_website.utils.DbConnectionUtil;

import java.sql.*;

public class UserDAO {

    /**
     * Checks if a username already exists in the database
     * @param username the username to check
     * @return true if the username exists, false otherwise
     */
    public boolean usernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

            return false;
        } catch (SQLException e) {
            System.err.println("Error checking if username exists: " + e.getMessage());
            return false;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Checks if an email already exists in the database
     * @param email the email to check
     * @return true if the email exists, false otherwise
     */
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

            return false;
        } catch (SQLException e) {
            System.err.println("Error checking if email exists: " + e.getMessage());
            return false;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Inserts a new user into the database
     * @param user the user to insert
     * @return the ID of the inserted user, or -1 if the insertion failed
     */
    public int insertUser(User user) {
        String sql = "INSERT INTO users (username, email, password, role, status) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getRole());
            stmt.setString(5, user.getStatus());

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
            System.err.println("Error inserting user: " + e.getMessage());
            return -1;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Gets a user by username
     * @param username the username to search for
     * @return the user if found, null otherwise
     */
    public User getUserByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }

            return null;
        } catch (SQLException e) {
            System.err.println("Error getting user by username: " + e.getMessage());
            return null;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Gets a user by email
     * @param email the email to search for
     * @return the user if found, null otherwise
     */
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }

            return null;
        } catch (SQLException e) {
            System.err.println("Error getting user by email: " + e.getMessage());
            return null;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Maps a ResultSet to a User object
     * @param rs the ResultSet to map
     * @return the mapped User object
     * @throws SQLException if an error occurs while accessing the ResultSet
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setFirstName(rs.getString("first_name"));
        user.setLastName(rs.getString("last_name"));
        user.setBio(rs.getString("bio"));
        user.setProfileImage(rs.getString("profile_image"));
        user.setRole(rs.getString("role"));
        user.setStatus(rs.getString("status"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        user.setLastLogin(rs.getTimestamp("last_login"));
        return user;
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

    /**
     * Checks if any admin user exists in the database
     * @return true if at least one admin user exists, false otherwise
     */
    public boolean adminExists() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'ADMIN'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

            return false;
        } catch (SQLException e) {
            System.err.println("Error checking if admin exists: " + e.getMessage());
            return false;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Gets all users from the database
     * @return a list of all users
     */
    public java.util.List<User> getAllUsers() {
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        java.util.List<User> users = new java.util.ArrayList<>();

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }

            return users;
        } catch (SQLException e) {
            System.err.println("Error getting all users: " + e.getMessage());
            return users;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Gets users by role from the database
     * @param role the role to filter by (or null for all users)
     * @return a list of users with the specified role
     */
    public java.util.List<User> getUsersByRole(String role) {
        String sql = role != null ?
                "SELECT * FROM users WHERE role = ? ORDER BY created_at DESC" :
                "SELECT * FROM users ORDER BY created_at DESC";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        java.util.List<User> users = new java.util.ArrayList<>();

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            if (role != null) {
                stmt.setString(1, role);
            }
            rs = stmt.executeQuery();

            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }

            return users;
        } catch (SQLException e) {
            System.err.println("Error getting users by role: " + e.getMessage());
            return users;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Gets a user by ID
     * @param id the user ID to search for
     * @return the user if found, null otherwise
     */
    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }

            return null;
        } catch (SQLException e) {
            System.err.println("Error getting user by ID: " + e.getMessage());
            return null;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Updates a user in the database
     * @param user the user to update
     * @return true if the update was successful, false otherwise
     */
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET username = ?, email = ?, first_name = ?, last_name = ?, " +
                "bio = ?, profile_image = ?, role = ?, status = ?, updated_at = CURRENT_TIMESTAMP " +
                "WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getFirstName());
            stmt.setString(4, user.getLastName());
            stmt.setString(5, user.getBio());
            stmt.setString(6, user.getProfileImage());
            stmt.setString(7, user.getRole());
            stmt.setString(8, user.getStatus());
            stmt.setInt(9, user.getId());

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error updating user: " + e.getMessage());
            return false;
        } finally {
            closeResources(conn, stmt, null);
        }
    }

    /**
     * Updates a user's password
     * @param userId the ID of the user whose password to update
     * @param newPassword the new password (already hashed)
     * @return true if the update was successful, false otherwise
     */
    public boolean updateUserPassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, newPassword);
            stmt.setInt(2, userId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error updating user password: " + e.getMessage());
            return false;
        } finally {
            closeResources(conn, stmt, null);
        }
    }

    /**
     * Deletes a user from the database
     * @param userId the ID of the user to delete
     * @return true if the deletion was successful, false otherwise
     */
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting user: " + e.getMessage());
            return false;
        } finally {
            closeResources(conn, stmt, null);
        }
    }

    /**
     * Gets the count of users by role
     * @param role the role to count (or null for all users)
     * @return the count of users with the specified role
     */
    public int getUserCountByRole(String role) {
        String sql = role != null ?
                "SELECT COUNT(*) FROM users WHERE role = ?" :
                "SELECT COUNT(*) FROM users";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            if (role != null) {
                stmt.setString(1, role);
            }
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

            return 0;
        } catch (SQLException e) {
            System.err.println("Error getting user count: " + e.getMessage());
            return 0;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Gets the count of users added in the current month
     * @return the count of users added in the current month
     */
    public int getUsersAddedThisMonth() {
        String sql = "SELECT COUNT(*) FROM users WHERE MONTH(created_at) = MONTH(CURRENT_DATE()) AND YEAR(created_at) = YEAR(CURRENT_DATE())";
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
            System.err.println("Error getting users added this month: " + e.getMessage());
            return 0;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }
}
