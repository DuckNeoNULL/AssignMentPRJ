/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
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
@Table(name = "Children")
@NamedQueries({
    @NamedQuery(name = "Children.findAll", query = "SELECT c FROM Children c"),
    @NamedQuery(name = "Children.findByChildId", query = "SELECT c FROM Children c WHERE c.childId = :childId"),
    @NamedQuery(name = "Children.findByName", query = "SELECT c FROM Children c WHERE c.name = :name"),
    @NamedQuery(name = "Children.findByAge", query = "SELECT c FROM Children c WHERE c.age = :age"),
    @NamedQuery(name = "Children.findByAvatarUrl", query = "SELECT c FROM Children c WHERE c.avatarUrl = :avatarUrl"),
    @NamedQuery(name = "Children.findByCreatedAt", query = "SELECT c FROM Children c WHERE c.createdAt = :createdAt")})
public class Children implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "child_id")
    private Integer childId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "name")
    private String name;
    @Basic(optional = false)
    @NotNull
    @Column(name = "age")
    private int age;
    @Size(max = 255)
    @Column(name = "avatar_url")
    private String avatarUrl;
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "childId")
    private List<Activities> activitiesList;
    @OneToMany(mappedBy = "childId")
    private List<BookSearches> bookSearchesList;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "childId")
    private List<Posts> postsList;
    @JoinColumn(name = "parent_id", referencedColumnName = "parent_id")
    @ManyToOne(optional = false)
    private Parents parentId;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "childId")
    private List<Drawings> drawingsList;

    public Children() {
    }

    public Children(Integer childId) {
        this.childId = childId;
    }

    public Children(Integer childId, String name, int age) {
        this.childId = childId;
        this.name = name;
        this.age = age;
    }

    public Integer getChildId() {
        return childId;
    }

    public void setChildId(Integer childId) {
        this.childId = childId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public List<Activities> getActivitiesList() {
        return activitiesList;
    }

    public void setActivitiesList(List<Activities> activitiesList) {
        this.activitiesList = activitiesList;
    }

    public List<BookSearches> getBookSearchesList() {
        return bookSearchesList;
    }

    public void setBookSearchesList(List<BookSearches> bookSearchesList) {
        this.bookSearchesList = bookSearchesList;
    }

    public List<Posts> getPostsList() {
        return postsList;
    }

    public void setPostsList(List<Posts> postsList) {
        this.postsList = postsList;
    }

    public Parents getParentId() {
        return parentId;
    }

    public void setParentId(Parents parentId) {
        this.parentId = parentId;
    }

    public List<Drawings> getDrawingsList() {
        return drawingsList;
    }

    public void setDrawingsList(List<Drawings> drawingsList) {
        this.drawingsList = drawingsList;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (childId != null ? childId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Children)) {
            return false;
        }
        Children other = (Children) object;
        if ((this.childId == null && other.childId != null) || (this.childId != null && !this.childId.equals(other.childId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Children[ childId=" + childId + " ]";
    }
    
}
