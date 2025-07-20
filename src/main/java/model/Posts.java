/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class Posts {
    // Primary fields
    private Integer id;                    // Post ID
    private String content;                // Post content
    private String title;                  // Post title
    private String imageUrl;               // Image URL/path
    private LocalDateTime createdAt;       // Creation time
    private String status;                 // Post status
    private String postType;               // Post type (POST, STORY, DRAWING)
    
    // Author information
    private Integer authorId;              // Author's ID (child_id)
    private String authorName;             // Author's name
    private Children child;                // Child author object
    private Parents parent;                // Parent object
    
    // Social features
    private Integer likeCount;             // Number of likes
    private List<Map<String, Object>> comments; // Comments list
    
    // Default constructor
    public Posts() {
    }
    
    // Getters and Setters
    
    // ID - supports both id and postId for compatibility
    public Integer getId() {
        return id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    
    public Integer getPostId() {
        return id;
    }
    
    public void setPostId(Integer postId) {
        this.id = postId;
    }
    
    // Content
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    // Title
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    // Image - supports both imageUrl and imagePath for compatibility
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public String getImagePath() {
        return imageUrl;
    }
    
    public void setImagePath(String imagePath) {
        this.imageUrl = imagePath;
    }
    
    // Time - supports both createdAt and postTime for compatibility
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt != null ? createdAt.toLocalDateTime() : null;
    }
    
    public LocalDateTime getPostTime() {
        return createdAt;
    }
    
    public void setPostTime(LocalDateTime postTime) {
        this.createdAt = postTime;
    }
    
    // PHƯƠNG THỨC MỚI: Chuyển đổi LocalDateTime sang Date để JSP có thể định dạng
    public Date getCreatedAtAsDate() {
        if (this.createdAt == null) {
            return null;
        }
        return Date.from(this.createdAt.atZone(ZoneId.systemDefault()).toInstant());
    }

    // Status
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    // Post Type
    public String getPostType() {
        return postType;
    }
    
    public void setPostType(String postType) {
        this.postType = postType;
    }
    
    // Author ID - supports both authorId and childId for compatibility
    public Integer getAuthorId() {
        return authorId;
    }
    
    public void setAuthorId(Integer authorId) {
        this.authorId = authorId;
    }
    
    public Integer getChildId() {
        return authorId;
    }
    
    public void setChildId(Integer childId) {
        this.authorId = childId;
    }
    
    // Author Name
    public String getAuthorName() {
        return authorName;
    }
    
    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }
    
    // Child object
    public Children getChild() {
        return child;
    }
    
    public void setChild(Children child) {
        this.child = child;
        if (child != null) {
            this.authorId = child.getChildId();
            this.authorName = child.getFullName();
        }
    }
    
    // Parent object
    public Parents getParent() {
        return parent;
    }
    
    public void setParent(Parents parent) {
        this.parent = parent;
    }
    
    // Like count
    public Integer getLikeCount() {
        return likeCount;
    }
    
    public void setLikeCount(Integer likeCount) {
        this.likeCount = likeCount;
    }
    
    // Comments
    public List<Map<String, Object>> getComments() {
        return comments;
    }
    
    public void setComments(List<Map<String, Object>> comments) {
        this.comments = comments;
    }
}
