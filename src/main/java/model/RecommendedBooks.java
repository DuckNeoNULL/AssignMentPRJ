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
@Table(name = "RecommendedBooks")
@NamedQueries({
    @NamedQuery(name = "RecommendedBooks.findAll", query = "SELECT r FROM RecommendedBooks r"),
    @NamedQuery(name = "RecommendedBooks.findByBookId", query = "SELECT r FROM RecommendedBooks r WHERE r.bookId = :bookId"),
    @NamedQuery(name = "RecommendedBooks.findByTitle", query = "SELECT r FROM RecommendedBooks r WHERE r.title = :title"),
    @NamedQuery(name = "RecommendedBooks.findByAuthor", query = "SELECT r FROM RecommendedBooks r WHERE r.author = :author"),
    @NamedQuery(name = "RecommendedBooks.findByAgeMin", query = "SELECT r FROM RecommendedBooks r WHERE r.ageMin = :ageMin"),
    @NamedQuery(name = "RecommendedBooks.findByAgeMax", query = "SELECT r FROM RecommendedBooks r WHERE r.ageMax = :ageMax"),
    @NamedQuery(name = "RecommendedBooks.findByDescription", query = "SELECT r FROM RecommendedBooks r WHERE r.description = :description"),
    @NamedQuery(name = "RecommendedBooks.findByCoverUrl", query = "SELECT r FROM RecommendedBooks r WHERE r.coverUrl = :coverUrl"),
    @NamedQuery(name = "RecommendedBooks.findByAmazonUrl", query = "SELECT r FROM RecommendedBooks r WHERE r.amazonUrl = :amazonUrl"),
    @NamedQuery(name = "RecommendedBooks.findByAddedAt", query = "SELECT r FROM RecommendedBooks r WHERE r.addedAt = :addedAt"),
    @NamedQuery(name = "RecommendedBooks.findByIsActive", query = "SELECT r FROM RecommendedBooks r WHERE r.isActive = :isActive")})
public class RecommendedBooks implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "book_id")
    private Integer bookId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "title")
    private String title;
    @Size(max = 100)
    @Column(name = "author")
    private String author;
    @Column(name = "age_min")
    private Integer ageMin;
    @Column(name = "age_max")
    private Integer ageMax;
    @Size(max = 2147483647)
    @Column(name = "description")
    private String description;
    @Size(max = 255)
    @Column(name = "cover_url")
    private String coverUrl;
    @Size(max = 255)
    @Column(name = "amazon_url")
    private String amazonUrl;
    @Column(name = "added_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date addedAt;
    @Column(name = "is_active")
    private Boolean isActive;

    public RecommendedBooks() {
    }

    public RecommendedBooks(Integer bookId) {
        this.bookId = bookId;
    }

    public RecommendedBooks(Integer bookId, String title) {
        this.bookId = bookId;
        this.title = title;
    }

    public Integer getBookId() {
        return bookId;
    }

    public void setBookId(Integer bookId) {
        this.bookId = bookId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public Integer getAgeMin() {
        return ageMin;
    }

    public void setAgeMin(Integer ageMin) {
        this.ageMin = ageMin;
    }

    public Integer getAgeMax() {
        return ageMax;
    }

    public void setAgeMax(Integer ageMax) {
        this.ageMax = ageMax;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCoverUrl() {
        return coverUrl;
    }

    public void setCoverUrl(String coverUrl) {
        this.coverUrl = coverUrl;
    }

    public String getAmazonUrl() {
        return amazonUrl;
    }

    public void setAmazonUrl(String amazonUrl) {
        this.amazonUrl = amazonUrl;
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

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (bookId != null ? bookId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof RecommendedBooks)) {
            return false;
        }
        RecommendedBooks other = (RecommendedBooks) object;
        if ((this.bookId == null && other.bookId != null) || (this.bookId != null && !this.bookId.equals(other.bookId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.RecommendedBooks[ bookId=" + bookId + " ]";
    }
    
}
