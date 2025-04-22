/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import controller.DBConnection;
import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.swing.*;


/**
 *
 * @author Mei Yen
 */
public class ProductDa {
    private String host = "jdbc:derby://localhost:1527/ass";
    private String user = "nbuser";
    private String password = "nbuser";
    private String tableName = "product";
    private Connection conn;
    private PreparedStatement stmt;
    private Product prod;

    public ProductDa() {
        createConnection(); //call connection
    }
    
     private void createConnection() {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(host, user, password);
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
    }
     
    private void shutDown() {
       if (conn != null) {
           try {
               conn.close();
           } catch (SQLException ex) {
               System.out.println(ex.getMessage());

           }
       }
   }

    public List<Product> getAllProd(){
        List<Product> prodList = new ArrayList<>();

        //Product prod = new Product();
        //prod=null; //initiale value

        try {
                String selectStr = "select * from product";
                stmt = conn.prepareStatement(selectStr);

                ResultSet rs = stmt.executeQuery();

                while(rs.next())
                {
                        Product prod = new Product();
                        prod.setProductid(rs.getString(1));
                        prod.setProductname(rs.getString(2));
                        prod.setImglocation(rs.getString(3));
                        prod.setPrice(rs.getDouble(4));
                        prod.setQuantity(rs.getInt(5));
                        prod.setCategory(rs.getString(6));
                        prod.setProductdescription(rs.getString(7));
                        prod.setStatus(rs.getInt(8));
                        prodList.add(prod);

                }

                }catch (Exception e) {
                        System.out.println(e.getMessage());
                }

                return prodList;
        }
    
    //get product based on id
    //check exist
    //the list only contain 1 prod if based on id
    public Product checkExist(String id){
        //Product prodList = new Product();
        Product prod = new Product();
        prod=null;
        
        try {
            String queryStr="SELECT * FROM product WHERE productId=?";

            stmt = conn.prepareStatement(queryStr);
            stmt.setString(1,id);
            ResultSet rs = stmt.executeQuery();
                
            if(rs.next()){
                prod = new Product();

                prod.setProductid(rs.getString(1));
                prod.setProductname(rs.getString(2));
                prod.setImglocation(rs.getString(3));
                prod.setPrice(rs.getDouble(4));
                prod.setQuantity(rs.getInt(5));
                prod.setCategory(rs.getString(6));
                prod.setProductdescription(rs.getString(7));
                prod.setStatus(rs.getInt(8));
                
            }

        }catch (Exception e) {
                System.out.println(e.getMessage());
        }

        return prod;
        
        
    }
    
    public boolean addProduct(Product prod){
        boolean insertStatus=false;
        
        try {
            String addStr="insert into product values(?,?,?,?,?,?,?,?)";

            //check prod exist before proceed
            Product prodExist=new Product();
            prodExist=checkExist(prod.getProductid());
            
            if(prodExist==null){ //product no exist
                stmt = conn.prepareStatement(addStr);

                stmt.setString(1, prod.getProductid());
                stmt.setString(2, prod.getProductname());
                stmt.setString(3, prod.getImglocation());
                stmt.setDouble(4, prod.getPrice());
                stmt.setInt(5, prod.getQuantity());
                stmt.setString(6, prod.getCategory());
                stmt.setString(7, prod.getProductdescription());
                stmt.setInt(8, prod.getStatus());
                stmt.executeUpdate();
                
                insertStatus=true;
            }else{
                insertStatus=false;
            }
            
            


        }catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return insertStatus;
    }
    
    public String autoProdId(){
        int idDigit=0;
        String numPart="0";
        String prodId="";

        try {
            String findMaxId="SELECT MAX(productid) AS maxId FROM product";
            stmt = conn.prepareStatement(findMaxId);

            ResultSet rs = stmt.executeQuery();
            
            while(rs.next()){
                String maxId=rs.getString("maxId");
                
                if (maxId != null) {
                    numPart = maxId.substring(4);
                    idDigit=Integer.parseInt(numPart);
                    idDigit++;
                    prodId=String.format("prod%03d",idDigit);
                }
                
            }
            
            

        }catch (Exception e) {
            System.out.println(e.getMessage());
        }
        
        return prodId;
    }
    
    public List<Product> filterProd(String column, String value){
       List<Product> prodList = new ArrayList<>();

        //Product prod = new Product();
        //prod=null; //initiale value

        try {
            String selectStr = "select * from product where lower("+column+") like ?";
            stmt = conn.prepareStatement(selectStr);
            stmt.setString(1, "%" + value.toLowerCase() + "%");

            ResultSet rs = stmt.executeQuery();

            while(rs.next())
            {
                    Product prod = new Product();
                    prod.setProductid(rs.getString(1));
                    prod.setProductname(rs.getString(2));
                    prod.setImglocation(rs.getString(3));
                    prod.setPrice(rs.getDouble(4));
                    prod.setQuantity(rs.getInt(5));
                    prod.setCategory(rs.getString(6));
                    prod.setProductdescription(rs.getString(7));
                    prod.setStatus(rs.getInt(8));
                    prodList.add(prod);

            }

            }catch (Exception e) {
                    System.out.println(e.getMessage());
            }

            return prodList;
    }
    
    public boolean isProdInUse(String prodId){

        try {
            String countInUse="SELECT COUNT(*) FROM cart WHERE productid = ?"; 
            //count how many time this prod id appear in cart table

            stmt = conn.prepareStatement(countInUse);
            stmt.setString(1,prodId);
            ResultSet rs = stmt.executeQuery();
                
            if(rs.next()){
                int count = rs.getInt(1);//get value of first column
                if(count>0){
                    return true;
                }
                
            }

        }catch (Exception e) {
                System.out.println(e.getMessage());
        }

        return false;

    }
    
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
                product.setPrice(rs.getBigDecimal("price").doubleValue());
                product.setCategory(rs.getString("category"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return product;
    }
    
    
//    //testing
//    public static void main(String[] args) {
//        
//        List<Product> prod=new ArrayList<>();
//        ProductDa pda=new ProductDa();
////        //get all prod()
////        prod=pda.getAllProd();
////        for (Product p : prod) {
////            System.out.println(p);  // Automatically calls toString()
////        }
////        //end
//        
////        //checkExist
////        Product prod2=new Product();
////        prod2=pda.checkExist("prod002");
////        System.out.println(prod2.getProductid()+prod2.getProductname());
////        //end
//        
////        //add prod ()
////        Product p=new Product("123", "123", "testing", 55.5, 100,"Skincare", "a", 1);
////        boolean addStatus=pda.addProduct(p);
////        System.out.println(addStatus);
//
//        //System.out.println(pda.autoProdId());
//        
////                //filterprod()
////        prod=pda.filterProd("category","ake up");
////        for (Product p : prod) {
////            System.out.println(p);  // Automatically calls toString()
////        }
////        //end
//
//        //is in use()
//        boolean checkInUse=pda.isProdInUse("prod003");
//        System.out.println(checkInUse);
//        
//    }


}
