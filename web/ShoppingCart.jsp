<%@ page import="model.CartService" %>
<%@ page import="model.CartItem" %>
<%@ page import="model.Product" %>
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

    CartService cartService = new CartService();
    List<CartItem> cartList = null;
    BigDecimal grandTotal = BigDecimal.ZERO;
    BigDecimal shippingCost = BigDecimal.ZERO;
    BigDecimal salesTax = BigDecimal.ZERO;
    BigDecimal finalTotal = BigDecimal.ZERO;

    try {
        cartList = cartService.getCartByCustomer(custId);
    } catch (Exception e) {
        out.println("<p>Error fetching cart: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Shopping Cart</title>
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
        .qty-btn {
            background-color: #f8f8f8;
            color: black;
            border: none;
            padding: 4px 10px;
            font-size: 16px;
            font-weight: bold;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .delete-btn {
            background-color: #e74c3c;
            color: white;
            border: none;
            padding: 6px 12px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }
        .delete-btn:hover {
            background-color: #c0392b;
        }
        .action-buttons {
            text-align: center;
            margin-top: 20px;
        }
        .action-buttons button {
            padding: 10px 20px;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }
        .continue-btn {
            background-color: #3498db;
            color: white;
        }
        .checkout-btn {
            background-color: #2ecc71;
            color: white;
            margin-left: 20px;
        }
    </style>
</head>
<body>

<h2>My Shopping Cart</h2>

<% if (cartList != null && !cartList.isEmpty()) { %>
    <table>
        <tr>
            <th>Product</th>
            <th>Price (RM)</th>
            <th>Quantity</th>
            <th>Subtotal (RM)</th>
            <th>Action</th>
        </tr>

        <% 
            for (CartItem item : cartList) {
                BigDecimal subtotal = item.getPrice().multiply(BigDecimal.valueOf(item.getQuantitypurchased()));
                grandTotal = grandTotal.add(subtotal);
        %>
            <tr>
                <td>
                    <img src="<%= item.getProductid().getImglocation() %>" width="80"><br>
                    <%= item.getProductid().getProductname() %> (<%= item.getProductid().getProductid() %>)
                </td>
                <td><%= item.getPrice() %></td>
                <td>
                    <form action="updateCart" method="post" style="display: flex; justify-content: center; align-items: center;">
                        <input type="hidden" name="cartItemId" value="<%= item.getCartitemid() %>">
                        <button type="submit" name="action" value="decrease" class="qty-btn">-</button>
                        <input type="text" name="quantity" value="<%= item.getQuantitypurchased() %>" readonly 
                               style="width: 40px; text-align: center; margin: 0 5px;">
                        <button type="submit" name="action" value="increase" class="qty-btn">+</button>
                    </form>
                </td>
                <td><%= subtotal.setScale(2) %></td>
                <td>
                    <form action="DeleteCart" method="post" onsubmit="return confirm('Remove this item?');">
                        <input type="hidden" name="cartItemId" value="<%= item.getCartitemid() %>">
                        <input type="submit" class="delete-btn" value="Delete">
                    </form>
                </td>
            </tr>
        <% } %>

        <%
            // Apply 6% sales tax
            salesTax = grandTotal.multiply(BigDecimal.valueOf(0.06));
            
            // Shipping cost (free if grandTotal >= 200)
            if (grandTotal.compareTo(BigDecimal.valueOf(1000)) < 0) {
                shippingCost = new BigDecimal("25.00");
            }

            // Final total = subtotal + tax + shipping
            finalTotal = grandTotal.add(salesTax).add(shippingCost);
        %>

        <tr>
            <td colspan="3" class="total">Subtotal:</td>
            <td><%= grandTotal.setScale(2) %></td>
            <td></td>
        </tr>
        <tr>
            <td colspan="3" class="total">Sales Tax (6%):</td>
            <td><%= salesTax.setScale(2) %></td>
            <td></td>
        </tr>
        <tr>
            <td colspan="3" class="total">
                Shipping:
                <% if (shippingCost.compareTo(BigDecimal.ZERO) == 0) { %>
                    <span style="color: green;">(Free over RM1000)</span>
                <% } %>
            </td>
            <td><%= shippingCost.setScale(2) %></td>
            <td></td>
        </tr>
        <tr>
            <td colspan="3" class="total">Total:</td>
            <td><strong><%= finalTotal.setScale(2) %></strong></td>
            <td></td>
        </tr>
    </table>

    <div class="action-buttons">
        <a href="ProductPage.jsp">
            <button class="continue-btn">Back to Continue Shopping</button>
        </a>

        <form action="Checkout" method="post" style="display:inline;">
            <button type="submit" class="checkout-btn">Check Out</button>
        </form>
    </div>

<% } else { %>
    <p style="text-align: center; color: #999;">Your cart is empty.</p>
<% } %>

</body>
</html>
