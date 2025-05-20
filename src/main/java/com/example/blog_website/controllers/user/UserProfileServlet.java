package com.example.blog_website.controllers.user;

import com.example.blog_website.dao.BlogPostDAO;
import com.example.blog_website.models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.Period;
import java.time.ZoneId;

@WebServlet("/profile")
public class UserProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check for success message in session
        String successMessage = (String) request.getSession().getAttribute("successMessage");
        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
            // Remove from session after transferring to request
            request.getSession().removeAttribute("successMessage");
        }

        // Get total views and published posts count
        BlogPostDAO blogPostDAO = new BlogPostDAO();
        int totalViews = blogPostDAO.getTotalViewCountByUser(user.getId());
        int publishedPosts = blogPostDAO.getPublishedPostCountByUser(user.getId());

        // Calculate member since (years, months, or days)
        String memberSince = calculateMemberSince(user.getCreatedAt());

        // Set attributes for the view
        request.setAttribute("totalViews", totalViews);
        request.setAttribute("publishedPosts", publishedPosts);
        request.setAttribute("memberSince", memberSince);

        // Forward to profile page
        request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
    }

    /**
     * Calculates how long a user has been a member
     * @param createdAt the timestamp when the user was created
     * @return a string representing the membership duration (e.g., "2 Years", "3 Months", "5 Days")
     */
    private String calculateMemberSince(Timestamp createdAt) {
        if (createdAt == null) {
            return "Unknown";
        }

        LocalDate createdDate = createdAt.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        LocalDate currentDate = LocalDate.now();
        Period period = Period.between(createdDate, currentDate);

        if (period.getYears() > 0) {
            return period.getYears() + (period.getYears() == 1 ? " Year" : " Years");
        } else if (period.getMonths() > 0) {
            return period.getMonths() + (period.getMonths() == 1 ? " Month" : " Months");
        } else {
            int days = period.getDays();
            return days + (days == 1 ? " Day" : " Days");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirect POST requests to GET
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
