/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.math.BigDecimal;
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
 * @author grace
 */
@Entity
@Table(name = "VOUCHER")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Voucher.findAll", query = "SELECT v FROM Voucher v"),
    @NamedQuery(name = "Voucher.findByVoucherid", query = "SELECT v FROM Voucher v WHERE v.voucherid = :voucherid"),
    @NamedQuery(name = "Voucher.findByCode", query = "SELECT v FROM Voucher v WHERE v.code = :code"),
    @NamedQuery(name = "Voucher.findByDiscount", query = "SELECT v FROM Voucher v WHERE v.discount = :discount"),
    @NamedQuery(name = "Voucher.findByMinspend", query = "SELECT v FROM Voucher v WHERE v.minspend = :minspend"),
    @NamedQuery(name = "Voucher.findByExpirydate", query = "SELECT v FROM Voucher v WHERE v.expirydate = :expirydate"),
    @NamedQuery(name = "Voucher.findByUsed", query = "SELECT v FROM Voucher v WHERE v.used = :used")})
public class Voucher implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "VOUCHERID")
    private String voucherid;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "CODE")
    private String code;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Basic(optional = false)
    @NotNull
    @Column(name = "DISCOUNT")
    private BigDecimal discount;
    @Column(name = "MINSPEND")
    private BigDecimal minspend;
    @Column(name = "EXPIRYDATE")
    @Temporal(TemporalType.DATE)
    private Date expirydate;
    @Column(name = "USED")
    private Boolean used;
    @JoinColumn(name = "CUSTID", referencedColumnName = "CUSTID")
    @ManyToOne
    private Customer custid;

    public Voucher() {
    }

    public Voucher(String voucherid) {
        this.voucherid = voucherid;
    }

    public Voucher(String voucherid, String code, BigDecimal discount) {
        this.voucherid = voucherid;
        this.code = code;
        this.discount = discount;
    }

    public String getVoucherid() {
        return voucherid;
    }

    public void setVoucherid(String voucherid) {
        this.voucherid = voucherid;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public BigDecimal getDiscount() {
        return discount;
    }

    public void setDiscount(BigDecimal discount) {
        this.discount = discount;
    }

    public BigDecimal getMinspend() {
        return minspend;
    }

    public void setMinspend(BigDecimal minspend) {
        this.minspend = minspend;
    }

    public Date getExpirydate() {
        return expirydate;
    }

    public void setExpirydate(Date expirydate) {
        this.expirydate = expirydate;
    }

    public Boolean getUsed() {
        return used;
    }

    public void setUsed(Boolean used) {
        this.used = used;
    }

    public Customer getCustid() {
        return custid;
    }

    public void setCustid(Customer custid) {
        this.custid = custid;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (voucherid != null ? voucherid.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Voucher)) {
            return false;
        }
        Voucher other = (Voucher) object;
        if ((this.voucherid == null && other.voucherid != null) || (this.voucherid != null && !this.voucherid.equals(other.voucherid))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Voucher[ voucherid=" + voucherid + " ]";
    }
    
}
