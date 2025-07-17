package controller;

import dao.ParentDAO;
import model.Parents;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ResetPasswordServlet.class.getName());
    
    private ParentDAO parentDao;
    
    @Override
    public void init() throws ServletException {
        super.init();
        try {
            parentDao = new ParentDAO();
            LOGGER.info("ResetPasswordServlet initialized successfully");
        } catch (Exception ex) {
            LOGGER.severe("Failed to initialize ResetPasswordServlet: " + ex.getMessage());
            throw new ServletException("ResetPasswordServlet initialization failed", ex);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/auth/reset-password.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String verificationCode = req.getParameter("verificationCode");
        String newPassword = req.getParameter("newPassword");
        
        if (email == null || email.trim().isEmpty() || 
            verificationCode == null || verificationCode.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty()) {
            req.setAttribute("error", "All fields are required");
            req.getRequestDispatcher("/auth/reset-password.jsp").forward(req, resp);
            return;
        }
        
        try {
            // Find parent by email
            Parents parent = parentDao.findByEmail(email.trim());
            
            if (parent == null) {
                req.setAttribute("error", "Invalid email address");
                req.getRequestDispatcher("/auth/reset-password.jsp").forward(req, resp);
                return;
            }
            
            // Check verification code
            String storedCode = parent.getVerificationCode();
            if (storedCode == null || !storedCode.equals(verificationCode.trim())) {
                LOGGER.warning("Invalid verification code for email: " + email + ". Expected: " + storedCode + ", Got: " + verificationCode);
                req.setAttribute("error", "Invalid verification code");
                req.getRequestDispatcher("/auth/reset-password.jsp").forward(req, resp);
                return;
            }
            
            // Update password
            boolean updated = parentDao.updatePassword(parent.getParentId(), newPassword.trim());
            
            if (updated) {
                // Clear verification code
                parentDao.updateVerificationCode(email.trim(), null);
                
                LOGGER.info("Password reset successful for email: " + email);
                resp.sendRedirect(req.getContextPath() + "/login?reset=success");
            } else {
                req.setAttribute("error", "Failed to update password. Please try again.");
                req.getRequestDispatcher("/auth/reset-password.jsp").forward(req, resp);
            }
            
        } catch (Exception ex) {
            LOGGER.severe("Error during password reset for email: " + email + " - " + ex.getMessage());
            req.setAttribute("error", "An error occurred. Please try again later.");
            req.getRequestDispatcher("/auth/reset-password.jsp").forward(req, resp);
        }
    }
}