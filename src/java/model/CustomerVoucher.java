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

    public void createVouchersForCustomer(String custId) {
        insertVoucher("voucher_rm200_" + custId, custId, "RM200OFF10", 10.00, 200.00);
        insertVoucher("voucher_rm450_" + custId, custId, "RM350OFF15", 15.00, 350.00);
        insertVoucher("voucher_first_" + custId, custId, "FIRSTORDER10", 10.00, 0.00);
    }

    private void insertVoucher(String voucherId, String custId, String code, double discount, double minSpend) {
        String sql = "INSERT INTO voucher (voucherId, custId, code, discount, minSpend, expiryDate, used) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement pst = connection.prepareStatement(sql)) {
            pst.setString(1, voucherId);
            pst.setString(2, custId);
            pst.setString(3, code);
            pst.setDouble(4, discount);
            pst.setDouble(5, minSpend);
            pst.setDate(6, Date.valueOf(LocalDate.now().plusMonths(3)));
            pst.setBoolean(7, false);

            pst.executeUpdate();
            System.out.println("Inserted voucher: " + voucherId);

        } catch (SQLException e) {
            if ("23505".equals(e.getSQLState())) { // Derby unique violation
                System.out.println("Skipped duplicate voucher: " + voucherId);
            } else {
                System.err.println("Failed to insert voucher: " + voucherId);
                e.printStackTrace();
            }
        }
    }
}
