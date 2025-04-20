/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.*;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Cart;
import model.CartService;
import model.Customer;
import model.Receipt;

/**
 *
 * @author Huay
 */
@WebServlet(name = "CompleteOrder", urlPatterns = {"/CompleteOrder"})
public class CompleteOrder extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */

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
                    "INSERT INTO receipt (receiptId, cartId, creationTime) VALUES (?, ?, CURRENT_TIMESTAMP)")) {
                stmt.setString(1, receiptId);
                stmt.setString(2, cartId);
                stmt.executeUpdate();
            }

            // Step 5: Copy cart_item into receipt_detail
            try (PreparedStatement selectStmt = conn.prepareStatement(
                    "SELECT productId, quantityPurchased, price FROM cart_item WHERE cartId = ?");
                 PreparedStatement insertStmt = conn.prepareStatement(
                    "INSERT INTO receipt_detail (receiptId, productId, quantity, price) VALUES (?, ?, ?, ?)")) {

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

            response.sendRedirect("OrderConfirmation.jsp?receiptId=" + receiptId);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("❌ Error during checkout: " + e.getMessage());
        }
    }
    
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
