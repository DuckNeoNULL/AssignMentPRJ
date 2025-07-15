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
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Collection;
import java.util.Date;

/**
 *
 * @author ADMIN
 */
@Entity
@Table(name = "Parents")
@NamedQueries({
    @NamedQuery(name = "Parents.findAll", query = "SELECT p FROM Parents p"),
    @NamedQuery(name = "Parents.findByParentId", query = "SELECT p FROM Parents p WHERE p.parentId = :parentId"),
    @NamedQuery(name = "Parents.findByEmail", query = "SELECT p FROM Parents p WHERE p.email = :email"),
    @NamedQuery(name = "Parents.findByPasswordHash", query = "SELECT p FROM Parents p WHERE p.passwordHash = :passwordHash"),
    @NamedQuery(name = "Parents.findByFullName", query = "SELECT p FROM Parents p WHERE p.fullName = :fullName"),
    @NamedQuery(name = "Parents.findByPhone", query = "SELECT p FROM Parents p WHERE p.phone = :phone"),
    @NamedQuery(name = "Parents.findByVerificationCode", query = "SELECT p FROM Parents p WHERE p.verificationCode = :verificationCode"),
    @NamedQuery(name = "Parents.findByIsVerified", query = "SELECT p FROM Parents p WHERE p.isVerified = :isVerified"),
    @NamedQuery(name = "Parents.findByCreatedAt", query = "SELECT p FROM Parents p WHERE p.createdAt = :createdAt"),
    @NamedQuery(name = "Parents.findByLastLogin", query = "SELECT p FROM Parents p WHERE p.lastLogin = :lastLogin"),
    @NamedQuery(name = "Parents.findByResetToken", query = "SELECT p FROM Parents p WHERE p.resetToken = :resetToken"),
    @NamedQuery(name = "Parents.findByResetTokenExpiry", query = "SELECT p FROM Parents p WHERE p.resetTokenExpiry = :resetTokenExpiry")})
public class Parents implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "parent_id")
    private Integer parentId;
    // @Pattern(regexp="[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?", message="Invalid email")//if the field contains email address consider using this annotation to enforce field validation
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "email")
    private String email;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "password_hash")
    private String passwordHash;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "full_name")
    private String fullName;
    // @Pattern(regexp="^\\(?(\\d{3})\\)?[- ]?(\\d{3})[- ]?(\\d{4})$", message="Invalid phone/fax format, should be as xxx-xxx-xxxx")//if the field contains phone or fax number consider using this annotation to enforce field validation
    @Size(max = 20)
    @Column(name = "phone")
    private String phone;
    @Size(max = 10)
    @Column(name = "verification_code")
    private String verificationCode;
    @Column(name = "is_verified")
    private Boolean isVerified;
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @Column(name = "last_login")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastLogin;
    @Size(max = 100)
    @Column(name = "reset_token")
    private String resetToken;
    @Column(name = "reset_token_expiry")
    @Temporal(TemporalType.TIMESTAMP)
    private Date resetTokenExpiry;
    @OneToMany(mappedBy = "approvedBy")
    private Collection<Posts> postsCollection;
    @OneToMany(mappedBy = "createdBy")
    private Collection<Courses> coursesCollection;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "parentId")
    private Collection<Children> childrenCollection;

    public Parents() {
    }

    public Parents(Integer parentId) {
        this.parentId = parentId;
    }

    public Parents(Integer parentId, String email, String passwordHash, String fullName) {
        this.parentId = parentId;
        this.email = email;
        this.passwordHash = passwordHash;
        this.fullName = fullName;
    }

    public Integer getParentId() {
        return parentId;
    }

    public void setParentId(Integer parentId) {
        this.parentId = parentId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getVerificationCode() {
        return verificationCode;
    }

    public void setVerificationCode(String verificationCode) {
        this.verificationCode = verificationCode;
    }

    public Boolean getIsVerified() {
        return isVerified;
    }

    public void setIsVerified(Boolean isVerified) {
        this.isVerified = isVerified;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(Date lastLogin) {
        this.lastLogin = lastLogin;
    }

    public String getResetToken() {
        return resetToken;
    }

    public void setResetToken(String resetToken) {
        this.resetToken = resetToken;
    }

    public Date getResetTokenExpiry() {
        return resetTokenExpiry;
    }

    public void setResetTokenExpiry(Date resetTokenExpiry) {
        this.resetTokenExpiry = resetTokenExpiry;
    }

    public Collection<Posts> getPostsCollection() {
        return postsCollection;
    }

    public void setPostsCollection(Collection<Posts> postsCollection) {
        this.postsCollection = postsCollection;
    }

    public Collection<Courses> getCoursesCollection() {
        return coursesCollection;
    }

    public void setCoursesCollection(Collection<Courses> coursesCollection) {
        this.coursesCollection = coursesCollection;
    }

    public Collection<Children> getChildrenCollection() {
        return childrenCollection;
    }

    public void setChildrenCollection(Collection<Children> childrenCollection) {
        this.childrenCollection = childrenCollection;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (parentId != null ? parentId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Parents)) {
            return false;
        }
        Parents other = (Parents) object;
        if ((this.parentId == null && other.parentId != null) || (this.parentId != null && !this.parentId.equals(other.parentId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Parents[ parentId=" + parentId + " ]";
    }
    
}
