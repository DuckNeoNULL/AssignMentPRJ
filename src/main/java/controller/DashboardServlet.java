package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(DashboardServlet.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        
        if (session == null) {
            LOGGER.info("Dashboard access attempt without session - redirecting to login");
            resp.sendRedirect(req.getContextPath() + "/login?error=session_expired");
            return;
        }
        
        String userRole = (String) session.getAttribute("userRole");
        String userEmail = (String) session.getAttribute("parentEmail");
        
        LOGGER.info("Dashboard access by user: " + userEmail + " with role: " + userRole);
        
        if (userRole == null) {
            LOGGER.warning("Dashboard access with null role - invalidating session");
            session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/login?error=invalid_session");
            return;
        }
        
        // Redirect based on role
        switch (userRole) {
            case "ADMIN":
                LOGGER.info("Redirecting admin user to admin dashboard: " + userEmail);
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                break;
            case "USER":
                LOGGER.info("Redirecting regular user to user home: " + userEmail);
                resp.sendRedirect(req.getContextPath() + "/user/home");
                break;
            default:
                LOGGER.warning("Unknown role encountered: " + userRole + " for user: " + userEmail);
                session.invalidate();
                resp.sendRedirect(req.getContextPath() + "/login?error=invalid_role");
                break;
        }
    }
}
