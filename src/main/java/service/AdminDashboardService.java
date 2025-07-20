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
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching all users", e);
            return new ArrayList<>();
        }
    }

    public boolean updateUserStatus(int userId, String action) {
        try {
            String status = "SUSPENDED";
            if ("activate".equals(action)) {
                status = "ACTIVE";
            }
            return parentDAO.updateUserStatus(userId, status);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating user status", e);
            return false;
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

    public boolean suspendUser(int userId) {
        try {
            return parentDAO.updateUserStatus(userId, "SUSPENDED");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Service error suspending user", e);
            return false;
        }
    }

    public boolean activateUser(int userId) {
        try {
            return parentDAO.updateUserStatus(userId, "ACTIVE");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Service error activating user", e);
            return false;
        }
    }

    public List<Posts> getPendingApprovalPosts() {
        try {
            return dashboardDAO.getAllPostsByStatus("PENDING");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Service error getting pending posts", e);
            return new ArrayList<>();
        }
    }

    public boolean approvePost(int postId, int adminId) {
        try {
            return dashboardDAO.updatePostStatus(postId, "APPROVED", adminId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Service error approving post", e);
            return false;
        }
    }

    public boolean rejectPost(int postId, int adminId) {
        try {
            return dashboardDAO.updatePostStatus(postId, "REJECTED", adminId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Service error rejecting post", e);
            return false;
        }
    }

    public boolean dismissReport(int reportId) {
        try {
            return dashboardDAO.updateReportStatus(reportId, "DISMISSED");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Service error dismissing report", e);
            return false;
        }
    }

    public boolean deletePostAndDismissReport(int postId, int reportId) {
        try {
            // This should be a transaction
            boolean postDeleted = dashboardDAO.deletePost(postId);
            boolean reportDismissed = dashboardDAO.updateReportStatus(reportId, "RESOLVED_DELETED");
            return postDeleted && reportDismissed;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Service error deleting post and dismissing report", e);
            return false;
        }
    }

    public boolean suspendUserAndDismissReport(int userId, int reportId) {
        try {
            // This should be a transaction
            boolean userSuspended = parentDAO.updateUserStatus(userId, "SUSPENDED");
            boolean reportDismissed = dashboardDAO.updateReportStatus(reportId, "RESOLVED_SUSPENDED");
            return userSuspended && reportDismissed;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Service error suspending user and dismissing report", e);
            return false;
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

    public Map<String, String> getSystemSettings() {
        try {
            return dashboardDAO.getAllSettings();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Service error getting system settings", e);
            return new HashMap<>();
        }
    }

    public boolean updateSystemSetting(String key, String value) {
        try {
            return dashboardDAO.updateSetting(key, value);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Service error updating system setting", e);
            return false;
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

