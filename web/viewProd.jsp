<%-- 
    Document   : viewProd
    Created on : Apr 15, 2025, 9:44:02 PM
    Author     : Mei Yen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Product"%>
<%@page import="model.ProductDa"%>
<%@include file="staffHeader.jsp" %>
<%--set session for admin and staff--%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product Listing</title>
        <style>
            
            .content-area {
                flex: 2;
                padding: 10px;
                width:100%;
                margin-left: 250px;
                margin-right: 50px;
            }
            
            table {
                font-family: arial, sans-serif;
                border-collapse: collapse;
                width: 100%;
                
              }
              
              thead{
                  background-color: #f2f2f2;
                  font-weight: bold;
              }

              td, th {
                border: 1px solid #dddddd;
                text-align: left;
                padding: 8px;
              }

              .edit-btn{
                background-color:#8cd98c;
                color:#ffffff;
                border: 1px solid green;
                padding: 10px 20px;
                text-align: center;
                text-decoration: none;
                font-weight: bold;
                display: inline-block;
              }
              
              .delete-btn{
                background-color:#ff704d;
                color:#ffffff;
                border: 1px solid green;
                padding: 10px 20px;
                text-align: center;
                text-decoration: none;
                font-weight: bold;
                display: inline-block;
              }

              .search{
                display: flex;
                justify-content: flex-end;
                margin-bottom: 15px;
              }
              
              
              #searchText{
                height:30px;
              }
              
              #search-btn,#filter{
                height:35px;
              }
              
              .addProd{
                background-color:#5c85d6;
                color:#ffffff;
                border: 1px solid green;
                padding: 10px 20px;
                text-align: center;
                text-decoration: none;
                font-weight: bold; 
                display: inline-block;
                align-items: center;
                justify-content: center;
                height: 30px;
              }
              
            .filter {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

              
        </style>
    </head>
    <body>
        <div class="content-area">
        <h1>Product Management</h1>

        <%--filter--%>
        <div class="filter">
            
        <%--add prod button--%>
        <div style="text-align: center; margin-bottom: 20px;display: inline-block; align-items: center; justify-content: center;">
        <a href="addProduct.jsp" class="addProd">Add Product</a>
        </div>
        
            <div class="search">
                <form action="FilterServlet" method="post">

                    <select name="filter" id="filter" required>
                        <option value="" disabled selected hidden>Filter By</option>
                        <option value=0>No Filter</option>
                        <option value=1>Product ID</option>
                        <option value=2>Name</option>
                        <option value=3>Categories</option>
                        
                    </select>
                    
                    <input type="text" id="searchText" name="searchText" placeholder="Search for products...">
                    <input type="submit" id="search-btn" name="search" value="Search">
                </form>
            </div>
        </div>
        <%--end filter--%>
        
        <table>
            
            <thead>
                <tr style="height:70px">
                  <th>&nbsp;</th>
                  <th>Image</th>
                  <th>ID</th>
                  <th>Name</th>
                  <th>Unit Price</th>
                  <th>Available Stock</th>
                  <th>Category</th>
                  <th>Product Description</th>
                  <th>Status</th>
                  <th colspan="2">Actions</th>
                </tr>
            </thead>
            
            <%--product list get from add prod servlet to list down all the product--%>
            <% 
                List<Product> displayList = null;

                List<Product> filterList = (List<Product>) session.getAttribute("filterList");
                List<Product> prodList = (List<Product>) session.getAttribute("prodList");

                if (filterList != null) {
                    displayList = filterList;
                } else if (prodList != null) {
                    displayList = prodList;
                } else { //if session is null redirect to servlet to get session for product
                    // Redirect to the session from servlet
                    response.sendRedirect("AddProdServlet"); //view product get method at addprodservlet
                }
            %>
            
            <%--<%
                ProductDa pda=new ProductDa();
                List<Product> prodList = pda.getAllProd();
                List<Product> filterList = (List<Product>) session.getAttribute("filterList");
                
                if (filterList == null) { //no search are perform
                    filterList = prodList;
                }
            %>--%>
            
            
            <% if (displayList == null || displayList.isEmpty()) { %>
                <tr>
                    <td colspan="12" style="text-align:center; font-weight:bold; color:#808080;">
                        No Record found!
                    </td>
                </tr>
            <% } else { %>
            
            <% for(Product prod : displayList){ %>
            <tr>
                <td>&nbsp;</td>
                <td><img src="imgUpload/<%=prod.getImglocation()%>" alt="<%=prod.getImglocation()%>" border=1 height=150 width=150></img><br></td>
                <td><%=prod.getProductid()%></td>
                <td><%=prod.getProductname()%></td>
                <td><%=prod.getPrice()%></td>
                <td><%=prod.getQuantity()%></td>
                <td><%=prod.getCategory()%></td>
                <td><%=prod.getProductdescription()%></td>
                
                <td>
                    <form action="EditStatus" method="post">
                        <input type="hidden" value="<%=prod.getProductid()%>" name="prodId">
                        <input type="hidden" value="<%=prod.getStatus()%>" name="prodStatus">
                        <input type="submit" class="status-btn" value="<%=prod.getStatus() == 1 ? "Show" : "Hide" %>">
                    </form>
                </td>
                
                <td>&nbsp;<a href="EditProdServlet?prodId=<%=prod.getProductid()%>" class="edit-btn">Edit</a>&nbsp;</td>
                <%--<td>&nbsp;<a href="DeleteProdServlet?prodId=<%=prod.getProductid()%>" class="delete-btn">Delete</a>&nbsp;</td>--%>
                <td>&nbsp;<a href="#" onclick="confirmDelete('<%=prod.getProductid()%>')" class="delete-btn">Delete</a>&nbsp;</td>
            </tr>
            <%}%>
            <% } %>


        </table>
            
        <script type="text/javascript">
        function confirmDelete(productId) {
            if (confirm("Are you sure you want to delete this product?")) {
                // If confirmed, redirect to the delete servlet
                window.location.href = "DeleteProdServlet?prodId=" + productId;
            }
        }
        </script>
        </div>
    </body>
</html>
