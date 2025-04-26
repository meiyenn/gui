package model;

import java.sql.*;
import java.time.LocalDate;

public class CustomerVoucher {

    private Connection connection;

    public CustomerVoucher() {
        // Assumes DBConnection class exists and works
        this.connection = controller.DBConnection.getConnection();
    }

    public CustomerVoucher(Connection connection) {
        this.connection = connection;
    }

    
    //voucher hardcode
    public void createVouchersForCustomer(String custId) {
        insertVoucher("voucher_rm200_" + custId, custId, "RM200OFF10", 10.00, 200.00);
        insertVoucher("voucher_rm350_" + custId, custId, "RM350OFF20", 20.00, 350.00);
        insertVoucher("voucher_first_" + custId, custId, "FIRSTORDER10", 10.00, 0.00);
    }

    //insert voucher when customer register
    private void insertVoucher(String voucherId, String custId, String code, double discount, double minSpend) {
        String sql = "INSERT INTO voucher (voucherId, custId, code, discount, minSpend, expiryDate, used) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, voucherId);
            stmt.setString(2, custId);
            stmt.setString(3, code);
            stmt.setDouble(4, discount);
            stmt.setDouble(5, minSpend);
            stmt.setDate(6, Date.valueOf(LocalDate.now().plusMonths(3))); //avalaible for 3 month to use
            stmt.setBoolean(7, false);

            stmt.executeUpdate();
            System.out.println("Inserted voucher: " + voucherId);

        } catch (SQLException e) {
            if ("23505".equals(e.getSQLState())) { //23505 is for skip duplicate 
                System.out.println("Skipped duplicate voucher: " + voucherId);
            } else {
                System.err.println("Failed to insert voucher: " + voucherId);
                e.printStackTrace();
            }
        }
    }
}
