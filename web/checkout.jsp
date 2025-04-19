<%@page import="model.Product"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.Cart" %> 
<%@ page import="model.CartService" %>
<%@ page import="java.math.BigDecimal" %>
<%
    // Get customer ID from session
    String custId = (String) session.getAttribute("custId");
    if (custId == null) {
        response.sendRedirect("CustomerLogin.jsp");
        return;
    }

    // Retrieve cart items - first try from request, then fetch if not found
    List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");
    
    // If cartItems is null, fetch them using CartService
    if (cartItems == null) {
        CartService cartService = new CartService();
        try {
            cartItems = cartService.getCartByCustomer(custId);
            // Calculate and set values that would normally be in the request
            if (cartItems != null && !cartItems.isEmpty()) {
                BigDecimal subtotalBD = BigDecimal.ZERO;
                for (Cart item : cartItems) {
                    BigDecimal price = item.getPrice();
                    int quantity = item.getQuantitypurchased();
                    subtotalBD = subtotalBD.add(price.multiply(BigDecimal.valueOf(quantity)));
                }
                
                // Store calculated values for request attributes
                request.setAttribute("cartItems", cartItems);
                request.setAttribute("subtotal", subtotalBD.doubleValue());
                
                // Default values - you can adjust calculation logic as needed
                double subtotal = subtotalBD.doubleValue();
                double tax = subtotal * 0.06; // 6% sales tax
                double discount = 0.0;
                double shipping = 5.0;
                
                // Apply discount if voucher code exists
                String voucherCode = request.getParameter("voucherCode");
                if (voucherCode != null && !voucherCode.isEmpty()) {
                    // Here you would normally check the voucher in database
                    // For now, let's apply a basic 10% discount
                    discount = subtotal * 0.1;
                    request.setAttribute("voucherCode", voucherCode);
                }
                
                double grandTotal = subtotal + tax + shipping - discount;
                
                request.setAttribute("tax", tax);
                request.setAttribute("discount", discount);
                request.setAttribute("shipping", shipping);
                request.setAttribute("grandTotal", grandTotal);
            }
        } catch (Exception e) {
            out.println("<p>Error fetching cart: " + e.getMessage() + "</p>");
        }
    }
    
    // Safely retrieve and convert request attributes
    double subtotal = 0.0;
    double discount = 0.0;
    double tax = 0.0;
    double shipping = 5.0;  // Default shipping value
    double grandTotal = 0.0;
    
    if (request.getAttribute("subtotal") != null) {
        subtotal = Double.parseDouble(request.getAttribute("subtotal").toString());
    }
    if (request.getAttribute("discount") != null) {
        discount = Double.parseDouble(request.getAttribute("discount").toString());
    }
    if (request.getAttribute("tax") != null) {
        tax = Double.parseDouble(request.getAttribute("tax").toString());
    }
    if (request.getAttribute("shipping") != null) {
        shipping = Double.parseDouble(request.getAttribute("shipping").toString());
    }
    if (request.getAttribute("grandTotal") != null) {
        grandTotal = Double.parseDouble(request.getAttribute("grandTotal").toString());
    } else {
        grandTotal = subtotal + tax + shipping - discount;
    }
    
    String voucherCode = (String) request.getAttribute("voucherCode");
    String voucherId = (String) request.getAttribute("voucherId");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout</title>
    <style>
        * {
            box-sizing: border-box;
            font-family: 'Segoe UI', Arial, sans-serif;
        }
        body {
            margin: 0;
            padding: 20px;
            background-color: #f9f9f9;
            color: #333;
        }
        .checkout-container {
            display: flex;
            flex-wrap: wrap;
            max-width: 1200px;
            margin: 0 auto;
            gap: 30px;
        }
        .checkout-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 30px;
            width: 100%;
        }
        .shipping-section {
            flex: 1;
            min-width: 300px;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .cart-section {
            flex: 1;
            min-width: 300px;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .section-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .delivery-options {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        .delivery-option {
            flex: 1;
            padding: 15px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .delivery-option.selected {
            border-color: #3b82f6;
            background-color: #eff6ff;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-size: 14px;
        }
        .required:after {
            content: " *";
            color: #e74c3c;
        }
        input[type="text"], 
        input[type="email"],
        input[type="tel"],
        select {
            width: 100%;
            padding: 10px;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            font-size: 14px;
        }
        .row {
            display: flex;
            gap: 15px;
        }
        .row .form-group {
            flex: 1;
        }
        .cart-item {
            display: flex;
            padding: 15px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .cart-item-image {
            width: 70px;
            height: 70px;
            margin-right: 15px;
            background-color: #f5f5f5;
            border-radius: 6px;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .cart-item-image img {
            max-width: 100%;
            max-height: 100%;
        }
        .cart-item-details {
            flex: 1;
        }
        .cart-item-title {
            font-weight: bold;
            margin-bottom: 5px;
        }
        .cart-item-qty {
            color: #666;
            font-size: 14px;
        }
        .cart-item-price {
            font-weight: bold;
            text-align: right;
            min-width: 80px;
        }
        .voucher-form {
            display: flex;
            margin: 20px 0;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            overflow: hidden;
        }
        .voucher-input {
            flex: 1;
            padding: 10px;
            border: none;
            font-size: 14px;
        }
        .voucher-btn {
            padding: 10px 15px;
            background-color: #fff;
            border: none;
            color: #3b82f6;
            font-weight: bold;
            cursor: pointer;
        }
        .summary-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        .summary-item.total {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #e0e0e0;
            font-weight: bold;
            font-size: 18px;
        }
        .discount {
            color: #10b981;
        }
        .pay-btn {
            display: block;
            width: 100%;
            padding: 15px;
            margin-top: 20px;
            background-color: #3b82f6;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .pay-btn:hover {
            background-color: #2563eb;
        }
        .security-note {
            text-align: center;
            margin-top: 15px;
            font-size: 14px;
            color: #666;
        }
        .security-note i {
            margin-right: 5px;
        }
        .terms {
            margin-top: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .phone-input {
            display: flex;
            align-items: center;
        }
        .phone-flag {
            display: flex;
            align-items: center;
            padding: 0 10px;
            border: 1px solid #e0e0e0;
            border-right: none;
            border-radius: 6px 0 0 6px;
            background-color: #f9f9f9;
        }
        .phone-number {
            flex: 1;
            border-radius: 0 6px 6px 0;
        }
        .error-message {
            color: #e74c3c;
            text-align: center;
            padding: 15px;
            border-radius: 6px;
            background-color: #fef2f2;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="checkout-container">
        <h1 class="checkout-title">Checkout</h1>
        
        <% if (cartItems == null || cartItems.isEmpty()) { %>
            <div class="error-message" style="width: 100%;">
                Your cart is empty. Please add items to your cart before checkout.
                <p><a href="ProductPage.jsp" style="color: #3b82f6; text-decoration: none;">Continue Shopping</a></p>
            </div>
        <% } else { %>
        
        <!-- Left Column - Shipping Information -->
        <div class="shipping-section">
            <h2 class="section-title">Shipping Information</h2>
            
            <div class="delivery-options">
                <div class="delivery-option selected">
                    <input type="radio" id="delivery" name="deliveryMethod" checked>
                    <label for="delivery">Delivery</label>
                </div>
                <div class="delivery-option">
                    <input type="radio" id="pickup" name="deliveryMethod">
                    <label for="pickup">Pick up</label>
                </div>
            </div>
            
            <form method="post" action="confirmCheckout" id="checkoutForm">
                <div class="form-group">
                    <label class="required" for="fullName">Full name</label>
                    <input type="text" id="fullName" name="fullName" placeholder="Enter full name" required>
                </div>
                
                <div class="form-group">
                    <label class="required" for="email">Email address</label>
                    <input type="email" id="email" name="email" placeholder="Enter email address" required>
                </div>
                
                <div class="form-group">
                    <label class="required" for="phone">Phone number</label>
                    <div class="phone-input">
                        <div class="phone-flag">
                            <span>MY</span>
                            <span>+60</span>
                        </div>
                        <input type="tel" id="phone" name="phone" class="phone-number" placeholder="Enter phone number" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="required" for="country">Country</label>
                    <select id="country" name="country" required>
                        <option value="">Choose country</option>
                        <option value="MY" selected>Malaysia</option>
                        
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="city">Address</label>
                    <input type="text" id="address" name="address" placeholder="Enter Address">
                </div>
                
                <div class="row">
                    
                    <div class="form-group">
                        <label for="city">City</label>
                        <input type="text" id="city" name="city" placeholder="Enter city">
                    </div>
                    
                    <div class="form-group">
                        <label for="state">State</label>
                        <input type="text" id="state" name="state" placeholder="Enter state">
                    </div>
                    
                    <div class="form-group">
                        <label for="zipCode">ZIP Code</label>
                        <input type="text" id="zipCode" name="zipCode" placeholder="Enter ZIP code">
                    </div>
                </div>
                
                <div class="terms">
                    <input type="checkbox" id="termsCheck" name="termsCheck" required>
                    <label for="termsCheck">I have read and agree to the Terms and Conditions</label>
                </div>
            
                <!-- Hidden fields for order processing -->
                <input type="hidden" name="voucherId" value="<%= voucherId != null ? voucherId : "" %>"/>
                <input type="hidden" name="subtotal" value="<%= subtotal %>"/>
                <input type="hidden" name="discount" value="<%= discount %>"/>
                <input type="hidden" name="tax" value="<%= tax %>"/>
                <input type="hidden" name="shipping" value="<%= shipping %>"/>
                <input type="hidden" name="grandTotal" value="<%= grandTotal %>"/>
            </form>
        </div>
        
        <!-- Right Column - Cart Review -->
        <div class="cart-section">
            <h2 class="section-title">Review your cart</h2>
            
            <% 
            for (Cart item : cartItems) { 
                Product product = item.getProductid();
                String productName = product.getProductname();
                
                BigDecimal price;
                if (item.getPrice() instanceof BigDecimal) {
                    price = (BigDecimal) item.getPrice();
                } else {
                    price = new BigDecimal(String.valueOf(item.getPrice()));
                }
                
                int quantity = item.getQuantitypurchased();
            %>
            <div class="cart-item">
                <div class="cart-item-image">
                    <% if (product.getImglocation() != null) { %>
                        <img src="<%= product.getImglocation() %>" alt="<%= productName %>">
                    <% } else { %>
                        <div style="width:50px; height:50px; background:#eee"></div>
                    <% } %>
                </div>
                <div class="cart-item-details">
                    <div class="cart-item-title"><%= productName %></div>
                    <div class="cart-item-qty"><%= quantity %>x</div>
                </div>
                <div class="cart-item-price">RM <%= String.format("%.2f", price) %></div>
            </div>
            <% } %>
            
            <!-- Voucher Code Input -->
            <form method="get" action="Checkout">
                <div class="voucher-form">
                    <input type="text" name="voucherCode" class="voucher-input" placeholder="Discount code" value="<%= (voucherCode != null ? voucherCode : "") %>">
                    <button type="submit" class="voucher-btn">Apply</button>
                </div>
            </form>
            
            <!-- Order Summary -->
            <div class="summary-item">
                <span>Subtotal</span>
                <span>RM <%= String.format("%.2f", subtotal) %></span>
            </div>
            <div class="summary-item">
                <span>Shipping</span>
                <span>RM <%= String.format("%.2f", shipping) %></span>
            </div>
            <% if (discount > 0) { %>
            <div class="summary-item discount">
                <span>Discount</span>
                <span>-RM <%= String.format("%.2f", discount) %></span>
            </div>
            <% } %>
            <div class="summary-item">
                <span>Tax (6%)</span>
                <span>RM <%= String.format("%.2f", tax) %></span>
            </div>
            <div class="summary-item total">
                <span>Total</span>
                <span>RM <%= String.format("%.2f", grandTotal) %></span>
            </div>
            
            <!-- Pay Button -->
            <button type="submit" form="checkoutForm" class="pay-btn">Pay Now</button>
            <a href="ShoppingCart.jsp">
                <button class="pay-btn">Cancel Checkout</button>
            </a>
            
            <!-- Security Note -->
            <div class="security-note">
                <p>🔒 Secure Checkout - SSL Encrypted</p>
                <p>Ensuring your financial and personal details are secure during every transaction.</p>
            </div>
        </div>
        <% } %>
    </div>
    
    <script>
        // Simple script to toggle between delivery options
        document.querySelectorAll('.delivery-option').forEach(option => {
            option.addEventListener('click', function() {
                document.querySelectorAll('.delivery-option').forEach(el => {
                    el.classList.remove('selected');
                });
                this.classList.add('selected');
                this.querySelector('input').checked = true;
            });
        });
    </script>
</body>
</html>