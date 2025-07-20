package dao;

import model.UserStats;
import dao.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserStatsDAO {
    
    public UserStats getUserStats(int childId) {
        String sql = "SELECT * FROM UserStats WHERE child_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, childId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUserStats(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean createUserStats(UserStats userStats) {
        String sql = "INSERT INTO UserStats (child_id, posts_count, drawings_count, stories_count, " +
                    "friends_count, audio_stories_heard, videos_watched, chat_sessions, total_xp, current_level) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userStats.getChildId());
            stmt.setInt(2, userStats.getPostsCount());
            stmt.setInt(3, userStats.getDrawingsCount());
            stmt.setInt(4, userStats.getStoriesCount());
            stmt.setInt(5, userStats.getFriendsCount());
            stmt.setInt(6, userStats.getAudioStoriesHeard());
            stmt.setInt(7, userStats.getVideosWatched());
            stmt.setInt(8, userStats.getChatSessions());
            stmt.setInt(9, userStats.getTotalXp());
            stmt.setInt(10, userStats.getCurrentLevel());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateUserStats(UserStats userStats) {
        String sql = "UPDATE UserStats SET posts_count = ?, drawings_count = ?, stories_count = ?, " +
                    "friends_count = ?, audio_stories_heard = ?, videos_watched = ?, chat_sessions = ?, " +
                    "total_xp = ?, current_level = ?, last_updated = GETDATE() WHERE child_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userStats.getPostsCount());
            stmt.setInt(2, userStats.getDrawingsCount());
            stmt.setInt(3, userStats.getStoriesCount());
            stmt.setInt(4, userStats.getFriendsCount());
            stmt.setInt(5, userStats.getAudioStoriesHeard());
            stmt.setInt(6, userStats.getVideosWatched());
            stmt.setInt(7, userStats.getChatSessions());
            stmt.setInt(8, userStats.getTotalXp());
            stmt.setInt(9, userStats.getCurrentLevel());
            stmt.setInt(10, userStats.getChildId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean incrementStat(int childId, String statType) {
        String sql = "UPDATE UserStats SET " + statType + " = " + statType + " + 1, " +
                    "last_updated = GETDATE() WHERE child_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, childId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean addXp(int childId, int xp) {
        String sql = "UPDATE UserStats SET total_xp = total_xp + ?, " +
                    "current_level = (total_xp + ?) / 1000 + 1, " +
                    "last_updated = GETDATE() WHERE child_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, xp);
            stmt.setInt(2, xp);
            stmt.setInt(3, childId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<UserStats> getTopUsers(int limit) {
        String sql = "SELECT TOP (?) * FROM UserStats ORDER BY total_xp DESC";
        List<UserStats> topUsers = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                topUsers.add(mapResultSetToUserStats(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return topUsers;
    }
    
    private UserStats mapResultSetToUserStats(ResultSet rs) throws SQLException {
        UserStats userStats = new UserStats();
        userStats.setChildId(rs.getInt("child_id"));
        userStats.setPostsCount(rs.getInt("posts_count"));
        userStats.setDrawingsCount(rs.getInt("drawings_count"));
        userStats.setStoriesCount(rs.getInt("stories_count"));
        userStats.setFriendsCount(rs.getInt("friends_count"));
        userStats.setAudioStoriesHeard(rs.getInt("audio_stories_heard"));
        userStats.setVideosWatched(rs.getInt("videos_watched"));
        userStats.setChatSessions(rs.getInt("chat_sessions"));
        userStats.setTotalXp(rs.getInt("total_xp"));
        userStats.setCurrentLevel(rs.getInt("current_level"));
        
        Timestamp lastUpdated = rs.getTimestamp("last_updated");
        if (lastUpdated != null) {
            userStats.setLastUpdated(lastUpdated.toLocalDateTime());
        }
        
        return userStats;
    }
} 