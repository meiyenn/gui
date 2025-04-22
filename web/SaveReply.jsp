<%-- 
    Document   : SaveReply
    Created on : Apr 22, 2025, 4:23:09 PM
    Author     : Huay
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, controller.DBConnection" %>
<%
    String ratingId = request.getParameter("ratingId");
    String reply = request.getParameter("reply");

    try {
        Connection conn = DBConnection.getConnection();
        String sql = "UPDATE productRating SET reply = ? WHERE ratingId = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, reply);
        stmt.setString(2, ratingId);
        int rows = stmt.executeUpdate();
        stmt.close();
        conn.close();

        if (rows > 0) {
            response.sendRedirect("SubmitSuccessful.jsp");
        } else {
            out.print("Failed to update reply.");
        }

    } catch (Exception e) {
        out.print("Error: " + e.getMessage());
    }
%>
