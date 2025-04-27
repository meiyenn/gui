package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "UpdateStaff", urlPatterns = {"/UpdateStaff"})
public class UpdateStaff extends HttpServlet {
    private static final String DB_URL = "jdbc:derby://localhost:1527/ass";
    private static final String DB_USER = "nbuser";
    private static final String DB_PASSWORD = "nbuser";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        request.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            // Retrieve form data
            String staffId = request.getParameter("staffId");
            String stfName = request.getParameter("stfName");
            String stfContactNo = request.getParameter("stfContactNo");
            String stfEmail = request.getParameter("stfEmail");
            String stfPswd = request.getParameter("stfPswd");
            String stfPosition = request.getParameter("stfPosition");

            try {
                Class.forName("org.apache.derby.jdbc.ClientDriver");
                Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

                String sql = "UPDATE staff SET stfName=?, stfContactNo=?, stfEmail=?, stfPswd=?, stfPosition=? WHERE staffId=?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, stfName);
                stmt.setString(2, stfContactNo);
                stmt.setString(3, stfEmail);
                stmt.setString(4, stfPswd);
                stmt.setString(5, stfPosition);
                stmt.setString(6, staffId);

                int rows = stmt.executeUpdate();

                stmt.close();
                conn.close();

                if (rows > 0) {
                    response.sendRedirect("StaffProfile.jsp?message=Profile updated successfully");
                } else {
                    response.sendRedirect("StaffProfile.jsp?error=Failed to update profile");
                }

            } catch (Exception e) {
                e.printStackTrace(out);
                response.sendRedirect("StaffProfile.jsp?error=An error occurred: " + e.getMessage());
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Handles staff profile updates";
    }
}