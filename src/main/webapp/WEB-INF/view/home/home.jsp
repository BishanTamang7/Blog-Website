<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Home - InsightHub</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home/home.css">
</head>
<body>
<header>
  <div class="logo"><a href="${pageContext.request.contextPath}/index.jsp">InsightHub</a></div>
  <div class="search-container">
    <input type="text" id="searchInput" placeholder="Search articles...">
    <button id="searchButton">
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <circle cx="11" cy="11" r="8"></circle>
        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
      </svg>
    </button>
  </div>
  <div class="nav-links">
    <a href="#" class="write-link">Write</a>
    <div class="user-menu">
      <div class="user-avatar" id="userAvatar">
        <span class="avatar-text">U</span>
      </div>
      <div class="dropdown-menu" id="userDropdown">
        <div class="dropdown-header">
          <span class="user-name" id="userName">Username</span>
          <span class="user-email" id="userEmail">user@example.com</span>
        </div>
        <div class="dropdown-divider"></div>
        <a href="#" class="dropdown-item">Profile</a>
        <a href="#" class="dropdown-item">Settings</a>
        <a href="#" class="dropdown-item" id="logoutBtn">Sign out</a>
      </div>
    </div>
  </div>
</header>

<div class="container">
  <div class="sidebar">
    <nav class="side-nav">
      <a href="#" class="active"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg> Home</a>
      <a href="#"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg> My Stories</a>
      <a href="#"><svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path></svg> Saved</a>
      <div class="category-section">
        <h3>Categories</h3>
        <a href="#">Technology</a>
        <a href="#">Business</a>
        <a href="#">Lifestyle</a>
        <a href="#">Education</a>
        <a href="#">Health</a>
        <a href="#">+ More</a>
      </div>
    </nav>
  </div>

  <main class="content">
    <div class="for-you-section">
      <h2>For You</h2>
      <div class="article-grid">
        <!-- Articles will be dynamically generated here -->
      </div>
    </div>

    <div class="trending-section">
      <h2>Trending on The Daily Idea</h2>
      <div class="trending-articles">
        <!-- Trending articles will be dynamically generated here -->
      </div>
    </div>
  </main>

  <div class="right-sidebar">
    <div class="profile-card">
      <div class="large-avatar">
        <span class="avatar-text" id="largeAvatarText">U</span>
      </div>
      <h3 id="profileName">Username</h3>
      <p class="profile-bio">Welcome to The Daily Idea! Complete your profile to start sharing your ideas with the world.</p>
      <a href="#" class="edit-profile-btn">Edit Profile</a>
    </div>

    <div class="suggestions-card">
      <h3>Who to follow</h3>
      <div class="suggested-users">
        <!-- Suggested users will be dynamically generated here -->
      </div>
      <a href="#" class="see-more-link">See more</a>
    </div>
  </div>
</div>

<div id="newPostModal" class="modal">
  <div class="modal-content">
    <span class="close">&times;</span>
    <h2>Create a new post</h2>
    <form id="newPostForm">
      <div class="form-group">
        <input type="text" id="postTitle" placeholder="Title" required>
      </div>
      <div class="form-group">
        <select id="postCategory" required>
          <option value="" disabled selected>Select a category</option>
          <option value="technology">Technology</option>
          <option value="business">Business</option>
          <option value="lifestyle">Lifestyle</option>
          <option value="education">Education</option>
          <option value="health">Health</option>
        </select>
      </div>
      <div class="form-group">
        <textarea id="postContent" placeholder="Write your story..." required></textarea>
      </div>
      <div class="form-actions">
        <button type="button" class="save-draft-btn">Save as draft</button>
        <button type="submit" class="publish-btn">Publish</button>
      </div>
    </form>
  </div>
</div>

<footer>
  <div class="footer-links">
    <a href="#">Help</a>
    <a href="#">Status</a>
    <a href="#">About</a>
    <a href="#">Blog</a>
    <a href="#">Privacy</a>
    <a href="#">Terms</a>
  </div>
</footer>

<script src="${pageContext.request.contextPath}/assets/js/home/home.js"></script>
</body>
</html>
