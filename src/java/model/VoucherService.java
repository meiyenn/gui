package model;

import controller.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;

public class VoucherService {

    // Get voucher by code and customer ID
    public Voucher getVoucherByCode(String code, String custId) {
        String sql = "SELECT * FROM voucher WHERE code = ? AND custId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, code);
            stmt.setString(2, custId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Voucher v = new Voucher();
                Customer cust = new Customer();
                
                v.setVoucherid(rs.getString("voucherId"));
                cust.setCustid(rs.getString("custId"));
                v.setCode(rs.getString("code"));
                v.setDiscount(rs.getBigDecimal("discount"));
                v.setMinspend(rs.getBigDecimal("minSpend"));
                v.setExpirydate(rs.getDate("expiryDate"));
                v.setUsed(rs.getBoolean("used"));
                return v;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Mark voucher as used
    public boolean markVoucherAsUsed(String code, String custId) {
        String sql = "UPDATE voucher SET used = 1 WHERE code = ? AND custId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, code);
            stmt.setString(2, custId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get all vouchers for a specific customer
    public List<Voucher> getVouchersByCustomer(String custId) {
        List<Voucher> vouchers = new ArrayList<>();
        String sql = "SELECT * FROM voucher WHERE custId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, custId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Voucher v = new Voucher();
                Customer cust = new Customer();
                
                v.setVoucherid(rs.getString("voucherId"));
                cust.setCustid(rs.getString("custId"));
                v.setCode(rs.getString("code"));
                v.setDiscount(rs.getBigDecimal("discount"));
                v.setMinspend(rs.getBigDecimal("minSpend"));
                
                v.setExpirydate(rs.getDate("expiryDate"));
                
                v.setUsed(rs.getBoolean("used"));
                vouchers.add(v);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vouchers;
    }
    
    public static boolean isBefore(Date date) {
        if (date == null) {
            return false;
        }

        LocalDate localDate = date.toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDate();

        return localDate.isBefore(LocalDate.now());
    }
}
    
    
    // Optional: get valid vouchers (not used and not expired)
//    public List<Voucher> getValidVouchers(String custId) {
//        List<Voucher> all = getVouchersByCustomer(custId);
//        List<Voucher> valid = new ArrayList<>();
//
//        for (Voucher v : all) {
//            if (!v.isUsed() && v.isBeforeExpiry()) {
//                valid.add(v);
//            }
//        }
//        return valid;
//    }
        
