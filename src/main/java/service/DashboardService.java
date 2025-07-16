package service;

import dao.ParentDAO;
import dao.PostDAO;
import dao.ReportDAO;
import dao.ActivityLogDAO;
import model.ActivityLog;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

public class DashboardService {
    private static final Logger LOGGER = Logger.getLogger(DashboardService.class.getName());
    private ParentDAO parentDAO;
    private PostDAO postDAO;
    private ReportDAO reportDAO;
    private ActivityLogDAO activityLogDAO;
    
    public DashboardService() {
        this.parentDAO = new ParentDAO();
        this.postDAO = new PostDAO();
        this.reportDAO = new ReportDAO();
        this.activityLogDAO = new ActivityLogDAO();
    }
    
    public Map<String, Object> getDashboardStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        try {
            // Get user statistics
            int totalUsers = parentDAO.getTotalUsersCount();
            int newUsersThisMonth = parentDAO.getNewUsersCountThisMonth();
            double userGrowthRate = calculateGrowthRate(totalUsers, newUsersThisMonth);
            
            // Get post statistics
            int totalPosts = postDAO.getTotalPostsCount();
            int newPostsThisMonth = postDAO.getNewPostsCountThisMonth();
            double postGrowthRate = calculateGrowthRate(totalPosts, newPostsThisMonth);
            
            // Get pending approvals
            int pendingApprovals = postDAO.getPendingApprovalsCount();
            int pendingApprovalsLastWeek = postDAO.getPendingApprovalsCountLastWeek();
            double pendingApprovalsChange = calculateChangeRate(pendingApprovals, pendingApprovalsLastWeek);
            
            // Get active reports
            int activeReports = reportDAO.getActiveReportsCount();
            int newReportsToday = reportDAO.getNewReportsCountToday();
            
            // Store all statistics
            stats.put("totalUsers", totalUsers);
            stats.put("userGrowthRate", userGrowthRate);
            stats.put("totalPosts", totalPosts);
            stats.put("postGrowthRate", postGrowthRate);
            stats.put("pendingApprovals", pendingApprovals);
            stats.put("pendingApprovalsChange", pendingApprovalsChange);
            stats.put("activeReports", activeReports);
            stats.put("newReportsToday", newReportsToday);
            
            LOGGER.info("Dashboard statistics retrieved successfully");
            
        } catch (Exception e) {
            LOGGER.severe("Error retrieving dashboard statistics: " + e.getMessage());
            // Set default values in case of error
            stats.put("totalUsers", 0);
            stats.put("userGrowthRate", 0.0);
            stats.put("totalPosts", 0);
            stats.put("postGrowthRate", 0.0);
            stats.put("pendingApprovals", 0);
            stats.put("pendingApprovalsChange", 0.0);
            stats.put("activeReports", 0);
            stats.put("newReportsToday", 0);
        }
        
        return stats;
    }
    
    public int getPendingApprovalsCount() {
        try {
            return postDAO.getPendingApprovalsCount();
        } catch (Exception e) {
            LOGGER.severe("Error getting pending approvals count: " + e.getMessage());
            return 0;
        }
    }
    
    public int getActiveReportsCount() {
        try {
            return reportDAO.getActiveReportsCount();
        } catch (Exception e) {
            LOGGER.severe("Error getting active reports count: " + e.getMessage());
            return 0;
        }
    }
    
    public List<ActivityLog> getRecentActivities(int limit) {
        try {
            return activityLogDAO.getRecentActivities(limit);
        } catch (Exception e) {
            LOGGER.severe("Error getting recent activities: " + e.getMessage());
            return List.of();
        }
    }
    
    public void logActivity(String activityType, String description, String userEmail, String userName) {
        try {
            activityLogDAO.logActivity(activityType, description, userEmail, userName);
        } catch (Exception e) {
            LOGGER.severe("Error logging activity: " + e.getMessage());
        }
    }
    
    private double calculateGrowthRate(int total, int newItems) {
        if (total == 0) return 0.0;
        return ((double) newItems / total) * 100;
    }
    
    private double calculateChangeRate(int current, int previous) {
        if (previous == 0) return current > 0 ? 100.0 : 0.0;
        return ((double) (current - previous) / previous) * 100;
    }
    
    public Map<String, Object> getSystemHealth() {
        Map<String, Object> health = new HashMap<>();
        
        try {
            // Check database connectivity
            boolean dbConnected = parentDAO.checkConnection();
            health.put("databaseConnected", dbConnected);
            
            // Get system metrics
            Runtime runtime = Runtime.getRuntime();
            long totalMemory = runtime.totalMemory();
            long freeMemory = runtime.freeMemory();
            long usedMemory = totalMemory - freeMemory;
            
            health.put("memoryUsage", (double) usedMemory / totalMemory * 100);
            health.put("totalMemoryMB", totalMemory / (1024 * 1024));
            health.put("usedMemoryMB", usedMemory / (1024 * 1024));
            
            // Check recent activity
            List<ActivityLog> recentActivities = getRecentActivities(1);
            health.put("hasRecentActivity", !recentActivities.isEmpty());
            
        } catch (Exception e) {
            LOGGER.severe("Error checking system health: " + e.getMessage());
            health.put("databaseConnected", false);
            health.put("memoryUsage", 0.0);
            health.put("hasRecentActivity", false);
        }
        
        return health;
    }
}
