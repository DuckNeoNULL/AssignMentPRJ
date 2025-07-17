package service;

import dao.DashboardDAO;
import dao.ParentDAO;
import model.*;
import java.sql.SQLException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AdminDashboardService {
    private static final Logger LOGGER = Logger.getLogger(AdminDashboardService.class.getName());
    private final DashboardDAO dashboardDAO;
    private final ParentDAO parentDAO;
    
    public AdminDashboardService() {
        this.dashboardDAO = new DashboardDAO();
        this.parentDAO = new ParentDAO();
    }
    
    public DashboardStats getDashboardStatistics() {
        try {
            return dashboardDAO.getDashboardStatistics();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Service error getting dashboard statistics", e);
            return new DashboardStats();
        }
    }
    
    public List<AdminActivity> getRecentActivities() {
        return getRecentActivities(5);
    }
    
    public List<AdminActivity> getRecentActivities(int limit) {
        try {
            List<AdminActivity> activities = dashboardDAO.getRecentActivities(limit);
            for (AdminActivity activity : activities) {
                setActivityDisplayProperties(activity);
            }
            return activities;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Service error getting recent activities", e);
            return Collections.emptyList();
        }
    }
    
    private void setActivityDisplayProperties(AdminActivity activity) {
        switch (activity.getActivityType().toUpperCase()) {
            case "ADMIN_LOGIN":
                activity.setIconClass("bi-box-arrow-in-right");
                activity.setIconColorClass("text-success");
                break;
            case "SECTION_ACCESS":
                activity.setIconClass("bi-eye");
                activity.setIconColorClass("text-info");
                break;
            case "EXPORT_DATA":
                activity.setIconClass("bi-download");
                activity.setIconColorClass("text-primary");
                break;
            default:
                activity.setIconClass("bi-info-circle");
                activity.setIconColorClass("text-secondary");
                break;
        }
        activity.setTimeAgo(calculateTimeAgo(activity.getTimestamp()));
    }

    private String calculateTimeAgo(LocalDateTime eventTime) {
        if (eventTime == null) {
            return "just now";
        }
        Duration duration = Duration.between(eventTime, LocalDateTime.now());
        long seconds = duration.getSeconds();

        if (seconds < 60) {
            return "just now";
        }
        long minutes = seconds / 60;
        if (minutes < 60) {
            return minutes + (minutes == 1 ? " minute" : " minutes") + " ago";
        }
        long hours = minutes / 60;
        if (hours < 24) {
            return hours + (hours == 1 ? " hour" : " hours") + " ago";
        }
        long days = hours / 24;
        return days + (days == 1 ? " day" : " days") + " ago";
    }

    public void logActivity(String activityType, String description, String adminEmail, 
                          String adminName, String ipAddress) {
        try {
            AdminActivity activity = new AdminActivity(activityType, description, adminEmail, adminName);
            activity.setIpAddress(ipAddress);
            dashboardDAO.logActivity(activity);
            LOGGER.info("Activity logged: " + description);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to log activity", e);
        }
    }
    
    public String generateCSVExport() {
        try {
            return convertToCSV(dashboardDAO.getDashboardDataForExport());
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to generate CSV export", e);
            return "";
        }
    }
    
    public List<Parents> getAllUsers() {
        try {
            return parentDAO.getAllParents();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Service error getting all users", e);
            return new ArrayList<>();
        }
    }

    /**
     * Get users overview data
     */
    public Map<String, Object> getUsersOverview() {
        try {
            Map<String, Object> overview = new HashMap<>();
            overview.put("totalUsers", dashboardDAO.getTotalUsers());
            overview.put("activeUsers", dashboardDAO.getActiveUsers());
            overview.put("newUsersToday", dashboardDAO.getNewUsersToday());
            overview.put("suspendedUsers", dashboardDAO.getSuspendedUsers());
            return overview;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Service error getting users overview", e);
            return new HashMap<>();
        }
    }

    /**
     * Get recent users
     */
    public List<Parents> getRecentUsers(int limit) {
        try {
            return dashboardDAO.getRecentUsers(limit);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Service error getting recent users", e);
            return new ArrayList<>();
        }
    }

    /**
     * Get posts overview data
     */
    public Map<String, Object> getPostsOverview() {
        try {
            Map<String, Object> overview = new HashMap<>();
            overview.put("totalPosts", dashboardDAO.getTotalPosts());
            overview.put("pendingPosts", dashboardDAO.getPendingPosts());
            overview.put("approvedPosts", dashboardDAO.getApprovedPosts());
            overview.put("rejectedPosts", dashboardDAO.getRejectedPosts());
            return overview;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Service error getting posts overview", e);
            return new HashMap<>();
        }
    }

    /**
     * Get pending posts
     */
    public List<Posts> getPendingPosts(int limit) {
        try {
            return dashboardDAO.getPendingPosts(limit);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Service error getting pending posts", e);
            return new ArrayList<>();
        }
    }

    /**
     * Get reports overview data
     */
    public Map<String, Object> getReportsOverview() {
        try {
            Map<String, Object> overview = new HashMap<>();
            overview.put("totalReports", dashboardDAO.getTotalReports());
            overview.put("activeReports", dashboardDAO.getActiveReportsCount());
            overview.put("resolvedReports", dashboardDAO.getResolvedReports());
            overview.put("newReportsToday", dashboardDAO.getNewReportsToday());
            return overview;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Service error getting reports overview", e);
            return new HashMap<>();
        }
    }

    /**
     * Get active reports
     */
    public List<ContentReports> getActiveReports(int limit) {
        try {
            return dashboardDAO.getActiveReports(limit);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Service error getting active reports", e);
            return new ArrayList<>();
        }
    }

    public Map<String, Object> getSystemSettings() {
        try {
            return dashboardDAO.getSystemSettings();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to get system settings", e);
            return Collections.emptyMap();
        }
    }

    public boolean isSystemHealthy() {
        try {
            return dashboardDAO.isDatabaseHealthy();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to check system health", e);
            return false;
        }
    }

    public void refreshDashboard(String adminEmail, String adminName, String ipAddress) {
        try {
            logActivity("DASHBOARD_REFRESH", "Dashboard data refreshed", adminEmail, adminName, ipAddress);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to refresh dashboard", e);
        }
    }
    
    private String convertToCSV(List<String[]> data) {
        if (data == null || data.isEmpty()) {
            return "";
        }
        
        StringBuilder csv = new StringBuilder();
        for (String[] row : data) {
            if (row == null) continue;
            
            for (int i = 0; i < row.length; i++) {
                if (i > 0) csv.append(",");
                String value = row[i] != null ? row[i] : "";
                if (value.contains(",") || value.contains("\"") || value.contains("\n")) {
                    value = "\"" + value.replace("\"", "\"\"") + "\"";
                }
                csv.append(value);
            }
            csv.append("\n");
        }
        return csv.toString();
    }
}

