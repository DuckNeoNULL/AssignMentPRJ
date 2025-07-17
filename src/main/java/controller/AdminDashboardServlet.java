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

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {
    "/admin/dashboard", 
    "/admin/users", 
    "/admin/posts", 
    "/admin/reports", 
    "/admin/settings",
    "/admin/export"
})
public class AdminDashboardServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminDashboardServlet.class.getName());
    private AdminDashboardService dashboardService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        try {
            dashboardService = new AdminDashboardService();
            if (dashboardService == null) {
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
                case "posts":
                    handlePostsSection(request, response);
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
            Map<String, Object> usersOverview = dashboardService.getUsersOverview();
            List<Parents> allUsers = dashboardService.getAllUsers();
            
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
    
    private void handlePostsSection(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            Map<String, Object> postsOverview = dashboardService.getPostsOverview();
            List<Posts> pendingPosts = dashboardService.getPendingPosts(10);
            
            // Null safety checks
            if (postsOverview == null) {
                postsOverview = new HashMap<>();
            }
            if (pendingPosts == null) {
                pendingPosts = new ArrayList<>();
            }
            
            request.setAttribute("postsOverview", postsOverview);
            request.setAttribute("pendingPosts", pendingPosts);
            request.setAttribute("currentPage", "posts");
            request.setAttribute("pageTitle", "Content Management");
            
            request.getRequestDispatcher("/admin/posts.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Error loading posts section: " + e.getMessage());
            request.setAttribute("errorMessage", "Failed to load content management data");
            request.getRequestDispatcher("/admin/error.jsp").forward(request, response);
        }
    }
    
    private void handleReportsSection(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Get reports overview data
            Map<String, Object> reportsOverview = dashboardService.getReportsOverview();
            List<ContentReports> activeReports = dashboardService.getActiveReports(10);
            
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
            Map<String, Object> systemSettings = dashboardService.getSystemSettings();
            boolean systemHealth = dashboardService.isSystemHealthy();
            
            // Null safety checks
            if (systemSettings == null) {
                systemSettings = new HashMap<>();
            }
            
            request.setAttribute("systemSettings", systemSettings);
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
            DashboardStats stats = dashboardService.getDashboardStatistics();
            List<AdminActivity> recentActivities = dashboardService.getRecentActivities(5);
            
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
            String csvData = dashboardService.generateCSVExport();
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
        if (dashboardService != null) {
            try {
                dashboardService.logActivity(type, description, email, name, ip);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Failed to log activity: " + description, e);
            }
        }
    }
}


