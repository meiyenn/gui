<%@ page import="model.CartService" %>
<%@ page import="model.CartItem" %>
<%@ page import="model.Product" %>
<%@ page import="model.Receipt" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ include file="header.jsp" %>

<%
    String custId = (String) session.getAttribute("custId");
    if (custId == null) {
        response.sendRedirect("CustomerLogin.jsp");
        return;
    }

    String receiptId = request.getParameter("receiptId");
    CartService cartService = new CartService();
    Receipt receipt = cartService.getReceiptById(receiptId);
    List<CartItem> items = cartService.getCartItemsByReceiptId(receiptId);

    BigDecimal subtotal = BigDecimal.ZERO;
    for (CartItem item : items) {
        subtotal = subtotal.add(item.getPrice().multiply(BigDecimal.valueOf(item.getQuantitypurchased())));
    }

    BigDecimal tax = subtotal.multiply(BigDecimal.valueOf(0.06));
    BigDecimal shipping = subtotal.compareTo(BigDecimal.valueOf(200)) < 0 ? new BigDecimal("10.00") : BigDecimal.ZERO;
    BigDecimal total = subtotal.add(tax).add(shipping);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Order Details</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 20px;
        }
        table {
            width: 80%;
            margin: auto;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ccc;
            text-align: center;
        }
        th {
            background-color: #f8f8f8;
        }
        .total {
            font-weight: bold;
            text-align: right;
            padding-right: 30px;
        }
        h2 {
            text-align: center;
        }
        img {
            max-width: 80px;
        }
        
        .btn-review {
            background-color: #6366f1; /* Tailwind's indigo-500 */
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            border-radius: 8px;
            cursor: pointer;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s ease-in-out;
        }

        .btn-review:hover {
            background-color: #4f46e5; /* Tailwind's indigo-600 */
            transform: translateY(-1px);
            box-shadow: 0 6px 10px rgba(0, 0, 0, 0.15);
        }
    </style>
</head>
<body>

<h2>Order Summary</h2>
<p style="text-align: center;">
    Receipt ID: <strong><%= receipt.getReceiptid() %></strong> |
    Date: <%= receipt.getCreationtime() %>
</p>

<% if (items != null && !items.isEmpty()) { %>
    <table>
        <tr>
            <th>Product</th>
            <th>Price (RM)</th>
            <th>Quantity</th>
            <th>Subtotal (RM)</th>
            <th>Action</th>
        </tr>

        <% for (CartItem item : items) {
            Product product = item.getProductid();
            BigDecimal sub = item.getPrice().multiply(BigDecimal.valueOf(item.getQuantitypurchased()));
        %>
        <tr>
            <td>
                <img src="<%= item.getProductid().getImglocation()%>" width="80"><br>
                <%= item.getProductid().getProductname()%>
            </td>
            <td><%= item.getPrice().setScale(2) %></td>
            <td><%= item.getQuantitypurchased() %></td>
            <td><%= sub.setScale(2) %></td>
            <td>
                <form action="LeaveReview.jsp" method="get">
                    <input type="hidden" name="productId" value="<%= product.getProductid() %>">
                    <input type="hidden" name="receiptId" value="<%= receipt.getReceiptid() %>">
                    <button type="submit" class="btn-review">✍️Write a Review</button>
                </form>
            </td>
        </tr>
        <% } %>

        <tr>
            <td colspan="3" class="total">Subtotal:</td>
            <td colspan="2">RM <%= subtotal.setScale(2) %></td>
        </tr>
        <tr>
            <td colspan="3" class="total">Sales Tax (6%):</td>
            <td colspan="2">RM <%= tax.setScale(2) %></td>
        </tr>
        <tr>
            <td colspan="3" class="total">
                Shipping:
                <% if (shipping.compareTo(BigDecimal.ZERO) == 0) { %>
                    <span style="color: green;">(Free over RM200)</span>
                <% } %>
            </td>
            <td colspan="2">RM <%= shipping.setScale(2) %></td>
        </tr>
        <tr>
            <td colspan="3" class="total">Total Paid:</td>
            <td colspan="2"><strong>RM <%= total.setScale(2) %></strong></td>
        </tr>
    </table>
<% } else { %>
    <p style="text-align: center; color: #999;">No products found in this receipt.</p>
<% } %>

</body>
</html>
