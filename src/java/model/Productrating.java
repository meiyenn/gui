/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author Huay
 */
@Entity
@Table(name = "PRODUCTRATING")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Productrating.findAll", query = "SELECT p FROM Productrating p"),
    @NamedQuery(name = "Productrating.findByRatingid", query = "SELECT p FROM Productrating p WHERE p.ratingid = :ratingid"),
    @NamedQuery(name = "Productrating.findByRatingdate", query = "SELECT p FROM Productrating p WHERE p.ratingdate = :ratingdate"),
    @NamedQuery(name = "Productrating.findBySatisfaction", query = "SELECT p FROM Productrating p WHERE p.satisfaction = :satisfaction"),
    @NamedQuery(name = "Productrating.findByComment", query = "SELECT p FROM Productrating p WHERE p.comment = :comment")})
public class Productrating implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 6)
    @Column(name = "RATINGID")
    private String ratingid;
    @Basic(optional = false)
    @NotNull
    @Column(name = "RATINGDATE")
    @Temporal(TemporalType.TIMESTAMP)
    private Date ratingdate;
    @Basic(optional = false)
    @NotNull
    @Column(name = "SATISFACTION")
    private int satisfaction;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 200)
    @Column(name = "COMMENT")
    private String comment;
    @JoinColumn(name = "PRODUCTID", referencedColumnName = "PRODUCTID")
    @ManyToOne(optional = false)
    private Product productid;
    @JoinColumn(name = "RECEIPTID", referencedColumnName = "RECEIPTID")
    @ManyToOne(optional = false)
    private Receipt receiptid;

    public Productrating() {
    }

    public Productrating(String ratingid) {
        this.ratingid = ratingid;
    }

    public Productrating(String ratingid, Date ratingdate, int satisfaction, String comment) {
        this.ratingid = ratingid;
        this.ratingdate = ratingdate;
        this.satisfaction = satisfaction;
        this.comment = comment;
    }

    public String getRatingid() {
        return ratingid;
    }

    public void setRatingid(String ratingid) {
        this.ratingid = ratingid;
    }

    public Date getRatingdate() {
        return ratingdate;
    }

    public void setRatingdate(Date ratingdate) {
        this.ratingdate = ratingdate;
    }

    public int getSatisfaction() {
        return satisfaction;
    }

    public void setSatisfaction(int satisfaction) {
        this.satisfaction = satisfaction;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Product getProductid() {
        return productid;
    }

    public void setProductid(Product productid) {
        this.productid = productid;
    }

    public Receipt getReceiptid() {
        return receiptid;
    }

    public void setReceiptid(Receipt receiptid) {
        this.receiptid = receiptid;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (ratingid != null ? ratingid.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Productrating)) {
            return false;
        }
        Productrating other = (Productrating) object;
        if ((this.ratingid == null && other.ratingid != null) || (this.ratingid != null && !this.ratingid.equals(other.ratingid))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Productrating[ ratingid=" + ratingid + " ]";
    }
    
}
