package service;

import dao.AchievementDAO;
import dao.UserStatsDAO;
import model.Achievement;
import model.UserStats;

import java.util.List;

public class AchievementService {
    private AchievementDAO achievementDAO;
    private UserStatsDAO userStatsDAO;
    
    public AchievementService() {
        this.achievementDAO = new AchievementDAO();
        this.userStatsDAO = new UserStatsDAO();
    }
    
    public UserStats getUserStats(int childId) {
        UserStats stats = userStatsDAO.getUserStats(childId);
        if (stats == null) {
            // Create default stats if not exists
            stats = new UserStats(childId, 0, 0, 0, 0, 0, 0, 0, 0, 1);
            userStatsDAO.createUserStats(stats);
        }
        return stats;
    }
    
    public List<Achievement> getAchievements(int childId) {
        return achievementDAO.getAchievementsByChildId(childId);
    }
    
    public void checkAndAwardAchievements(int childId) {
        UserStats stats = getUserStats(childId);
        
        // Check Posts achievements
        if (stats.getPostsCount() >= 5 && !achievementDAO.hasAchievement(childId, "POSTS", "Nhà văn nhí")) {
            awardAchievement(childId, "POSTS", "Nhà văn nhí", "Viết được 5 bài viết", "✍️", 100);
        }
        if (stats.getPostsCount() >= 20 && !achievementDAO.hasAchievement(childId, "POSTS", "Nhà văn chuyên nghiệp")) {
            awardAchievement(childId, "POSTS", "Nhà văn chuyên nghiệp", "Viết được 20 bài viết", "✍️", 200);
        }
        
        // Check Drawings achievements
        if (stats.getDrawingsCount() >= 10 && !achievementDAO.hasAchievement(childId, "DRAWINGS", "Họa sĩ nhí")) {
            awardAchievement(childId, "DRAWINGS", "Họa sĩ nhí", "Vẽ được 10 bức tranh", "🎨", 150);
        }
        if (stats.getDrawingsCount() >= 30 && !achievementDAO.hasAchievement(childId, "DRAWINGS", "Họa sĩ tài năng")) {
            awardAchievement(childId, "DRAWINGS", "Họa sĩ tài năng", "Vẽ được 30 bức tranh", "🎨", 300);
        }
        
        // Check Friends achievements
        if (stats.getFriendsCount() >= 5 && !achievementDAO.hasAchievement(childId, "FRIENDS", "Bạn bè tốt")) {
            awardAchievement(childId, "FRIENDS", "Bạn bè tốt", "Kết bạn với 5 người", "🤝", 80);
        }
        if (stats.getFriendsCount() >= 15 && !achievementDAO.hasAchievement(childId, "FRIENDS", "Bạn bè thân thiện")) {
            awardAchievement(childId, "FRIENDS", "Bạn bè thân thiện", "Kết bạn với 15 người", "🤝", 200);
        }
        
        // Check Audio achievements
        if (stats.getAudioStoriesHeard() >= 20 && !achievementDAO.hasAchievement(childId, "AUDIO", "Mọt sách")) {
            awardAchievement(childId, "AUDIO", "Mọt sách", "Nghe 20 truyện audio", "📚", 120);
        }
        if (stats.getAudioStoriesHeard() >= 50 && !achievementDAO.hasAchievement(childId, "AUDIO", "Thính giả xuất sắc")) {
            awardAchievement(childId, "AUDIO", "Thính giả xuất sắc", "Nghe 50 truyện audio", "📚", 250);
        }
        
        // Check Video achievements
        if (stats.getVideosWatched() >= 15 && !achievementDAO.hasAchievement(childId, "VIDEOS", "Người xem chăm chỉ")) {
            awardAchievement(childId, "VIDEOS", "Người xem chăm chỉ", "Xem 15 video học tập", "🎬", 100);
        }
        if (stats.getVideosWatched() >= 40 && !achievementDAO.hasAchievement(childId, "VIDEOS", "Học sinh xuất sắc")) {
            awardAchievement(childId, "VIDEOS", "Học sinh xuất sắc", "Xem 40 video học tập", "🎬", 200);
        }
        
        // Check Chat achievements
        if (stats.getChatSessions() >= 10 && !achievementDAO.hasAchievement(childId, "CHAT", "Người trò chuyện")) {
            awardAchievement(childId, "CHAT", "Người trò chuyện", "Chat với Kiki 10 lần", "💬", 80);
        }
        if (stats.getChatSessions() >= 30 && !achievementDAO.hasAchievement(childId, "CHAT", "Bạn thân của Kiki")) {
            awardAchievement(childId, "CHAT", "Bạn thân của Kiki", "Chat với Kiki 30 lần", "💬", 150);
        }
    }
    
    private void awardAchievement(int childId, String badgeType, String badgeName, String description, String icon, int xp) {
        Achievement achievement = new Achievement(childId, badgeType, badgeName, description, icon);
        if (achievementDAO.addAchievement(achievement)) {
            userStatsDAO.addXp(childId, xp);
        }
    }
    
    public void incrementStat(int childId, String statType) {
        userStatsDAO.incrementStat(childId, statType);
        checkAndAwardAchievements(childId);
    }
    
    public void addXp(int childId, int xp) {
        userStatsDAO.addXp(childId, xp);
    }
    
    public List<UserStats> getTopUsers(int limit) {
        return userStatsDAO.getTopUsers(limit);
    }
    
    public List<Achievement> getRecentAchievements(int limit) {
        return achievementDAO.getRecentAchievements(limit);
    }
    
    public int getAchievementCount(int childId) {
        return achievementDAO.getAchievementCount(childId);
    }
    
    public List<Achievement> getSpecialAchievements(int childId) {
        return achievementDAO.getSpecialAchievements(childId);
    }
    
    public void awardSpecialAchievement(int childId, String badgeName, String description) {
        if (!achievementDAO.hasAchievement(childId, "SPECIAL", badgeName)) {
            Achievement achievement = new Achievement(childId, "SPECIAL", badgeName, description, "🥇", true);
            achievementDAO.addAchievement(achievement);
            userStatsDAO.addXp(childId, 500); // Special achievements give more XP
        }
    }
} 