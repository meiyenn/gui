package controller;

import model.Voucher;
import model.VoucherService;
import model.CartItem;
import model.CartService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String custId = (String) session.getAttribute("custId");

        if (custId == null) {
            request.setAttribute("errorMessage", "Please login to apply vouchers");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
            return;
        }

        String voucherCode = request.getParameter("Code");
        if (voucherCode == null || voucherCode.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please enter a valid voucher code");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
            return;
        }

        String deliveryMethod = request.getParameter("deliveryMethod");
        if (deliveryMethod == null || deliveryMethod.trim().isEmpty()) {
            deliveryMethod = (String) session.getAttribute("deliveryMethod");
            if (deliveryMethod == null) {
                deliveryMethod = "delivery";
            }
        } else {
            session.setAttribute("deliveryMethod", deliveryMethod);
        }

        try {
            CartService cartService = new CartService();
            List<CartItem> cartItems = cartService.getCartByCustomer(custId);

            if (cartItems == null || cartItems.isEmpty()) {
                request.setAttribute("errorMessage", "Your cart is empty");
                request.getRequestDispatcher("checkout.jsp").forward(request, response);
                return;
            }

            // ✅ Calculate subtotal
            BigDecimal subtotal = BigDecimal.ZERO;
            for (CartItem item : cartItems) {
                BigDecimal itemPrice = item.getPrice().multiply(BigDecimal.valueOf(item.getQuantitypurchased()));
                subtotal = subtotal.add(itemPrice);
            }

            // ✅ Calculate tax (6%)
            BigDecimal tax = subtotal.multiply(BigDecimal.valueOf(0.06));

            // ✅ Calculate shipping
            BigDecimal shipping = BigDecimal.ZERO;
            if ("delivery".equalsIgnoreCase(deliveryMethod) && subtotal.compareTo(BigDecimal.valueOf(200)) < 0) {
                shipping = BigDecimal.valueOf(10);
            }

            // ✅ Validate voucher
            Voucher voucher = voucherService.getVoucherByCode(voucherCode, custId);

            BigDecimal discount = BigDecimal.ZERO;
            String voucherMsg = "";

            if (voucher == null) {
                voucherMsg = "Invalid voucher code or voucher has expired";
                session.removeAttribute("validVoucher");
            } else {
                if (!voucherService.isValidForCart(voucher, subtotal)) {
                    voucherMsg = "Minimum spend not met (RM " + voucher.getMinspend() + ")";
                    session.setAttribute("validVoucher", voucher); // store but not applied
                } else {
                    discount = voucher.getDiscount();
                    voucherMsg = "Voucher applied successfully!";
                    session.setAttribute("validVoucher", voucher); // store applied
                }
            }

            // ✅ Grand total
            BigDecimal total = subtotal.add(tax).add(shipping).subtract(discount);

            // ✅ Set attributes for checkout.jsp
            request.setAttribute("cartList", cartItems);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("tax", tax);
            request.setAttribute("shipping", shipping);
            request.setAttribute("discount", discount);
            request.setAttribute("total", total);
            request.setAttribute("voucherMsg", voucherMsg);
            request.setAttribute("voucherCode", voucherCode);
            request.setAttribute("deliveryMethod", deliveryMethod);

            request.getRequestDispatcher("checkout.jsp").forward(request, response);

        } catch (Exception e) {
            getServletContext().log("Error in ApplyVoucher servlet: " + e.getMessage(), e);
            request.setAttribute("errorMessage", "Error processing voucher: " + e.getMessage());
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String custId = (String) session.getAttribute("custId");

        if (custId == null) {
            response.sendRedirect("CustomerLogin.jsp");
            return;
        }

        try {
            List<Voucher> vouchers = voucherService.getVouchersByCustomer(custId);
            request.setAttribute("vouchers", vouchers);
            request.getRequestDispatcher("voucherList.jsp").forward(request, response);
        } catch (Exception e) {
            getServletContext().log("Error in ApplyVoucher servlet: " + e.getMessage(), e);
            request.setAttribute("errorMessage", "Error retrieving vouchers: " + e.getMessage());
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }
}
