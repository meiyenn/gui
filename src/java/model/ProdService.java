/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.List;
import javax.annotation.Resource;
import javax.persistence.PersistenceContext;
import javax.persistence.*;
import javax.transaction.UserTransaction;
import model.Product;
/**
 *
 * @author Mei Yen
 */
public class ProdService {
    @PersistenceContext
    EntityManager em;
    
    @Resource
    UserTransaction utx;
    
    public ProdService(EntityManager em) {
        this.em = em;
    }
    
    // Create
    public void addProduct(Product prod) throws Exception {
        em.persist(prod);
    }

    // find the product based on prod id
    public Product findProduct(String productId) {
        return em.find(Product.class, productId); //return record found - only have 1 result
    }

    // Update
    public void updateProduct(Product updateProd) throws Exception {
        em.merge(updateProd);

    }

    // Delete
    public void deleteProduct(String productId) throws Exception {
        Product prod = findProduct(productId);
        if (prod != null) {//can find the product
            em.remove(prod);
        }
    }
    
    public List<Product> findAll() {
        List prodList = em.createNamedQuery("Product.findAll").getResultList();
        return prodList; //select * from product
    }
    
    public boolean productExists(String productId) {
        Product existProd = findProduct(productId);
        if(existProd!=null){
            return true;
        }
        return false;
  
    }

}
