package util;

import model.Children;
import service.AchievementService;
import dao.ChildrenDAO;

import jakarta.servlet.http.HttpSession;

public class AchievementHelper {
    private static AchievementService achievementService = new AchievementService();
    
    /**
     * Helper method to get child from session
     */
    private static Children getChildFromSession(HttpSession session) {
        // Kiểm tra parent session trước
        if (session == null || session.getAttribute("parentId") == null) {
            return null;
        }
        
        Children child = (Children) session.getAttribute("currentChild");
        if (child == null) {
            // Thử lấy childId từ session và tìm child object
            Integer childId = (Integer) session.getAttribute("childId");
            if (childId != null) {
                ChildrenDAO childrenDAO = new ChildrenDAO();
                child = childrenDAO.findChildById(childId);
                if (child != null) {
                    session.setAttribute("currentChild", child);
                }
            }
        }
        return child;
    }
    
    /**
     * Increment post count and check for achievements
     */
    public static void incrementPostCount(HttpSession session) {
        Children child = getChildFromSession(session);
        if (child != null) {
            achievementService.incrementStat(child.getChildId(), "posts_count");
        }
    }
    
    /**
     * Increment drawing count and check for achievements
     */
    public static void incrementDrawingCount(HttpSession session) {
        Children child = getChildFromSession(session);
        if (child != null) {
            achievementService.incrementStat(child.getChildId(), "drawings_count");
        }
    }
    
    /**
     * Increment story count and check for achievements
     */
    public static void incrementStoryCount(HttpSession session) {
        Children child = getChildFromSession(session);
        if (child != null) {
            achievementService.incrementStat(child.getChildId(), "stories_count");
        }
    }
    
    /**
     * Increment friend count and check for achievements
     */
    public static void incrementFriendCount(HttpSession session) {
        Children child = getChildFromSession(session);
        if (child != null) {
            achievementService.incrementStat(child.getChildId(), "friends_count");
        }
    }
    
    /**
     * Increment audio story count and check for achievements
     */
    public static void incrementAudioStoryCount(HttpSession session) {
        Children child = getChildFromSession(session);
        if (child != null) {
            achievementService.incrementStat(child.getChildId(), "audio_stories_heard");
        }
    }
    
    /**
     * Increment video count and check for achievements
     */
    public static void incrementVideoCount(HttpSession session) {
        Children child = getChildFromSession(session);
        if (child != null) {
            achievementService.incrementStat(child.getChildId(), "videos_watched");
        }
    }
    
    /**
     * Increment chat session count and check for achievements
     */
    public static void incrementChatCount(HttpSession session) {
        Children child = getChildFromSession(session);
        if (child != null) {
            achievementService.incrementStat(child.getChildId(), "chat_sessions");
        }
    }
    
    /**
     * Add XP to user
     */
    public static void addXp(HttpSession session, int xp) {
        Children child = getChildFromSession(session);
        if (child != null) {
            achievementService.addXp(child.getChildId(), xp);
        }
    }
    
    /**
     * Award special achievement
     */
    public static void awardSpecialAchievement(HttpSession session, String badgeName, String description) {
        Children child = getChildFromSession(session);
        if (child != null) {
            achievementService.awardSpecialAchievement(child.getChildId(), badgeName, description);
        }
    }
    
    /**
     * Check and award achievements for a specific child
     */
    public static void checkAndAwardAchievements(int childId) {
        achievementService.checkAndAwardAchievements(childId);
    }
    
    /**
     * Get user stats for display
     */
    public static model.UserStats getUserStats(HttpSession session) {
        Children child = getChildFromSession(session);
        if (child != null) {
            return achievementService.getUserStats(child.getChildId());
        }
        return null;
    }
} 