package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/user/home")
public class UserHomeServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(UserHomeServlet.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        
        if (session == null) {
            LOGGER.warning("User home access without session");
            resp.sendRedirect(req.getContextPath() + "/login?error=session_expired");
            return;
        }
        
        String userRole = (String) session.getAttribute("userRole");
        String userEmail = (String) session.getAttribute("parentEmail");
        
        LOGGER.info("User home access by: " + userEmail + " with role: " + userRole);
        
        if (userRole == null || (!userRole.equals("USER") && !userRole.equals("ADMIN"))) {
            LOGGER.warning("Invalid role trying to access user home: " + userEmail + " with role: " + userRole);
            resp.sendRedirect(req.getContextPath() + "/login?error=invalid_role");
            return;
        }
        
        req.getRequestDispatcher("/user/home.jsp").forward(req, resp);
    }
}