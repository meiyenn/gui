package controller;

import model.Cart;
import model.CartService;
import model.Voucher;
import model.VoucherService;

import java.io.IOException;
import static java.lang.Boolean.TRUE;
import java.math.BigDecimal;
import java.util.List;
import java.time.LocalDate;
import java.util.Date;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "Checkout", urlPatterns = {"/Checkout"})
public class Checkout extends HttpServlet {
    
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String custId = (String) request.getSession().getAttribute("custId");
        if (custId == null) {
            response.sendRedirect("CustomerLogin.jsp");
            return;
        }

        String voucherCode = request.getParameter("Code");

        CartService cartService = new CartService();
        VoucherService voucherService = new VoucherService();

        try {
            List<Cart> cartList = cartService.getCartByCustomer(custId);

            BigDecimal subtotal = BigDecimal.ZERO;
            for (Cart item : cartList) {
                BigDecimal itemSubtotal = item.getPrice().multiply(BigDecimal.valueOf(item.getQuantitypurchased()));
                subtotal = subtotal.add(itemSubtotal);
            }

            BigDecimal tax = subtotal.multiply(BigDecimal.valueOf(0.06));
            BigDecimal shipping = subtotal.compareTo(BigDecimal.valueOf(200)) >= 0 ? BigDecimal.ZERO : BigDecimal.valueOf(10);

            BigDecimal discount = BigDecimal.ZERO;
            String voucherMsg = "";

            if (voucherCode != null && !voucherCode.trim().isEmpty()) {
                Voucher voucher = voucherService.getVoucherByCode(voucherCode.trim(), custId);
                if (voucher != null && !voucher.getUsed().equals(TRUE)) {
                       if (VoucherService.isBefore(voucher.getExpirydate())) {
                            voucherMsg = "Voucher has expired.";
                    } else if (voucher.getMinspend().compareTo(subtotal) > 0) {
                        voucherMsg = "Minimum spend not met (RM " + voucher.getMinspend() + ").";
                    } else {
                        discount = voucher.getDiscount();
                        voucherMsg = "Voucher applied successfully!";
                        request.setAttribute("validVoucher", voucher); // you can later mark it used after payment
                    }
                } else {
                    voucherMsg = "Invalid voucher code.";
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

            RequestDispatcher dispatcher = request.getRequestDispatcher("checkout.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Error during checkout: " + e.getMessage());
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
