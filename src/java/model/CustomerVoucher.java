package model;

import java.sql.*;
import controller.DBConnection;

public class CustomerVoucher {

    private Connection connection;
    
    public CustomerVoucher() {
        this.connection = DBConnection.getConnection();
    }

    // Constructor that accepts a connection
    public CustomerVoucher(Connection connection) {
        this.connection = connection;
    }

    // Method to create 3 vouchers for the new customer
    public void createVouchersForCustomer(String custId) {
        // Define the SQL query for inserting vouchers
        String insertVoucherQuery = "INSERT INTO voucher (voucherId, custId, code, discount, minSpend, expiryDate, used) VALUES (?, ?, ?, ?, ?, ?, ?)";
        insertVoucher("voucher_rm200_" + custId, custId, "RM200OFF10", 10.00, 200.00);
        insertVoucher("voucher_rm350_" + custId, custId, "RM350OFF20", 20.00, 350.00);
        insertVoucher("voucher_first_" + custId, custId, "FIRSTORDER10", 10.00, 0.00);
    }

        try (PreparedStatement pstVoucher = connection.prepareStatement(insertVoucherQuery)) {
            // Add first voucher (First-time order)
            pstVoucher.setString(1, "voucher_firsttime");
            pstVoucher.setString(2, custId);
            pstVoucher.setString(3, "FIRSTORDER10");
            pstVoucher.setDouble(4, 10.00);
            pstVoucher.setDouble(5, 0.00);  // No minimum spend for first-time order
            pstVoucher.setDate(6, Date.valueOf("2025-12-31"));
            pstVoucher.setBoolean(7, false);
            pstVoucher.addBatch();

            // Add second voucher (RM200 spend, RM10 off)
            pstVoucher.setString(1, "voucher_rm200");
            pstVoucher.setString(2, custId);
            pstVoucher.setString(3, "RM200OFF10");
            pstVoucher.setDouble(4, 10.00);
            pstVoucher.setDouble(5, 200.00);  // Minimum spend RM200
            pstVoucher.setDate(6, Date.valueOf("2025-12-31"));
            pstVoucher.setBoolean(7, false);
            pstVoucher.addBatch();

            // Add third voucher (RM450 spend, 15% off)
            pstVoucher.setString(1, "voucher_rm450");
            pstVoucher.setString(2, custId);
            pstVoucher.setString(3, "RM450OFF15");
            pstVoucher.setDouble(4, 15.00);
            pstVoucher.setDouble(5, 450.00);  // Minimum spend RM450
            pstVoucher.setDate(6, Date.valueOf("2025-12-31"));
            pstVoucher.setBoolean(7, false);
            pstVoucher.addBatch();

            // Execute batch insert for all 3 vouchers
            pstVoucher.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
