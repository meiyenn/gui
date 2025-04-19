/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.util.Collection;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

/**
 *
 * @author Huay
 */
@Entity
@Table(name = "RECEIPT")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Receipt.findAll", query = "SELECT r FROM Receipt r"),
    @NamedQuery(name = "Receipt.findByReceiptid", query = "SELECT r FROM Receipt r WHERE r.receiptid = :receiptid"),
    @NamedQuery(name = "Receipt.findByCreationtime", query = "SELECT r FROM Receipt r WHERE r.creationtime = :creationtime")})
public class Receipt implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 7)
    @Column(name = "RECEIPTID")
    private String receiptid;
    @Basic(optional = false)
    @NotNull
    @Column(name = "CREATIONTIME")
    @Temporal(TemporalType.TIMESTAMP)
    private Date creationtime;
    @OneToMany(mappedBy = "receiptid")
    private Collection<Productrating> productratingCollection;
    @JoinColumn(name = "CARTID", referencedColumnName = "CARTID")
    @ManyToOne
    private Cart cartid;

    public Receipt() {
    }

    public Receipt(String receiptid) {
        this.receiptid = receiptid;
    }

    public Receipt(String receiptid, Date creationtime) {
        this.receiptid = receiptid;
        this.creationtime = creationtime;
    }

    public String getReceiptid() {
        return receiptid;
    }

    public void setReceiptid(String receiptid) {
        this.receiptid = receiptid;
    }

    public Date getCreationtime() {
        return creationtime;
    }

    public void setCreationtime(Date creationtime) {
        this.creationtime = creationtime;
    }

    @XmlTransient
    public Collection<Productrating> getProductratingCollection() {
        return productratingCollection;
    }

    public void setProductratingCollection(Collection<Productrating> productratingCollection) {
        this.productratingCollection = productratingCollection;
    }

    public Cart getCartid() {
        return cartid;
    }

    public void setCartid(Cart cartid) {
        this.cartid = cartid;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (receiptid != null ? receiptid.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Receipt)) {
            return false;
        }
        Receipt other = (Receipt) object;
        if ((this.receiptid == null && other.receiptid != null) || (this.receiptid != null && !this.receiptid.equals(other.receiptid))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Receipt[ receiptid=" + receiptid + " ]";
    }
    
}
