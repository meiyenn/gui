package controller;

import model.Voucher;
import model.VoucherService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
/**
 * Servlet specifically for handling voucher code application
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
            session.setAttribute("voucherMsg", "Please log in to apply a voucher.");
            response.sendRedirect("Checkout");
            return;
        }

        String voucherCode = request.getParameter("Code");
        if (voucherCode == null || voucherCode.trim().isEmpty()) {
            session.setAttribute("voucherMsg", "Please enter a voucher code.");
            response.sendRedirect("Checkout");
            return;
        }

        try {
            // Lookup voucher from DB
            Voucher voucher = voucherService.getVoucherByCode(voucherCode.trim(), custId);

            String voucherMsg;

            if (voucher == null) {
                voucherMsg = "Invalid voucher code or voucher has expired.";
                session.removeAttribute("validVoucher");
            } else if (voucher.isUsed()) {
                voucherMsg = "This voucher has already been used.";
                session.removeAttribute("validVoucher");
            } else if (!custId.equals(voucher.getCustid().getCustid())) {
                voucherMsg = "This voucher does not belong to your account.";
                session.removeAttribute("validVoucher");
            } else {
                // Everything looks good – store in session
                voucherMsg = "Voucher applied successfully!";
                session.setAttribute("validVoucher", voucher);
            }
            
            session.setAttribute("voucherMsg", voucherMsg);
            session.setAttribute("voucherCode", voucherCode.trim());
            
            // Redirect back to Checkout (recalculate totals)
            response.sendRedirect("Checkout");

        } catch (Exception e) {
            e.printStackTrace(); // Print full error to console/log
            getServletContext().log("Error in ApplyVoucher servlet: " + e.getMessage(), e);
            session.setAttribute("voucherMsg", "Error processing voucher. Please try again.");
            response.sendRedirect("Checkout");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
