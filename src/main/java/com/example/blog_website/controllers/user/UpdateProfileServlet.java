package com.example.blog_website.controllers.user;

import com.example.blog_website.dao.UserDAO;
import com.example.blog_website.models.User;
import com.example.blog_website.services.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Pattern;

@WebServlet("/update-profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 5 * 1024 * 1024,   // 5 MB
    maxRequestSize = 10 * 1024 * 1024 // 10 MB
)
public class UpdateProfileServlet extends HttpServlet {
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
    private static final String UPLOAD_DIRECTORY = "assets/images";
    private UserDAO userDAO;
    private UserService userService;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirect to profile page if accessed directly
        response.sendRedirect(request.getContextPath() + "/profile");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the user from the session
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get form data
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String bio = request.getParameter("bio");

        // Validate form data
        Map<String, String> errors = validateFormData(user, email);

        // Process profile image if provided
        String profileImagePath = user.getProfileImage(); // Keep existing image by default
        Part filePart = request.getPart("profileImage");
        if (filePart != null && filePart.getSize() > 0) {
            try {
                profileImagePath = processProfileImage(filePart, request);
            } catch (IOException e) {
                errors.put("imageError", "Failed to upload image: " + e.getMessage());
            }
        }

        // If there are validation errors, redirect back to edit profile with errors
        if (!errors.isEmpty()) {
            for (Map.Entry<String, String> error : errors.entrySet()) {
                request.setAttribute(error.getKey(), error.getValue());
            }
            request.setAttribute("errorMessage", "Please fix the errors below.");
            request.getRequestDispatcher("/WEB-INF/views/user/edit-profile.jsp").forward(request, response);
            return;
        }

        // Update user object
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        user.setBio(bio);
        user.setProfileImage(profileImagePath);

        // Save to database
        boolean updated = userDAO.updateUser(user);

        if (updated) {
            // Update session user
            request.getSession().setAttribute("user", user);
            // Set success message in session so it persists through redirect
            request.getSession().setAttribute("successMessage", "Profile updated successfully!");
            // Redirect back to profile
            response.sendRedirect(request.getContextPath() + "/profile");
        } else {
            request.setAttribute("errorMessage", "Failed to update profile. Please try again.");
            // Forward back to edit profile page with error
            request.getRequestDispatcher("/WEB-INF/views/user/edit-profile.jsp").forward(request, response);
        }
    }

    private Map<String, String> validateFormData(User user, String email) {
        Map<String, String> errors = new HashMap<>();

        // Validate email
        if (email == null || email.trim().isEmpty()) {
            errors.put("emailError", "Email is required");
        } else if (!EMAIL_PATTERN.matcher(email).matches()) {
            errors.put("emailError", "Invalid email format");
        } else if (!email.equals(user.getEmail()) && userDAO.emailExists(email)) {
            errors.put("emailError", "Email already exists");
        }

        return errors;
    }

    private String processProfileImage(Part filePart, HttpServletRequest request) throws IOException {
        // Validate file type
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String fileExtension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();

        if (!fileExtension.equals(".jpg") && !fileExtension.equals(".jpeg") && 
            !fileExtension.equals(".png") && !fileExtension.equals(".gif")) {
            throw new IOException("Invalid file type. Only JPG, PNG, and GIF are allowed.");
        }

        // Create upload directory if it doesn't exist
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIRECTORY;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // Generate unique filename
        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
        Path filePath = Paths.get(uploadPath, uniqueFileName);

        // Save the file
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
        }

        // Return the relative path to be stored in the database
        return UPLOAD_DIRECTORY + "/" + uniqueFileName;
    }
}
