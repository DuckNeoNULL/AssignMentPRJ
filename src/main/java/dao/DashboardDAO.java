package dao;

import model.DashboardStats;
import model.AdminActivity;
import model.Parents;
import model.Posts;
import model.ContentReports;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.util.Map;
import java.util.HashMap;
import model.Children;

public class DashboardDAO {
    private static final Logger LOGGER = Logger.getLogger(DashboardDAO.class.getName());
    private static final String DATE_TIME_FORMAT = "yyyy-MM-dd HH:mm:ss";
    
    /**
     * Get comprehensive dashboard statistics including growth percentages
     */
    public DashboardStats getDashboardStatistics() throws SQLException {
        String sql = "SELECT total_users, total_posts, pending_posts, active_reports, "
                + "users_this_month, users_last_month, posts_this_month, posts_last_month, new_reports_today "
                + "FROM vw_dashboard_stats";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                DashboardStats stats = new DashboardStats();
                stats.setTotalUsers(rs.getInt("total_users"));
                stats.setTotalPosts(rs.getInt("total_posts"));
                stats.setPendingPosts(rs.getInt("pending_posts"));
                stats.setActiveReports(rs.getInt("active_reports"));
                stats.setNewReportsToday(rs.getInt("new_reports_today"));
                
                // Calculate growth percentages
                int usersThisMonth = rs.getInt("users_this_month");
                int usersLastMonth = rs.getInt("users_last_month");
                double userGrowth = calculateGrowthPercentage(usersThisMonth, usersLastMonth);
                stats.setUserGrowthPercentage(userGrowth);
                
                int postsThisMonth = rs.getInt("posts_this_month");
                int postsLastMonth = rs.getInt("posts_last_month");
                double postGrowth = calculateGrowthPercentage(postsThisMonth, postsLastMonth);
                stats.setPostGrowthPercentage(postGrowth);
                
                LOGGER.info("Dashboard statistics retrieved successfully");
                return stats;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving dashboard statistics", e);
            throw e;
        }
        
        return new DashboardStats(); // Return empty stats if no data
    }
    
    /**
     * Get recent admin activities
     */
    public List<AdminActivity> getRecentActivities(int limit) throws SQLException {
        if (limit <= 0) {
            throw new IllegalArgumentException("Limit must be greater than 0");
        }
        
        String sql = "SELECT id, activity_type, description, admin_email, admin_name, "
                + "timestamp, ip_address, metadata "
                + "FROM activity_log "
                + "ORDER BY timestamp DESC "
                + "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        
        List<AdminActivity> activities = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    AdminActivity activity = mapResultSetToActivity(rs);
                    activities.add(activity);
                }
            }
            
            LOGGER.info("Retrieved " + activities.size() + " recent activities");
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving recent activities", e);
            throw e;
        }
        
        return activities;
    }
    
    private AdminActivity mapResultSetToActivity(ResultSet rs) throws SQLException {
        AdminActivity activity = new AdminActivity();
        activity.setId(rs.getInt("id"));
        activity.setActivityType(rs.getString("activity_type"));
        activity.setDescription(rs.getString("description"));
        activity.setAdminEmail(rs.getString("admin_email"));
        activity.setAdminName(rs.getString("admin_name"));
        
        Timestamp timestamp = rs.getTimestamp("timestamp");
        if (timestamp != null) {
            activity.setTimestamp(timestamp.toLocalDateTime());
        }
        
        activity.setIpAddress(rs.getString("ip_address"));
        activity.setMetadata(rs.getString("metadata"));
        
        return activity;
    }
    
    /**
     * Log admin activity
     */
    public boolean logActivity(AdminActivity activity) throws SQLException {
        if (activity == null) {
            throw new IllegalArgumentException("Activity cannot be null");
        }
        
        String sql = "INSERT INTO activity_log (activity_type, description, admin_email, admin_name, "
                + "timestamp, ip_address, metadata) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, activity.getActivityType());
            stmt.setString(2, activity.getDescription());
            stmt.setString(3, activity.getAdminEmail());
            stmt.setString(4, activity.getAdminName());
            stmt.setTimestamp(5, Timestamp.valueOf(activity.getTimestamp()));
            stmt.setString(6, activity.getIpAddress());
            stmt.setString(7, activity.getMetadata());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                LOGGER.info("Activity logged successfully: " + activity.getDescription());
                return true;
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error logging activity: " + e.getMessage(), e);
            throw e;
        }
        
        return false;
    }
    
    /**
     * Get dashboard data for CSV export
     */
    public List<String[]> getDashboardDataForExport() throws SQLException {
        List<String[]> data = new ArrayList<>();
        
        // Add headers
        data.add(new String[]{"Metric", "Value", "Export Date"});
        
        try {
            DashboardStats stats = getDashboardStatistics();
            String exportDate = LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern(DATE_TIME_FORMAT));
            
            // Add statistics data
            addStatisticsToExport(data, stats, exportDate);
            
            // Add recent activities section
            addActivitiesToExport(data);
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error generating dashboard export", e);
            throw e;
        }
        
        return data;
    }
    
    private void addStatisticsToExport(List<String[]> data, DashboardStats stats, String exportDate) {
        data.add(new String[]{"Total Users", String.valueOf(stats.getTotalUsers()), exportDate});
        data.add(new String[]{"Total Posts", String.valueOf(stats.getTotalPosts()), exportDate});
        data.add(new String[]{"Pending Posts", String.valueOf(stats.getPendingPosts()), exportDate});
        data.add(new String[]{"Active Reports", String.valueOf(stats.getActiveReports()), exportDate});
        data.add(new String[]{"User Growth %", String.format("%.2f", stats.getUserGrowthPercentage()), exportDate});
        data.add(new String[]{"Post Growth %", String.format("%.2f", stats.getPostGrowthPercentage()), exportDate});
    }
    
    private void addActivitiesToExport(List<String[]> data) throws SQLException {
        data.add(new String[]{"", "", ""});
        data.add(new String[]{"Recent Activities", "", ""});
        data.add(new String[]{"Activity Type", "Description", "Timestamp"});
        
        List<AdminActivity> activities = getRecentActivities(10);
        for (AdminActivity activity : activities) {
            data.add(new String[]{
                activity.getActivityType(),
                activity.getDescription(),
                activity.getFormattedTimestamp()
            });
        }
    }
    
    /**
     * Calculate growth percentage between two values
     */
    private double calculateGrowthPercentage(int current, int previous) {
        if (previous == 0) {
            return current > 0 ? 100.0 : 0.0;
        }
        return ((double) (current - previous) / previous) * 100.0;
    }

    /**
     * Get total users count
     */
    public int getTotalUsers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Parents WHERE status != 'DELETED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Get active users count
     */
    public int getActiveUsers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Parents WHERE status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Get new users today count
     */
    public int getNewUsersToday() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Parents WHERE CAST(created_at AS DATE) = CAST(GETDATE() AS DATE) AND status != 'DELETED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Get suspended users count
     */
    public int getSuspendedUsers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Parents WHERE status = 'SUSPENDED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Get recent users
     */
    public List<Parents> getRecentUsers(int limit) throws SQLException {
        String sql = "SELECT TOP (?) parent_id, email, full_name, status, created_at FROM Parents WHERE status != 'DELETED' ORDER BY created_at DESC";
        List<Parents> users = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Parents parent = new Parents();
                    parent.setParentId(rs.getInt("parent_id"));
                    parent.setEmail(rs.getString("email"));
                    parent.setFullName(rs.getString("full_name"));
                    parent.setStatus(rs.getString("status"));
                    // parent.setCreatedAt(rs.getTimestamp("created_at")); // This line is for a different model
                    users.add(parent);
                }
            }
        }
        
        return users;
    }

    /**
     * Get total posts count
     */
    public int getTotalPosts() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Posts";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Get pending posts count
     */
    public int getPendingPosts() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Posts WHERE status = 'PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Get approved posts count
     */
    public int getApprovedPosts() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Posts WHERE status = 'APPROVED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Get rejected posts count
     */
    public int getRejectedPosts() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Posts WHERE status = 'REJECTED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Get pending posts list
     */
    public List<Posts> getPendingPosts(int limit) throws SQLException {
        String sql = "SELECT post_id, title, content, status, created_at FROM Posts WHERE status = 'PENDING' ORDER BY created_at DESC "
                   + "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        List<Posts> posts = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Posts post = new Posts();
                    post.setPostId(rs.getInt("post_id"));
                    post.setTitle(rs.getString("title"));
                    post.setContent(rs.getString("content"));
                    post.setStatus(rs.getString("status"));
                    post.setPostTime(rs.getTimestamp("created_at").toLocalDateTime());
                    posts.add(post);
                }
            }
        }
        
        return posts;
    }

    public List<Posts> getAllPostsByStatus(String status) throws SQLException {
        List<Posts> posts = new ArrayList<>();
        String sql = "SELECT p.*, c.full_name as child_name "
                   + "FROM Posts p JOIN Children c ON p.child_id = c.child_id "
                   + "WHERE p.status = ? ORDER BY p.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Posts post = new Posts();
                    post.setPostId(rs.getInt("post_id"));
                    post.setTitle(rs.getString("title"));
                    post.setContent(rs.getString("content"));
                    post.setStatus(rs.getString("status"));
                    post.setPostTime(rs.getTimestamp("created_at").toLocalDateTime());

                    Children child = new Children();
                    child.setChildId(rs.getInt("child_id"));
                    child.setFullName(rs.getString("child_name"));
                    post.setChild(child);
                    
                    posts.add(post);
                }
            }
        }
        return posts;
    }

    public boolean updatePostStatus(int postId, String status, int adminId) throws SQLException {
        String sql = "UPDATE Posts SET status = ?, reviewed_by = ?, reviewed_at = GETDATE() WHERE post_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, adminId);
            ps.setInt(3, postId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateReportStatus(int reportId, String status) throws SQLException {
        String sql = "UPDATE ContentReports SET status = ? WHERE report_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, reportId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deletePost(int postId) throws SQLException {
        // We should probably mark as deleted instead of actually deleting
        String sql = "DELETE FROM Posts WHERE post_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, postId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Get total reports count
     */
    public int getTotalReports() throws SQLException {
        String sql = "SELECT COUNT(*) FROM ContentReports";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Get active reports count
     */
    public int getActiveReportsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM ContentReports WHERE status IN ('PENDING', 'REVIEWED')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Get resolved reports count
     */
    public int getResolvedReports() throws SQLException {
        String sql = "SELECT COUNT(*) FROM ContentReports WHERE status = 'RESOLVED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Get new reports today count
     */
    public int getNewReportsToday() throws SQLException {
        String sql = "SELECT COUNT(*) FROM ContentReports WHERE CAST(created_at AS DATE) = CAST(GETDATE() AS DATE)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Get active reports list
     */
    public List<ContentReports> getActiveReports(int limit) throws SQLException {
        List<ContentReports> reports = new ArrayList<>();
        String sql = "SELECT TOP (?) cr.report_id, cr.reason, cr.status, cr.created_at, " +
                     "p.post_id, p.title AS post_title, " +
                     "c.child_id, c.full_name AS child_name, c.parent_id AS author_parent_id, " +
                     "reporter.parent_id AS reporter_parent_id, reporter.full_name AS reporter_name " +
                     "FROM ContentReports cr " +
                     "LEFT JOIN Posts p ON cr.post_id = p.post_id " +
                     "LEFT JOIN Children c ON p.child_id = c.child_id " +
                     "LEFT JOIN Parents reporter ON cr.reporter_id = reporter.parent_id " +
                     "WHERE cr.status IN ('PENDING', 'REVIEWED') " +
                     "ORDER BY cr.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ContentReports report = new ContentReports();
                    report.setReportId(rs.getInt("report_id"));
                    report.setReason(rs.getString("reason"));
                    report.setStatus(rs.getString("status"));
                    report.setCreatedAt(rs.getTimestamp("created_at"));

                    // Null-safe mapping for Post
                    Integer postId = (Integer) rs.getObject("post_id");
                    if (postId != null) {
                        Posts post = new Posts();
                        post.setPostId(postId);
                        post.setTitle(rs.getString("post_title"));
                        report.setPost(post);

                        // Null-safe mapping for Child
                        Integer childId = (Integer) rs.getObject("child_id");
                        if (childId != null) {
                            Children child = new Children();
                            child.setChildId(childId);
                            child.setFullName(rs.getString("child_name"));
                            post.setChild(child);

                            // Null-safe mapping for Author Parent
                            Integer authorParentId = (Integer) rs.getObject("author_parent_id");
                            if (authorParentId != null) {
                                Parents authorParent = new Parents();
                                authorParent.setParentId(authorParentId);
                                child.setParent(authorParent);
                            }
                        }
                    }

                    // Null-safe mapping for Reporter
                    Integer reporterId = (Integer) rs.getObject("reporter_parent_id");
                    if (reporterId != null) {
                        Parents reporter = new Parents();
                        reporter.setParentId(reporterId);
                        reporter.setFullName(rs.getString("reporter_name"));
                        report.setReporter(reporter);
                    }
                    
                    reports.add(report);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "DAO error getting active reports", e);
            throw e;
        }
        return reports;
    }

    public void createPost(Posts post) throws SQLException {
        String sql = "INSERT INTO Posts (child_id, title, content, image_url, status, created_at) VALUES (?, ?, ?, ?, ?, GETDATE())";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, post.getChild().getChildId());
            ps.setString(2, post.getTitle());
            ps.setString(3, post.getContent());
            ps.setString(4, post.getImagePath());
            ps.setString(5, post.getStatus());
            
            ps.executeUpdate();
        }
    }

    /**
     * Check database health
     */
    public boolean isDatabaseHealthy() throws SQLException {
        try (Connection conn = DBConnection.getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database health check failed: " + e.getMessage(), e);
            throw e;
        }
    }

    /**
     * Get system settings
     */
    public Map<String, Object> getSystemSettings() throws SQLException {
        Map<String, Object> settings = new HashMap<>();
        
        // Add basic system information
        settings.put("databaseStatus", isDatabaseHealthy() ? "Connected" : "Disconnected");
        settings.put("totalUsers", getTotalUsers());
        settings.put("totalPosts", getTotalPosts());
        settings.put("totalReports", getTotalReports());
        settings.put("lastUpdated", new java.util.Date());
        
        return settings;
    }

    public Map<String, String> getAllSettings() throws SQLException {
        Map<String, String> settings = new HashMap<>();
        String sql = "SELECT setting_key, setting_value FROM Settings";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                settings.put(rs.getString("setting_key"), rs.getString("setting_value"));
            }
        }
        return settings;
    }

    public boolean updateSetting(String key, String value) throws SQLException {
        String sql = "UPDATE Settings SET setting_value = ? WHERE setting_key = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, value);
            stmt.setString(2, key);
            return stmt.executeUpdate() > 0;
        }
    }
}

