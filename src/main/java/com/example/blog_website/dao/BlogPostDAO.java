package com.example.blog_website.dao;

import com.example.blog_website.models.BlogPost;
import com.example.blog_website.utils.DbConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BlogPostDAO {

    /**
     * Creates a new blog post
     * @param post the BlogPost object to create
     * @return the ID of the created post, or -1 if creation failed
     */
    public int createPost(BlogPost post) {
        String sql = "INSERT INTO blog_posts (title, content, author_id, category_id, status) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, post.getTitle());
            stmt.setString(2, post.getContent());
            stmt.setInt(3, post.getAuthorId());
            stmt.setInt(4, post.getCategoryId());
            stmt.setString(5, post.getStatus());

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
            System.err.println("Error creating blog post: " + e.getMessage());
            return -1;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Gets a blog post by its ID
     * @param postId the ID of the post to retrieve
     * @return the BlogPost object, or null if not found
     */
    public BlogPost getPostById(int postId) {
        String sql = "SELECT * FROM blog_posts WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, postId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                BlogPost post = new BlogPost();
                post.setId(rs.getInt("id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setAuthorId(rs.getInt("author_id"));
                post.setCategoryId(rs.getInt("category_id"));
                post.setStatus(rs.getString("status"));
                post.setViewCount(rs.getInt("view_count"));
                post.setCreatedAt(rs.getTimestamp("created_at"));
                post.setUpdatedAt(rs.getTimestamp("updated_at"));
                post.setPublishedAt(rs.getTimestamp("published_at"));
                return post;
            }

            return null;
        } catch (SQLException e) {
            System.err.println("Error getting post by ID: " + e.getMessage());
            return null;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Updates an existing blog post
     * @param post the BlogPost object with updated values
     * @return true if the update was successful, false otherwise
     */
    public boolean updatePost(BlogPost post) {
        String sql = "UPDATE blog_posts SET title = ?, content = ?, category_id = ?, status = ?, published_at = ? WHERE id = ? AND author_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, post.getTitle());
            stmt.setString(2, post.getContent());
            stmt.setInt(3, post.getCategoryId());
            stmt.setString(4, post.getStatus());
            stmt.setTimestamp(5, post.getPublishedAt());
            stmt.setInt(6, post.getId());
            stmt.setInt(7, post.getAuthorId());

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error updating blog post: " + e.getMessage());
            return false;
        } finally {
            closeResources(conn, stmt, null);
        }
    }

    /**
     * Deletes a blog post
     * @param postId the ID of the post to delete
     * @param userId the ID of the user who owns the post
     * @return true if the deletion was successful, false otherwise
     */
    public boolean deletePost(int postId, int userId) {
        String sql = "DELETE FROM blog_posts WHERE id = ? AND author_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, postId);
            stmt.setInt(2, userId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting blog post: " + e.getMessage());
            return false;
        } finally {
            closeResources(conn, stmt, null);
        }
    }

    /**
     * Gets posts by a specific user with optional status filter
     * @param userId the ID of the user
     * @param status optional status filter ("PUBLISHED", "DRAFT", or null for all)
     * @return a list of maps containing post data
     */
    public List<Map<String, Object>> getPostsByUser(int userId, String status) {
        StringBuilder sqlBuilder = new StringBuilder(
                "SELECT p.id, p.title, p.content, p.status, p.view_count, p.created_at, " +
                        "c.name as category " +
                        "FROM blog_posts p " +
                        "JOIN categories c ON p.category_id = c.id " +
                        "WHERE p.author_id = ? "
        );

        if (status != null && !status.isEmpty()) {
            sqlBuilder.append("AND p.status = ? ");
        }

        sqlBuilder.append("ORDER BY p.created_at DESC");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> posts = new ArrayList<>();

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sqlBuilder.toString());
            stmt.setInt(1, userId);

            if (status != null && !status.isEmpty()) {
                stmt.setString(2, status);
            }

            rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> post = new HashMap<>();
                post.put("id", rs.getInt("id"));
                post.put("title", rs.getString("title"));
                post.put("content", rs.getString("content"));
                post.put("category", rs.getString("category"));
                post.put("status", rs.getString("status"));
                post.put("views", rs.getInt("view_count"));
                post.put("createdAt", rs.getTimestamp("created_at"));
                posts.add(post);
            }

            return posts;
        } catch (SQLException e) {
            System.err.println("Error getting posts by user: " + e.getMessage());
            return posts;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Gets the count of published posts by a specific user
     * @param userId the ID of the user
     * @return the count of published posts by the user
     */
    public int getPublishedPostCountByUser(int userId) {
        String sql = "SELECT COUNT(*) FROM blog_posts WHERE author_id = ? AND status = 'PUBLISHED'";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

            return 0;
        } catch (SQLException e) {
            System.err.println("Error getting published post count by user: " + e.getMessage());
            return 0;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Gets the total view count of posts by a specific user
     * @param userId the ID of the user
     * @return the total view count of posts by the user
     */
    public int getTotalViewCountByUser(int userId) {
        String sql = "SELECT SUM(view_count) FROM blog_posts WHERE author_id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

            return 0;
        } catch (SQLException e) {
            System.err.println("Error getting total view count by user: " + e.getMessage());
            return 0;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Gets the total count of blog posts
     * @return the count of all blog posts
     */
    public int getTotalPostCount() {
        String sql = "SELECT COUNT(*) FROM blog_posts";
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
            System.err.println("Error getting total post count: " + e.getMessage());
            return 0;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Gets a list of recent blog posts with author and category information
     * @param limit the maximum number of posts to return
     * @return a list of maps containing post data
     */
    public List<Map<String, Object>> getRecentPosts(int limit) {
        String sql = "SELECT p.id, p.title, p.created_at, p.view_count, u.username as author, c.name as category " +
                "FROM blog_posts p " +
                "JOIN users u ON p.author_id = u.id " +
                "JOIN categories c ON p.category_id = c.id " +
                "ORDER BY p.created_at DESC " +
                "LIMIT ?";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> posts = new ArrayList<>();

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, limit);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> post = new HashMap<>();
                post.put("id", rs.getInt("id"));
                post.put("title", rs.getString("title"));
                post.put("author", rs.getString("author"));
                post.put("category", rs.getString("category"));
                post.put("createdAt", rs.getTimestamp("created_at"));
                post.put("views", rs.getInt("view_count"));
                posts.add(post);
            }

            return posts;
        } catch (SQLException e) {
            System.err.println("Error getting recent posts: " + e.getMessage());
            return posts;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Gets the count of posts by category
     * @return a map of category IDs to post counts
     */
    public Map<Integer, Integer> getPostCountByCategory() {
        String sql = "SELECT category_id, COUNT(*) as post_count FROM blog_posts GROUP BY category_id";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Map<Integer, Integer> categoryCounts = new HashMap<>();

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                categoryCounts.put(rs.getInt("category_id"), rs.getInt("post_count"));
            }

            return categoryCounts;
        } catch (SQLException e) {
            System.err.println("Error getting post count by category: " + e.getMessage());
            return categoryCounts;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Gets the ID of the most active category (the one with the most posts)
     * @return the ID of the most active category, or -1 if no posts exist
     */
    public int getMostActiveCategoryId() {
        String sql = "SELECT category_id, COUNT(*) as post_count FROM blog_posts GROUP BY category_id ORDER BY post_count DESC LIMIT 1";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("category_id");
            }

            return -1;
        } catch (SQLException e) {
            System.err.println("Error getting most active category: " + e.getMessage());
            return -1;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Gets the count of published posts
     * @return the count of published posts
     */
    public int getPublishedPostCount() {
        String sql = "SELECT COUNT(*) FROM blog_posts WHERE status = 'PUBLISHED'";
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
            System.err.println("Error getting published post count: " + e.getMessage());
            return 0;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Gets the count of draft posts
     * @return the count of draft posts
     */
    public int getDraftPostCount() {
        String sql = "SELECT COUNT(*) FROM blog_posts WHERE status = 'DRAFT'";
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
            System.err.println("Error getting draft post count: " + e.getMessage());
            return 0;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Gets the total view count of all posts
     * @return the total view count
     */
    public int getTotalViewCount() {
        String sql = "SELECT SUM(view_count) FROM blog_posts";
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
            System.err.println("Error getting total view count: " + e.getMessage());
            return 0;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Gets all blog posts with pagination and optional filtering
     * @param page the page number (1-based)
     * @param pageSize the number of posts per page
     * @param status optional status filter ("PUBLISHED", "DRAFT", or null for all)
     * @return a list of maps containing post data
     */
    public List<Map<String, Object>> getAllPosts(int page, int pageSize, String status) {
        StringBuilder sqlBuilder = new StringBuilder(
                "SELECT p.id, p.title, p.content, p.status, p.view_count, p.created_at, " +
                        "u.username as author, c.name as category " +
                        "FROM blog_posts p " +
                        "JOIN users u ON p.author_id = u.id " +
                        "JOIN categories c ON p.category_id = c.id "
        );

        if (status != null && !status.isEmpty()) {
            sqlBuilder.append("WHERE p.status = ? ");
        }

        sqlBuilder.append("ORDER BY p.created_at DESC LIMIT ? OFFSET ?");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> posts = new ArrayList<>();

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sqlBuilder.toString());

            int paramIndex = 1;
            if (status != null && !status.isEmpty()) {
                stmt.setString(paramIndex++, status);
            }

            stmt.setInt(paramIndex++, pageSize);
            stmt.setInt(paramIndex, (page - 1) * pageSize);

            rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> post = new HashMap<>();
                post.put("id", rs.getInt("id"));
                post.put("title", rs.getString("title"));
                post.put("content", rs.getString("content"));
                post.put("author", rs.getString("author"));
                post.put("category", rs.getString("category"));
                post.put("status", rs.getString("status"));
                post.put("views", rs.getInt("view_count"));
                post.put("createdAt", rs.getTimestamp("created_at"));
                posts.add(post);
            }

            return posts;
        } catch (SQLException e) {
            System.err.println("Error getting all posts: " + e.getMessage());
            return posts;
        } finally {
            closeResources(conn, stmt, rs);
        }
    }

    /**
     * Updates the view count of a blog post
     * @param postId the ID of the post to update
     * @param viewCount the new view count value
     * @return true if the update was successful, false otherwise
     */
    public boolean updateViewCount(int postId, int viewCount) {
        String sql = "UPDATE blog_posts SET view_count = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, viewCount);
            stmt.setInt(2, postId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error updating blog post view count: " + e.getMessage());
            return false;
        } finally {
            closeResources(conn, stmt, null);
        }
    }

    /**
     * Searches for blog posts by keyword in title or content
     * @param keyword the search keyword
     * @param page the page number (1-based)
     * @param pageSize the number of posts per page
     * @return a list of maps containing post data
     */
    public List<Map<String, Object>> searchPosts(String keyword, int page, int pageSize) {
        StringBuilder sqlBuilder = new StringBuilder(
                "SELECT p.id, p.title, p.content, p.status, p.view_count, p.created_at, " +
                        "u.username as author, c.name as category " +
                        "FROM blog_posts p " +
                        "JOIN users u ON p.author_id = u.id " +
                        "JOIN categories c ON p.category_id = c.id " +
                        "WHERE p.status = 'PUBLISHED' AND (p.title LIKE ? OR p.content LIKE ?) " +
                        "ORDER BY p.created_at DESC LIMIT ? OFFSET ?"
        );

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> posts = new ArrayList<>();

        try {
            conn = DbConnectionUtil.getConnection();
            stmt = conn.prepareStatement(sqlBuilder.toString());

            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setInt(3, pageSize);
            stmt.setInt(4, (page - 1) * pageSize);

            rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> post = new HashMap<>();
                post.put("id", rs.getInt("id"));
                post.put("title", rs.getString("title"));
                post.put("content", rs.getString("content"));
                post.put("author", rs.getString("author"));
                post.put("category", rs.getString("category"));
                post.put("status", rs.getString("status"));
                post.put("views", rs.getInt("view_count"));
                post.put("createdAt", rs.getTimestamp("created_at"));
                posts.add(post);
            }

            return posts;
        } catch (SQLException e) {
            System.err.println("Error searching posts: " + e.getMessage());
            return posts;
        } finally {
            closeResources(conn, stmt, rs);
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
