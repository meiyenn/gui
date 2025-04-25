<%@ page import="model.CartService" %>
<%@ page import="model.CartItem" %>
<%@ page import="model.Product" %>
<%@ page import="model.Receipt" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<%
    String custId = (String) session.getAttribute("custId");
    if (custId == null) {
        response.sendRedirect("CustomerLogin.jsp");
        return;
    }

    String receiptId = request.getParameter("receiptId");

    CartService cartService = new CartService();
    Receipt receipt = cartService.getReceiptById(receiptId); // fetch receipt info
    List<CartItem> items = cartService.getCartItemsByReceiptId(receiptId);

    BigDecimal total = BigDecimal.ZERO;
    for (CartItem item : items) {
        total = total.add(item.getPrice().multiply(BigDecimal.valueOf(item.getQuantitypurchased())));
    }

    BigDecimal tax = total.multiply(BigDecimal.valueOf(0.06));
    BigDecimal shipping = total.compareTo(BigDecimal.valueOf(200)) < 0 ? new BigDecimal("10.00") : BigDecimal.ZERO;
    BigDecimal finalTotal = total.add(tax).add(shipping);
    BigDecimal tax = subtotal.multiply(BigDecimal.valueOf(0.06));
    BigDecimal shipping = subtotal.compareTo(BigDecimal.valueOf(1000)) < 0 ? new BigDecimal("25.00") : BigDecimal.ZERO;
    BigDecimal discount = receipt.getDiscount() != null ? receipt.getDiscount() : BigDecimal.ZERO;
    BigDecimal total = receipt.getTotal();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Order Details</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        h2 { text-align: center; }
        table {
            width: 90%;
            margin: auto;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ccc;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
        }
        .summary {
            width: 90%;
            margin: 20px auto;
            font-weight: bold;
            text-align: right;
        }
        .summary span {
            display: inline-block;
            width: 200px;
        }
    </style>
</head>
<body>

<h2>Order Summary</h2>
<p style="text-align:center;">
    Receipt ID: <strong><%= receipt.getReceiptid() %></strong> |
    Date: <%= receipt.getCreationtime() %>
</p>

<table>
    <tr>
        <th>Product</th>
        <th>Price (RM)</th>
        <th>Quantity</th>
        <th>Subtotal (RM)</th>
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
        <% if (discount != null && discount.compareTo(BigDecimal.ZERO) > 0) {%>
        <tr>
            <td colspan="3" class="total">
                Voucher Applied:
                <%= (receipt.getVoucherCode() != null) ? receipt.getVoucherCode() : ""%>
            </td>
            <td colspan="2" style="color: green;">
                - RM <%= String.format("%.2f", discount)%>
            </td>
        </tr>
        <% }%>
        <tr>
            <td colspan="3" class="total">Sales Tax (6%):</td>
            <td colspan="2">RM <%= tax.setScale(2) %></td>
        </tr>
        <tr>
            <td colspan="3" class="total">
                Shipping:
                <% if (shipping.compareTo(BigDecimal.ZERO) == 0) { %>
                    <span style="color: green;">(Free over RM1000)</span>
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
</table>

<div class="summary">
    <p><span>Subtotal:</span> RM <%= total.setScale(2) %></p>
    <p><span>Sales Tax (6%):</span> RM <%= tax.setScale(2) %></p>
    <p><span>Shipping:</span> RM <%= shipping.setScale(2) %></p>
    <p><span>Total Paid:</span> <strong>RM <%= finalTotal.setScale(2) %></strong></p>
</div>

</body>
</html>
