<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@include file="staffHeader.jsp" %>

<%
    // Simulate session role (REMOVE in production)
//     session.setAttribute("role", "manager"); // or "staff"

    //String role = (String) session.getAttribute("role");
    if (role == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    if (!"manager".equals(role)) {
            response.sendRedirect("NoAccess.jsp");
            return;
        }


    String deleteId = request.getParameter("delete");
    String keyword = request.getParameter("search");

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        conn = DriverManager.getConnection("jdbc:derby://localhost:1527/ass", "nbuser", "nbuser");

        // Delete staff (manager only)
        if ("manager".equals(role) && deleteId != null && !deleteId.isEmpty()) {
            stmt = conn.prepareStatement("DELETE FROM staff WHERE staffId = ?");
            stmt.setString(1, deleteId);
            stmt.executeUpdate();
            stmt.close();
        }

        // Search query
        String sql = "SELECT * FROM staff";
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " WHERE staffId LIKE ? OR stfName LIKE ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, "%" + keyword + "%");
            stmt.setString(2, "%" + keyword + "%");
        } else {
            stmt = conn.prepareStatement(sql + " ORDER BY staffId");
        }

        rs = stmt.executeQuery();
%>



<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Staff List</title>
    <style>
        .content-area {
                flex: 2;
                padding: 10px;
                width:100%;
                margin-left: 250px;
                margin-right: 50px;
            }
            
            table {
                font-family: arial, sans-serif;
                border-collapse: collapse;
                width: 100%;
                
              }
              
              thead{
                  background-color: #f2f2f2;
                  font-weight: bold;
              }

              td, th {
                border: 1px solid #dddddd;
                text-align: left;
                padding: 8px;
              }

              .edit-btn{
                background-color:#8cd98c;
                color:#ffffff;
                border: 1px solid green;
                padding: 10px 20px;
                text-align: center;
                text-decoration: none;
                font-weight: bold;
                display: inline-block;
              }
              
              .delete-btn{
                background-color:#ff704d;
                color:#ffffff;
                border: 1px solid green;
                padding: 10px 20px;
                text-align: center;
                text-decoration: none;
                font-weight: bold;
                display: inline-block;
              }

              .search{
                display: flex;
                justify-content: flex-end;
                margin-bottom: 15px;
              }
              
              
              #searchText{
                height:30px;
              }
              
              #search-btn,#filter{
                height:35px;
              }

              .addStaff{
                background-color:#5c85d6;
                color:#ffffff;
                border: 1px solid green;
                padding: 10px 20px;
                text-align: center;
                text-decoration: none;
                font-weight: bold; 
                display: inline-block;
                align-items: center;
                justify-content: center;
                height: 30px;
              }
              
            .filter {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .role-banner{ 
                text-align: center; 
                margin-bottom: 10px; 
                color: darkblue; 
                font-weight: bold; 
            }
    </style>
</head>
<body>

    
<div class="content-area">
    <h1>Staff List</h1>
    <div class="filter">
        
        <div style="text-align: center; margin-bottom: 20px;display: inline-block; align-items: center; justify-content: center;">
            <% if ("manager".equals(role)) { %>
                <a href="AddStaff.jsp" class="addStaff">Add New Staff</a>
            <% } %>
        </div>

        <div class="search">
            <!-- Search Form -->
            <form method="get" class="search-form">
                <input type="text" id="searchText" name="search" placeholder="Search by Staff ID or Name" value="<%= keyword != null ? keyword : "" %>">
                <input type="submit" value="Search" id="search-btn">
            </form>
        </div>
    </div>

<table>
    <thead>
        <tr style="height:70px">
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Contact</th>
            <th>Position</th>
            <th>Username</th>
            <th>Password</th>
            <% if ("manager".equals(role)) { %>
                <th colspan="2">Action</th>
            <% } %>
        </tr>
    </thead>
    <tbody>
        <%
            boolean hasData = false;
            while (rs.next()) {
                hasData = true;
        %>
        <tr>
            <td><%= rs.getString("staffId") %></td>
            <td><%= rs.getString("stfName") %></td>
            <td><%= rs.getString("stfEmail") %></td>
            <td><%= rs.getString("stfContactNo") %></td>
            <td><%= rs.getString("stfPosition") %></td>
            <td><%= rs.getString("stfUserName") %></td>
            <td>
                <%= "manager".equals(role) ? rs.getString("stfPswd") : "••••••••" %>
            </td>
            <% if ("manager".equals(role)) { %>
            <td style="text-align:center; vertical-align:middle;">
                <!-- Edit Button -->
                <form action="EditStaffServlet" method="get" style="display:inline;">
                    <input type="hidden" name="staffId" value="<%= rs.getString("staffId") %>">
                    <input type="submit" value="Edit" class="edit-btn">
                </form>
            </td>
            <td style="text-align:center; vertical-align:middle;">
                <!-- Delete Button -->
                <form method="get" style="display:inline;">
                    <input type="hidden" name="delete" value="<%= rs.getString("staffId") %>">
                    <input type="submit" value="Delete" class="delete-btn" onclick="return confirm('Are you sure?')">
                </form>
            </td>
            <% } %>
        </tr>
        <%
            }
            if (!hasData) {
        %>
        <tr>
            <td colspan="<%= "manager".equals(role) ? "9" : "8" %>">No staff found.</td>
        </tr>
        <%
            }
        %>
    </tbody>
</table>
</div>
    
</body>
</html>

<%
    } catch (Exception e) {
        out.println("<p style='color:red; text-align:center;'>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
        if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
    }
%>
