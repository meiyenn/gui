/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

/**
 *
 * @author Huay
 */
@Embeddable
public class ReceiptDetailPK implements Serializable {

    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 7)
    @Column(name = "RECEIPTID")
    private String receiptid;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 7)
    @Column(name = "PRODUCTID")
    private String productid;

    public ReceiptDetailPK() {
    }

    public ReceiptDetailPK(String receiptid, String productid) {
        this.receiptid = receiptid;
        this.productid = productid;
    }

    public String getReceiptid() {
        return receiptid;
    }

    public void setReceiptid(String receiptid) {
        this.receiptid = receiptid;
    }

    public String getProductid() {
        return productid;
    }

    public void setProductid(String productid) {
        this.productid = productid;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (receiptid != null ? receiptid.hashCode() : 0);
        hash += (productid != null ? productid.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ReceiptDetailPK)) {
            return false;
        }
        ReceiptDetailPK other = (ReceiptDetailPK) object;
        if ((this.receiptid == null && other.receiptid != null) || (this.receiptid != null && !this.receiptid.equals(other.receiptid))) {
            return false;
        }
        if ((this.productid == null && other.productid != null) || (this.productid != null && !this.productid.equals(other.productid))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.ReceiptDetailPK[ receiptid=" + receiptid + ", productid=" + productid + " ]";
    }
    
}
