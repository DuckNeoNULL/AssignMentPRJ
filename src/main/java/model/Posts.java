/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.time.LocalDateTime;

/**
 *
 * @author FPT
 */
public class Posts {
    private int postId;
    private String title;
    private String content;
    private String imagePath;
    private LocalDateTime postTime;
    private String status;
    private String postType;
    private int childId;
    private Children child;
    private Parents parent;

    public Posts() {
    }

    public Posts(int postId, String title, String content, String imagePath, LocalDateTime postTime, String status, String postType, int childId, Children child, Parents parent) {
        this.postId = postId;
        this.title = title;
        this.content = content;
        this.imagePath = imagePath;
        this.postTime = postTime;
        this.status = status;
        this.postType = postType;
        this.childId = childId;
        this.child = child;
        this.parent = parent;
    }

    public int getPostId() {
        return postId;
    }

    public void setPostId(int postId) {
        this.postId = postId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public LocalDateTime getPostTime() {
        return postTime;
    }

    public void setPostTime(LocalDateTime postTime) {
        this.postTime = postTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPostType() {
        return postType;
    }

    public void setPostType(String postType) {
        this.postType = postType;
    }

    public int getChildId() {
        return childId;
    }

    public void setChildId(int childId) {
        this.childId = childId;
    }

    public Children getChild() {
        return child;
    }

    public void setChild(Children child) {
        this.child = child;
    }

    public Parents getParent() {
        return parent;
    }

    public void setParent(Parents parent) {
        this.parent = parent;
    }

    
}
