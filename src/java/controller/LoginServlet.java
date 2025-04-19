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
import javax.servlet.http.HttpSession;
import java.sql.*;
import javax.servlet.http.Cookie;

/**
 *
 * @author Huay
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:derby://localhost:1527/ass";
    private static final String USER = "nbuser";
    private static final String PASS = "nbuser";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("custUserName");
        String password = request.getParameter("custPswd");
        boolean rememberMe = request.getParameter("rememberMe") != null;

        HttpSession session = request.getSession();

        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS)) {
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            //manager
            String managerSql = "SELECT * FROM staff WHERE stfUserName = ? AND stfPswd = ? AND stfPosition = 'Manager'";
            try (PreparedStatement stmt = conn.prepareStatement(managerSql)) {
                stmt.setString(1, username);
                stmt.setString(2, password);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    session.setAttribute("username", rs.getString("stfUserName"));
                    session.setAttribute("role", "manager"); // or "admin"

                    if (rememberMe) {
                        Cookie cookie = new Cookie("username", username);
                        cookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                        cookie.setPath("/");
                        response.addCookie(cookie);
                    }

                    response.sendRedirect("StaffManagerDashboard.jsp"); // your admin/manager page
                    return;
                }
            }

            // staff
            String staffSql = "SELECT * FROM staff WHERE stfUserName = ? AND stfPswd = ?";
            try (PreparedStatement stmt = conn.prepareStatement(staffSql)) {
                stmt.setString(1, username);
                stmt.setString(2, password);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    session.setAttribute("username", rs.getString("stfUserName"));
                    session.setAttribute("role", "staff");

                    if (rememberMe) {
                        Cookie cookie = new Cookie("username", username);
                        cookie.setMaxAge(30 * 24 * 60 * 60);
                        cookie.setPath("/");
                        response.addCookie(cookie);
                    }

                    response.sendRedirect("index.jsp?login=success");
                    return;
                }
            }

            // customer
            String custSql = "SELECT * FROM customer WHERE custUserName = ? AND custPswd = ?";
            try (PreparedStatement stmt = conn.prepareStatement(custSql)) {
                stmt.setString(1, username);
                stmt.setString(2, password);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    
                    session.setAttribute("custId", rs.getString("custId"));
                    session.setAttribute("username", rs.getString("custUserName"));
                    session.setAttribute("role", "customer");


                    if (rememberMe) {
                        Cookie cookie = new Cookie("username", username);
                        cookie.setMaxAge(30 * 24 * 60 * 60);
                        cookie.setPath("/");
                        response.addCookie(cookie);
                    }

                    response.sendRedirect("index.jsp?login=success");
                    return;
                }
            }

            // 4. Failed login
            response.sendRedirect("CustomerLogin.jsp?error=Invalid username or password.");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("CustomerLogin.jsp?error=An error occurred.");
        }
    }
}

