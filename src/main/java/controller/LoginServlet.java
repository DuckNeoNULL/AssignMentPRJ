package controller;

import dao.ParentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Parents;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());
    
    private ParentDAO parentDao;
    
    @Override
    public void init() throws ServletException {
        super.init();
        try {
            parentDao = new ParentDAO();
            LOGGER.info("LoginServlet initialized successfully");
        } catch (Exception ex) {
            LOGGER.severe("Failed to initialize LoginServlet: " + ex.getMessage());
            throw new ServletException("LoginServlet initialization failed", ex);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String registered = req.getParameter("registered");
        if ("true".equals(registered)) {
            req.setAttribute("message", "Registration successful! Please login.");
        }
        req.getRequestDispatcher("/auth/login.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        LOGGER.info("=== LOGIN ATTEMPT STARTED ===");
        
        String email = req.getParameter("email");
        String passwordInput = req.getParameter("password");
        
        LOGGER.info("Login attempt: email=[" + email + "], passwordInput=[" + passwordInput + "]");
        
        // Validate input parameters
        if (email == null || email.trim().isEmpty()) {
            LOGGER.warning("Login failed: Missing email parameter");
            req.setAttribute("error", "Email is required");
            req.getRequestDispatcher("/auth/login.jsp").forward(req, resp);
            return;
        }
        
        if (passwordInput == null || passwordInput.trim().isEmpty()) {
            LOGGER.warning("Login failed: Missing password parameter");
            req.setAttribute("error", "Password is required");
            req.getRequestDispatcher("/auth/login.jsp").forward(req, resp);
            return;
        }
        
        try {
            LOGGER.info("Attempting to find user in database...");
            
            // Test database connection first
            if (!dao.DBConnection.testConnection()) {
                LOGGER.severe("Database connection test failed");
                req.setAttribute("error", "Database connection failed. Please try again later.");
                req.getRequestDispatcher("/auth/login.jsp").forward(req, resp);
                return;
            }
            
            Parents p = parentDao.findByEmail(email.trim());
            if (p == null) {
                LOGGER.warning("Login failed: no such user " + email);
                req.setAttribute("error", "Invalid email or password");
                req.getRequestDispatcher("/auth/login.jsp").forward(req, resp);
                return;
            }
            
            LOGGER.info("User found in database: " + p.getEmail());
            
            // Compare plaintext passwords
            if (passwordInput.equals(p.getPassword())) {
                LOGGER.info("Login successful for " + email);
                
                // Validate role
                String roleFromDB = p.getRole();
                if (roleFromDB == null || roleFromDB.trim().isEmpty()) {
                    roleFromDB = "USER";
                    LOGGER.warning("User " + email + " has null role, defaulting to USER");
                }
                
                if (!roleFromDB.equals("USER") && !roleFromDB.equals("ADMIN")) {
                    LOGGER.severe("Invalid role for user: " + email + " - Role: " + roleFromDB);
                    req.setAttribute("error", "Account has invalid role. Please contact administrator.");
                    req.getRequestDispatcher("/auth/login.jsp").forward(req, resp);
                    return;
                }
                
                LOGGER.info("Authentication successful, creating session...");
                
                // Create new session and set attributes
                HttpSession session = req.getSession(true);
                session.setAttribute("parentId", p.getParentId());
                session.setAttribute("parentEmail", p.getEmail());
                session.setAttribute("userRole", roleFromDB);
                session.setAttribute("username", p.getFullName());
                session.setAttribute("loginTime", System.currentTimeMillis());
                
                // Set session timeout (30 minutes)
                session.setMaxInactiveInterval(30 * 60);
                
                LOGGER.info("Session created successfully. Session ID: " + session.getId());
                LOGGER.info("Session attributes set - Role: " + roleFromDB + ", Email: " + p.getEmail());
                
                // Determine redirect URL based on role
                String redirectUrl;
                if ("ADMIN".equals(roleFromDB)) {
                    redirectUrl = req.getContextPath() + "/admin/dashboard";
                } else if ("USER".equals(roleFromDB)) {
                    redirectUrl = req.getContextPath() + "/user/home";
                } else {
                    redirectUrl = req.getContextPath() + "/dashboard";
                }
                
                LOGGER.info("Redirecting to: " + redirectUrl);
                LOGGER.info("=== LOGIN SUCCESSFUL ===");
                
                resp.sendRedirect(redirectUrl);
                
            } else {
                LOGGER.warning("Login failed: mismatched password for " + email
                    + " [stored=" + p.getPassword() + "], [input=" + passwordInput + "]");
                req.setAttribute("error", "Invalid email or password");
                req.getRequestDispatcher("/auth/login.jsp").forward(req, resp);
            }
            
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Unexpected error during login for email: " + email, ex);
            req.setAttribute("error", "Login failed due to system error. Please try again later.");
            req.getRequestDispatcher("/auth/login.jsp").forward(req, resp);
        }
    }
}
