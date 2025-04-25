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
            response.getWriter().write("❌ Missing customer ID, product ID, or quantity.");
            return;
        }

        int quantity;
        try {
            quantity = Integer.parseInt(qtyStr);
        } catch (NumberFormatException e) {
            response.getWriter().write("❌ Invalid quantity.");
            return;
        }

        double price = 0.0;

        try (Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/ass", "nbuser", "nbuser")) {
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            String sql = "SELECT PRICE FROM PRODUCT WHERE PRODUCTID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, pid);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    price = rs.getBigDecimal("PRICE").doubleValue();
                } else {
                    response.getWriter().write("❌ Product not found.");
                    return;
                }
            }

            // Add to cart using CartService
            CartService cartService = new CartService();
            cartService.addToCart(custId, pid, quantity, price);

            response.sendRedirect("ShoppingCart.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("❌ Error: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
