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
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Admin
 */
@Entity
@Table(name = "Drawings")
@NamedQueries({
    @NamedQuery(name = "Drawings.findAll", query = "SELECT d FROM Drawings d"),
    @NamedQuery(name = "Drawings.findByDrawingId", query = "SELECT d FROM Drawings d WHERE d.drawingId = :drawingId"),
    @NamedQuery(name = "Drawings.findByImageUrl", query = "SELECT d FROM Drawings d WHERE d.imageUrl = :imageUrl"),
    @NamedQuery(name = "Drawings.findByTitle", query = "SELECT d FROM Drawings d WHERE d.title = :title"),
    @NamedQuery(name = "Drawings.findByCreatedAt", query = "SELECT d FROM Drawings d WHERE d.createdAt = :createdAt"),
    @NamedQuery(name = "Drawings.findByIsApproved", query = "SELECT d FROM Drawings d WHERE d.isApproved = :isApproved")})
public class Drawings implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "drawing_id")
    private Integer drawingId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "image_url")
    private String imageUrl;
    @Size(max = 100)
    @Column(name = "title")
    private String title;
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @Column(name = "is_approved")
    private Boolean isApproved;
    @OneToMany(mappedBy = "drawingId")
    private List<ContentReports> contentReportsList;
    @JoinColumn(name = "child_id", referencedColumnName = "child_id")
    @ManyToOne(optional = false)
    private Children childId;
    @JoinColumn(name = "approved_by", referencedColumnName = "parent_id")
    @ManyToOne
    private Parents approvedBy;

    public Drawings() {
    }

    public Drawings(Integer drawingId) {
        this.drawingId = drawingId;
    }

    public Drawings(Integer drawingId, String imageUrl) {
        this.drawingId = drawingId;
        this.imageUrl = imageUrl;
    }

    public Integer getDrawingId() {
        return drawingId;
    }

    public void setDrawingId(Integer drawingId) {
        this.drawingId = drawingId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Boolean getIsApproved() {
        return isApproved;
    }

    public void setIsApproved(Boolean isApproved) {
        this.isApproved = isApproved;
    }

    public List<ContentReports> getContentReportsList() {
        return contentReportsList;
    }

    public void setContentReportsList(List<ContentReports> contentReportsList) {
        this.contentReportsList = contentReportsList;
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
        hash += (drawingId != null ? drawingId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Drawings)) {
            return false;
        }
        Drawings other = (Drawings) object;
        if ((this.drawingId == null && other.drawingId != null) || (this.drawingId != null && !this.drawingId.equals(other.drawingId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Drawings[ drawingId=" + drawingId + " ]";
    }
    
}
