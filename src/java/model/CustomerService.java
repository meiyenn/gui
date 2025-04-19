
package model;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import java.util.List;
import javax.annotation.Resource;
import javax.persistence.*;

public class CustomerService {

    @PersistenceContext
    EntityManager mgr;
    @Resource
    Query query;

    public CustomerService(EntityManager mgr) {
        this.mgr = mgr;
    }

    public boolean addCust(Customer cust) {
        mgr.persist(cust);
        return true;
    }
    
    public boolean delCust(Customer cust) {
        mgr.remove(cust);
        return true;
    }
    
    public boolean updateCust(Customer cust) {
        mgr.merge(cust);
        return true;
    }

    public Customer findCustByCode(String Custid) {
        Customer cust = mgr.find(Customer.class, Custid);
        return cust;
    }
    
    public Customer findEmail(String email) {
        Customer cust = (Customer) mgr.createNamedQuery("Customer.findByCustemail").setParameter("email", email).getSingleResult();
        return cust;
    }

    public String findLastCustomerId() {
        String lastId;
        try {
            lastId = (String) mgr.createQuery("SELECT u.custid FROM Customer u ORDER BY u.custid DESC").setMaxResults(1).getSingleResult();
        } catch (NoResultException ex) {
            lastId = "";
        }
        return lastId;
    }
    
    public List<Customer> findCustomerById(String custId) {
        List CustomerResult = mgr.createNamedQuery("Customer.findByCustid").setParameter("custId", custId).getResultList();
        return CustomerResult;
    }
    
    public List<Customer> findCustomerByEmail(String email) {
        List emailList = mgr.createNamedQuery("Customer.findByCustemail").setParameter("email", email).getResultList();
        return emailList;
    }

    public List<Customer> findAll() {
        List CustomerList = mgr.createNamedQuery("Cust.findAll").getResultList();
        return CustomerList;
    }

}
