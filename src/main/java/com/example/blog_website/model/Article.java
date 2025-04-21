package com.example.blog_website.model;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;

public class Article {
    private Long id;
    private String title;
    private String content;
    private User author;
    private Date publicationDate;
    private List<Category> categories;

    // Constructors
    public Article() {
        this.categories = new ArrayList<>();
        this.publicationDate = new Date();
    }

    public Article(String title, String content, User author) {
        this();
        this.title = title;
        this.content = content;
        this.author = author;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public User getAuthor() {
        return author;
    }

    public void setAuthor(User author) {
        this.author = author;
    }

    public Date getPublicationDate() {
        return publicationDate;
    }

    public void setPublicationDate(Date publicationDate) {
        this.publicationDate = publicationDate;
    }

    public List<Category> getCategories() {
        return categories;
    }

    public void setCategories(List<Category> categories) {
        this.categories = categories;
    }

    public void addCategory(Category category) {
        if (!categories.contains(category)) {
            categories.add(category);
        }
    }

    public void removeCategory(Category category) {
        categories.remove(category);
    }

    @Override
    public String toString() {
        return "Article{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", author=" + (author != null ? author.getUsername() : "none") +
                ", publicationDate=" + publicationDate +
                ", categories=" + categories +
                '}';
    }
}