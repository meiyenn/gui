/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import model.CustomerVoucher;
/**
 *
 * @author Huay
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String DB_URL = "jdbc:derby://localhost:1527/ass";
    private static final String USER = "nbuser";
    private static final String PASS = "nbuser";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS)) {

            String email = request.getParameter("email");
            String username = request.getParameter("username");

            //Check if email or username already exists
            String checkSql = "SELECT custId FROM customer WHERE custUserName = ? OR custEmail = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, username);
                checkStmt.setString(2, email);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        // Duplicate user found, redirect back with error
                        response.sendRedirect("CustomerRegister.jsp?error=exists");
                        return;
                    }
                }
            }

            //Generate next customer ID
            String nextCustId = generateNextCustomerId(conn);

            //Insert customer
            String sql = "INSERT INTO customer (custId, custName, custContactNo, custEmail, custUserName, custPswd) "
                    + "VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, nextCustId);
                stmt.setString(2, request.getParameter("fullName"));
                stmt.setString(3, request.getParameter("phone"));
                stmt.setString(4, email);
                stmt.setString(5, username);
                stmt.setString(6, request.getParameter("password")); 

                int rowsAffected = stmt.executeUpdate();

                if (rowsAffected >= 0) {
                    //Create vouchers
                    CustomerVoucher customerVoucher = new CustomerVoucher(conn);
                    customerVoucher.createVouchersForCustomer(nextCustId);

                    response.sendRedirect("CustomerLogin.jsp?success=1");
                } else {
                    response.sendRedirect("CustomerRegister.jsp?error=insert_failed");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("registration-exception.jsp");
        }
    }

    private String generateNextCustomerId(Connection conn) throws SQLException {
        String maxCustId = "cus001";
        String sql = "SELECT MAX(custId) FROM customer";
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next() && rs.getString(1) != null) {
                maxCustId = rs.getString(1);
            }
        }
        int nextNum = Integer.parseInt(maxCustId.substring(3)) + 1;
        return "cus" + String.format("%03d", nextNum);
    }
}
