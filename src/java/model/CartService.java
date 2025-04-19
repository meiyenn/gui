package model;

import controller.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartService {

    // ✅ Get the last cartId from DB
    public String getLastCartId() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        String lastId = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT cartId FROM cart ORDER BY cartId DESC FETCH FIRST 1 ROWS ONLY";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            if (rs.next()) {
                lastId = rs.getString("cartId");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return lastId;
    }

    // ✅ Generate next cartId based on the last one
    public String generateNextCartId(String lastId) {
        if (lastId == null || lastId.isEmpty()) {
            return "cart001";
        }
        String numeric = lastId.substring(4); // e.g., "cart005" -> "005"
        int next = Integer.parseInt(numeric) + 1;
        return "cart" + String.format("%03d", next);
    }

    public void addToCart(String custId, String productId, int quantity, double price) throws Exception {
    try (Connection con = DBConnection.getConnection()) {

        // Step 1: Check if product is already in cart for the same customer
        String checkSql = "SELECT cartId, quantityPurchased FROM cart WHERE custId = ? AND productId = ? AND checkOutStatus = false";
        try (PreparedStatement checkStmt = con.prepareStatement(checkSql)) {
            checkStmt.setString(1, custId);
            checkStmt.setString(2, productId);

            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next()) {
                    // Already exists → update quantity
                    String existingCartId = rs.getString("cartId");
                    int existingQty = rs.getInt("quantityPurchased");
                    int newQty = existingQty + quantity;

                    String updateSql = "UPDATE cart SET quantityPurchased = ? WHERE cartId = ?";
                    try (PreparedStatement updateStmt = con.prepareStatement(updateSql)) {
                        updateStmt.setInt(1, newQty);
                        updateStmt.setString(2, existingCartId);
                        updateStmt.executeUpdate();
                        System.out.println("✅ Quantity updated for cartId: " + existingCartId);
                        return;
                    }
                }
            }
        }

        // Step 2: If not exists → insert new cart item
        String lastId = getLastCartId();
        String cartId = generateNextCartId(lastId);

        String insertSql = "INSERT INTO cart (cartId, custId, productId, quantityPurchased, price, checkOutStatus) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement insertStmt = con.prepareStatement(insertSql)) {
            insertStmt.setString(1, cartId);
            insertStmt.setString(2, custId);
            insertStmt.setString(3, productId);
            insertStmt.setInt(4, quantity);
            insertStmt.setDouble(5, price);
            insertStmt.setBoolean(6, false);
            insertStmt.executeUpdate();
            System.out.println("✅ New item inserted: " + cartId);
        }

    } catch (SQLException e) {
        e.printStackTrace();
        throw new Exception("Error adding item to cart: " + e.getMessage());
    }
}


    // ✅ Update quantity (cartId is VARCHAR)
    public void updateQuantity(String cartId, int quantity) throws Exception {
        try (Connection con = DBConnection.getConnection()) {
            String sql = "UPDATE cart SET quantityPurchased = ? WHERE cartId = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, quantity);
                ps.setString(2, cartId);
                ps.executeUpdate();
            }
        }
    }

    // ✅ Remove from cart (cartId is VARCHAR)
    public void removeFromCart(String cartId) throws Exception {
        try (Connection con = DBConnection.getConnection()) {
            String sql = "DELETE FROM cart WHERE cartId = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, cartId);
                ps.executeUpdate();
            }
        }
    }

 public List<Cart> getCartByCustomer(String custId) throws Exception {
    List<Cart> cartList = new ArrayList<>();
    try (Connection con = DBConnection.getConnection()) {
        String sql = "SELECT * FROM cart WHERE custId = ? AND checkOutStatus = false";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, custId);
            try (ResultSet rs = ps.executeQuery()) {

                // Prepare statement to fetch product details
                String productSql = "SELECT * FROM product WHERE productId = ?";
                try (PreparedStatement productStmt = con.prepareStatement(productSql)) {

                    while (rs.next()) {
                        Cart item = new Cart();
                        Customer cust = new Customer();
                        Product product = new Product();

                        // Set cart fields
                        item.setCartid(rs.getString("cartId"));
                        cust.setCustid(rs.getString("custId"));
                        item.setQuantitypurchased(rs.getInt("quantityPurchased"));
                        item.setPrice(rs.getBigDecimal("price"));
                        item.setCheckoutstatus(rs.getBoolean("checkOutStatus"));

                        // Get productId from cart
                        String pid = rs.getString("productId");
                        product.setProductid(pid);

                        // Query product details
                        productStmt.setString(1, pid);
                        try (ResultSet prs = productStmt.executeQuery()) {
                            if (prs.next()) {
                                product.setProductname(prs.getString("productName"));
                                product.setImglocation(prs.getString("imgLocation")); // ⚠️ Make sure your DB column matches this
                            }
                        }

                        // Set product and customer
                        item.setProductid(product);
                        item.setCustid(cust);

                        cartList.add(item);
                    }
                }
            }
        }
    }
    return cartList;
}

}
