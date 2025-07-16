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
@Table(name = "SensitiveKeywords")
@NamedQueries({
    @NamedQuery(name = "SensitiveKeywords.findAll", query = "SELECT s FROM SensitiveKeywords s"),
    @NamedQuery(name = "SensitiveKeywords.findByKeywordId", query = "SELECT s FROM SensitiveKeywords s WHERE s.keywordId = :keywordId"),
    @NamedQuery(name = "SensitiveKeywords.findByKeyword", query = "SELECT s FROM SensitiveKeywords s WHERE s.keyword = :keyword"),
    @NamedQuery(name = "SensitiveKeywords.findBySeverity", query = "SELECT s FROM SensitiveKeywords s WHERE s.severity = :severity"),
    @NamedQuery(name = "SensitiveKeywords.findByAddedAt", query = "SELECT s FROM SensitiveKeywords s WHERE s.addedAt = :addedAt"),
    @NamedQuery(name = "SensitiveKeywords.findByIsActive", query = "SELECT s FROM SensitiveKeywords s WHERE s.isActive = :isActive")})
public class SensitiveKeywords implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "keyword_id")
    private Integer keywordId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "keyword")
    private String keyword;
    @Column(name = "severity")
    private Integer severity;
    @Column(name = "added_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date addedAt;
    @Column(name = "is_active")
    private Boolean isActive;
    @JoinColumn(name = "added_by", referencedColumnName = "parent_id")
    @ManyToOne
    private Parents addedBy;

    public SensitiveKeywords() {
    }

    public SensitiveKeywords(Integer keywordId) {
        this.keywordId = keywordId;
    }

    public SensitiveKeywords(Integer keywordId, String keyword) {
        this.keywordId = keywordId;
        this.keyword = keyword;
    }

    public Integer getKeywordId() {
        return keywordId;
    }

    public void setKeywordId(Integer keywordId) {
        this.keywordId = keywordId;
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public Integer getSeverity() {
        return severity;
    }

    public void setSeverity(Integer severity) {
        this.severity = severity;
    }

    public Date getAddedAt() {
        return addedAt;
    }

    public void setAddedAt(Date addedAt) {
        this.addedAt = addedAt;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public Parents getAddedBy() {
        return addedBy;
    }

    public void setAddedBy(Parents addedBy) {
        this.addedBy = addedBy;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (keywordId != null ? keywordId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof SensitiveKeywords)) {
            return false;
        }
        SensitiveKeywords other = (SensitiveKeywords) object;
        if ((this.keywordId == null && other.keywordId != null) || (this.keywordId != null && !this.keywordId.equals(other.keywordId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.SensitiveKeywords[ keywordId=" + keywordId + " ]";
    }
    
}
