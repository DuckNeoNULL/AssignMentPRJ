package dao;

import model.ActivityLog;
import dao.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class ActivityLogDAO {
    private static final Logger LOGGER = Logger.getLogger(ActivityLogDAO.class.getName());
    
    public List<ActivityLog> getRecentActivities(int limit) {
        List<ActivityLog> activities = new ArrayList<>();
        String sql = "SELECT TOP (?) id, activity_type, description, user_email, user_name, timestamp " +
                     "FROM activity_log ORDER BY timestamp DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ActivityLog activity = new ActivityLog();
                activity.setId(rs.getInt("id"));
                activity.setActivityType(rs.getString("activity_type"));
                activity.setDescription(rs.getString("description"));
                activity.setUserEmail(rs.getString("user_email"));
                activity.setUserName(rs.getString("user_name"));
                activity.setTimestamp(rs.getTimestamp("timestamp"));
                
                activities.add(activity);
            }
            
        } catch (SQLException e) {
            LOGGER.severe("Error retrieving recent activities: " + e.getMessage());
        }
        
        return activities;
    }
    
    public void logActivity(String activityType, String description, String userEmail, String userName) {
        String sql = "INSERT INTO activity_log (activity_type, description, user_email, user_name, timestamp) " +
                     "VALUES (?, ?, ?, ?, GETDATE())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, activityType);
            stmt.setString(2, description);
            stmt.setString(3, userEmail);
            stmt.setString(4, userName);
            
            stmt.executeUpdate();
            
        } catch (SQLException e) {
            LOGGER.severe("Error logging activity: " + e.getMessage());
        }
    }
}

