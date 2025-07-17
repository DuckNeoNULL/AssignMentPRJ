package controller;

import dao.ParentDAO;
import model.Parents;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Random;
import java.util.logging.Logger;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ForgotPasswordServlet.class.getName());
    
    private ParentDAO parentDao;
    
    @Override
    public void init() throws ServletException {
        super.init();
        try {
            parentDao = new ParentDAO();
            LOGGER.info("ForgotPasswordServlet initialized successfully");
        } catch (Exception ex) {
            LOGGER.severe("Failed to initialize ForgotPasswordServlet: " + ex.getMessage());
            throw new ServletException("ForgotPasswordServlet initialization failed", ex);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/auth/forgot-password.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        
        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "Email address is required");
            req.getRequestDispatcher("/auth/forgot-password.jsp").forward(req, resp);
            return;
        }
        
        email = email.trim();
        
        try {
            // Check if email exists
            Parents parent = parentDao.findByEmail(email);
            
            if (parent != null) {
                // Generate 6-digit verification code
                String verificationCode = generateVerificationCode();
                
                // Update verification code
                boolean updated = parentDao.updateVerificationCode(email, verificationCode);
                
                if (updated) {
                    // For development: log the reset code (in production, send via email)
                    System.out.println("=== PASSWORD RESET ===");
                    System.out.println("Email: " + email);
                    System.out.println("Current Password (plaintext): " + parent.getPassword());
                    System.out.println("Reset Code: " + verificationCode);
                    System.out.println("=====================");
                    
                    LOGGER.info("Password reset code generated for email: " + email);
                } else {
                    LOGGER.warning("Failed to update verification code for email: " + email);
                }
            }
            
            // Always show the same success message for security
            req.setAttribute("message", "If email exists, reset instructions have been sent. Check console for details.");
            
        } catch (Exception ex) {
            LOGGER.severe("Error processing forgot password request for email: " + email + " - " + ex.getMessage());
            req.setAttribute("error", "An error occurred. Please try again later.");
        }
        
        req.getRequestDispatcher("/auth/forgot-password.jsp").forward(req, resp);
    }
    
    private String generateVerificationCode() {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000);
        return String.valueOf(code);
    }
}

