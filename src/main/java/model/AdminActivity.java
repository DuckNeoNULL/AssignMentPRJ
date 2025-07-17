package model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class AdminActivity {
    private int id;
    private String activityType;
    private String description;
    private String adminEmail;
    private String adminName;
    private String ipAddress;
    private LocalDateTime timestamp;
    private String metadata;
    private String iconClass;
    private String iconColorClass;
    private String timeAgo;
    private String userName;
    
    // Constructors
    public AdminActivity() {}
    
    public AdminActivity(String activityType, String description, String adminEmail, String adminName) {
        this.activityType = activityType;
        this.description = description;
        this.adminEmail = adminEmail;
        this.adminName = adminName;
        this.timestamp = LocalDateTime.now();
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getActivityType() { return activityType; }
    public void setActivityType(String activityType) { this.activityType = activityType; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getAdminEmail() { return adminEmail; }
    public void setAdminEmail(String adminEmail) { this.adminEmail = adminEmail; }
    
    public String getAdminName() { return adminName; }
    public void setAdminName(String adminName) { this.adminName = adminName; }
    
    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }
    
    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
    
    public String getMetadata() { return metadata; }
    public void setMetadata(String metadata) { this.metadata = metadata; }
    
    public String getFormattedTimestamp() {
        if (timestamp == null) {
            return "";
        }
        return timestamp.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
    }
    
    public String getIconClass() { return iconClass; }
    public void setIconClass(String iconClass) { this.iconClass = iconClass; }
    
    public String getIconColorClass() { return iconColorClass; }
    public void setIconColorClass(String iconColorClass) { this.iconColorClass = iconColorClass; }
    
    public String getTimeAgo() { return timeAgo; }
    public void setTimeAgo(String timeAgo) { this.timeAgo = timeAgo; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
}
