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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Receipt Details</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f8fafc;
            margin: 0;
            padding: 40px 20px;
        }
        .receipt-container {
            background: #ffffff;
            max-width: 850px;
            margin: auto;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
        }
        h1 {
            text-align: center;
            color: #1e293b;
            margin-bottom: 30px;
        }
        .section {
            margin-bottom: 25px;
            color: #334155;
        }
        .section h3 {
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 6px;
            margin-bottom: 12px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        th, td {
            padding: 14px;
            border-bottom: 1px solid #e2e8f0;
            text-align: left;
        }
        th {
            background-color: #f1f5f9;
            color: #1e293b;
            font-weight: 600;
        }
        .totals {
            background: #f9fafb;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 20px;
            margin-top: 30px;
            font-size: 16px;
            color: #1e293b;
        }
        .totals div {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        .totals div:last-child {
            font-weight: bold;
            font-size: 18px;
            color: #111827;
        }
        .btn {
            display: block;
            width: fit-content;
            margin: 40px auto 0;
            background: #3b82f6;
            color: white;
            padding: 12px 30px;
            text-decoration: none;
            border-radius: 6px;
            transition: background 0.2s ease-in-out;
        }
        .btn:hover {
            background: #2563eb;
        }

        @media (max-width: 600px) {
            .receipt-container {
                padding: 20px;
            }
            th, td {
                font-size: 14px;
                padding: 10px;
            }
            .totals div {
                flex-direction: column;
                align-items: flex-start;
            }
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
            <% for (CartItem item : items) {
                Product product = item.getProductid();
                int qty = item.getQuantitypurchased();
                BigDecimal price = item.getPrice();
                BigDecimal rowTotal = price.multiply(BigDecimal.valueOf(qty));
            %>
            <tr>
                <td><%= product.getProductname() %></td>
                <td><%= qty %></td>
                <td><%= String.format("%.2f", price) %></td>
                <td><%= String.format("%.2f", rowTotal) %></td>
            </tr>
            <% } %>
            </tbody>
        </table>

        <div class="totals">
            <div><span>Subtotal:</span> <span>RM <%= String.format("%.2f", receipt.getSubtotal()) %></span></div>
            <% if (receipt.getDiscount() != null && receipt.getDiscount().compareTo(BigDecimal.ZERO) > 0) { %>
                <div><span>Discount:</span> <span style="color:red;">- RM <%= String.format("%.2f", receipt.getDiscount()) %></span></div>
            <% } %>
            <div><span>Tax (6%):</span> <span>RM <%= String.format("%.2f", receipt.getTax()) %></span></div>
            <div><span>Shipping:</span> <span>RM <%= String.format("%.2f", receipt.getShipping()) %></span></div>
            <div><span>Total Paid:</span> <span><strong>RM <%= String.format("%.2f", receipt.getTotal()) %></strong></span></div>
        </div>

    <% } else { %>
        <p style="text-align:center; color: red;">Receipt not found. Please check the receipt ID.</p>
    <% } %>

    <a class="btn" href="index.jsp">Continue Shopping</a>
</div>

<%
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
