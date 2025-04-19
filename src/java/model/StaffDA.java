/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import model.Staff;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StaffDA {

    private Connection conn;
    private PreparedStatement stmt;

    public StaffDA(Connection conn) {
        this.conn = conn;
    }

    private StaffDA(String string, String string0, String string1, String string2, String string3, String string4, String string5) {
//        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public StaffDA() {
//        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    // Create
    public void addStaff(Staff staff) {
        try {
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/ass", "nbuser", "nbuser");
            String sql = "INSERT INTO staff VALUES (?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, staff.getStaffid());
            stmt.setString(2, staff.getStfname());
            stmt.setString(3, staff.getStfemail());
            stmt.setString(4, staff.getStfcontactno());
            stmt.setString(5, staff.getStfposition());
            stmt.setString(6, staff.getStfusername());
            stmt.setString(7, staff.getStfpswd());
            stmt.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    // Retrieve (Get one staff by ID)
    public Staff getStaffById(String staffId) {
        try {
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/ass", "nbuser", "nbuser");
            String sql = "SELECT * FROM staff WHERE staffId = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, staffId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Staff(
                        rs.getString("staffId"),
                        rs.getString("stfName"),
                        rs.getString("stfEmail"),
                        rs.getString("stfContactNo"),
                        rs.getString("stfPosition"),
                        rs.getString("stfUserName"),
                        rs.getString("stfPswd"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    // Retrieve (Get all staff)
    public List<StaffDA> getAllStaff() {
        try {
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/ass", "nbuser", "nbuser");
            String sql = "SELECT * FROM staff";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            List<StaffDA> staffList = new ArrayList<>();
            while (rs.next()) {
                staffList.add(new StaffDA(
                        rs.getString("staffId"),
                        rs.getString("stfName"),
                        rs.getString("stfEmail"),
                        rs.getString("stfContactNo"),
                        rs.getString("stfPosition"),
                        rs.getString("stfUserName"),
                        rs.getString("stfPswd")
                ));
            }
            return staffList;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return null;
    }

    // Update
    public void updateStaff(Staff staff) {
        try {
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/ass", "nbuser", "nbuser");
            String sql = "UPDATE staff SET stfName=?, stfEmail=?, stfContactNo=?, stfPosition=?, stfUserName=?, stfPswd=? WHERE staffId=?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, staff.getStfname());
            stmt.setString(2, staff.getStfemail());
            stmt.setString(3, staff.getStfcontactno());
            stmt.setString(4, staff.getStfposition());
            stmt.setString(5, staff.getStfusername());
            stmt.setString(6, staff.getStfpswd());
            stmt.setString(7, staff.getStaffid());
            stmt.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

    }

    // Delete
    public void deleteStaff(String staffId) {

        try {
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/ass", "nbuser", "nbuser");
            String sql = "DELETE FROM staff WHERE staffId = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, staffId);
            stmt.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    
    public String getLastStaffId() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        String lastId = null;

        try {
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/ass", "nbuser", "nbuser");
            String sql = "SELECT staffId FROM staff ORDER BY staffId DESC FETCH FIRST 1 ROWS ONLY";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            if (rs.next()) {
                lastId = rs.getString("staffId");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return lastId;
    }

    
    public String generateNextStaffId(String lastId) {
        if (lastId == null || lastId.isEmpty()) {
            return "STF001";
        }
        String numeric = lastId.substring(3);
        int next = Integer.parseInt(numeric) + 1;
        return "stf" + String.format("%03d", next);
    }
}
