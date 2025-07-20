package dao;

import model.Achievement;
import dao.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AchievementDAO {
    
    public List<Achievement> getAchievementsByChildId(int childId) {
        String sql = "SELECT * FROM Achievements WHERE child_id = ? ORDER BY earned_date DESC";
        List<Achievement> achievements = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, childId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                achievements.add(mapResultSetToAchievement(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return achievements;
    }
    
    public boolean addAchievement(Achievement achievement) {
        String sql = "INSERT INTO Achievements (child_id, badge_type, badge_name, description, icon, is_special) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, achievement.getChildId());
            stmt.setString(2, achievement.getBadgeType());
            stmt.setString(3, achievement.getBadgeName());
            stmt.setString(4, achievement.getDescription());
            stmt.setString(5, achievement.getIcon());
            stmt.setBoolean(6, achievement.isSpecial());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean hasAchievement(int childId, String badgeType, String badgeName) {
        String sql = "SELECT COUNT(*) FROM Achievements WHERE child_id = ? AND badge_type = ? AND badge_name = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, childId);
            stmt.setString(2, badgeType);
            stmt.setString(3, badgeName);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Achievement> getRecentAchievements(int limit) {
        String sql = "SELECT TOP (?) * FROM Achievements ORDER BY earned_date DESC";
        List<Achievement> achievements = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                achievements.add(mapResultSetToAchievement(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return achievements;
    }
    
    public int getAchievementCount(int childId) {
        String sql = "SELECT COUNT(*) FROM Achievements WHERE child_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, childId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public List<Achievement> getSpecialAchievements(int childId) {
        String sql = "SELECT * FROM Achievements WHERE child_id = ? AND is_special = 1 ORDER BY earned_date DESC";
        List<Achievement> achievements = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, childId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                achievements.add(mapResultSetToAchievement(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return achievements;
    }
    
    private Achievement mapResultSetToAchievement(ResultSet rs) throws SQLException {
        Achievement achievement = new Achievement();
        achievement.setAchievementId(rs.getInt("achievement_id"));
        achievement.setChildId(rs.getInt("child_id"));
        achievement.setBadgeType(rs.getString("badge_type"));
        achievement.setBadgeName(rs.getString("badge_name"));
        achievement.setDescription(rs.getString("description"));
        achievement.setIcon(rs.getString("icon"));
        achievement.setSpecial(rs.getBoolean("is_special"));
        
        Timestamp earnedDate = rs.getTimestamp("earned_date");
        if (earnedDate != null) {
            achievement.setEarnedDate(earnedDate.toLocalDateTime());
        }
        
        return achievement;
    }
} 