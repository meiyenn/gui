/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Huay
 */
@WebServlet(name = "editCustomer", urlPatterns = {"/editCustomer"})
public class editCustomer extends HttpServlet {
    private static final String DB_URL = "jdbc:derby://localhost:1527/ass";
    private static final String DB_USER = "nbuser";
    private static final String DB_PASSWORD = "nbuser";
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String custId = request.getParameter("custId");
            String custName = request.getParameter("custName");
            String custContactNo = request.getParameter("custContactNo");
            String custEmail = request.getParameter("custEmail");
            String custPswd = request.getParameter("custPswd");

            try {
                Class.forName("org.apache.derby.jdbc.ClientDriver");
                Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

                String sql = "UPDATE customer SET custName=?, custContactNo=?, custEmail=?, custPswd=? WHERE custId=?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, custName);
                stmt.setString(2, custContactNo);
                stmt.setString(3, custEmail);
                stmt.setString(4, custPswd);
                stmt.setString(5, custId);

                int rows = stmt.executeUpdate();

                stmt.close();
                conn.close();

                if (rows > 0) {
                    response.sendRedirect("CustomerDashboard.jsp?message=Profile updated successfully");
                } else {
                    response.sendRedirect("CustomerDashboard.jsp?error=Failed to update profile");
                }

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("CustomerDashboard.jsp?error=An error occurred: " + e.getMessage());
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
