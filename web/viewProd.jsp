<%-- 
    Document   : viewProd
    Created on : Apr 15, 2025, 9:44:02 PM
    Author     : Mei Yen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Product"%>
<%--set session for admin and staff--%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product Listing</title>
        <style>
            table {
                font-family: arial, sans-serif;
                border-collapse: collapse;
                width: 100%;
              }
              
              thead{
                  background-color: #bbd2ed;
                  font-weight: bold;
              }

              td, th {
                border: 1px solid #dddddd;
                text-align: left;
                padding: 8px;
              }
              
              
              
            
        </style>
    </head>
    <body>
        <h1>Product Listing</h1>
        <table>
            
            <thead>
                <tr>
                  <th>&nbsp;</th>
                  <th>Image</th>
                  <th>ID</th>
                  <th>Name</th>
                  <th>Unit Price</th>
                  <th>Available Stock</th>
                  <th>Category</th>
                  <th>Product Description</th>
                  <th>Status</th>
                  <th colspan="3">Actions</th>
                </tr>
            </thead>
            
            <%--product list get from add prod servlet to list down all the product--%>
            <% List<Product> prodList = (List) session.getAttribute("prodList");%>
            
            <% for(Product prod : prodList){ %>
            <tr>
                <td>&nbsp;</td>
                <td><img src="imgUpload/<%=prod.getImglocation()%>" alt="<%=prod.getImglocation()%>" border=3 height=100 width=300></img><br><%=prod.getProductid()%><%=prod.getImglocation()%></td>
                <td><%=prod.getProductid()%></td>
                <td><%=prod.getProductname()%></td>
                <td><%=prod.getPrice()%></td>
                <td><%=prod.getQuantity()%></td>
                <td><%=prod.getCategory()%></td>
                <td><%=prod.getProductdescription()%></td>
                <td><%=prod.getStatus()%></td>
                <td>&nbsp;<a href="EditProdServlet?prodId=<%=prod.getProductid()%>">Edit</a>&nbsp;</td>
                <td>&nbsp;<a href="DeleteProdServlet?prodId=<%=prod.getProductid()%>">Delete</a>&nbsp;</td>
            </tr>
            <%}%>

        </table>
    </body>
</html>
