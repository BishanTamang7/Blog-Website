package com.example.blog_website.services;

import com.example.blog_website.dao.UserDAO;
import com.example.blog_website.models.User;
import com.example.blog_website.utils.PasswordUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

public class UserService {
    private final UserDAO userDAO;

    // Email validation pattern
    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");

    // Password validation pattern (at least 8 characters, containing letters and numbers)
    private static final Pattern PASSWORD_PATTERN =
            Pattern.compile("^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$");

    public UserService() {
        this.userDAO = new UserDAO();
    }

    /**
     * Gets all users
     * @return a list of all users
     */
    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }

    /**
     * Gets users by role
     * @param role the role to filter by (or null for all users)
     * @return a list of users with the specified role
     */
    public List<User> getUsersByRole(String role) {
        return userDAO.getUsersByRole(role);
    }

    /**
     * Gets a user by ID
     * @param id the user ID
     * @return the user if found, null otherwise
     */
    public User getUserById(int id) {
        return userDAO.getUserById(id);
    }

    /**
     * Creates a new user (admin function)
     * @param username the username
     * @param email the email
     * @param password the password
     * @param role the role (admin/user)
     * @return a map containing the result of the creation
     */
    public Map<String, Object> createUser(String username, String email, String password, String role) {
        Map<String, Object> result = new HashMap<>();
        result.put("success", false);

        // Validate input
        Map<String, String> validationErrors = validateUserInput(username, email, password, null);
        if (!validationErrors.isEmpty()) {
            result.put("errors", validationErrors);
            return result;
        }

        // Check if username or email already exists
        if (userDAO.usernameExists(username)) {
            validationErrors.put("username", "Username already exists");
            result.put("errors", validationErrors);
            return result;
        }

        if (userDAO.emailExists(email)) {
            validationErrors.put("email", "Email already exists");
            result.put("errors", validationErrors);
            return result;
        }

        // Hash the password
        String hashedPassword = PasswordUtil.hashPassword(password);

        // Create and save the user
        User user = new User(username, email, hashedPassword);
        user.setRole(role);
        int userId = userDAO.insertUser(user);

        if (userId > 0) {
            result.put("success", true);
            result.put("userId", userId);
        } else {
            validationErrors.put("general", "Failed to create user");
            result.put("errors", validationErrors);
        }

        return result;
    }

    /**
     * Updates a user
     * @param userId the user ID
     * @param username the username
     * @param email the email
     * @param role the role
     * @param status the status
     * @return a map containing the result of the update
     */
    public Map<String, Object> updateUser(int userId, String username, String email, String role, String status) {
        Map<String, Object> result = new HashMap<>();
        result.put("success", false);

        // Get the user
        User user = userDAO.getUserById(userId);
        if (user == null) {
            Map<String, String> errors = new HashMap<>();
            errors.put("general", "User not found");
            result.put("errors", errors);
            return result;
        }

        // Validate input
        Map<String, String> validationErrors = validateUserInput(username, email, null, null);
        if (!validationErrors.isEmpty()) {
            result.put("errors", validationErrors);
            return result;
        }

        // Check if username already exists (if changed)
        if (!username.equals(user.getUsername()) && userDAO.usernameExists(username)) {
            validationErrors.put("username", "Username already exists");
            result.put("errors", validationErrors);
            return result;
        }

        // Check if email already exists (if changed)
        if (!email.equals(user.getEmail()) && userDAO.emailExists(email)) {
            validationErrors.put("email", "Email already exists");
            result.put("errors", validationErrors);
            return result;
        }

        // Update user
        user.setUsername(username);
        user.setEmail(email);
        user.setRole(role);
        user.setStatus(status);

        boolean updated = userDAO.updateUser(user);

        if (updated) {
            result.put("success", true);
        } else {
            validationErrors.put("general", "Failed to update user");
            result.put("errors", validationErrors);
        }

        return result;
    }

    /**
     * Resets a user's password
     * @param userId the user ID
     * @param newPassword the new password
     * @return a map containing the result of the password reset
     */
    public Map<String, Object> resetUserPassword(int userId, String newPassword) {
        Map<String, Object> result = new HashMap<>();
        result.put("success", false);

        // Get the user
        User user = userDAO.getUserById(userId);
        if (user == null) {
            Map<String, String> errors = new HashMap<>();
            errors.put("general", "User not found");
            result.put("errors", errors);
            return result;
        }

        // Validate password
        Map<String, String> validationErrors = validateUserInput(null, null, newPassword, null);
        if (!validationErrors.isEmpty()) {
            result.put("errors", validationErrors);
            return result;
        }

        // Hash the password
        String hashedPassword = PasswordUtil.hashPassword(newPassword);

        // Update password
        boolean updated = userDAO.updateUserPassword(userId, hashedPassword);

        if (updated) {
            result.put("success", true);
        } else {
            validationErrors.put("general", "Failed to reset password");
            result.put("errors", validationErrors);
        }

        return result;
    }

    /**
     * Deletes a user
     * @param userId the user ID
     * @return a map containing the result of the deletion
     */
    public Map<String, Object> deleteUser(int userId) {
        Map<String, Object> result = new HashMap<>();
        result.put("success", false);

        // Get the user
        User user = userDAO.getUserById(userId);
        if (user == null) {
            Map<String, String> errors = new HashMap<>();
            errors.put("general", "User not found");
            result.put("errors", errors);
            return result;
        }

        // Delete user
        boolean deleted = userDAO.deleteUser(userId);

        if (deleted) {
            result.put("success", true);
        } else {
            Map<String, String> errors = new HashMap<>();
            errors.put("general", "Failed to delete user");
            result.put("errors", errors);
        }

        return result;
    }

    /**
     * Gets user statistics
     * @return a map containing user statistics
     */
    public Map<String, Integer> getUserStats() {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("totalUsers", userDAO.getUserCountByRole(null));
        stats.put("adminUsers", userDAO.getUserCountByRole("ADMIN"));
        stats.put("regularUsers", userDAO.getUserCountByRole("USER"));
        stats.put("newUsersThisMonth", userDAO.getUsersAddedThisMonth());
        return stats;
    }

    /**
     * Validates user input for various operations
     * @param username the username (can be null if not being validated)
     * @param email the email (can be null if not being validated)
     * @param password the password (can be null if not being validated)
     * @param confirmPassword the confirm password (can be null if not being validated)
     * @return a map of validation errors
     */
    private Map<String, String> validateUserInput(String username, String email, String password, String confirmPassword) {
        Map<String, String> errors = new HashMap<>();

        // Validate username if provided
        if (username != null) {
            if (username.trim().isEmpty()) {
                errors.put("username", "Username is required");
            } else if (username.length() < 3 || username.length() > 50) {
                errors.put("username", "Username must be between 3 and 50 characters");
            }
        }

        // Validate email if provided
        if (email != null) {
            if (email.trim().isEmpty()) {
                errors.put("email", "Email is required");
            } else if (!EMAIL_PATTERN.matcher(email).matches()) {
                errors.put("email", "Invalid email format");
            }
        }

        // Validate password if provided
        if (password != null) {
            if (password.trim().isEmpty()) {
                errors.put("password", "Password is required");
            } else if (!PASSWORD_PATTERN.matcher(password).matches()) {
                errors.put("password", "Password must be at least 8 characters and contain letters and numbers");
            }
        }

        // Validate confirm password if provided
        if (confirmPassword != null && password != null) {
            if (confirmPassword.trim().isEmpty()) {
                errors.put("confirmPassword", "Confirm password is required");
            } else if (!password.equals(confirmPassword)) {
                errors.put("confirmPassword", "Passwords do not match");
            }
        }

        return errors;
    }

    /**
     * Registers a new user
     * @param username the username
     * @param email the email
     * @param password the password
     * @return a map containing the result of the registration
     */
    public Map<String, Object> registerUser(String username, String email, String password, String confirmPassword) {
        Map<String, Object> result = new HashMap<>();
        result.put("success", false);

        // Validate input
        Map<String, String> validationErrors = validateRegistrationInput(username, email, password, confirmPassword);
        if (!validationErrors.isEmpty()) {
            result.put("errors", validationErrors);
            return result;
        }

        // Check if username or email already exists
        if (userDAO.usernameExists(username)) {
            validationErrors.put("username", "Username already exists");
            result.put("errors", validationErrors);
            return result;
        }

        if (userDAO.emailExists(email)) {
            validationErrors.put("email", "Email already exists");
            result.put("errors", validationErrors);
            return result;
        }

        // Hash the password
        String hashedPassword = PasswordUtil.hashPassword(password);

        // Create and save the user
        User user = new User(username, email, hashedPassword);
        int userId = userDAO.insertUser(user);

        if (userId > 0) {
            result.put("success", true);
            result.put("userId", userId);
        } else {
            validationErrors.put("general", "Failed to register user");
            result.put("errors", validationErrors);
        }

        return result;
    }

    /**
     * Validates registration input
     * @param username the username
     * @param email the email
     * @param password the password
     * @param confirmPassword the confirm password
     * @return a map of validation errors
     */
    private Map<String, String> validateRegistrationInput(String username, String email, String password, String confirmPassword) {
        Map<String, String> errors = new HashMap<>();

        // Validate username
        if (username == null || username.trim().isEmpty()) {
            errors.put("username", "Username is required");
        } else if (username.length() < 3 || username.length() > 50) {
            errors.put("username", "Username must be between 3 and 50 characters");
        }

        // Validate email
        if (email == null || email.trim().isEmpty()) {
            errors.put("email", "Email is required");
        } else if (!EMAIL_PATTERN.matcher(email).matches()) {
            errors.put("email", "Invalid email format");
        }

        // Validate password
        if (password == null || password.trim().isEmpty()) {
            errors.put("password", "Password is required");
        } else if (!PASSWORD_PATTERN.matcher(password).matches()) {
            errors.put("password", "Password must be at least 8 characters and contain letters and numbers");
        }

        // Validate confirm password
        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            errors.put("confirmPassword", "Confirm password is required");
        } else if (!password.equals(confirmPassword)) {
            errors.put("confirmPassword", "Passwords do not match");
        }

        return errors;
    }

    /**
     * Authenticates a user
     * @param usernameOrEmail the username or email
     * @param password the password
     * @return the authenticated user, or null if authentication fails
     */
    public User authenticateUser(String usernameOrEmail, String password) {
        User user = null;

        // Try to get user by username or email
        if (usernameOrEmail.contains("@")) {
            user = userDAO.getUserByEmail(usernameOrEmail);
        } else {
            user = userDAO.getUserByUsername(usernameOrEmail);
        }

        // Check if user exists and password matches
        if (user != null && PasswordUtil.verifyPassword(password, user.getPassword())) {
            return user;
        }

        return null;
    }

    /**
     * Authenticates a user by email
     * @param email the user's email
     * @param password the password
     * @return the authenticated user, or null if authentication fails
     */
    public User authenticateUserByEmail(String email, String password) {
        User user = userDAO.getUserByEmail(email);

        // Check if user exists and password matches
        if (user != null && PasswordUtil.verifyPassword(password, user.getPassword())) {
            return user;
        }

        return null;
    }
}
