<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Product"%>
<%@page import="model.ProductDa"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Product</title>
        
        <!-- Add Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        
        <style>
            body{
                background-color: #f9f9f9;
            }
            
            .form-container{
                width: 600px;
                margin: 100px auto;
                padding: 40px;
                border: 1px solid #ccc;
                background-color: white;
                box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
            }
            
            input[type=text],input[type=number], select, textarea {
                width: 95%;
                padding: 12px;
                border: 1px solid #ccc;
                border-radius: 3px;
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
            
            input[type="submit"],
            input[type="reset"]{
                width:49%;
                margin:15px 0px;
                box-sizing:border-box;
                height:50px;
                font-weight: bold;
                font-size: 20px;
                background-color: #e3e1e1;
                border: none;
                color: #595959;
            }

            .shadow:hover {
                box-shadow: 0 12px 16px 0 rgba(0,0,0,0.24),0 17px 50px 0 rgba(0,0,0,0.19);
            }
            
            /* Modal styling to match your design */
            #addProductModal .modal-content {
                border: 1px solid #ccc;
                background-color: #f9f9f9;
                box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
            }
            
            #addProductModal .modal-body {
                background-color: white;
                padding: 20px 40px;
            }
            
            #addProductModal .modal-dialog {
                max-width: 680px;
                margin-top: 50px;
            }
            
            /* Hide the regular form container */
            #regularForm {
                display: none;
            }
        </style>
    </head>
    <body>
        <!-- Regular form (hidden by default) -->
        <div class="form-container" id="regularForm">
            <h1>Add Product</h1>
            <form action="AddProdServlet" id="prodForm" enctype="multipart/form-data" method="post">
                <!-- Form content here (unchanged) -->
            </form>
        </div>

        <!-- Bootstrap Modal with your form -->
        <div class="modal fade" id="addProductModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="addProductModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="addProductModalLabel">Add Product</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="AddProdServlet" id="modalProdForm" enctype="multipart/form-data" method="post">
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
                            <select id="prodCat" name="prodCat" required>
                                <option value="" selected disabled>Choose an option</option>
                                <option value="Make Up">Make Up</option>
                                <option value="Skincare">Skincare</option>
                            </select></br>

                            <label for="prodDesc">Description:</label>
                            <textarea id="prodDesc" name="prodDesc" required></textarea></br>

                            <label for="prodStatus">Status:</label>
                            <select id="prodStatus" name="prodStatus" required>
                                <option value="" selected disabled>Choose an option</option>
                                <option value="1">Show</option>
                                <option value="0">Hide</option>
                            </select></br>

                            <label for="prodImage">Upload Product Image:</label></br>
                            <input type="file" id="prodImage" name="prodImage" accept="image/png, image/gif, image/jpeg" required></br></br>

                            <div>
                                <% String error = request.getParameter("error");
                                    if (error != null) {
                                %>
                                        <p style="color: red;font-size: 20px;font-weight: bold;"><%=error%></p>
                                <%}%>
                            </div>
                            
                            <div style="text-align: center;">
                                <input type="reset" value="RESET" class="shadow">
                                <input type="submit" value="ADD PRODUCT" class="shadow">
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add Bootstrap JS and auto-show modal script -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // When the page loads, automatically show the modal
            document.addEventListener('DOMContentLoaded', function() {
                var addProductModal = new bootstrap.Modal(document.getElementById('addProductModal'));
                addProductModal.show();
                
                // If modal is closed, redirect back to the previous page
                document.querySelector('#addProductModal .btn-close').addEventListener('click', function() {
                    window.history.back();
                });
            });
        </script>
    </body>
</html>