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
import java.sql.Timestamp;
import java.time.LocalDateTime;
import util.EmailService;
import util.OtpGenerator;
import java.util.logging.Level;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(RegisterServlet.class.getName());
    
    private ParentDAO parentDao;
    
    @Override
    public void init() throws ServletException {
        super.init();
        try {
            parentDao = new ParentDAO();
            LOGGER.info("RegisterServlet initialized successfully");
        } catch (Exception ex) {
            LOGGER.severe("Failed to initialize RegisterServlet: " + ex.getMessage());
            throw new ServletException("RegisterServlet initialization failed", ex);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/auth/register.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        
        // Basic validation
        if (fullName == null || email == null || password == null || confirmPassword == null ||
            fullName.trim().isEmpty() || email.trim().isEmpty() || 
            password.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            req.setAttribute("error", "Please fill in all required fields.");
            req.getRequestDispatcher("/auth/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords do not match.");
            req.getRequestDispatcher("/auth/register.jsp").forward(req, resp);
            return;
        }

        ParentDAO parentDAO = new ParentDAO();
        try {
            if (parentDAO.emailExists(email)) {
                req.setAttribute("error", "An account with this email already exists.");
                req.getRequestDispatcher("/auth/register.jsp").forward(req, resp);
                return;
            }

            // Create parent object with UNVERIFIED status
            Parents newParent = new Parents();
            newParent.setFullName(fullName);
            newParent.setEmail(email);
            newParent.setPassword(password); // Storing plain text, consider hashing
            newParent.setPhone(phone);
            newParent.setStatus("UNVERIFIED");

            boolean created = parentDAO.create(newParent);

            if (created) {
                // Generate and send OTP
                String otp = OtpGenerator.generateOtp();
                Timestamp expiryTime = Timestamp.valueOf(LocalDateTime.now().plusMinutes(10));
                
                parentDAO.saveVerificationCode(email, otp, expiryTime);

                EmailService emailService = new EmailService();
                emailService.sendOtpEmail(email, otp);

                // Redirect to OTP verification page
                resp.sendRedirect(req.getContextPath() + "/auth/verify-otp.jsp?email=" + email);

            } else {
                req.setAttribute("error", "An unexpected error occurred. Please try again.");
                req.getRequestDispatcher("/auth/register.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Registration error", e);
            req.setAttribute("error", "A database error occurred.");
            req.getRequestDispatcher("/auth/register.jsp").forward(req, resp);
        }
    }
}
