package com.example.blog_website.listners;

import com.example.blog_website.dao.UserDAO;
import com.example.blog_website.models.User;
import com.example.blog_website.utils.PasswordUtil;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * Application initialization listener that runs when the application starts up.
 * Creates an admin user if one doesn't exist.
 */
@WebListener
public class ApplnitListener implements ServletContextListener {

    private static final String ADMIN_USERNAME = "admin";
    private static final String ADMIN_EMAIL = "admin@insighthub.com";
    private static final String ADMIN_PASSWORD = "admin123"; // This would be better stored in a config file

    /**
     * Called when the application is starting up
     * @param sce the ServletContextEvent
     */
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Application starting up - checking for admin user");

        UserDAO userDAO = new UserDAO();

        // Check if an admin user already exists
        if (!userDAO.adminExists()) {
            System.out.println("No admin user found - creating default admin account");

            // Create a new admin user
            User adminUser = new User(ADMIN_USERNAME, ADMIN_EMAIL,
                    PasswordUtil.hashPassword(ADMIN_PASSWORD));
            adminUser.setRole("ADMIN");

            // Insert the admin user into the database
            int userId = userDAO.insertUser(adminUser);

            if (userId > 0) {
                System.out.println("Admin user created successfully with ID: " + userId);
            } else {
                System.err.println("Failed to create admin user");
            }
        } else {
            System.out.println("Admin user already exists - skipping creation");
        }
    }

    /**
     * Called when the application is shutting down
     * @param sce the ServletContextEvent
     */
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Application shutting down");
    }
}
