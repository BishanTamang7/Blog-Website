CREATE DATABASE IF NOT EXISTS blog_db;
USE blog_db;

-- Users Table
CREATE TABLE IF NOT EXISTS users (
                                     id INT AUTO_INCREMENT PRIMARY KEY,
                                     username VARCHAR(50) NOT NULL UNIQUE,
                                     email VARCHAR(100) NOT NULL UNIQUE,
                                     password VARCHAR(255) NOT NULL,
                                     first_name VARCHAR(50),
                                     last_name VARCHAR(50),
                                     bio TEXT,
                                     profile_image VARCHAR(255),
                                     role ENUM('ADMIN', 'USER') NOT NULL DEFAULT 'USER',
                                     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                     updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                     last_login TIMESTAMP NULL,
                                     status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE'
);

-- Categories Table
CREATE TABLE IF NOT EXISTS categories (
                                          id INT AUTO_INCREMENT PRIMARY KEY,
                                          name VARCHAR(50) NOT NULL UNIQUE,
                                          description TEXT,
                                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                          created_by INT,
                                          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                          FOREIGN KEY (created_by) REFERENCES users(id)
);

-- Blog Posts Table
CREATE TABLE IF NOT EXISTS blog_posts (
                                          id INT AUTO_INCREMENT PRIMARY KEY,
                                          title VARCHAR(255) NOT NULL,
                                          content TEXT NOT NULL,
                                          author_id INT NOT NULL,
                                          category_id INT NOT NULL,
                                          status ENUM('DRAFT', 'PUBLISHED') DEFAULT 'DRAFT',
                                          view_count INT DEFAULT 0,
                                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                          published_at TIMESTAMP NULL,
                                          FOREIGN KEY (author_id) REFERENCES users(id),
                                          FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- User Activity Table (for reports)
CREATE TABLE IF NOT EXISTS user_activities (
                                               id INT AUTO_INCREMENT PRIMARY KEY,
                                               user_id INT NOT NULL,
                                               activity_type VARCHAR(50) NOT NULL,
                                               timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                               details TEXT,
                                               FOREIGN KEY (user_id) REFERENCES users(id)
);