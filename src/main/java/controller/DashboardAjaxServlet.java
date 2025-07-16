package controller;

import com.google.gson.Gson;
import service.DashboardService;
import model.ActivityLog;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

@WebServlet("/admin/dashboard/ajax")
public class DashboardAjaxServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(DashboardAjaxServlet.class.getName());
    private DashboardService dashboardService;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        dashboardService = new DashboardService();
        gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        String action = req.getParameter("action");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = resp.getWriter()) {
            switch (action) {
                case "stats":
                    handleStatsRequest(out);
                    break;
                case "activities":
                    handleActivitiesRequest(req, out);
                    break;
                case "health":
                    handleHealthRequest(out);
                    break;
                case "refresh":
                    handleRefreshRequest(out);
                    break;
                default:
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.write("{\"error\":\"Invalid action\"}");
            }
        } catch (Exception e) {
            LOGGER.severe("Error handling AJAX request: " + e.getMessage());
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void handleStatsRequest(PrintWriter out) {
        Map<String, Object> stats = dashboardService.getDashboardStatistics();
        out.write(gson.toJson(stats));
    }
    
    private void handleActivitiesRequest(HttpServletRequest req, PrintWriter out) {
        int limit = 5;
        try {
            String limitParam = req.getParameter("limit");
            if (limitParam != null) {
                limit = Integer.parseInt(limitParam);
            }
        } catch (NumberFormatException e) {
            limit = 5;
        }
        
        List<ActivityLog> activities = dashboardService.getRecentActivities(limit);
        out.write(gson.toJson(activities));
    }
    
    private void handleHealthRequest(PrintWriter out) {
        Map<String, Object> health = dashboardService.getSystemHealth();
        out.write(gson.toJson(health));
    }
    
    private void handleRefreshRequest(PrintWriter out) {
        Map<String, Object> response = new HashMap<>();
        
        // Get fresh statistics
        Map<String, Object> stats = dashboardService.getDashboardStatistics();
        List<ActivityLog> activities = dashboardService.getRecentActivities(5);
        Map<String, Object> health = dashboardService.getSystemHealth();
        
        response.put("stats", stats);
        response.put("activities", activities);
        response.put("health", health);
        response.put("timestamp", System.currentTimeMillis());
        
        out.write(gson.toJson(response));
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        String action = req.getParameter("action");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = resp.getWriter()) {
            if ("log_activity".equals(action)) {
                handleLogActivity(req, out);
            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"error\":\"Invalid action\"}");
            }
        } catch (Exception e) {
            LOGGER.severe("Error handling POST request: " + e.getMessage());
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void handleLogActivity(HttpServletRequest req, PrintWriter out) {
        String activityType = req.getParameter("type");
        String description = req.getParameter("description");
        String userEmail = (String) req.getSession().getAttribute("parentEmail");
        String userName = req.getParameter("userName");
        
        if (activityType != null && description != null) {
            dashboardService.logActivity(activityType, description, userEmail, userName);
            out.write("{\"success\":true}");
        } else {
            out.write("{\"error\":\"Missing required parameters\"}");
        }
    }
}
