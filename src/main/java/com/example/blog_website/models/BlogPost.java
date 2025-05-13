package com.example.blog_website.models;

import java.sql.Timestamp;

public class BlogPost {
    private int id;
    private String title;
    private String content;
    private int authorId;
    private int categoryId;
    private String status;  // "DRAFT" or "PUBLISHED"
    private int viewCount;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp publishedAt;

    // Constructors
    public BlogPost() {}

    public BlogPost(String title, String content, int authorId, int categoryId) {
        this.title = title;
        this.content = content;
        this.authorId = authorId;
        this.categoryId = categoryId;
        this.status = "DRAFT";
        this.viewCount = 0;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public int getAuthorId() { return authorId; }
    public void setAuthorId(int authorId) { this.authorId = authorId; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getViewCount() { return viewCount; }
    public void setViewCount(int viewCount) { this.viewCount = viewCount; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public Timestamp getPublishedAt() { return publishedAt; }
    public void setPublishedAt(Timestamp publishedAt) { this.publishedAt = publishedAt; }

    public void incrementViewCount() {
        this.viewCount++;
    }

    public void publish() {
        this.status = "PUBLISHED";
        this.publishedAt = new Timestamp(System.currentTimeMillis());
    }
}

