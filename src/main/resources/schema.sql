CREATE SCHEMA IF NOT EXISTS blog_db;
USE blog_db;

CREATE TABLE IF NOT EXISTS Users (
                                     id INT AUTO_INCREMENT PRIMARY KEY,
                                     username VARCHAR(50) NOT NULL UNIQUE,
                                     email VARCHAR(100) NOT NULL UNIQUE,
                                     password VARCHAR(255) NOT NULL,
                                     profile_info TEXT,
                                     role ENUM('ADMIN', 'AUTHOR', 'READER') NOT NULL DEFAULT 'READER',
                                     is_active BOOLEAN DEFAULT TRUE,
                                     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                     updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS Categories (
                                          id INT AUTO_INCREMENT PRIMARY KEY,
                                          name VARCHAR(100) NOT NULL UNIQUE,
                                          description TEXT,
                                          is_active BOOLEAN DEFAULT TRUE,
                                          created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                                          updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS Articles (
                                        id INT AUTO_INCREMENT PRIMARY KEY,
                                        title VARCHAR(200) NOT NULL,
                                        content TEXT NOT NULL,
                                        user_id INT NOT NULL,
                                        publication_date DATETIME DEFAULT CURRENT_TIMESTAMP,
                                        image_url VARCHAR(255),
                                        status VARCHAR(20) DEFAULT 'pending',
                                        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                                        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                        FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Article_Categories (
                                                  article_id INT NOT NULL,
                                                  category_id INT NOT NULL,
                                                  PRIMARY KEY (article_id, category_id),
                                                  FOREIGN KEY (article_id) REFERENCES Articles(id) ON DELETE CASCADE,
                                                  FOREIGN KEY (category_id) REFERENCES Categories(id) ON DELETE CASCADE
);
