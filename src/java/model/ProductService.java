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

public class ProductService {

    public Product getProductById(String productId) {
        Product product = null;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement("SELECT * FROM product WHERE productId = ?")) {

            stmt.setString(1, productId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                product = new Product();
                product.setProductid(rs.getString("productId"));
                product.setProductname(rs.getString("productName"));
                product.setImglocation(rs.getString("imgLocation"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setCategory(rs.getString("category"));
                // Add more if needed
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return product;
    }
}
