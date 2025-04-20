<%-- 
    Document   : editProd
    Created on : Apr 16, 2025, 11:34:53 PM
    Author     : Mei Yen
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Product" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update Product</title>
    </head>
    <body>
        <h1>Update Product</h1>
        <%Product prod = (Product) session.getAttribute("editProd");%>
        

        <form action="EditProdServlet" id="editProdServlet" enctype="multipart/form-data" method="post">
            <%--show prod image--%>
            <div class="left">
            <p>Current Image<br>
            <img src="imgUpload/<%=prod.getImglocation()%>" alt="Current Image" border=3 height=100 width=300></img><br><%=prod.getProductid()%><%=prod.getImglocation()%></td>
            </p>
            
            <label for="prodImage">Upload New Image of Product:</label>
            <span>   ***Original product image will be replace by new uploaded image</span></br>
            <input type="file" id="prodImage" name="prodImage" accept="image/png, image/gif, image/jpeg"></br></br>
            </div>
            
            <%-- when user doesn't upload anything --%>
            <input type="hidden" id="oldProdImage" name="oldProdImage" value="<%=prod.getImglocation()%>">

            <%--input field--%>
            <div class="right">
            <label for="prodId">Product ID:</label>
            <input type="text" id="prodId" name="prodId" value="<%=prod.getProductid()%>" required maxlength="15" readonly></br>
            
            <label for="prodName">Name:</label>
            <input type="text" id="prodName" name="prodName" value="<%=prod.getProductname()%>" required maxlength="50"></br>
            
            <label for="prodPrice">Price:</label>
            <input type="number" id="prodPrice" name="prodPrice" value="<%=prod.getPrice()%>" min="1" max="5000" step=any required></br>
            
            <label for="prodStock">Stock:</label>
            <input type="number" id="prodStock" name="prodStock" value="<%=prod.getQuantity()%>" min="1" max="5000" step=any required></br>
            
            <label for="prodCat">Category</label>
            <select id="prodCat" name="prodCat">
                <option value="Make Up" <%= "Make Up".equals(prod.getCategory()) ? "selected" : "" %>>Make Up</option>
                <option value="Skincare" <%= "Skincare".equals(prod.getCategory()) ? "selected" : "" %>>Skincare</option>

            </select></br>
            
            <label for="prodDesc">Description:</label>
            <textarea id="prodDesc" name="prodDesc"><%=prod.getProductdescription()%></textarea></br>
            
            <label for="prodStatus">Status:</label>
            <select id="prodStatus" name="prodStatus">
                <option value="1" <%= prod.getStatus() == 1 ? "selected" : "" %>>Show</option>
                <option value="2" <%= prod.getStatus() == 2 ? "selected" : "" %>>Hide</option>
            </select></br>

            <input type="reset" value="RESET">
            <input type="submit" value="UPDATE">
            </div>
            
        </form>

    </body>
</html>
