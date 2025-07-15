package controller;

import dao.ParentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Logger;
import model.Parents;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());
    
    // Lazy initialization - no field initialization
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
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Email and password are required");
            req.getRequestDispatcher("/auth/login.jsp").forward(req, resp);
            return;
        }
        
        try {
            Parents parent = parentDao.findByEmail(email.trim());
            
            if (parent == null || !password.equals(parent.getPasswordHash())) {
                req.setAttribute("error", "Invalid email or password");
                req.getRequestDispatcher("/auth/login.jsp").forward(req, resp);
                return;
            }
            
            HttpSession session = req.getSession();
            session.setAttribute("parentId", parent.getParentId());
            session.setAttribute("parentEmail", parent.getEmail());
            
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            
        } catch (Exception ex) {
            LOGGER.severe("Error during login for email: " + email + " - " + ex.getMessage());
            req.setAttribute("error", "Login failed. Please try again later.");
            req.getRequestDispatcher("/auth/login.jsp").forward(req, resp);
        }
    }
}
