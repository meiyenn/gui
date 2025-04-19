package controller;

import model.CartService;
import model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;

@WebServlet(name = "AddToCart", urlPatterns = {"/AddToCart"})
public class AddToCart extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String custId = (String) session.getAttribute("custId");
        String pid = request.getParameter("pid");
        String pqtyStr = request.getParameter("pqty");

        if (custId == null || pid == null || pqtyStr == null || pid.isEmpty() || pqtyStr.isEmpty()) {
            response.getWriter().write("Missing or invalid input.");
            return;
        }

        int pqty = Integer.parseInt(pqtyStr);
        double price = 0;

        try {
            // Step 1: Fetch product info via JDBC
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/ass", "nbuser", "nbuser");

            String sql = "SELECT * FROM PRODUCT WHERE PRODUCTID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, pid);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                price = rs.getBigDecimal("PRICE").doubleValue();
            } else {
                response.getWriter().write("Product not found.");
                return;
            }

            rs.close();
            stmt.close();
            conn.close();

            // Step 2: Add to cart using CartService
            CartService cartService = new CartService();
            cartService.addToCart(custId, pid, pqty, price);

            response.sendRedirect("ShoppingCart.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("❌ Error: " + e.getMessage());
        }
    }
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
    
}
