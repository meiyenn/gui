<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Customer, model.CustomerService" %>
<%
    String custId = request.getParameter("custId");
    Customer cust = null;

    if (custId != null) {
        try {
            CustomerService service = new CustomerService();
            cust = service.getCustomerById(custId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Customer</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 40px;
        }

        .container {
            max-width: 700px;
            margin: auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 12px rgba(0,0,0,0.1);
        }

        h2 {
            color: #2c3e50;
            text-align: center;
        }

        label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }

        input {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            box-sizing: border-box;
        }

        button {
            margin-top: 20px;
            padding: 10px 18px;
            background-color: #0277bd;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        button:hover {
            background-color: #01579b;
        }
    </style>

    <script>
        function confirmUpdate() {
            return confirm("Are you sure you want to update this customer?");
        }
    </script>
</head>
<body>
    <div class="container">
        <h2>Edit Customer</h2>
        <% if (cust == null)
                out.println("<p style='color:red;'>Customer not loaded. custId param: " + request.getParameter("custId") + "</p>");%>

        <form action="EditCustomerByAdmin" method="post" onsubmit="return confirmUpdate();">
            <input type="hidden" name="custId" value="<%= cust != null ? cust.getCustid() : "" %>">

            <label>Name:</label>
            <input type="text" name="custName" value="<%= cust != null ? cust.getCustname() : "" %>" required>

            <label>Contact No:</label>
            <input type="text" name="custContactNo" value="<%= cust != null ? cust.getCustcontactno() : "" %>" required>

            <label>Email:</label>
            <input type="email" name="custEmail" value="<%= cust != null ? cust.getCustemail() : "" %>" required>

            <label>Username:</label>
            <input type="text" name="custUserName" value="<%= cust != null ? cust.getCustusername() : "" %>" required>

            <label>Password:</label>
            <input type="text" name="custPswd" value="<%= cust != null ? cust.getCustpswd() : "" %>" required>

            <button type="submit">Update Customer</button>
            <button type="button" onclick="window.location.href='CustomerManagement.jsp'">Back</button>
        </form>
    </div>
</body>
</html>
