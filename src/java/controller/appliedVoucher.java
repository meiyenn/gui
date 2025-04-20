package controller;

import model.Voucher;
import model.VoucherService;
import model.Cart;
import model.CartService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Servlet specifically for handling voucher operations
 */
@WebServlet(name = "appliedVoucher", urlPatterns = {"/appliedVoucher"})
public class appliedVoucher extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private VoucherService voucherService;
    
    public appliedVoucher() {
        super();
        voucherService = new VoucherService();
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String custId = (String) session.getAttribute("custId");
        
        // Check if user is logged in
        if (custId == null) {
            request.setAttribute("errorMessage", "Please login to apply vouchers");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
            return;
        }
        
        // Get voucher code from request
        String voucherCode = request.getParameter("Code");
        if (voucherCode == null || voucherCode.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please enter a valid voucher code");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
            return;
        }
        
        // Get delivery method to maintain state
        String deliveryMethod = request.getParameter("deliveryMethod");
        if (deliveryMethod == null || deliveryMethod.trim().isEmpty()) {
            deliveryMethod = (String) session.getAttribute("deliveryMethod");
            if (deliveryMethod == null) {
                deliveryMethod = "delivery"; // default
            }
        } else {
            session.setAttribute("deliveryMethod", deliveryMethod);
        }
        
        try {
            // Get cart items and calculate total
            CartService cartService = new CartService();
            List<Cart> cartItems = cartService.getCartByCustomer(custId);
            
            if (cartItems == null || cartItems.isEmpty()) {
                request.setAttribute("errorMessage", "Your cart is empty");
                request.getRequestDispatcher("checkout.jsp").forward(request, response);
                return;
            }
            
            // Calculate cart total
            BigDecimal subtotal = BigDecimal.ZERO;
            for (Cart item : cartItems) {
                BigDecimal itemPrice = item.getPrice().multiply(BigDecimal.valueOf(item.getQuantitypurchased()));
                subtotal = subtotal.add(itemPrice);
            }
            
            // Calculate tax (6%)
            BigDecimal tax = subtotal.multiply(BigDecimal.valueOf(0.06));
            
            // Calculate shipping based on delivery method and subtotal
            BigDecimal shipping = BigDecimal.ZERO;
            if ("delivery".equalsIgnoreCase(deliveryMethod) && subtotal.compareTo(BigDecimal.valueOf(200)) < 0) {
                shipping = BigDecimal.valueOf(10);
            }
            
            // Validate voucher
            Voucher voucher = voucherService.getVoucherByCode(voucherCode, custId);
            
            // Initialize discount and message variables
            BigDecimal discount = BigDecimal.ZERO;
            String voucherMsg = "";
            
            if (voucher == null) {
                voucherMsg = "Invalid voucher code or voucher has expired";
                session.removeAttribute("validVoucher");
            } else {
                // Check minimum spend
                if (!voucherService.isValidForCart(voucher, subtotal)) {
                    voucherMsg = "Minimum spend not met (RM " + voucher.getMinspend() + ")";
                    session.setAttribute("validVoucher", voucher); // Store but don't apply
                } else {
                    // Valid voucher and meets minimum spend
                    discount = voucher.getDiscount();
                    voucherMsg = "Voucher applied successfully!";
                    session.setAttribute("validVoucher", voucher);
                }
            }
            
            // Calculate grand total
            BigDecimal total = subtotal.add(tax).add(shipping).subtract(discount);
            
            // Set attributes for the JSP
            request.setAttribute("cartList", cartItems);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("tax", tax);
            request.setAttribute("shipping", shipping);
            request.setAttribute("discount", discount);
            request.setAttribute("total", total);
            request.setAttribute("voucherMsg", voucherMsg);
            request.setAttribute("voucherCode", voucherCode);
            request.setAttribute("deliveryMethod", deliveryMethod);
            
            // Forward back to checkout page with updated information
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Log the error
            getServletContext().log("Error in ApplyVoucher servlet: " + e.getMessage(), e);
            
            // Set error message and forward back to checkout
            request.setAttribute("errorMessage", "Error processing voucher: " + e.getMessage());
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String custId = (String) session.getAttribute("custId");
        
        if (custId == null) {
            response.sendRedirect("CustomerLogin.jsp");
            return;
        }
        
        try {
            // Get all available vouchers for the customer
            List<Voucher> vouchers = voucherService.getVouchersByCustomer(custId);
            request.setAttribute("vouchers", vouchers);
            request.getRequestDispatcher("voucherList.jsp").forward(request, response);
        } catch (Exception e) {
            // Log the error
            getServletContext().log("Error in ApplyVoucher servlet: " + e.getMessage(), e);
            
            // Set error message and forward to an appropriate page
            request.setAttribute("errorMessage", "Error retrieving vouchers: " + e.getMessage());
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }
}