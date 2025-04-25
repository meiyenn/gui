<%-- 
    Document   : OrderDetails
    Created on : Apr 20, 2025, 5:18:19 PM
    Author     : Huay
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Cart, model.Product, model.Receipt, java.util.List" %>
<%
    List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");
    Receipt receipt = (Receipt) request.getAttribute("receipt");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Order Details</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 30px;
        }
        .container {
            max-width: 800px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
        }
        h2 {
            margin-top: 0;
            color: #333;
        }
        .receipt-info {
            margin-bottom: 20px;
        }
        .item {
            border-bottom: 1px solid #eee;
            padding: 15px 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .item-details {
            flex: 1;
        }
        .item-title {
            font-weight: bold;
            font-size: 16px;
            color: #333;
        }
        .item-sub {
            font-size: 14px;
            color: #666;
        }
        .review-btn {
            padding: 6px 12px;
            font-size: 13px;
            background-color: #3b82f6;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .review-btn:hover {
            background-color: #2563eb;
        }
        .total {
            margin-top: 30px;
            font-size: 18px;
            font-weight: bold;
            text-align: right;
            color: #333;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Order Receipt</h2>

    <div class="receipt-info">
        <p><strong>Receipt ID:</strong> <%= receipt != null ? receipt.getReceiptid() : "Unavailable" %></p>
        <p><strong>Date:</strong> <%= receipt != null ? receipt.getCreationtime() : "Unavailable" %></p>
    </div>

    <% 
        BigDecimal grandTotal = BigDecimal.ZERO;
        if (cartItems != null && !cartItems.isEmpty()) {
            for (Cart item : cartItems) {
                Product product = item.getProductid();
                BigDecimal itemTotal = item.getPrice().multiply(BigDecimal.valueOf(item.getQuantitypurchased()));
                grandTotal = grandTotal.add(itemTotal);
    %>
        <div class="item">
            <div class="item-details">
                <div class="item-title"><%= product != null ? product.getProductname() : "Unknown Product" %></div>
                <div class="item-sub">Quantity: <%= item.getQuantitypurchased() %></div>
                <div class="item-sub">Price: RM <%= String.format("%.2f", item.getPrice()) %></div>
                <div class="item-sub">Subtotal: RM <%= String.format("%.2f", itemTotal) %></div>
            </div>
            <a class="review-btn" href="AddReview.jsp?productId=<%= product != null ? product.getProductid() : "" %>">Write Review</a>
        </div>
    <% 
            }
        } else {
    %>
        <p>No items found for this receipt.</p>
    <% } %>

    <div class="total">
        Grand Total: RM <%= String.format("%.2f", grandTotal) %>
    </div>
</div>
</body>
</html>
