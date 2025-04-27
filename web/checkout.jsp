<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.CartItem, model.Product, model.CartService, java.math.BigDecimal, java.util.*" %>

<%
    String custId = (String) session.getAttribute("custId");
    if (custId == null) {
        response.sendRedirect("CustomerLogin.jsp");
        return;
    }

    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartList");
    if (cartItems == null) {
        CartService cartService = new CartService();
        cartItems = cartService.getCartByCustomer(custId);
    }

    double subtotal = request.getAttribute("subtotal") != null
            ? Double.parseDouble(request.getAttribute("subtotal").toString()) : 0.0;

    double discount = request.getAttribute("discount") != null
            ? Double.parseDouble(request.getAttribute("discount").toString()) : 0.0;

    double shipping = request.getAttribute("shipping") != null
            ? Double.parseDouble(request.getAttribute("shipping").toString()) : 0.0;

    double tax = request.getAttribute("tax") != null
            ? Double.parseDouble(request.getAttribute("tax").toString()) : 0.0;

    double grandTotal = request.getAttribute("total") != null
            ? Double.parseDouble(request.getAttribute("total").toString())
            : subtotal + tax + shipping - discount;

    String voucherCode = request.getAttribute("voucherCode") != null
            ? request.getAttribute("voucherCode").toString() : "";

    String voucherMsg = request.getAttribute("voucherMsg") != null
            ? request.getAttribute("voucherMsg").toString() : "";

    String deliveryMethod = request.getAttribute("deliveryMethod") != null
            ? request.getAttribute("deliveryMethod").toString() : "delivery";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout</title>
    <link rel="stylesheet" href="src/css/checkout.css">
</head>
<body>

<div class="checkout-container">
    <h1 class="checkout-title">Checkout</h1>

    <% if (cartItems == null || cartItems.isEmpty()) { %>
        <div class="error-message">
            Your cart is empty. <a href="ProductPage.jsp" style="color: #3b82f6;">Shop now</a>
        </div>
    <% } else { %>

    <!--Cart Section -->
    <div class="cart-section">
        <h2 class="section-title">Your Cart</h2>
        <% for (CartItem item : cartItems) {
            Product product = item.getProductid();
        %>
        <div class="cart-item">
            <div class="cart-item-image">
                <img src="imgUpload/<%= product.getImglocation() %>" alt="">
            </div>
            <div class="cart-item-details">
                <div class="cart-item-title"><%= product.getProductname() %></div>
                <div class="cart-item-qty"><%= item.getQuantitypurchased() %>x</div>
            </div>
            <div class="cart-item-price">RM <%= String.format("%.2f", item.getPrice()) %></div>
        </div>
        <% } %>

        <!--Voucher Form -->
        <form method="post" action="appliedVoucher">
            <input type="hidden" name="custId" value="<%= custId %>">
            <input type="hidden" name="deliveryMethod" value="<%= deliveryMethod %>">
            <div class="voucher-form">
                <input type="text" name="Code" class="voucher-input" placeholder="Discount code" value="<%= voucherCode %>">
                <button type="submit" class="voucher-btn">Apply</button>
            </div>
            <% if (!voucherMsg.isEmpty()) {
                String msgClass = voucherMsg.toLowerCase().contains("success") ? "success" : "error";
            %>
                <div class="voucher-message <%= msgClass %>">
                    <%= msgClass.equals("success") ? "✓" : "⚠" %> <%= voucherMsg %>
                </div>
                
                    <%
                            
                            session.removeAttribute("voucherMsg");
                            session.removeAttribute("voucherCode");
                        
                    %>
            <% } %>
        </form>

        <!--Totals -->
        <div class="summary-item"><span>Subtotal</span><span>RM <%= String.format("%.2f", subtotal) %></span></div>
        <div class="summary-item"><span>Shipping</span><span>RM <%= String.format("%.2f", shipping) %></span></div>
        <% if (discount > 0) { %>
            <div class="summary-item discount"><span>Discount</span><span>-RM <%= String.format("%.2f", discount) %></span></div>
        <% } %>
        <div class="summary-item"><span>Tax (6%)</span><span>RM <%= String.format("%.2f", tax) %></span></div>
        <div class="summary-item total"><span>Total</span><span>RM <%= String.format("%.2f", grandTotal) %></span></div>

        <a href="ShoppingCart.jsp">
            <button type="button" class="pay-btn" style="background-color: #64748b;">Back to Cart</button>
        </a>
    </div>

    <!-- Shipping & Payment -->
    <div class="shipping-section">
        <form method="post" action="CompleteOrder" id="checkoutForm">
            <input type="hidden" name="custId" value="<%= custId %>">
            <input type="hidden" name="deliveryMethod" value="<%= deliveryMethod %>">
            <input type="hidden" name="Code" value="<%= voucherCode %>">
            <input type="hidden" name="subtotal" value="<%= subtotal %>">
            <input type="hidden" name="discount" value="<%= discount %>">
            <input type="hidden" name="tax" value="<%= tax %>">
            <input type="hidden" name="shipping" value="<%= shipping %>">
            <input type="hidden" name="grandTotal" value="<%= grandTotal %>">



            <!-- Payment Method -->
            <div class="form-group">
                <label class="required" for="paymentMethod">Payment Method</label>
                <select name="paymentMethod" id="paymentMethod" required>
                    <option value="">Select a payment method</option>
                    <option value="debit_card">Debit/Credit Card</option>
                    <option value="tng">Touch 'n Go</option>
                    <option value="online_banking">Online Banking</option>
                </select>
            </div>

            <!-- Credit Card Info -->
            <div id="cardContainer" class="card-container">
                <div class="card-header">
                    <span>Card Details</span>
                    <div class="card-icons">
                        <div class="card-icon">VISA</div>
                        <div class="card-icon">MC</div>
                        <div class="card-icon">AMEX</div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="required" for="cardNumber">Card Number</label>
                    <input type="text" id="cardNumber" name="cardNumber" placeholder="XXXX XXXX XXXX XXXX" maxlength="19">
                    <div class="invalid-feedback" id="cardNumberError">Invalid card number</div>
                </div>
                <div class="row">
                    <div class="form-group">
                        <label class="required" for="expiry">Expiry Date</label>
                        <input type="text" id="expiry" name="expiry" placeholder="MM/YY" maxlength="5">
                        <div class="invalid-feedback" id="expiryError">Invalid expiry date</div>
                    </div>
                    <div class="form-group">
                        <label class="required" for="cvv">CVV</label>
                        <input type="text" id="cvv" name="cvv" placeholder="XXX" maxlength="4">
                        <div class="invalid-feedback" id="cvvError">Invalid CVV</div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="required" for="cardName">Name on Card</label>
                    <input type="text" id="cardName" name="cardName">
                    <div class="invalid-feedback" id="cardNameError">Name required</div>
                </div>
            </div>

            <!-- Online Banking -->
            <div id="bankContainer" class="card-container">
                <div class="card-header">
                    <span>Bank Selection</span>
                </div>
                <div class="form-group">
                    <label class="required" for="bankSelection">Bank</label>
                    <select name="bankSelection" id="bankSelection">
                        <option value="">Select your bank</option>
                        <option value="maybank">Maybank</option>
                        <option value="publicbank">Public Bank</option>
                        <option value="cimb">CIMB Bank</option>
                        <option value="rhb">RHB Bank</option>
                    </select>
                    <div class="invalid-feedback" id="bankSelectionError">Please select your bank</div>
                </div>
            </div>

            <!-- Customer Info -->
            <div class="form-group">
                <label class="required" for="fullName">Full Name</label>
                <input type="text" name="fullName" id="fullName" required>
            </div>
            <div class="form-group">
                <label class="required" for="email">Email</label>
                <input type="email" name="email" id="email" required>
            </div>
            <div class="form-group">
                <label class="required" for="phone">Phone</label>
                <input type="tel" name="phone" id="phone" required>
            </div>

            <!-- Address Section (Visible for Delivery) -->
            <div class="shipping-address">
                <h3 class="section-subtitle">Shipping Address</h3>
                <div class="form-group">
                    <label class="required" for="street">Street Address</label>
                    <input type="text" name="street" id="street">
                </div>
                <div class="form-group">
                    <label class="required" for="city">City</label>
                    <input type="text" name="city" id="city">
                </div>
                <div class="form-group">
                    <label class="required" for="postalCode">Postal Code</label>
                    <input type="text" name="postalCode" id="postalCode">
                </div>
                <div class="form-group">
                    <label class="required" for="state">State</label>
                    <select name="state" id="state">
                        <option value="">Select State</option>
                        <option value="Selangor">Selangor</option>
                        <option value="KL">Kuala Lumpur</option>
                    </select>
                </div>
            </div>

            <!-- Place Order -->
            <button type="submit" class="pay-btn" id="payButton" onclick="return confirm('Confirm place order?')">Place Order</button>
        </form>
    </div>
    <% } %>
    
    <%
        session.removeAttribute("voucherCode");
    %>

</div>

<script src="src/js/checkout.js"></script>
</body>
</html>
