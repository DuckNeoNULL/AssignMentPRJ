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

@WebServlet("/register")
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
        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        
        if (email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty() || 
            fullName == null || fullName.trim().isEmpty()) {
            req.setAttribute("error", "Email, password, and full name are required");
            req.getRequestDispatcher("/auth/register.jsp").forward(req, resp);
            return;
        }
        
        try {
            if (parentDao.emailExists(email.trim())) {
                req.setAttribute("error", "Email already registered");
                req.getRequestDispatcher("/auth/register.jsp").forward(req, resp);
                return;
            }
            
            Parents parent = new Parents();
            parent.setEmail(email.trim());
            parent.setPasswordHash(password);
            parent.setFullName(fullName.trim());
            parent.setPhone(phone != null ? phone.trim() : null);
            
            boolean created = parentDao.create(parent);
            if (created) {
                resp.sendRedirect(req.getContextPath() + "/login?registered=true");
            } else {
                req.setAttribute("error", "Registration failed. Please try again.");
                req.getRequestDispatcher("/auth/register.jsp").forward(req, resp);
            }
            
        } catch (Exception ex) {
            LOGGER.severe("Error during registration for email: " + email + " - " + ex.getMessage());
            req.setAttribute("error", "Registration failed. Please try again later.");
            req.getRequestDispatcher("/auth/register.jsp").forward(req, resp);
        }
    }
}
