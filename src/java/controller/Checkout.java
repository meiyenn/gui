package controller;

import model.CartItem;
import model.CartService;
import model.Voucher;
import model.VoucherService;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "Checkout", urlPatterns = {"/Checkout"})
public class Checkout extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String custId = (String) session.getAttribute("custId");

        if (custId == null) {
            response.sendRedirect("CustomerLogin.jsp");
            return;
        }

        String action = request.getParameter("action");

        String deliveryMethod = request.getParameter("deliveryMethod");
        if (deliveryMethod == null || deliveryMethod.trim().isEmpty()) {
            deliveryMethod = (String) session.getAttribute("deliveryMethod");
            if (deliveryMethod == null) {
                deliveryMethod = "delivery";
            }
        } else {
            session.setAttribute("deliveryMethod", deliveryMethod);
        }

        CartService cartService = new CartService();
        VoucherService voucherService = new VoucherService();

        try {
            List<CartItem> cartList = cartService.getCartByCustomer(custId);

            if (cartList == null || cartList.isEmpty()) {
                response.sendRedirect("ShoppingCart.jsp");
                return;
            }

            BigDecimal subtotal = BigDecimal.ZERO;
            for (CartItem item : cartList) {
                BigDecimal itemSubtotal = item.getPrice().multiply(BigDecimal.valueOf(item.getQuantitypurchased()));
                subtotal = subtotal.add(itemSubtotal);
            }

            BigDecimal tax = subtotal.multiply(BigDecimal.valueOf(0.06));
            BigDecimal shipping = BigDecimal.ZERO;
            if ("delivery".equalsIgnoreCase(deliveryMethod) && subtotal.compareTo(BigDecimal.valueOf(200)) < 0) {
                shipping = BigDecimal.valueOf(10);
            }

            BigDecimal discount = BigDecimal.ZERO;
            String voucherMsg = "";
            String voucherCode = (String) session.getAttribute("voucherCode");
            Voucher voucher = (Voucher) session.getAttribute("validVoucher");

            if (voucher != null) {
                if (voucherService.isValidForCart(voucher, subtotal)) {
                    discount = voucher.getDiscount();
                    voucherMsg = "Voucher applied successfully!";
                    voucherCode = voucher.getCode();
                } else {
                    voucherMsg = "Minimum spend not met (RM " + voucher.getMinspend() + ").";
                    discount = BigDecimal.ZERO;
                }
            }

            BigDecimal total = subtotal.add(tax).add(shipping).subtract(discount);

            request.setAttribute("cartList", cartList);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("tax", tax);
            request.setAttribute("shipping", shipping);
            request.setAttribute("discount", discount);
            request.setAttribute("total", total);
            request.setAttribute("voucherMsg", voucherMsg);
            request.setAttribute("voucherCode", voucherCode);
            request.setAttribute("deliveryMethod", deliveryMethod);

            if ("processCheckout".equals(action)) {
                if (voucher != null && discount.compareTo(BigDecimal.ZERO) > 0) {
                    voucherService.markVoucherAsUsed(voucher.getCode(), custId);
                    session.removeAttribute("validVoucher");
                    session.removeAttribute("voucherCode");
                }

                // Optionally mark the cart as completed
                cartService.confirmOrder(custId); // Marks current cart as checked out

                // You could also forward to a final confirmation page
                response.sendRedirect("checkoutConfirmation.jsp");
                return;
            }

            RequestDispatcher dispatcher = request.getRequestDispatcher("checkout.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            getServletContext().log("Error in Checkout servlet: " + e.getMessage(), e);
            request.setAttribute("error", "Error during checkout: " + e.getMessage());
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
