package com.example.blog_website.controllers.user;

import jakarta.servlet.annotation.WebServlet;

@WebServlet("/user/edit-post")
public class EditPostServlet extends UpdatePostServlet {
    // This servlet extends UpdatePostServlet to reuse its functionality
    // The only difference is the URL mapping (/user/edit-post instead of /user/update-post)
}