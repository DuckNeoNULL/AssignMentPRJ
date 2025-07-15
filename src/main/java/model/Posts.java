/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Date;

/**
 *
 * @author ADMIN
 */
@Entity
@Table(name = "Posts")
@NamedQueries({
    @NamedQuery(name = "Posts.findAll", query = "SELECT p FROM Posts p"),
    @NamedQuery(name = "Posts.findByPostId", query = "SELECT p FROM Posts p WHERE p.postId = :postId"),
    @NamedQuery(name = "Posts.findByContent", query = "SELECT p FROM Posts p WHERE p.content = :content"),
    @NamedQuery(name = "Posts.findByImageUrl", query = "SELECT p FROM Posts p WHERE p.imageUrl = :imageUrl"),
    @NamedQuery(name = "Posts.findByIsApproved", query = "SELECT p FROM Posts p WHERE p.isApproved = :isApproved"),
    @NamedQuery(name = "Posts.findByApprovalDate", query = "SELECT p FROM Posts p WHERE p.approvalDate = :approvalDate"),
    @NamedQuery(name = "Posts.findByCreatedAt", query = "SELECT p FROM Posts p WHERE p.createdAt = :createdAt"),
    @NamedQuery(name = "Posts.findByUpdatedAt", query = "SELECT p FROM Posts p WHERE p.updatedAt = :updatedAt"),
    @NamedQuery(name = "Posts.findByModerationScore", query = "SELECT p FROM Posts p WHERE p.moderationScore = :moderationScore"),
    @NamedQuery(name = "Posts.findByModerationFlag", query = "SELECT p FROM Posts p WHERE p.moderationFlag = :moderationFlag")})
public class Posts implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "post_id")
    private Integer postId;
    @Size(max = 2147483647)
    @Column(name = "content")
    private String content;
    @Size(max = 255)
    @Column(name = "image_url")
    private String imageUrl;
    @Column(name = "is_approved")
    private Boolean isApproved;
    @Column(name = "approval_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date approvalDate;
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @Column(name = "updated_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "moderation_score")
    private Double moderationScore;
    @Column(name = "moderation_flag")
    private Boolean moderationFlag;
    @JoinColumn(name = "child_id", referencedColumnName = "child_id")
    @ManyToOne(optional = false)
    private Children childId;
    @JoinColumn(name = "approved_by", referencedColumnName = "parent_id")
    @ManyToOne
    private Parents approvedBy;

    public Posts() {
    }

    public Posts(Integer postId) {
        this.postId = postId;
    }

    public Integer getPostId() {
        return postId;
    }

    public void setPostId(Integer postId) {
        this.postId = postId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Boolean getIsApproved() {
        return isApproved;
    }

    public void setIsApproved(Boolean isApproved) {
        this.isApproved = isApproved;
    }

    public Date getApprovalDate() {
        return approvalDate;
    }

    public void setApprovalDate(Date approvalDate) {
        this.approvalDate = approvalDate;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Double getModerationScore() {
        return moderationScore;
    }

    public void setModerationScore(Double moderationScore) {
        this.moderationScore = moderationScore;
    }

    public Boolean getModerationFlag() {
        return moderationFlag;
    }

    public void setModerationFlag(Boolean moderationFlag) {
        this.moderationFlag = moderationFlag;
    }

    public Children getChildId() {
        return childId;
    }

    public void setChildId(Children childId) {
        this.childId = childId;
    }

    public Parents getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(Parents approvedBy) {
        this.approvedBy = approvedBy;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (postId != null ? postId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Posts)) {
            return false;
        }
        Posts other = (Posts) object;
        if ((this.postId == null && other.postId != null) || (this.postId != null && !this.postId.equals(other.postId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Posts[ postId=" + postId + " ]";
    }
    
}
