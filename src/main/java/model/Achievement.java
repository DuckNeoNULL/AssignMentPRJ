package model;

import java.time.LocalDateTime;

public class Achievement {
    private int achievementId;
    private int childId;
    private String badgeType;
    private String badgeName;
    private String description;
    private String icon;
    private LocalDateTime earnedDate;
    private boolean isSpecial;

    // Constructors
    public Achievement() {}

    public Achievement(int childId, String badgeType, String badgeName, String description, String icon) {
        this.childId = childId;
        this.badgeType = badgeType;
        this.badgeName = badgeName;
        this.description = description;
        this.icon = icon;
        this.earnedDate = LocalDateTime.now();
        this.isSpecial = false;
    }

    public Achievement(int childId, String badgeType, String badgeName, String description, String icon, boolean isSpecial) {
        this.childId = childId;
        this.badgeType = badgeType;
        this.badgeName = badgeName;
        this.description = description;
        this.icon = icon;
        this.earnedDate = LocalDateTime.now();
        this.isSpecial = isSpecial;
    }

    // Getters and Setters
    public int getAchievementId() {
        return achievementId;
    }

    public void setAchievementId(int achievementId) {
        this.achievementId = achievementId;
    }

    public int getChildId() {
        return childId;
    }

    public void setChildId(int childId) {
        this.childId = childId;
    }

    public String getBadgeType() {
        return badgeType;
    }

    public void setBadgeType(String badgeType) {
        this.badgeType = badgeType;
    }

    public String getBadgeName() {
        return badgeName;
    }

    public void setBadgeName(String badgeName) {
        this.badgeName = badgeName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public LocalDateTime getEarnedDate() {
        return earnedDate;
    }

    public void setEarnedDate(LocalDateTime earnedDate) {
        this.earnedDate = earnedDate;
    }

    public boolean isSpecial() {
        return isSpecial;
    }

    public void setSpecial(boolean special) {
        isSpecial = special;
    }

    // Helper methods
    public String getBadgeTypeDisplayName() {
        switch (badgeType) {
            case "POSTS": return "Bài viết";
            case "DRAWINGS": return "Vẽ tranh";
            case "STORIES": return "Truyện";
            case "FRIENDS": return "Bạn bè";
            case "AUDIO": return "Nghe truyện";
            case "VIDEOS": return "Xem video";
            case "CHAT": return "Trò chuyện";
            case "SPECIAL": return "Đặc biệt";
            default: return badgeType;
        }
    }

    public String getBadgeColor() {
        if (isSpecial) return "#FFD700"; // Gold for special badges
        switch (badgeType) {
            case "POSTS": return "#4CAF50"; // Green
            case "DRAWINGS": return "#2196F3"; // Blue
            case "STORIES": return "#9C27B0"; // Purple
            case "FRIENDS": return "#FF9800"; // Orange
            case "AUDIO": return "#795548"; // Brown
            case "VIDEOS": return "#F44336"; // Red
            case "CHAT": return "#00BCD4"; // Cyan
            default: return "#607D8B"; // Blue Grey
        }
    }
} 