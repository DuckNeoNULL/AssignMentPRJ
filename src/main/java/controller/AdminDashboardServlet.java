package controller;

import model.Parents;
import model.Posts;
import model.ContentReports;
import service.AdminDashboardService;
import model.DashboardStats;
import model.AdminActivity;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.util.Enumeration;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {
    "/admin/dashboard", 
    "/admin/users", 
    "/admin/reports", 
    "/admin/settings",
    "/admin/export"
})
public class AdminDashboardServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminDashboardServlet.class.getName());
    private AdminDashboardService adminService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        try {
            adminService = new AdminDashboardService();
            if (adminService == null) {
                throw new ServletException("Failed to create AdminDashboardService instance");
            }
            LOGGER.info("AdminDashboardServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize AdminDashboardServlet", e);
            throw new ServletException("AdminDashboardServlet initialization failed", e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Validate admin session
        if (!isValidAdminSession(request)) {
            LOGGER.warning("Unauthorized dashboard access attempt");
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }
        
        // Get section from servlet path
        String servletPath = request.getServletPath();
        String section = "dashboard";
        
        if (servletPath.contains("/admin/")) {
            String[] parts = servletPath.split("/");
            if (parts.length >= 3) {
                section = parts[2];
            }
        }
        
        try {
            HttpSession session = request.getSession();
            String adminEmail = (String) session.getAttribute("parentEmail");
            String adminName = (String) session.getAttribute("parentName");
            String ipAddress = getClientIpAddress(request);
            
            // Null safety for session attributes
            if (adminEmail == null) adminEmail = "unknown";
            if (adminName == null) adminName = "Unknown Admin";
            if (ipAddress == null) ipAddress = "unknown";
            
            // Log section access
            logActivitySafely("SECTION_ACCESS", "Admin accessed " + section + " section", 
                               adminEmail, adminName, ipAddress);
            
            // Route to appropriate section
            switch (section.toLowerCase()) {
                case "users":
                    handleUsersSection(request, response);
                    break;
                case "reports":
                    handleReportsSection(request, response);
                    break;
                case "settings":
                    handleSettingsSection(request, response);
                    break;
                case "export":
                    handleExportData(request, response);
                    break;
                case "dashboard":
                default:
                    handleDashboardSection(request, response);
                    break;
            }
            
        } catch (Exception e) {
            LOGGER.severe("Error handling admin dashboard request: " + e.getMessage());
            request.setAttribute("errorMessage", "An error occurred while loading the dashboard");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    private void handleUsersSection(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Get users overview data
            Map<String, Object> usersOverview = adminService.getUsersOverview();
            List<Parents> allUsers = adminService.getAllUsers();
            
            // Null safety checks
            if (usersOverview == null) {
                usersOverview = new HashMap<>();
            }
            if (allUsers == null) {
                allUsers = new ArrayList<>();
            }
            
            request.setAttribute("usersOverview", usersOverview);
            request.setAttribute("allUsers", allUsers);
            request.setAttribute("currentPage", "users");
            request.setAttribute("pageTitle", "User Management");
            
            request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error loading users section: " + e.getMessage());
            request.setAttribute("errorMessage", "Failed to load user management data");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        if ("updateSettings".equals(action)) {
            updateSettings(request, response);
            return;
        }

        if ("dismiss_report".equals(action) || "delete_post".equals(action) || "suspend_user".equals(action)) {
            handleReportAction(request, response);
            return;
        }
        
        String userAction = request.getParameter("userAction");
        if (userAction != null) {
            handleUserAction(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }

    private void updateSettings(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Enumeration<String> parameterNames = request.getParameterNames();
        boolean allSuccess = true;
        while (parameterNames.hasMoreElements()) {
            String key = parameterNames.nextElement();
            if (!key.equals("action")) {
                String value = request.getParameter(key);
                if (!adminService.updateSystemSetting(key, value)) {
                    allSuccess = false;
                }
            }
        }
        if (allSuccess) {
            response.sendRedirect(request.getContextPath() + "/admin/settings?status=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/settings?status=error");
        }
    }

    private void handleReportAction(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String action = request.getParameter("action");
            int reportId = Integer.parseInt(request.getParameter("reportId"));
            boolean success = false;

            switch (action) {
                case "dismiss_report":
                    success = adminService.dismissReport(reportId);
                    break;
                case "delete_post":
                    int postId = Integer.parseInt(request.getParameter("postId"));
                    success = adminService.deletePostAndDismissReport(postId, reportId);
                    break;
                case "suspend_user":
                    int userId = Integer.parseInt(request.getParameter("userId"));
                    success = adminService.suspendUserAndDismissReport(userId, reportId);
                    break;
            }

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/reports?status=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/reports?status=error");
            }

        } catch (NumberFormatException | NullPointerException e) {
            LOGGER.log(Level.WARNING, "Invalid parameters for report action.", e);
            response.sendRedirect(request.getContextPath() + "/admin/reports?status=error");
        }
    }

    private void handleUserAction(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String action = request.getParameter("userAction");

            boolean success = adminService.updateUserStatus(userId, action);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/users?status=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users?status=error");
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid user ID provided for user action.", e);
            response.sendRedirect(request.getContextPath() + "/admin/users?status=error");
        }
    }

    private void handleReportsSection(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Get reports overview data
            Map<String, Object> reportsOverview = adminService.getReportsOverview();
            List<ContentReports> activeReports = adminService.getActiveReports(10);
            
            // Null safety checks
            if (reportsOverview == null) {
                reportsOverview = new HashMap<>();
            }
            if (activeReports == null) {
                activeReports = new ArrayList<>();
            }
            
            request.setAttribute("reportsOverview", reportsOverview);
            request.setAttribute("activeReports", activeReports);
            request.setAttribute("currentPage", "reports");
            request.setAttribute("pageTitle", "Reports Management");
            
            request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error loading reports section: " + e.getMessage());
            request.setAttribute("errorMessage", "Failed to load reports management data");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    private void handleSettingsSection(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            Map<String, String> systemSettings = adminService.getSystemSettings();
            request.setAttribute("systemSettings", systemSettings);
            
            boolean systemHealth = adminService.isSystemHealthy();
            request.setAttribute("systemHealth", systemHealth);

            request.setAttribute("currentPage", "settings");
            request.setAttribute("pageTitle", "System Settings");
            
            request.getRequestDispatcher("/admin/settings.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error loading settings section: " + e.getMessage());
            request.setAttribute("errorMessage", "Failed to load system settings");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    private void handleDashboardSection(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Get dashboard statistics
            DashboardStats stats = adminService.getDashboardStatistics();
            List<AdminActivity> recentActivities = adminService.getRecentActivities(5);
            
            // Null safety checks
            if (stats == null) {
                stats = new DashboardStats();
            }
            if (recentActivities == null) {
                recentActivities = new ArrayList<>();
            }
            
            request.setAttribute("stats", stats);
            request.setAttribute("recentActivities", recentActivities);
            request.setAttribute("currentPage", "dashboard");
            request.setAttribute("pageTitle", "Admin Dashboard");
            
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error loading dashboard section: " + e.getMessage());
            request.setAttribute("errorMessage", "Failed to load dashboard data");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }

    private void handleExportData(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"dashboard_export.csv\"");
        
        try {
            String csvData = adminService.generateCSVExport();
            response.getWriter().write(csvData);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error generating CSV export", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error generating CSV export.");
        }
    }
    
    private boolean isValidAdminSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && "ADMIN".equals(session.getAttribute("userRole"));
    }
    
    private String getClientIpAddress(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }
        
        String xRealIp = request.getHeader("X-Real-IP");
        if (xRealIp != null && !xRealIp.isEmpty()) {
            return xRealIp;
        }
        
        return request.getRemoteAddr();
    }
    
    private void logActivitySafely(String type, String description, String email, String name, String ip) {
        if (adminService != null) {
            try {
                adminService.logActivity(type, description, email, name, ip);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Failed to log activity: " + description, e);
            }
        }
    }
}


