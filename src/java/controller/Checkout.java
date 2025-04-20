package controller;
import model.Cart;
import model.CartService;
import model.Voucher;
import model.VoucherService;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Handles the checkout process including voucher application and validation
 */
@WebServlet(name = "Checkout", urlPatterns = {"/Checkout"})
public class Checkout extends HttpServlet {
    
    /**
     * Handles POST requests for checkout process including voucher application
     * This method manages the checkout workflow and voucher application to prevent
     * form state from being reset when applying vouchers.
     * @param request
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String custId = (String) session.getAttribute("custId");

        if (custId == null) {
            response.sendRedirect("CustomerLogin.jsp");
            return;
        }

        // Get the action parameter to determine if this is a checkout submission
        String action = request.getParameter("action");

        // Get delivery method with fallback to session or default value
        String deliveryMethod = request.getParameter("deliveryMethod");
        if (deliveryMethod == null || deliveryMethod.trim().isEmpty()) {
            deliveryMethod = (String) session.getAttribute("deliveryMethod");
            if (deliveryMethod == null) {
                deliveryMethod = "delivery"; // default if not selected
            }
        } else {
            session.setAttribute("deliveryMethod", deliveryMethod);
        }

        CartService cartService = new CartService();
        VoucherService voucherService = new VoucherService();

        try {
            // Get cart items and calculate totals
            List<Cart> cartList = cartService.getCartByCustomer(custId);

            // Redirect to shopping cart if cart is empty
            if (cartList == null || cartList.isEmpty()) {
                response.sendRedirect("ShoppingCart.jsp");
                return;
            }

            // Calculate subtotal
            BigDecimal subtotal = BigDecimal.ZERO;
            for (Cart item : cartList) {
                BigDecimal itemSubtotal = item.getPrice().multiply(BigDecimal.valueOf(item.getQuantitypurchased()));
                subtotal = subtotal.add(itemSubtotal);
            }

            // Calculate tax (6%)
            BigDecimal tax = subtotal.multiply(BigDecimal.valueOf(0.06));

            // Calculate shipping based on delivery method and subtotal
            BigDecimal shipping = BigDecimal.ZERO;
            if ("delivery".equalsIgnoreCase(deliveryMethod) && subtotal.compareTo(BigDecimal.valueOf(200)) < 0) {
                shipping = BigDecimal.valueOf(10);
            }

            // Initialize discount variables
            BigDecimal discount = BigDecimal.ZERO;
            String voucherMsg = "";
            String voucherCode = (String) session.getAttribute("voucherCode");

            // Get voucher from session if it exists
            Voucher voucher = (Voucher) session.getAttribute("validVoucher");

            // If there's a valid voucher, check if it's still applicable
            if (voucher != null) {
                // Check if the voucher is still valid for the current cart total
                if (voucherService.isValidForCart(voucher, subtotal)) {
                    discount = voucher.getDiscount();
                    voucherMsg = "Voucher applied successfully!";
                    voucherCode = voucher.getCode();
                } else {
                    voucherMsg = "Minimum spend not met (RM " + voucher.getMinspend() + ").";
                    // Keep the voucher in session but don't apply discount
                    discount = BigDecimal.ZERO;
                }
            }

            // Calculate grand total
            BigDecimal total = subtotal.add(tax).add(shipping).subtract(discount);

            // Set attributes for the JSP
            request.setAttribute("cartList", cartList);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("tax", tax);
            request.setAttribute("shipping", shipping);
            request.setAttribute("discount", discount);
            request.setAttribute("total", total);
            request.setAttribute("voucherMsg", voucherMsg);
            request.setAttribute("voucherCode", voucherCode);
            request.setAttribute("deliveryMethod", deliveryMethod);

            // Process the final checkout if requested
            if ("processCheckout".equals(action)) {
                // If a voucher was successfully applied, mark it as used
                if (voucher != null && discount.compareTo(BigDecimal.ZERO) > 0) {
                    // Only mark as used when actual checkout happens and min spend is met
                    voucherService.markVoucherAsUsed(voucher.getCode(), custId);
                    // Clear the voucher from session to prevent reuse
                    session.removeAttribute("validVoucher");
                    session.removeAttribute("voucherCode");
                }

                // Forward to the confirmCheckout servlet for final processing
                request.getRequestDispatcher("confirmCheckout").forward(request, response);
                return;
            }

            // Default action - just show the checkout page
            RequestDispatcher dispatcher = request.getRequestDispatcher("checkout.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            // Log the error
            getServletContext().log("Error in Checkout servlet: " + e.getMessage(), e);

            // Set error message and forward back to checkout
            request.setAttribute("error", "Error during checkout: " + e.getMessage());
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }

    /**
     * Handles GET requests by delegating to doPost
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
