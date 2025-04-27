package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.CartService;

@WebServlet(name = "updateCart", urlPatterns = {"/updateCart"})
public class updateCart extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");

        String cartItemId = request.getParameter("cartItemId"); 
        int currentQty = Integer.parseInt(request.getParameter("quantity"));
        String action = request.getParameter("action");

        int newQty = currentQty;

        try (Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/ass", "nbuser", "nbuser")) {
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            // 1. Find the productId from cart_item
            String productId = null;
            String findProductSql = "SELECT productId FROM cart_item WHERE cartItemId = ?";
            try (PreparedStatement stmt = conn.prepareStatement(findProductSql)) {
                stmt.setString(1, cartItemId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    productId = rs.getString("productId");
                }
            }

            if (productId == null) {
                response.getWriter().write("Product not found in cart.");
                return;
            }

            // 2. Get current stock
            int stock = 0;
            String findStockSql = "SELECT quantity FROM product WHERE productId = ?";
            try (PreparedStatement stmt = conn.prepareStatement(findStockSql)) {
                stmt.setString(1, productId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    stock = rs.getInt("quantity");
                }
            }

            if ("increase".equals(action)) {
                if (currentQty < stock) {
                    newQty++;
                } else {
                    // If try to increase over stock, block it
                    response.getWriter().write("<script>alert('❗ Cannot add more. Stock limit reached.'); window.location='ShoppingCart.jsp';</script>");
                    return;
                }
            } else if ("decrease".equals(action) && currentQty > 1) {
                newQty--;
            }

            // 3. Update quantity in cart
            CartService cartService = new CartService();
            cartService.updateQuantity(cartItemId, newQty);

            response.sendRedirect("ShoppingCart.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
