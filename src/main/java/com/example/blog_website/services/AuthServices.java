package com.example.blog_website.services;

import com.example.blog_website.models.User;
import com.example.blog_website.utils.SessionUtil;
import jakarta.servlet.http.HttpServletRequest;

/**
 * Service class for authentication-related operations
 */
public class AuthServices {
    private final UserService userService;

    public AuthServices() {
        this.userService = new UserService();
    }

    /**
     * Authenticates a user and creates a session
     * @param email the user's email
     * @param password the password
     * @param request the HTTP request
     * @return true if authentication is successful, false otherwise
     */
    public boolean authenticateUser(String email, String password, HttpServletRequest request) {
        User user = userService.authenticateUserByEmail(email, password);

        if (user != null) {
            // Create session using SessionUtil
            SessionUtil.createUserSession(request, user);
            return true;
        }

        return false;
    }

    /**
     * Logs out a user by invalidating the session
     * @param request the HTTP request
     */
    public void logoutUser(HttpServletRequest request) {
        SessionUtil.invalidateSession(request);
    }

    /**
     * Checks if a user is logged in
     * @param request the HTTP request
     * @return true if the user is logged in, false otherwise
     */
    public boolean isLoggedIn(HttpServletRequest request) {
        return SessionUtil.isLoggedIn(request);
    }

    /**
     * Checks if a user is an admin
     * @param request the HTTP request
     * @return true if the user is an admin, false otherwise
     */
    public boolean isAdmin(HttpServletRequest request) {
        return SessionUtil.isAdmin(request);
    }
}
