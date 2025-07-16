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
@Table(name = "BookSearches")
@NamedQueries({
    @NamedQuery(name = "BookSearches.findAll", query = "SELECT b FROM BookSearches b"),
    @NamedQuery(name = "BookSearches.findBySearchId", query = "SELECT b FROM BookSearches b WHERE b.searchId = :searchId"),
    @NamedQuery(name = "BookSearches.findBySearchTerm", query = "SELECT b FROM BookSearches b WHERE b.searchTerm = :searchTerm"),
    @NamedQuery(name = "BookSearches.findBySearchDate", query = "SELECT b FROM BookSearches b WHERE b.searchDate = :searchDate"),
    @NamedQuery(name = "BookSearches.findByResultsCount", query = "SELECT b FROM BookSearches b WHERE b.resultsCount = :resultsCount")})
public class BookSearches implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "search_id")
    private Integer searchId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "search_term")
    private String searchTerm;
    @Column(name = "search_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date searchDate;
    @Column(name = "results_count")
    private Integer resultsCount;
    @JoinColumn(name = "child_id", referencedColumnName = "child_id")
    @ManyToOne
    private Children childId;

    public BookSearches() {
    }

    public BookSearches(Integer searchId) {
        this.searchId = searchId;
    }

    public BookSearches(Integer searchId, String searchTerm) {
        this.searchId = searchId;
        this.searchTerm = searchTerm;
    }

    public Integer getSearchId() {
        return searchId;
    }

    public void setSearchId(Integer searchId) {
        this.searchId = searchId;
    }

    public String getSearchTerm() {
        return searchTerm;
    }

    public void setSearchTerm(String searchTerm) {
        this.searchTerm = searchTerm;
    }

    public Date getSearchDate() {
        return searchDate;
    }

    public void setSearchDate(Date searchDate) {
        this.searchDate = searchDate;
    }

    public Integer getResultsCount() {
        return resultsCount;
    }

    public void setResultsCount(Integer resultsCount) {
        this.resultsCount = resultsCount;
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
        hash += (searchId != null ? searchId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof BookSearches)) {
            return false;
        }
        BookSearches other = (BookSearches) object;
        if ((this.searchId == null && other.searchId != null) || (this.searchId != null && !this.searchId.equals(other.searchId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.BookSearches[ searchId=" + searchId + " ]";
    }
    
}
