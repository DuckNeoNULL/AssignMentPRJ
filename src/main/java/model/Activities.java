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
@Table(name = "Activities")
@NamedQueries({
    @NamedQuery(name = "Activities.findAll", query = "SELECT a FROM Activities a"),
    @NamedQuery(name = "Activities.findByActivityId", query = "SELECT a FROM Activities a WHERE a.activityId = :activityId"),
    @NamedQuery(name = "Activities.findByActivityType", query = "SELECT a FROM Activities a WHERE a.activityType = :activityType"),
    @NamedQuery(name = "Activities.findByTargetId", query = "SELECT a FROM Activities a WHERE a.targetId = :targetId"),
    @NamedQuery(name = "Activities.findByActivityDate", query = "SELECT a FROM Activities a WHERE a.activityDate = :activityDate"),
    @NamedQuery(name = "Activities.findByDetails", query = "SELECT a FROM Activities a WHERE a.details = :details")})
public class Activities implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "activity_id")
    private Integer activityId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "activity_type")
    private String activityType;
    @Column(name = "target_id")
    private Integer targetId;
    @Column(name = "activity_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date activityDate;
    @Size(max = 2147483647)
    @Column(name = "details")
    private String details;
    @JoinColumn(name = "child_id", referencedColumnName = "child_id")
    @ManyToOne(optional = false)
    private Children childId;

    public Activities() {
    }

    public Activities(Integer activityId) {
        this.activityId = activityId;
    }

    public Activities(Integer activityId, String activityType) {
        this.activityId = activityId;
        this.activityType = activityType;
    }

    public Integer getActivityId() {
        return activityId;
    }

    public void setActivityId(Integer activityId) {
        this.activityId = activityId;
    }

    public String getActivityType() {
        return activityType;
    }

    public void setActivityType(String activityType) {
        this.activityType = activityType;
    }

    public Integer getTargetId() {
        return targetId;
    }

    public void setTargetId(Integer targetId) {
        this.targetId = targetId;
    }

    public Date getActivityDate() {
        return activityDate;
    }

    public void setActivityDate(Date activityDate) {
        this.activityDate = activityDate;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public Children getChildId() {
        return childId;
    }

    public void setChildId(Children childId) {
        this.childId = childId;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (activityId != null ? activityId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Activities)) {
            return false;
        }
        Activities other = (Activities) object;
        if ((this.activityId == null && other.activityId != null) || (this.activityId != null && !this.activityId.equals(other.activityId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Activities[ activityId=" + activityId + " ]";
    }
    
}
