package model;

import controller.DBConnection;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;

public class VoucherService {

    public Voucher getVoucherByCode(String code, String custId) {
        String sql = "SELECT * FROM voucher WHERE code = ? AND custId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, code);
            stmt.setString(2, custId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Voucher v = new Voucher();
                v.setVoucherid(rs.getString("voucherId"));
                v.setCode(rs.getString("code"));
                v.setDiscount(rs.getBigDecimal("discount"));
                v.setMinspend(rs.getBigDecimal("minSpend"));
                v.setExpirydate(rs.getDate("expiryDate"));
                v.setUsed(rs.getBoolean("used"));

                // Validate voucher
                if (v.isUsed()) {
                    System.out.println("Voucher already used: " + code);
                    return null;
                }
                if (isExpired(v.getExpirydate())) {
                    System.out.println("Voucher expired: " + code);
                    return null;
                }
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
    
    public static boolean isExpired(Date date) {
        if (date == null) {
            return true; // Treat null as expired
        }

        LocalDate localDate = date.toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDate();

        return localDate.isBefore(LocalDate.now());
    }
    
    public boolean isValidForCart(Voucher voucher, BigDecimal cartTotal) {
        if (voucher == null) {
            return false;
        }
        return cartTotal.compareTo(voucher.getMinspend()) >= 0;
    }
}
    
        
