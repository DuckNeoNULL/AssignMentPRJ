package model;

public class DashboardStats {
    private int totalUsers;
    private int totalPosts;
    private int pendingPosts;
    private int activeReports;
    private double userGrowthPercentage;
    private double postGrowthPercentage;
    private int pendingApprovalsChange;
    private int newReportsToday;
    
    // Constructors
    public DashboardStats() {}
    
    // Getters and Setters
    public int getTotalUsers() { return totalUsers; }
    public void setTotalUsers(int totalUsers) { this.totalUsers = totalUsers; }
    
    public int getTotalPosts() { return totalPosts; }
    public void setTotalPosts(int totalPosts) { this.totalPosts = totalPosts; }
    
    public int getPendingPosts() { return pendingPosts; }
    public void setPendingPosts(int pendingPosts) { this.pendingPosts = pendingPosts; }
    
    public int getActiveReports() { return activeReports; }
    public void setActiveReports(int activeReports) { this.activeReports = activeReports; }
    
    public double getUserGrowthPercentage() { return userGrowthPercentage; }
    public void setUserGrowthPercentage(double userGrowthPercentage) { this.userGrowthPercentage = userGrowthPercentage; }
    
    public double getPostGrowthPercentage() { return postGrowthPercentage; }
    public void setPostGrowthPercentage(double postGrowthPercentage) { this.postGrowthPercentage = postGrowthPercentage; }
    
    public int getPendingApprovalsChange() { return pendingApprovalsChange; }
    public void setPendingApprovalsChange(int pendingApprovalsChange) { this.pendingApprovalsChange = pendingApprovalsChange; }
    
    public int getNewReportsToday() { return newReportsToday; }
    public void setNewReportsToday(int newReportsToday) { this.newReportsToday = newReportsToday; }
}
