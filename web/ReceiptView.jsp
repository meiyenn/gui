<%@ page import="java.util.*, java.math.BigDecimal" %>
<%@ page import="model.CartService, model.CartItem, model.Product, model.Receipt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String receiptId = request.getParameter("receiptId");
    Receipt receipt = null;
    List<CartItem> items = null;

    if (receiptId != null && !receiptId.trim().isEmpty()) {
        CartService cartService = new CartService();
        receipt = cartService.getReceiptById(receiptId);
        items = cartService.getCartItemsByReceiptId(receiptId);
    }

    // Get customer info from session
    String fullName = (String) session.getAttribute("fullName");
    String email = (String) session.getAttribute("email");
    String phone = (String) session.getAttribute("phone");
    String paymentMethod = (String) session.getAttribute("paymentMethod");
    String deliveryMethod = (String) session.getAttribute("deliveryMethod");
    String street = (String) session.getAttribute("street");
    String city = (String) session.getAttribute("city");
    String postalCode = (String) session.getAttribute("postalCode");
    String state = (String) session.getAttribute("state");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Receipt Details</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f3f4f6;
            padding: 40px;
        }
        .receipt-container {
            background: white;
            max-width: 800px;
            margin: auto;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            text-align: center;
            color: #111827;
        }
        .section {
            margin-bottom: 20px;
        }
        .section div {
            margin-bottom: 5px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th, td {
            padding: 12px;
            border-bottom: 1px solid #e5e7eb;
            text-align: left;
        }
        th {
            background-color: #f3f4f6;
        }
        .totals {
            text-align: right;
            margin-top: 20px;
        }
        .totals div {
            margin: 5px 0;
        }
        .btn {
            display: block;
            width: fit-content;
            margin: 30px auto 0;
            background: #2563eb;
            color: white;
            padding: 10px 25px;
            text-decoration: none;
            border-radius: 6px;
            transition: background 0.2s ease-in-out;
        }
        .btn:hover {
            background: #1d4ed8;
        }
    </style>
</head>
<body>
<div class="receipt-container">
    <h1>Receipt</h1>

    <% if (receipt != null) { %>
        <div class="section">
            <div><strong>Receipt ID:</strong> <%= receipt.getReceiptid() %></div>
            <div><strong>Date:</strong> <%= receipt.getCreationtime() %></div>
            <div><strong>Voucher Used:</strong> <%= receipt.getVoucherCode() != null ? receipt.getVoucherCode() : "N/A" %></div>
        </div>

        <div class="section">
            <h3>Customer Info</h3>
            <div><strong>Name:</strong> <%= fullName %></div>
            <div><strong>Email:</strong> <%= email %></div>
            <div><strong>Phone:</strong> <%= phone %></div>
            <div><strong>Payment Method:</strong> <%= paymentMethod %></div>
            <div><strong>Delivery Method:</strong> <%= deliveryMethod %></div>
            <% if ("delivery".equalsIgnoreCase(deliveryMethod)) { %>
                <div><strong>Shipping Address:</strong></div>
                <div style="margin-left: 15px;">
                    <div><%= street %></div>
                    <div><%= city %>, <%= postalCode %></div>
                    <div><%= state %></div>
                </div>
            <% } %>
        </div>

        <table>
            <thead>
            <tr>
                <th>Product</th>
                <th>Qty</th>
                <th>Unit Price (RM)</th>
                <th>Total (RM)</th>
            </tr>
            </thead>
            <tbody>
            <%
                for (CartItem item : items) {
                    Product product = item.getProductid();
                    int qty = item.getQuantitypurchased();
                    BigDecimal price = item.getPrice();
                    BigDecimal total = price.multiply(BigDecimal.valueOf(qty));
            %>
            <tr>
                <td><%= product.getProductname() %></td>
                <td><%= qty %></td>
                <td><%= String.format("%.2f", price) %></td>
                <td><%= String.format("%.2f", total) %></td>
            </tr>
            <% } %>
            </tbody>
        </table>

        <div class="totals">
            <div><strong>Subtotal:</strong> RM <%= String.format("%.2f", receipt.getSubtotal()) %></div>
            <div><strong>Discount:</strong> -RM <%= String.format("%.2f", receipt.getDiscount()) %></div>
            <div><strong>Tax (6%):</strong> RM <%= String.format("%.2f", receipt.getTax()) %></div>
            <div><strong>Shipping:</strong> RM <%= String.format("%.2f", receipt.getShipping()) %></div>
            <div><strong>Total Paid:</strong> <strong>RM <%= String.format("%.2f", receipt.getTotal()) %></strong></div>
        </div>
    <% } else { %>
        <p style="text-align:center; color: red;"> Receipt not found. Please check the receipt ID.</p>
    <% } %>

    <a class="btn" href="index.jsp">Continue Shopping</a>
</div>

<%
    // Clean up session values after rendering
    session.removeAttribute("fullName");
    session.removeAttribute("email");
    session.removeAttribute("phone");
    session.removeAttribute("paymentMethod");
    session.removeAttribute("deliveryMethod");
    session.removeAttribute("street");
    session.removeAttribute("city");
    session.removeAttribute("postalCode");
    session.removeAttribute("state");
%>
</body>
</html>
