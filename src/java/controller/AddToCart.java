package controller;

import model.CartService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "AddToCart", urlPatterns = {"/AddToCart"})
public class AddToCart extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String custId = (String) session.getAttribute("custId");
        String pid = request.getParameter("pid");
        String qtyStr = request.getParameter("pqty");

        if (custId == null || pid == null || qtyStr == null || custId.isEmpty() || pid.isEmpty() || qtyStr.isEmpty()) {
            response.getWriter().write("Missing customer ID, product ID, or quantity.");
            return;
        }

        int quantity;
        try {
            quantity = Integer.parseInt(qtyStr);
        } catch (NumberFormatException e) {
            response.getWriter().write("Invalid quantity.");
            return;
        }

        double price = 0.0;
        int stock = 0;
        int existingQty = 0;

        try (Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/ass", "nbuser", "nbuser")) {
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            // 1. Check product price and stock
            String sql = "SELECT price, quantity FROM product WHERE productId = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, pid);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    price = rs.getBigDecimal("price").doubleValue();
                    stock = rs.getInt("quantity");
                } else {
                    response.getWriter().write("Product not found.");
                    return;
                }
            }

            // 2. Check existing quantity in cart (if any)
            String cartId = null;
            String findCartSql = "SELECT cartId FROM cart WHERE custId = ? AND checkOutStatus = FALSE";
            try (PreparedStatement stmt = conn.prepareStatement(findCartSql)) {
                stmt.setString(1, custId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    cartId = rs.getString("cartId");
                }
            }

            if (cartId != null) {
                String findItemSql = "SELECT quantityPurchased FROM cart_item WHERE cartId = ? AND productId = ?";
                try (PreparedStatement stmt = conn.prepareStatement(findItemSql)) {
                    stmt.setString(1, cartId);
                    stmt.setString(2, pid);
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        existingQty = rs.getInt("quantityPurchased");
                    }
                }
            }

            // 3. Validate stock
            if ((existingQty + quantity) > stock) {
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().write("<script>alert('❗ Not enough stock. Only " + (stock - existingQty) + " more available.');window.history.back();</script>");
                return;
            }

            // 4. Add to cart using CartService
            CartService cartService = new CartService();
            cartService.addToCart(custId, pid, quantity, price);

            // 5. Redirect
            response.sendRedirect("ShoppingCart.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
