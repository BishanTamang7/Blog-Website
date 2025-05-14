package com.example.blog_website.utils;

import com.example.blog_website.models.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * Utility class for session management
 */
public class SessionUtil {

    /**
     * Creates a user session
     * @param request the HTTP request
     * @param user the user to create a session for
     */
    public static void createUserSession(HttpServletRequest request, User user) {
        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getId());
        session.setAttribute("username", user.getUsername());
        session.setAttribute("role", user.getRole());
        session.setAttribute("isLoggedIn", true);
    }

    /**
     * Gets the current user from the session
     * @param request the HTTP request
     * @return the current user, or null if not logged in
     */
    public static User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            return (User) session.getAttribute("user");
        }

        return null;
    }

    /**
     * Checks if a user is logged in
     * @param request the HTTP request
     * @return true if the user is logged in, false otherwise
     */
    public static boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        return session != null && session.getAttribute("isLoggedIn") != null
                && (Boolean) session.getAttribute("isLoggedIn");
    }

    /**
     * Gets the role of the current user from the session
     * @param request the HTTP request
     * @return the user's role, or null if not logged in
     */
    public static String getUserRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (isLoggedIn(request) && session.getAttribute("role") != null) {
            return (String) session.getAttribute("role");
        }

        return null;
    }

    /**
     * Checks if the current user is an admin
     * @param request the HTTP request
     * @return true if the user is an admin, false otherwise
     */
    public static boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        return isLoggedIn(request) && session.getAttribute("role") != null
                && "ADMIN".equals(session.getAttribute("role"));
    }

    /**
     * Invalidates the current session
     * @param request the HTTP request
     */
    public static void invalidateSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session != null) {
            session.invalidate();
        }
    }
}

