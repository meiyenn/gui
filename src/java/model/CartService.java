package model;

import controller.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartService {

    // Get last cartId
    public String getLastCartId() {
        String lastId = null;
        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement("SELECT cartId FROM cart ORDER BY cartId DESC FETCH FIRST 1 ROWS ONLY");
            ResultSet rs = stmt.executeQuery()
        ) {
            if (rs.next()) lastId = rs.getString("cartId");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lastId;
    }

    // Generate next cartId like cart001, cart002, ...
    public String generateNextCartId() {
        String lastId = null, nextId = "cart001";
        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement("SELECT cartId FROM cart ORDER BY cartId DESC FETCH FIRST 1 ROWS ONLY"); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                String numeric = rs.getString("cartId").substring(4);
                int next = Integer.parseInt(numeric) + 1;
                nextId = "cart" + String.format("%03d", next);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return nextId;
    }

    // Add item to cart
    public void addToCart(String custId, String productId, int quantity, double price) throws Exception {
        try (Connection conn = DBConnection.getConnection()) {

            // Check for active cart
            String cartId = null;
            String findCartSql = "SELECT cartId FROM cart WHERE custId = ? AND checkOutStatus = FALSE";
            try (PreparedStatement stmt = conn.prepareStatement(findCartSql)) {
                stmt.setString(1, custId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    cartId = rs.getString("cartId");
                }
            }

            // Create cart 
            if (cartId == null) {
                cartId = generateNextCartId();
                String createCartSql = "INSERT INTO cart (cartId, custId, checkOutStatus) VALUES (?, ?, FALSE)";
                try (PreparedStatement stmt = conn.prepareStatement(createCartSql)) {
                    stmt.setString(1, cartId);
                    stmt.setString(2, custId);
                    stmt.executeUpdate();
                }
            }

            //Check if product already in cart 
            String cartItemId = null;
            int existingQty = 0;
            String findItemSql = "SELECT cartItemId, quantityPurchased FROM cart_item WHERE cartId = ? AND productId = ?";
            try (PreparedStatement stmt = conn.prepareStatement(findItemSql)) {
                stmt.setString(1, cartId);
                stmt.setString(2, productId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    cartItemId = rs.getString("cartItemId");
                    existingQty = rs.getInt("quantityPurchased");
                }
            }

            if (cartItemId != null) {
                // Update quantity
                String updateSql = "UPDATE cart_item SET quantityPurchased = ? WHERE cartItemId = ?";
                try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                    stmt.setInt(1, existingQty + quantity);
                    stmt.setString(2, cartItemId);
                    stmt.executeUpdate();
                }
            } else {
                // Insert new cart item
                cartItemId = generateNextCartItemId();
                String insertSql = "INSERT INTO cart_item (cartItemId, cartId, productId, quantityPurchased, price) VALUES (?, ?, ?, ?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {
                    stmt.setString(1, cartItemId);
                    stmt.setString(2, cartId);
                    stmt.setString(3, productId);
                    stmt.setInt(4, quantity);
                    stmt.setDouble(5, price);
                    stmt.executeUpdate();
                }
            }
        }
    }


    // Get all cart items for a customer 
    public List<CartItem> getCartByCustomer(String custId) throws Exception {
    List<CartItem> itemList = new ArrayList<>();
    try (Connection con = DBConnection.getConnection()) {
        //Get active cart
        String cartId = null;
        try (PreparedStatement stmt = con.prepareStatement("SELECT cartId FROM cart WHERE custId = ? AND checkOutStatus = FALSE")) {
            stmt.setString(1, custId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) cartId = rs.getString("cartId");
        }

        if (cartId == null) return itemList;

        // Get cart items
        String sql = "SELECT ci.*, p.productName, p.imgLocation FROM cart_item ci " +
                     "JOIN product p ON ci.productId = p.productId WHERE ci.cartId = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, cartId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CartItem cartitem = new CartItem();
                cartitem.setCartitemid(rs.getString("cartItemId"));
                cartitem.setQuantitypurchased(rs.getInt("quantityPurchased"));
                cartitem.setPrice(rs.getBigDecimal("price"));

                Product product = new Product();
                product.setProductid(rs.getString("productId"));
                product.setProductname(rs.getString("productName"));
                product.setImglocation(rs.getString("imgLocation"));
                cartitem.setProductid(product);

                Cart cart = new Cart();
                cart.setCartid(cartId);
                cartitem.setCartid(cart);

                itemList.add(cartitem);
            }
        }
    }
    return itemList;
}


    // Remove item from cart
    public void removeFromCart(String cartItemId) throws Exception {
        try (Connection con = DBConnection.getConnection()) {
            try (PreparedStatement stmt = con.prepareStatement("DELETE FROM cart_item WHERE cartItemId = ?")) {
                stmt.setString(1, cartItemId);
                stmt.executeUpdate();
            }
        }
    }

    // Update quantity for a cart item
    public void updateQuantity(String cartItemId, int newQty) throws Exception {
        try (Connection con = DBConnection.getConnection()) {
            try (PreparedStatement stmt = con.prepareStatement("UPDATE cart_item SET quantityPurchased = ? WHERE cartItemId = ?")) {
                stmt.setInt(1, newQty);
                stmt.setString(2, cartItemId);
                stmt.executeUpdate();
            }
        }
    }

    // Confirm the order: update checkout status 
    public void confirmOrder(String custId) throws Exception {
        try (Connection con = DBConnection.getConnection()) {
            String sql = "UPDATE cart SET checkOutStatus = TRUE WHERE custId = ? AND checkOutStatus = FALSE";
            try (PreparedStatement stmt = con.prepareStatement(sql)) {
                stmt.setString(1, custId);
                stmt.executeUpdate();
            }
        }
    }
    
    //nextcartid
    public String generateNextCartItemId() {
        String lastId = null;
        String nextId = "itm001";

        try (
                Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(
                "SELECT cartItemId FROM cart_item WHERE cartItemId LIKE 'itm%' ORDER BY cartItemId DESC FETCH FIRST 1 ROWS ONLY"); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                lastId = rs.getString("cartItemId"); // e.g., "itm005"
                if (lastId != null && lastId.length() >= 6) {
                    String numeric = lastId.substring(3); // gets "005"
                    int next = Integer.parseInt(numeric) + 1;
                    nextId = "itm" + String.format("%03d", next);
                }
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
        }

        return nextId;
    }
    
    //get receipt id
    public Receipt getReceiptById(String receiptId) throws Exception {
        Receipt receipt = null;

        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM receipt WHERE receiptId = ?";
            try (PreparedStatement stmt = con.prepareStatement(sql)) {
                stmt.setString(1, receiptId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    receipt = new Receipt();
                    receipt.setReceiptid(receiptId);
                    receipt.setCreationtime(rs.getTimestamp("creationTime"));
                    receipt.setSubtotal(rs.getBigDecimal("subtotal"));
                    receipt.setDiscount(rs.getBigDecimal("discount"));
                    receipt.setTax(rs.getBigDecimal("tax"));
                    receipt.setShipping(rs.getBigDecimal("shipping"));
                    receipt.setTotal(rs.getBigDecimal("total"));
                    receipt.setVoucherCode(rs.getString("voucher_code"));
                }
            }
        }

        return receipt;
    }
    
    // get receipt list by customer (one customer have many receipt)
    public List<Receipt> getReceiptsByCustomer(String custId) {
        List<Receipt> list = new ArrayList<>();
        String sql = "SELECT r.* FROM receipt r JOIN cart c ON r.cartId = c.cartId WHERE c.custId = ? ORDER BY r.creationTime DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, custId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Receipt r = new Receipt();
                r.setReceiptid(rs.getString("receiptId"));
                r.setCreationtime(rs.getTimestamp("creationTime"));

                Cart cart = new Cart();
                cart.setCartid(rs.getString("cartId"));
                r.setCartid(cart);

                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    
    
    public Receipt getLatestReceiptByCustomer(String custId) {
        Receipt receipt = null;
        String sql = "SELECT r.* FROM receipt r JOIN cart c ON r.cartId = c.cartId WHERE c.custId = ? ORDER BY r.creationTime DESC FETCH FIRST 1 ROWS ONLY";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, custId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                receipt = new Receipt();
                receipt.setReceiptid(rs.getString("receiptId"));
                receipt.setCreationtime(rs.getTimestamp("creationTime"));

                Cart cart = new Cart();
                cart.setCartid(rs.getString("cartId"));
                receipt.setCartid(cart);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return receipt;
    }
    
    //get purchased item by receipt id
    public List<CartItem> getCartItemsByReceiptId(String receiptId) {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT rd.productId, rd.quantity, rd.price, p.productName, p.imgLocation "
                + "FROM receipt_detail rd "
                + "JOIN product p ON rd.productId = p.productId "
                + "WHERE rd.receiptId = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, receiptId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                CartItem item = new CartItem();
                item.setQuantitypurchased(rs.getInt("quantity"));
                item.setPrice(rs.getBigDecimal("price"));

                Product p = new Product();
                p.setProductid(rs.getString("productId"));
                p.setProductname(rs.getString("productName"));   
                p.setImglocation(rs.getString("imgLocation"));  
                item.setProductid(p);

                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }  
}
