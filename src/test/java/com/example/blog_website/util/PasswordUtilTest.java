package com.example.blog_website.util;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class PasswordUtilTest {

    @Test
    public void testVerifyPassword_WithValidPassword() {
        // Given
        String password = "testPassword123";
        String hashedPassword = PasswordUtil.hashPassword(password);
        
        // When
        boolean result = PasswordUtil.verifyPassword(password, hashedPassword);
        
        // Then
        assertTrue(result, "Valid password should be verified successfully");
    }
    
    @Test
    public void testVerifyPassword_WithInvalidPassword() {
        // Given
        String password = "testPassword123";
        String wrongPassword = "wrongPassword";
        String hashedPassword = PasswordUtil.hashPassword(password);
        
        // When
        boolean result = PasswordUtil.verifyPassword(wrongPassword, hashedPassword);
        
        // Then
        assertFalse(result, "Invalid password should not be verified");
    }
    
    @Test
    public void testVerifyPassword_WithNullPassword() {
        // Given
        String password = "testPassword123";
        String hashedPassword = PasswordUtil.hashPassword(password);
        
        // When
        boolean result = PasswordUtil.verifyPassword(null, hashedPassword);
        
        // Then
        assertFalse(result, "Null password should not be verified");
    }
    
    @Test
    public void testVerifyPassword_WithEmptyPassword() {
        // Given
        String password = "testPassword123";
        String hashedPassword = PasswordUtil.hashPassword(password);
        
        // When
        boolean result = PasswordUtil.verifyPassword("", hashedPassword);
        
        // Then
        assertFalse(result, "Empty password should not be verified");
    }
    
    @Test
    public void testVerifyPassword_WithNullHash() {
        // When
        boolean result = PasswordUtil.verifyPassword("somePassword", null);
        
        // Then
        assertFalse(result, "Null hash should not be verified");
    }
    
    @Test
    public void testVerifyPassword_WithEmptyHash() {
        // When
        boolean result = PasswordUtil.verifyPassword("somePassword", "");
        
        // Then
        assertFalse(result, "Empty hash should not be verified");
    }
    
    @Test
    public void testVerifyPassword_WithInvalidHash() {
        // When
        boolean result = PasswordUtil.verifyPassword("somePassword", "invalidHash");
        
        // Then
        assertFalse(result, "Invalid hash format should not be verified");
    }
}