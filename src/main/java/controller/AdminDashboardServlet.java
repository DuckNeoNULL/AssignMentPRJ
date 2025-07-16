package controller;

import dao.ActivityLogDAO;
import dao.ParentDAO;
import dao.PostDAO;
import dao.ReportDAO;
import model.ActivityLog;
import service.DashboardService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminDashboardServlet.class.getName());
    private DashboardService dashboardService;
    private ActivityLogDAO activityLogDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        dashboardService = new DashboardService();
        activityLogDAO = new ActivityLogDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        
        if (session == null) {
            LOGGER.warning("Admin dashboard access without session");
            resp.sendRedirect(req.getContextPath() + "/login?error=session_expired");
            return;
        }
        
        String userRole = (String) session.getAttribute("userRole");
        String userEmail = (String) session.getAttribute("parentEmail");
        
        LOGGER.info("Admin dashboard access by: " + userEmail + " with role: " + userRole);
        
        if (!"ADMIN".equals(userRole)) {
            LOGGER.warning("Non-admin user trying to access admin dashboard: " + userEmail);
            resp.sendRedirect(req.getContextPath() + "/login?error=access_denied");
            return;
        }
        
        try {
            // Get dashboard statistics
            Map<String, Object> dashboardStats = dashboardService.getDashboardStatistics();
            req.setAttribute("stats", dashboardStats);
            
            // Get recent activities
            List<ActivityLog> recentActivities = activityLogDAO.getRecentActivities(5);
            req.setAttribute("recentActivities", recentActivities);
            
            // Get pending items counts for notification badges
            int pendingApprovals = dashboardService.getPendingApprovalsCount();
            int activeReports = dashboardService.getActiveReportsCount();
            
            req.setAttribute("pendingApprovals", pendingApprovals);
            req.setAttribute("activeReports", activeReports);
            
            // Forward to dashboard JSP
            req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
        } catch (Exception e) {
            LOGGER.severe("Error loading dashboard data: " + e.getMessage());
            req.setAttribute("errorMessage", "Failed to load dashboard data. Please try again later.");
            req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
        }
    }
}
