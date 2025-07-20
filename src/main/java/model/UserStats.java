package model;

import java.time.LocalDateTime;

public class UserStats {
    private int childId;
    private int postsCount;
    private int drawingsCount;
    private int storiesCount;
    private int friendsCount;
    private int audioStoriesHeard;
    private int videosWatched;
    private int chatSessions;
    private int totalXp;
    private int currentLevel;
    private LocalDateTime lastUpdated;

    // Constructors
    public UserStats() {}

    public UserStats(int childId, int postsCount, int drawingsCount, int storiesCount, 
                    int friendsCount, int audioStoriesHeard, int videosWatched, 
                    int chatSessions, int totalXp, int currentLevel) {
        this.childId = childId;
        this.postsCount = postsCount;
        this.drawingsCount = drawingsCount;
        this.storiesCount = storiesCount;
        this.friendsCount = friendsCount;
        this.audioStoriesHeard = audioStoriesHeard;
        this.videosWatched = videosWatched;
        this.chatSessions = chatSessions;
        this.totalXp = totalXp;
        this.currentLevel = currentLevel;
    }

    // Getters and Setters
    public int getChildId() {
        return childId;
    }

    public void setChildId(int childId) {
        this.childId = childId;
    }

    public int getPostsCount() {
        return postsCount;
    }

    public void setPostsCount(int postsCount) {
        this.postsCount = postsCount;
    }

    public int getDrawingsCount() {
        return drawingsCount;
    }

    public void setDrawingsCount(int drawingsCount) {
        this.drawingsCount = drawingsCount;
    }

    public int getStoriesCount() {
        return storiesCount;
    }

    public void setStoriesCount(int storiesCount) {
        this.storiesCount = storiesCount;
    }

    public int getFriendsCount() {
        return friendsCount;
    }

    public void setFriendsCount(int friendsCount) {
        this.friendsCount = friendsCount;
    }

    public int getAudioStoriesHeard() {
        return audioStoriesHeard;
    }

    public void setAudioStoriesHeard(int audioStoriesHeard) {
        this.audioStoriesHeard = audioStoriesHeard;
    }

    public int getVideosWatched() {
        return videosWatched;
    }

    public void setVideosWatched(int videosWatched) {
        this.videosWatched = videosWatched;
    }

    public int getChatSessions() {
        return chatSessions;
    }

    public void setChatSessions(int chatSessions) {
        this.chatSessions = chatSessions;
    }

    public int getTotalXp() {
        return totalXp;
    }

    public void setTotalXp(int totalXp) {
        this.totalXp = totalXp;
    }

    public int getCurrentLevel() {
        return currentLevel;
    }

    public void setCurrentLevel(int currentLevel) {
        this.currentLevel = currentLevel;
    }

    public LocalDateTime getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(LocalDateTime lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    // Helper methods
    public int getXpToNextLevel() {
        int xpForCurrentLevel = (currentLevel - 1) * 1000;
        int xpForNextLevel = currentLevel * 1000;
        return xpForNextLevel - (totalXp - xpForCurrentLevel);
    }

    public double getLevelProgress() {
        int xpForCurrentLevel = (currentLevel - 1) * 1000;
        int xpForNextLevel = currentLevel * 1000;
        int currentLevelXp = totalXp - xpForCurrentLevel;
        int levelXpRange = xpForNextLevel - xpForCurrentLevel;
        return (double) currentLevelXp / levelXpRange * 100;
    }

    public String getLevelTitle() {
        if (currentLevel <= 3) return "Nhà sáng tạo nhí";
        else if (currentLevel <= 6) return "Nghệ sĩ tài năng";
        else if (currentLevel <= 9) return "Nhà văn chuyên nghiệp";
        else return "Bậc thầy sáng tạo";
    }
} 