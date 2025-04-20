<%@page import="model.Product"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="model.Cart" %> 
<%@ page import="model.CartService" %>
<%@ page import="java.math.BigDecimal" %>

<%
    String custId = (String) session.getAttribute("custId");
    if (custId == null) {
        response.sendRedirect("CustomerLogin.jsp");
        return;
    }

    List<Cart> cartItems = (List<Cart>) request.getAttribute("cartList");
    if (cartItems == null) {
        CartService cartService = new CartService();
        cartItems = cartService.getCartByCustomer(custId);
    }

    double subtotal = request.getAttribute("subtotal") != null ? Double.parseDouble(request.getAttribute("subtotal").toString()) : 0.0;
    double discount = request.getAttribute("discount") != null ? Double.parseDouble(request.getAttribute("discount").toString()) : 0.0;
    double tax = request.getAttribute("tax") != null ? Double.parseDouble(request.getAttribute("tax").toString()) : 0.0;
    double shipping = request.getAttribute("shipping") != null ? Double.parseDouble(request.getAttribute("shipping").toString()) : 0.0;
    double grandTotal = request.getAttribute("total") != null ? Double.parseDouble(request.getAttribute("total").toString()) : 0.0;

    String voucherCode = request.getAttribute("voucherCode") != null ? (String) request.getAttribute("voucherCode") : "";
    String voucherMsg = request.getAttribute("voucherMsg") != null ? (String) request.getAttribute("voucherMsg") : "";
    String deliveryMethod = request.getAttribute("deliveryMethod") != null ? (String) request.getAttribute("deliveryMethod") : "delivery";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout</title>
    <link rel="stylesheet" type="text/css" href="src/css/checkout.css">
</head>
<body>
<div class="checkout-container">
    <h1 class="checkout-title">Checkout</h1>

    <% if (cartItems == null || cartItems.isEmpty()) { %>
        <div class="error-message" style="width: 100%;">
            Your cart is empty. <a href="ProductPage.jsp" style="color: #3b82f6;">Go shopping</a>
        </div>
    <% } else { %>

    <!-- Shipping Form -->
    <div class="shipping-section">
        <h2 class="section-title">Shipping Information</h2>

        <form method="post" action="Checkout" id="checkoutForm">
            <input type="hidden" name="action" value="processCheckout">

            <!-- Delivery Method -->
            <div class="form-group">
                <label class="required">Delivery Method</label>
                <div class="delivery-options">
                    <div class="delivery-option <%= "delivery".equals(deliveryMethod) ? "selected" : "" %>">
                        <input type="radio" id="delivery" name="deliveryMethod" value="delivery" <%= "delivery".equals(deliveryMethod) ? "checked" : "" %>>
                        <label for="delivery">Delivery</label>
                    </div>
                    <div class="delivery-option <%= "pickup".equals(deliveryMethod) ? "selected" : "" %>">
                        <input type="radio" id="pickup" name="deliveryMethod" value="pickup" <%= "pickup".equals(deliveryMethod) ? "checked" : "" %>>
                        <label for="pickup">Pick up</label>
                    </div>
                </div>
            </div>

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
            
            <!-- Online Banking Options (initially hidden) -->
            <div id="bankContainer" class="card-container">
                <div class="card-header">
                    <span>Select your bank</span>
                </div>
                
                <div class="form-group">
                    <label class="required" for="bankSelection">Bank</label>
                    <select name="bankSelection" id="bankSelection" required>
                        <option value="">Select your bank</option>
                        <option value="maybank">Maybank</option>
                        <option value="publicbank">Public Bank</option>
                        <option value="cimb">CIMB Bank</option>
                        <option value="rhb">RHB Bank</option>
                        <option value="hongleong">Hong Leong Bank</option>
                        <option value="ambank">AmBank</option>
                        <option value="bsn">Bank Simpanan Nasional</option>
                        <option value="bankislam">Bank Islam</option>
                    </select>
                    <div class="invalid-feedback" id="bankSelectionError">Please select your bank</div>
                </div>
                
                <div class="security-note" style="text-align: left; margin-top: 15px;">
                    <p>You will be redirected to your bank's secure login page to complete the payment.</p>
                </div>
            </div>
            
            <!-- Credit Card Details (initially hidden) -->
            <div id="cardContainer" class="card-container">
                <div class="card-header">
                    <span>Enter card details</span>
                    <div class="card-icons">
                        <div class="card-icon">VISA</div>
                        <div class="card-icon">MC</div>
                        <div class="card-icon">AMEX</div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="required" for="cardNumber">Card number</label>
                    <input type="text" id="cardNumber" name="cardNumber" placeholder="XXXX XXXX XXXX XXXX" maxlength="19">
                    <div class="invalid-feedback" id="cardNumberError">Please enter a valid card number</div>
                </div>
                
                <div class="row">
                    <div class="form-group">
                        <label class="required" for="expiry">Expiry date</label>
                        <input type="text" id="expiry" name="expiry" placeholder="MM/YY" maxlength="5">
                        <div class="invalid-feedback" id="expiryError">Please enter a valid date (MM/YY)</div>
                    </div>
                    <div class="form-group">
                        <label class="required" for="cvv">CVV</label>
                        <input type="text" id="cvv" name="cvv" placeholder="XXX" maxlength="4">
                        <div class="invalid-feedback" id="cvvError">Please enter a valid CVV</div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="required" for="cardName">Name on card</label>
                    <input type="text" id="cardName" name="cardName">
                    <div class="invalid-feedback" id="cardNameError">Please enter the name on your card</div>
                </div>
            </div>

            <!-- Customer Info -->
            <div class="form-group">
                <label class="required" for="fullName">Full name</label>
                <input type="text" name="fullName" id="fullName" required>
            </div>
            <div class="form-group">
                <label class="required" for="email">Email address</label>
                <input type="email" name="email" id="email" required>
            </div>
            <div class="form-group">
                <label class="required" for="phone">Phone number</label>
                <input type="tel" name="phone" id="phone" required>
            </div>
            
            <!-- Address Information (Expanded) -->
            <div class="shipping-address">
                <h3 class="section-subtitle">Shipping Address</h3>
                
                <div class="form-group">
                    <label class="required" for="street">Street Address</label>
                    <input type="text" name="street" id="street" required>
                </div>
                
                <div class="row">
                    <div class="form-group">
                        <label for="apt">Apt/Suite/Unit (optional)</label>
                        <input type="text" name="apt" id="apt">
                    </div>
                </div>
                
                <div class="row">
                    <div class="form-group">
                        <label class="required" for="city">City</label>
                        <input type="text" name="city" id="city" required>
                    </div>
                    <div class="form-group">
                        <label class="required" for="postalCode">Postal Code</label>
                        <input type="text" name="postalCode" id="postalCode" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="required" for="state">State</label>
                    <select name="state" id="state" required>
                        <option value="">Select State</option>
                        <option value="Johor">Johor</option>
                        <option value="Kedah">Kedah</option>
                        <option value="Kelantan">Kelantan</option>
                        <option value="Melaka">Melaka</option>
                        <option value="Negeri Sembilan">Negeri Sembilan</option>
                        <option value="Pahang">Pahang</option>
                        <option value="Perak">Perak</option>
                        <option value="Perlis">Perlis</option>
                        <option value="Pulau Pinang">Pulau Pinang</option>
                        <option value="Sabah">Sabah</option>
                        <option value="Sarawak">Sarawak</option>
                        <option value="Selangor">Selangor</option>
                        <option value="Terengganu">Terengganu</option>
                        <option value="Kuala Lumpur">Kuala Lumpur</option>
                        <option value="Labuan">Labuan</option>
                        <option value="Putrajaya">Putrajaya</option>
                    </select>
                </div>
            </div>

            <!-- Hidden Values -->
            <input type="hidden" name="Code" value="${voucherCode}">
            <input type="hidden" name="subtotal" value="<%= subtotal %>">
            <input type="hidden" name="discount" value="<%= discount %>">
            <input type="hidden" name="tax" value="<%= tax %>">
            <input type="hidden" name="shipping" value="<%= shipping %>">
            <input type="hidden" name="grandTotal" value="<%= grandTotal %>">

        </form>
    </div>

    <!-- Cart Review -->
    <div class="cart-section">
        <h2 class="section-title">Your Cart</h2>

        <% for (Cart item : cartItems) {
            Product product = item.getProductid();
            int quantity = item.getQuantitypurchased();
            BigDecimal price = item.getPrice();
        %>
        <div class="cart-item">
            <div class="cart-item-image">
                <% if (product.getImglocation() != null) { %>
                    <img src="<%= product.getImglocation() %>" alt="">
                <% } %>
            </div>
            <div class="cart-item-details">
                <div class="cart-item-title"><%= product.getProductname() %></div>
                <div class="cart-item-qty"><%= quantity %>x</div>
            </div>
            <div class="cart-item-price">RM <%= String.format("%.2f", price) %></div>
        </div>
        <% } %>

        <!-- Voucher Input - Updated to use ApplyVoucher servlet -->
        <form method="post" action="appliedVoucher">
            <input type="hidden" name="deliveryMethod" value="<%= deliveryMethod %>">
            <div class="voucher-form">
                <input type="text" name="Code" class="voucher-input" placeholder="Discount code" value="<%= (voucherCode != null ? voucherCode : "") %>">
                <button type="submit" class="voucher-btn">Apply</button>
            </div>
            
            <% if (!voucherMsg.isEmpty()) { 
                String messageClass = voucherMsg.contains("successfully") ? "success" : "error";
            %>
                <div class="voucher-message <%= messageClass %>">
                    <% if (messageClass.equals("success")) { %>
                        ✓ 
                    <% } else { %>
                        ⚠ 
                    <% } %>
                    <%= voucherMsg %>
                </div>
            <% } %>
        </form>

        <!-- Totals -->
        <div class="summary-item"><span>Subtotal</span><span>RM <%= String.format("%.2f", subtotal) %></span></div>
        <div class="summary-item"><span>Shipping</span><span>RM <%= String.format("%.2f", shipping) %></span></div>
        <% if (discount > 0) { %>
            <div class="summary-item discount"><span>Discount</span><span>-RM <%= String.format("%.2f", discount) %></span></div>
        <% } %>
        <div class="summary-item"><span>Tax (6%)</span><span>RM <%= String.format("%.2f", tax) %></span></div>
        <div class="summary-item total"><span>Total</span><span>RM <%= String.format("%.2f", grandTotal) %></span></div>

        <!-- Buttons -->
       
        <button type="submit" form="ConfirmCheckout" class="pay-btn" id="payButton" onclick="confirmOrder()">Place Order</button>
       
        
        
        <a href="ShoppingCart.jsp" style="text-decoration: none;">
            <button type="button" class="pay-btn" style="background-color: #64748b; margin-top: 10px;">Back to Cart</button>
        </a>

        <div class="security-note">
            <p>🔒 SSL Encrypted — Your info is safe</p>
        </div>
    </div>
    <% } %>
</div>

<script>
    function confirmOrder() {
        const result = confirm("Do you confirm place order?");
        if (result) {
            // If user clicks "OK"
            window.location.href = "OrderSuccessful.jsp"; // Or submit form
        } else {
            // If user clicks "Cancel"
            window.location.href = "checkout.jsp";
        }
    }
</script>

<script src="src/js/checkout.js"></script>
</body>
</html>