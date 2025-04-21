package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import controller.DBConnection;
import model.VoucherService;

@WebServlet(name = "CompleteOrder", urlPatterns = {"/CompleteOrder"})
public class CompleteOrder extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String custId = (String) session.getAttribute("custId");

        if (custId == null) {
            response.sendRedirect("CustomerLogin.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {

            // Get voucher and pricing information from request
            String voucherCode = request.getParameter("Code");
            BigDecimal subtotal = new BigDecimal(request.getParameter("subtotal"));
            BigDecimal discount = new BigDecimal(request.getParameter("discount"));
            BigDecimal tax = new BigDecimal(request.getParameter("tax"));
            BigDecimal shipping = new BigDecimal(request.getParameter("shipping"));
            BigDecimal grandTotal = new BigDecimal(request.getParameter("grandTotal"));

            // Step 1: Get active cart
            String cartId = null;
            try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT cartId FROM cart WHERE custId = ? AND checkOutStatus = FALSE")) {
                stmt.setString(1, custId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    cartId = rs.getString("cartId");
                } else {
                    response.getWriter().write("❌ No active cart found.");
                    return;
                }
            }

            // Step 2: Mark cart as checked out
            try (PreparedStatement stmt = conn.prepareStatement(
                    "UPDATE cart SET checkOutStatus = TRUE WHERE cartId = ?")) {
                stmt.setString(1, cartId);
                stmt.executeUpdate();
            }

            // Step 3: Generate new receipt ID
            String receiptId = generateNextReceiptId(conn);

            // Step 4: Insert into receipt table
            try (PreparedStatement stmt = conn.prepareStatement(
                    "INSERT INTO receipt (receiptId, cartId, creationTime, subtotal, discount, tax, shipping, total, voucher_code) "
                            + "VALUES (?, ?, CURRENT_TIMESTAMP, ?, ?, ?, ?, ?, ?)")) {
                stmt.setString(1, receiptId);
                stmt.setString(2, cartId);
                stmt.setBigDecimal(3, subtotal);
                stmt.setBigDecimal(4, discount);
                stmt.setBigDecimal(5, tax);
                stmt.setBigDecimal(6, shipping);
                stmt.setBigDecimal(7, grandTotal);
                stmt.setString(8, voucherCode);
                stmt.executeUpdate();
            }

            // Step 5: Insert receipt details
            try (
                PreparedStatement selectStmt = conn.prepareStatement(
                        "SELECT productId, quantityPurchased, price FROM cart_item WHERE cartId = ?");
                PreparedStatement insertStmt = conn.prepareStatement(
                        "INSERT INTO receipt_detail (receiptId, productId, quantity, price) VALUES (?, ?, ?, ?)")
            ) {
                selectStmt.setString(1, cartId);
                ResultSet rs = selectStmt.executeQuery();

                while (rs.next()) {
                    insertStmt.setString(1, receiptId);
                    insertStmt.setString(2, rs.getString("productId"));
                    insertStmt.setInt(3, rs.getInt("quantityPurchased"));
                    insertStmt.setBigDecimal(4, rs.getBigDecimal("price"));
                    insertStmt.addBatch();
                }

                insertStmt.executeBatch();
            }

            // Step 6: Decrease product stock (with validation)
            try (
                PreparedStatement selectStmt = conn.prepareStatement(
                        "SELECT productId, quantityPurchased FROM cart_item WHERE cartId = ?");
                PreparedStatement stockCheckStmt = conn.prepareStatement(
                        "SELECT quantity FROM product WHERE productId = ?");
                PreparedStatement stockUpdateStmt = conn.prepareStatement(
                        "UPDATE product SET quantity = quantity - ? WHERE productId = ?")
            ) {
                selectStmt.setString(1, cartId);
                ResultSet rs = selectStmt.executeQuery();

                while (rs.next()) {
                    String productId = rs.getString("productId");
                    int qtyPurchased = rs.getInt("quantityPurchased");

                    // Check current stock
                    stockCheckStmt.setString(1, productId);
                    try (ResultSet stockRs = stockCheckStmt.executeQuery()) {
                        if (stockRs.next()) {
                            int currentStock = stockRs.getInt("quantity");
                            if (currentStock >= qtyPurchased) {
                                stockUpdateStmt.setInt(1, qtyPurchased);
                                stockUpdateStmt.setString(2, productId);
                                stockUpdateStmt.addBatch();
                            } else {
                                throw new SQLException("❌ Not enough stock for product: " + productId
                                        + " | Requested: " + qtyPurchased + ", Available: " + currentStock);
                            }
                        } else {
                            throw new SQLException("❌ Product not found: " + productId);
                        }
                    }
                }

                stockUpdateStmt.executeBatch();
            }

            // Step 7: Mark voucher as used if applicable
            if (voucherCode != null && !voucherCode.isEmpty() && discount.compareTo(BigDecimal.ZERO) > 0) {
                try {
                    VoucherService voucherService = new VoucherService();
                    voucherService.markVoucherAsUsed(voucherCode, custId);
                    session.removeAttribute("validVoucher");
                    session.removeAttribute("voucherCode");
                } catch (Exception e) {
                    getServletContext().log("Error marking voucher as used: " + e.getMessage(), e);
                }
            }
            
            //store details temp
            session.setAttribute("fullName", request.getParameter("fullName"));
            session.setAttribute("email", request.getParameter("email"));
            session.setAttribute("phone", request.getParameter("phone"));
            session.setAttribute("paymentMethod", request.getParameter("paymentMethod"));
            session.setAttribute("deliveryMethod", request.getParameter("deliveryMethod"));

            if ("delivery".equalsIgnoreCase(request.getParameter("deliveryMethod"))) {
                session.setAttribute("street", request.getParameter("street"));
                session.setAttribute("city", request.getParameter("city"));
                session.setAttribute("postalCode", request.getParameter("postalCode"));
                session.setAttribute("state", request.getParameter("state"));
            }

            // Final step: Redirect to confirmation
            response.sendRedirect("OrderSuccessful.jsp?receiptId=" + receiptId);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("❌ Error during checkout: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    private String generateNextReceiptId(Connection conn) throws SQLException {
        String nextId = "re00001";
        String sql = "SELECT receiptId FROM receipt ORDER BY receiptId DESC FETCH FIRST 1 ROWS ONLY";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                String lastId = rs.getString("receiptId").substring(2); // remove 're'
                int next = Integer.parseInt(lastId) + 1;
                nextId = "re" + String.format("%05d", next);
            }
        }
        return nextId;
    }
}
