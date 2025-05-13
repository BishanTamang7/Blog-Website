package com.example.blog_website.utils;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DbConnectionUtil {
    private static final Properties properties = new Properties();

    static {
        try (InputStream input = DbConnectionUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input == null) {
                throw new RuntimeException("Unable to find db.properties");
            }
            properties.load(input);

            // Load the JDBC driver
            Class.forName(properties.getProperty("db.driver"));
        } catch (IOException | ClassNotFoundException e) {
            throw new RuntimeException("Error initializing database connection: " + e.getMessage(), e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
                properties.getProperty("db.url"),
                properties.getProperty("db.username"),
                properties.getProperty("db.password")
        );
    }

    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                System.err.println("Error closing connection: " + e.getMessage());
            }
        }
    }
}
