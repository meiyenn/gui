/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.math.BigDecimal;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author Huay
 */
@Entity
@Table(name = "CART_ITEM")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "CartItem.findAll", query = "SELECT c FROM CartItem c"),
    @NamedQuery(name = "CartItem.findByCartitemid", query = "SELECT c FROM CartItem c WHERE c.cartitemid = :cartitemid"),
    @NamedQuery(name = "CartItem.findByQuantitypurchased", query = "SELECT c FROM CartItem c WHERE c.quantitypurchased = :quantitypurchased"),
    @NamedQuery(name = "CartItem.findByPrice", query = "SELECT c FROM CartItem c WHERE c.price = :price")})
public class CartItem implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "CARTITEMID")
    private String cartitemid;
    @Basic(optional = false)
    @NotNull
    @Column(name = "QUANTITYPURCHASED")
    private int quantitypurchased;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Basic(optional = false)
    @NotNull
    @Column(name = "PRICE")
    private BigDecimal price;
    @JoinColumn(name = "CARTID", referencedColumnName = "CARTID")
    @ManyToOne(optional = false)
    private Cart cartid;
    @JoinColumn(name = "PRODUCTID", referencedColumnName = "PRODUCTID")
    @ManyToOne(optional = false)
    private Product productid;

    public CartItem() {
    }

    public CartItem(String cartitemid) {
        this.cartitemid = cartitemid;
    }

    public CartItem(String cartitemid, int quantitypurchased, BigDecimal price) {
        this.cartitemid = cartitemid;
        this.quantitypurchased = quantitypurchased;
        this.price = price;
    }

    public String getCartitemid() {
        return cartitemid;
    }

    public void setCartitemid(String cartitemid) {
        this.cartitemid = cartitemid;
    }

    public int getQuantitypurchased() {
        return quantitypurchased;
    }

    public void setQuantitypurchased(int quantitypurchased) {
        this.quantitypurchased = quantitypurchased;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Cart getCartid() {
        return cartid;
    }

    public void setCartid(Cart cartid) {
        this.cartid = cartid;
    }

    public Product getProductid() {
        return productid;
    }

    public void setProductid(Product productid) {
        this.productid = productid;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (cartitemid != null ? cartitemid.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof CartItem)) {
            return false;
        }
        CartItem other = (CartItem) object;
        if ((this.cartitemid == null && other.cartitemid != null) || (this.cartitemid != null && !this.cartitemid.equals(other.cartitemid))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.CartItem[ cartitemid=" + cartitemid + " ]";
    }
    
}
