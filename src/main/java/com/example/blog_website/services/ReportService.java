package com.example.blog_website.services;

import com.example.blog_website.dao.BlogPostDAO;
import com.example.blog_website.dao.CategoryDAO;
import com.example.blog_website.dao.UserDAO;
import com.example.blog_website.models.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

import com.example.blog_website.utils.DbConnectionUtil;

/**
 * Service class for generating reports
 */
public class ReportService {
    private final BlogPostDAO blogPostDAO;
    private final CategoryDAO categoryDAO;
    private final UserDAO userDAO;

    public ReportService() {
        this.blogPostDAO = new BlogPostDAO();
        this.categoryDAO = new CategoryDAO();
        this.userDAO = new UserDAO();
    }

    /**
     * Gets the most active users based on post count
     * @param limit the maximum number of users to return
     * @param days the number of days to look back (30, 90, 365)
     * @return a list of maps containing user activity data
     */
    public List<Map<String, Object>> getMostActiveUsers(int limit, int days) {
        String sql = "SELECT u.id, u.username, COUNT(p.id) as post_count, MAX(p.created_at) as last_active " +
                "FROM users u " +
                "JOIN blog_posts p ON u.id = p.author_id " +
                "WHERE p.created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                "GROUP BY u.id, u.username " +
                "ORDER BY post_count DESC " +
                "LIMIT ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> activeUsers = new ArrayList<>();

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, days);
            stmt.setInt(2, limit);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> userData = new HashMap<>();
                int userId = rs.getInt("id");
                String username = rs.getString("username");
                int postCount = rs.getInt("post_count");
                Date lastActive = rs.getTimestamp("last_active");
                
                userData.put("userId", userId);
                userData.put("username", username);
                userData.put("postCount", postCount);
                userData.put("lastActive", lastActive);
                userData.put("totalActivity", postCount); // Since we don't have comments, total activity is just post count
                
                activeUsers.add(userData);
            }

            return activeUsers;
        } catch (SQLException e) {
            System.err.println("Error getting most active users: " + e.getMessage());
            return activeUsers;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Gets the category distribution data
     * @return a list of maps containing category distribution data
     */
    public List<Map<String, Object>> getCategoryDistribution() {
        return categoryDAO.getCategoryDistribution();
    }

    /**
     * Gets the total number of posts
     * @return the total number of posts
     */
    public int getTotalPosts() {
        return blogPostDAO.getTotalPostCount();
    }

    /**
     * Gets the average views per post
     * @return the average views per post
     */
    public int getAverageViewsPerPost() {
        int totalPosts = blogPostDAO.getTotalPostCount();
        int totalViews = blogPostDAO.getTotalViewCount();
        
        if (totalPosts == 0) {
            return 0;
        }
        
        return totalViews / totalPosts;
    }

    /**
     * Formats a date relative to the current date
     * @param date the date to format
     * @return a string representation of the date (Today, Yesterday, X days ago, etc.)
     */
    public static String formatRelativeDate(Date date) {
        if (date == null) {
            return "Never";
        }
        
        Calendar now = Calendar.getInstance();
        Calendar then = Calendar.getInstance();
        then.setTime(date);
        
        // Check if it's today
        if (now.get(Calendar.YEAR) == then.get(Calendar.YEAR) &&
            now.get(Calendar.DAY_OF_YEAR) == then.get(Calendar.DAY_OF_YEAR)) {
            return "Today";
        }
        
        // Check if it's yesterday
        now.add(Calendar.DAY_OF_YEAR, -1);
        if (now.get(Calendar.YEAR) == then.get(Calendar.YEAR) &&
            now.get(Calendar.DAY_OF_YEAR) == then.get(Calendar.DAY_OF_YEAR)) {
            return "Yesterday";
        }
        
        // Calculate days difference
        now.setTime(new Date());
        long diffInMillis = now.getTimeInMillis() - then.getTimeInMillis();
        long diffInDays = diffInMillis / (24 * 60 * 60 * 1000);
        
        if (diffInDays < 7) {
            return diffInDays + " days ago";
        } else if (diffInDays < 30) {
            long diffInWeeks = diffInDays / 7;
            return diffInWeeks + " week" + (diffInWeeks > 1 ? "s" : "") + " ago";
        } else {
            long diffInMonths = diffInDays / 30;
            return diffInMonths + " month" + (diffInMonths > 1 ? "s" : "") + " ago";
        }
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
}