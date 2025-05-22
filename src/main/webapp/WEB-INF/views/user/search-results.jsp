<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results - InsightHub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user/user-dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="logo">
                <h2>InsightHub</h2>
            </div>
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/user/user-dashboard"><i class="fas fa-home"></i> Home</a></li>
                <li><a href="${pageContext.request.contextPath}/user/my-stories"><i class="fas fa-book"></i> My Stories</a></li>
                <li><a href="${pageContext.request.contextPath}/user/create-post"><i class="fas fa-pen"></i> Write</a></li>
                <li><a href="${pageContext.request.contextPath}/user/profile"><i class="fas fa-user"></i> Profile</a></li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Header -->
            <div class="header">
                <div class="search-container">
                    <div class="search-bar">
                        <svg class="search-icon svg-icon" viewBox="0 0 24 24">
                            <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"></path>
                        </svg>
                        <form action="${pageContext.request.contextPath}/search" method="get">
                            <input type="text" class="search-input" name="keyword" placeholder="Search" value="${keyword}">
                            <button type="submit" style="display:none;">Search</button>
                        </form>
                    </div>
                </div>
                <div class="user-profile">
                    <div class="profile-dropdown">
                        <div class="profile-dropdown-btn">
                            <div class="profile-img">
                                <i class="fa-solid fa-circle-user"></i>
                            </div>
                            <span>${sessionScope.user.username} <i class="fa-solid fa-angle-down"></i></span>
                        </div>
                        <ul class="profile-dropdown-list">
                            <li class="profile-dropdown-list-item">
                                <a href="${pageContext.request.contextPath}/user/profile">
                                    <i class="fa-regular fa-user"></i>
                                    Edit Profile
                                </a>
                            </li>
                            <li class="profile-dropdown-list-item">
                                <a href="${pageContext.request.contextPath}/user/change-password">
                                    <i class="fa-solid fa-lock"></i>
                                    Change Password
                                </a>
                            </li>
                            <hr/>
                            <li class="profile-dropdown-list-item">
                                <a href="${pageContext.request.contextPath}/logout">
                                    <i class="fa-solid fa-arrow-right-from-bracket"></i>
                                    Log out
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Search Results -->
            <div class="content-section">
                <h2>Search Results for: ${keyword}</h2>
                
                <c:if test="${empty searchResults}">
                    <div class="no-results">
                        <p>No results found for "${keyword}"</p>
                    </div>
                </c:if>
                
                <c:if test="${not empty searchResults}">
                    <div class="blog-posts">
                        <c:forEach var="post" items="${searchResults}">
                            <div class="blog-post">
                                <h3><a href="${pageContext.request.contextPath}/user/view-post?id=${post.id}">${post.title}</a></h3>
                                <div class="post-meta">
                                    <span class="author">By ${post.author}</span>
                                    <span class="category">${post.category}</span>
                                    <span class="date"><fmt:formatDate value="${post.createdAt}" pattern="MMM dd, yyyy" /></span>
                                    <span class="views"><i class="fas fa-eye"></i> ${post.views}</span>
                                </div>
                                <p class="post-excerpt">${post.content.length() > 200 ? post.content.substring(0, 200).concat('...') : post.content}</p>
                                <a href="${pageContext.request.contextPath}/user/view-post?id=${post.id}" class="read-more">Read More</a>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="pagination">
                            <c:if test="${currentPage > 1}">
                                <a href="${pageContext.request.contextPath}/search?keyword=${keyword}&page=${currentPage - 1}" class="prev">Previous</a>
                            </c:if>
                            
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:choose>
                                    <c:when test="${currentPage == i}">
                                        <span class="current">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/search?keyword=${keyword}&page=${i}">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <a href="${pageContext.request.contextPath}/search?keyword=${keyword}&page=${currentPage + 1}" class="next">Next</a>
                            </c:if>
                        </div>
                    </c:if>
                </c:if>
            </div>
        </div>
    </div>

    <script>
        // Profile dropdown functionality
        const profileDropdownBtn = document.querySelector('.profile-dropdown-btn');
        const profileDropdownList = document.querySelector('.profile-dropdown-list');
        
        profileDropdownBtn.addEventListener('click', () => {
            profileDropdownList.classList.toggle('active');
        });
        
        // Close dropdown when clicking outside
        window.addEventListener('click', (e) => {
            if (!profileDropdownBtn.contains(e.target) && !profileDropdownList.contains(e.target)) {
                profileDropdownList.classList.remove('active');
            }
        });
    </script>
</body>
</html>