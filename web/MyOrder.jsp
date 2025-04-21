<%-- 
    Document   : MyOrder
    Created on : Apr 20, 2025, 8:35:32 PM
    Author     : Huay
--%>

<%@ page import="model.CartService" %>
<%@ page import="model.Receipt" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="header.jsp" %>

<%
    String custId = (String) session.getAttribute("custId");
    if (custId == null) {
        response.sendRedirect("CustomerLogin.jsp");
        return;
    }

    CartService cartService = new CartService();
    List<Receipt> receiptList = cartService.getReceiptsByCustomer(custId);
%>

<html>
<head>
    <title>My Orders</title>
    <style>
        body { 
            font-family: Arial; 
            padding: 20px; 
        }
        h2 { 
            text-align: center; 
        }
        table { 
            width: 80%; 
            margin: auto; 
            border-collapse: collapse; 
        }
        th, td { 
            padding: 10px; 
            border: 1px solid #ccc; 
            text-align: center; 
        }
        th { 
            background-color: #f2f2f2; 
        }
        .btn { 
            background-color: #3498db; 
            color: white; 
            padding: 6px 12px; 
            border: none; 
            cursor: pointer; 
        }
        .btn:hover { 
            background-color: #2980b9; 
        }
    </style>
</head>
<body>

<h2>My Orders</h2>

<% if (receiptList != null && !receiptList.isEmpty()) { %>
<table>
    <tr>
        <th>Receipt ID</th>
        <th>Date</th>
        <th>Action</th>
    </tr>

    <% for (Receipt r : receiptList) { %>
    <tr>
        <td><%= r.getReceiptid() %></td>
        <td><%= r.getCreationtime() %></td>
        <td>
            <form action="ViewOrder.jsp" method="get">
                <input type="hidden" name="receiptId" value="<%= r.getReceiptid() %>">
                <button type="submit" class="btn">View Details</button>
            </form>
        </td>
    </tr>
    <% } %>
</table>
<% } else { %>
    <p style="text-align:center; color: gray;">You have no past orders.</p>
<% } %>

</body>
</html>

