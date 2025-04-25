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
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS)) {
            // Generate next customer ID
            String nextCustId = generateNextCustomerId(conn);

            // Prepare SQL query for inserting new customer
            String sql = "INSERT INTO customer (custId, custName, custContactNo, custEmail, custUserName, custPswd) "
                    + "VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                // Set parameters from form data
                stmt.setString(1, nextCustId); // New customer ID
                stmt.setString(2, request.getParameter("fullName"));
                stmt.setString(3, request.getParameter("phone"));
                stmt.setString(4, request.getParameter("email"));
                stmt.setString(5, request.getParameter("username"));
                stmt.setString(6, request.getParameter("password"));

                // Execute the insert query
                int rowsAffected = stmt.executeUpdate();
                
                // Call CustomerVoucher to insert 3 vouchers for the new customer
                CustomerVoucher customerVoucher = new CustomerVoucher(conn);
                customerVoucher.createVouchersForCustomer(nextCustId);

                // Redirect based on whether the insert was successful or not
                if (rowsAffected > 0) {
                    response.sendRedirect("CustomerLogin.jsp?success=1");  // Redirect to login page if successful
                } else {
                    response.sendRedirect("CustomerRegister.jsp");  // Stay on the registration page if failed
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("registration-exception.jsp"); // Database connection error
        }
    }

    // Method to generate the next customer ID based on the current maximum ID in the table
    private String generateNextCustomerId(Connection conn) throws SQLException {
        String maxCustId = "cus001"; // Default starting value if no customers exist
        String sql = "SELECT MAX(custId) FROM customer";
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            if (rs.next() && rs.getString(1) != null) {
                maxCustId = rs.getString(1);
            }
        }

        // Extract the numeric part from the ID and increment
        String numericPart = maxCustId.substring(3); // Skip the "cus" part
        int nextNum = Integer.parseInt(numericPart) + 1;

        // Format the new ID with leading zeros
        return "cus" + String.format("%03d", nextNum);
    }
}
