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
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Date;

/**
 *
 * @author Admin
 */
@Entity
@Table(name = "ContentReports")
@NamedQueries({
    @NamedQuery(name = "ContentReports.findAll", query = "SELECT c FROM ContentReports c"),
    @NamedQuery(name = "ContentReports.findByReportId", query = "SELECT c FROM ContentReports c WHERE c.reportId = :reportId"),
    @NamedQuery(name = "ContentReports.findByReason", query = "SELECT c FROM ContentReports c WHERE c.reason = :reason"),
    @NamedQuery(name = "ContentReports.findByStatus", query = "SELECT c FROM ContentReports c WHERE c.status = :status"),
    @NamedQuery(name = "ContentReports.findByReviewNotes", query = "SELECT c FROM ContentReports c WHERE c.reviewNotes = :reviewNotes"),
    @NamedQuery(name = "ContentReports.findByCreatedAt", query = "SELECT c FROM ContentReports c WHERE c.createdAt = :createdAt"),
    @NamedQuery(name = "ContentReports.findByResolvedAt", query = "SELECT c FROM ContentReports c WHERE c.resolvedAt = :resolvedAt")})
public class ContentReports implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "report_id")
    private Integer reportId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 2147483647)
    @Column(name = "reason")
    private String reason;
    @Size(max = 20)
    @Column(name = "status")
    private String status;
    @Size(max = 2147483647)
    @Column(name = "review_notes")
    private String reviewNotes;
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @Column(name = "resolved_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date resolvedAt;
    @JoinColumn(name = "drawing_id", referencedColumnName = "drawing_id")
    @ManyToOne
    private Drawings drawingId;
    @JoinColumn(name = "reporter_id", referencedColumnName = "parent_id")
    @ManyToOne(optional = false)
    private Parents reporterId;
    @JoinColumn(name = "reviewed_by", referencedColumnName = "parent_id")
    @ManyToOne
    private Parents reviewedBy;
    @JoinColumn(name = "post_id", referencedColumnName = "post_id")
    @ManyToOne
    private Posts postId;

    public ContentReports() {
    }

    public ContentReports(Integer reportId) {
        this.reportId = reportId;
    }

    public ContentReports(Integer reportId, String reason) {
        this.reportId = reportId;
        this.reason = reason;
    }

    public Integer getReportId() {
        return reportId;
    }

    public void setReportId(Integer reportId) {
        this.reportId = reportId;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReviewNotes() {
        return reviewNotes;
    }

    public void setReviewNotes(String reviewNotes) {
        this.reviewNotes = reviewNotes;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getResolvedAt() {
        return resolvedAt;
    }

    public void setResolvedAt(Date resolvedAt) {
        this.resolvedAt = resolvedAt;
    }

    public Drawings getDrawingId() {
        return drawingId;
    }

    public void setDrawingId(Drawings drawingId) {
        this.drawingId = drawingId;
    }

    public Parents getReporterId() {
        return reporterId;
    }

    public void setReporterId(Parents reporterId) {
        this.reporterId = reporterId;
    }

    public Parents getReviewedBy() {
        return reviewedBy;
    }

    public void setReviewedBy(Parents reviewedBy) {
        this.reviewedBy = reviewedBy;
    }

    public Posts getPostId() {
        return postId;
    }

    public void setPostId(Posts postId) {
        this.postId = postId;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (reportId != null ? reportId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ContentReports)) {
            return false;
        }
        ContentReports other = (ContentReports) object;
        if ((this.reportId == null && other.reportId != null) || (this.reportId != null && !this.reportId.equals(other.reportId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.ContentReports[ reportId=" + reportId + " ]";
    }
    
}
