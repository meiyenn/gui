package model;

import controller.DBConnection;
import java.sql.*;
import java.math.BigDecimal;
import java.util.List;

public class ReceiptService {

    public String completeOrder(String custId) throws Exception {
        String receiptId = "rec" + System.currentTimeMillis(); // or use a UUID
        String cartId = null;

        try (Connection con = DBConnection.getConnection()) {
            // Get latest active cart
            String sqlCart = "SELECT cartId FROM cart WHERE custId = ? AND checkOutStatus = FALSE";
            try (PreparedStatement stmt = con.prepareStatement(sqlCart)) {
                stmt.setString(1, custId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    cartId = rs.getString("cartId");
                }
            }

            if (cartId == null) {
                return null;
            }

            // Insert receipt
            String sqlInsert = "INSERT INTO receipt (receiptId, cartId, dateIssued) VALUES (?, ?, CURRENT_TIMESTAMP)";
            try (PreparedStatement stmt = con.prepareStatement(sqlInsert)) {
                stmt.setString(1, receiptId);
                stmt.setString(2, cartId);
                stmt.executeUpdate();
            }

            // Update cart checkout status
            String sqlUpdate = "UPDATE cart SET checkOutStatus = TRUE WHERE cartId = ?";
            try (PreparedStatement stmt = con.prepareStatement(sqlUpdate)) {
                stmt.setString(1, cartId);
                stmt.executeUpdate();
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }

        return receiptId;
    }

    private String generateReceiptId(Connection conn) throws SQLException {
        String lastId = null;
        String sql = "SELECT receiptId FROM receipt ORDER BY receiptId DESC FETCH FIRST 1 ROWS ONLY";

        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                lastId = rs.getString("receiptId");
            }
        }

        if (lastId == null) return "R001";

        int num = Integer.parseInt(lastId.substring(1)) + 1;
        return "R" + String.format("%03d", num);
    }
    
    public String generateNextReceiptId() {
        String prefix = "re";
        int nextNumber = 1;
        String newId = prefix + String.format("%05d", nextNumber);

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement("SELECT receiptId FROM receipt ORDER BY receiptId DESC FETCH FIRST 1 ROWS ONLY"); ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                String lastId = rs.getString("receiptId");
                int lastNumber = Integer.parseInt(lastId.substring(1));
                nextNumber = lastNumber + 1;
                newId = prefix + String.format("%03d", nextNumber);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return newId;
    }

}
