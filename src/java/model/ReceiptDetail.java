/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.math.BigDecimal;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author Huay
 */
@Entity
@Table(name = "RECEIPT_DETAIL")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "ReceiptDetail.findAll", query = "SELECT r FROM ReceiptDetail r"),
    @NamedQuery(name = "ReceiptDetail.findByReceiptid", query = "SELECT r FROM ReceiptDetail r WHERE r.receiptDetailPK.receiptid = :receiptid"),
    @NamedQuery(name = "ReceiptDetail.findByProductid", query = "SELECT r FROM ReceiptDetail r WHERE r.receiptDetailPK.productid = :productid"),
    @NamedQuery(name = "ReceiptDetail.findByQuantity", query = "SELECT r FROM ReceiptDetail r WHERE r.quantity = :quantity"),
    @NamedQuery(name = "ReceiptDetail.findByPrice", query = "SELECT r FROM ReceiptDetail r WHERE r.price = :price")})
public class ReceiptDetail implements Serializable {

    private static final long serialVersionUID = 1L;
    @EmbeddedId
    protected ReceiptDetailPK receiptDetailPK;
    @Basic(optional = false)
    @NotNull
    @Column(name = "QUANTITY")
    private int quantity;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Basic(optional = false)
    @NotNull
    @Column(name = "PRICE")
    private BigDecimal price;
    @JoinColumn(name = "PRODUCTID", referencedColumnName = "PRODUCTID", insertable = false, updatable = false)
    @ManyToOne(optional = false)
    private Product product;
    @JoinColumn(name = "RECEIPTID", referencedColumnName = "RECEIPTID", insertable = false, updatable = false)
    @ManyToOne(optional = false)
    private Receipt receipt;

    public ReceiptDetail() {
    }

    public ReceiptDetail(ReceiptDetailPK receiptDetailPK) {
        this.receiptDetailPK = receiptDetailPK;
    }

    public ReceiptDetail(ReceiptDetailPK receiptDetailPK, int quantity, BigDecimal price) {
        this.receiptDetailPK = receiptDetailPK;
        this.quantity = quantity;
        this.price = price;
    }

    public ReceiptDetail(String receiptid, String productid) {
        this.receiptDetailPK = new ReceiptDetailPK(receiptid, productid);
    }

    public ReceiptDetailPK getReceiptDetailPK() {
        return receiptDetailPK;
    }

    public void setReceiptDetailPK(ReceiptDetailPK receiptDetailPK) {
        this.receiptDetailPK = receiptDetailPK;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public Receipt getReceipt() {
        return receipt;
    }

    public void setReceipt(Receipt receipt) {
        this.receipt = receipt;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (receiptDetailPK != null ? receiptDetailPK.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ReceiptDetail)) {
            return false;
        }
        ReceiptDetail other = (ReceiptDetail) object;
        if ((this.receiptDetailPK == null && other.receiptDetailPK != null) || (this.receiptDetailPK != null && !this.receiptDetailPK.equals(other.receiptDetailPK))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.ReceiptDetail[ receiptDetailPK=" + receiptDetailPK + " ]";
    }
    
}
