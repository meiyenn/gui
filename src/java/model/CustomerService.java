/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Huay
 */

import controller.DBConnection;
import java.sql.*;
import java.util.*;

public class CustomerService {
    public void insertCustomer(Customer cust) throws Exception {
        String sql = "INSERT INTO customer VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, cust.getCustid());
            stmt.setString(2, cust.getCustname());
            stmt.setString(3, cust.getCustcontactno());
            stmt.setString(4, cust.getCustemail());
            stmt.setString(5, cust.getCustusername());
            stmt.setString(6, cust.getCustpswd());
            stmt.executeUpdate();
        }
    }

    public void updateCustomer(Customer cust) throws Exception {
        String sql = "UPDATE customer SET custName=?, custContactNo=?, custEmail=?, custUserName=?, custPswd=? WHERE custId=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, cust.getCustname());
            stmt.setString(2, cust.getCustcontactno());
            stmt.setString(3, cust.getCustemail());
            stmt.setString(4, cust.getCustusername());
            stmt.setString(5, cust.getCustpswd());
            stmt.setString(6, cust.getCustid()); 
            stmt.executeUpdate();
        }
    }

    public Customer getCustomerById(String custId) throws Exception {
        String sql = "SELECT * FROM customer WHERE custId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, custId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Customer cust = new Customer();
                cust.setCustid(rs.getString("custId"));
                cust.setCustname(rs.getString("custName"));
                cust.setCustcontactno(rs.getString("custContactNo"));
                cust.setCustemail(rs.getString("custEmail"));
                cust.setCustusername(rs.getString("custUserName"));
                cust.setCustpswd(rs.getString("custPswd"));
                return cust;
            }
        }
        return null;
    }
    
    public String generateNextCustomerId(Connection conn) throws SQLException {
        String maxCustId = "cus001";
        String sql = "SELECT MAX(custId) FROM customer";
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next() && rs.getString(1) != null) {
                maxCustId = rs.getString(1);
            }
        }
        int nextNum = Integer.parseInt(maxCustId.substring(3)) + 1;
        return "cus" + String.format("%03d", nextNum);
    }

}

