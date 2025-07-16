package model;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

public class ActivityLog {
    private int id;
    private String activityType;
    private String description;
    private String userEmail;
    private String userName;
    private Timestamp timestamp;
    
    public ActivityLog() {}
    
    public ActivityLog(String activityType, String description, String userEmail, String userName) {
        this.activityType = activityType;
        this.description = description;
        this.userEmail = userEmail;
        this.userName = userName;
        this.timestamp = new Timestamp(System.currentTimeMillis());
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getActivityType() { return activityType; }
    public void setActivityType(String activityType) { this.activityType = activityType; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    
    public Timestamp getTimestamp() { return timestamp; }
    public void setTimestamp(Timestamp timestamp) { this.timestamp = timestamp; }
    
    // Helper methods for JSP
    public String getTimeAgo() {
        if (timestamp == null) return "Unknown time";
        
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime activityTime = timestamp.toLocalDateTime();
        
        long minutes = ChronoUnit.MINUTES.between(activityTime, now);
        long hours = ChronoUnit.HOURS.between(activityTime, now);
        long days = ChronoUnit.DAYS.between(activityTime, now);
        
        if (minutes < 1) {
            return "Just now";
        } else if (minutes < 60) {
            return minutes + " minute" + (minutes > 1 ? "s" : "") + " ago";
        } else if (hours < 24) {
            return hours + " hour" + (hours > 1 ? "s" : "") + " ago";
        } else if (days < 7) {
            return days + " day" + (days > 1 ? "s" : "") + " ago";
        } else {
            return activityTime.format(DateTimeFormatter.ofPattern("MMM dd, yyyy"));
        }
    }
    
    public String getIconClass() {
        switch (activityType) {
            case "USER_REGISTRATION":
                return "bi-person-plus";
            case "POST_APPROVED":
                return "bi-check-circle";
            case "POST_SUBMITTED":
                return "bi-file-plus";
            case "CONTENT_REPORTED":
                return "bi-flag";
            case "SECURITY_SCAN":
                return "bi-shield-check";
            case "USER_LOGIN":
                return "bi-box-arrow-in-right";
            case "USER_LOGOUT":
                return "bi-box-arrow-right";
            case "POST_DELETED":
                return "bi-trash";
            case "REPORT_RESOLVED":
                return "bi-check2-circle";
            default:
                return "bi-info-circle";
        }
    }
    
    public String getIconColorClass() {
        switch (activityType) {
            case "USER_REGISTRATION":
            case "POST_APPROVED":
            case "REPORT_RESOLVED":
                return "success";
            case "POST_SUBMITTED":
            case "USER_LOGIN":
                return "primary";
            case "CONTENT_REPORTED":
            case "POST_DELETED":
                return "danger";
            case "SECURITY_SCAN":
                return "info";
            case "USER_LOGOUT":
                return "secondary";
            default:
                return "secondary";
        }
    }
}
