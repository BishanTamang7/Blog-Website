package com.example.blog_website.models;

import java.sql.Timestamp;

public class Category {
    private int id;
    private String name;
    private String description;
    private int createdBy;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Constructors
    public Category() {}

    public Category(String name, String description, int createdBy) {
        this.name = name;
        this.description = description;
        this.createdBy = createdBy;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}

