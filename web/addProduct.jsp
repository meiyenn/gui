<%-- 
    Document   : addProduct
    Created on : Apr 13, 2025, 4:41:05 PM
    Author     : Mei Yen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Product"%>
<%@page import="model.ProductDa"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Product</title>
        
        <style>
            body{
                background-color: #f9f9f9;
            }
            
            .form-container{
                width: 500px;
                margin: 100px auto;
                padding: 40px;
                border: 2px solid #ccc;
                background-color: white;
            }
            
            input[type=text],input[type=number], select, textarea {
                width: 95%;
                padding: 12px;
                border: 1px solid #ccc;
                border-radius: 4px;
                resize: vertical;
            }
            
            select{
                width: 100%;
                padding: 12px;
                border: 1px solid #ccc;
                border-radius: 4px;
                resize: vertical;
            }
            
            label{
                margin: 12px 12px 10px 0;
                display: inline-block;
            }
            
            
            
        </style>
    </head>
    <body>
        
        <div class="form-container">
            
            <h1>Add Product</h1>
            <form action="AddProdServlet" id="prodForm" enctype="multipart/form-data" method="post">

                <% ProductDa pda = new ProductDa();%>
                <label for="prodId">Product ID:</label>
                <input type="text" id="prodId" name="prodId" value="<%=pda.autoProdId()%>" required maxlength="15" readonly></br>

                <label for="prodName">Name:</label>
                <input type="text" id="prodName" name="prodName" required maxlength="50"></br>

                <label for="prodPrice">Price:</label>
                <input type="number" id="prodPrice" name="prodPrice" min="1" max="5000" step=any required></br>

                <label for="prodStock">Stock:</label>
                <input type="number" id="prodStock" name="prodStock" min="1" max="5000" step=any required></br>

                <label for="prodCat">Category</label>
                <select id="prodCat" name="prodCat">
                    <option disabled selected value>Choose an option</option>
                    <option value="Make Up">Make Up</option>
                    <option value="Skincare">Skincare</option>
                </select></br>

                <label for="prodDesc">Description:</label>
                <textarea id="prodDesc" name="prodDesc"></textarea></br>

                <label for="prodStatus">Status:</label>
                <select id="prodStatus" name="prodStatus">
                    <option disabled selected value>Choose an option</option>
                    <option value="1">Show</option>
                    <option value="2">Hide</option>
                </select></br>

                <label for="prodImage">Upload Product Image:</label></br>
                <input type="file" id="prodImage" name="prodImage" accept="image/png, image/gif, image/jpeg"></br></br>

                <input type="reset" value="RESET">
                <input type="submit" value="ADD PRODUCT">


            </form>
        </div>

    </body>
</html>
