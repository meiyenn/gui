<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    // Simulate session role (REMOVE in production)
    // session.setAttribute("role", "manager"); // or "staff"

    String role = (String) session.getAttribute("role");
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
        body { font-family: Arial, sans-serif; }
        table { width: 90%; margin: auto; border-collapse: collapse; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
        th { background-color: #f2f2f2; }
        .btn-delete, .btn-edit, .btn-add {
            padding: 5px 10px;
            border: none;
            color: white;
            cursor: pointer;
        }
        .btn-delete { background-color: red; }
        .btn-edit { background-color: orange; }
        .btn-add { background-color: green; text-decoration: none; display: inline-block; }
        .top-bar { text-align: center; margin: 20px; }
        form.search-form { text-align: center; margin-bottom: 20px; }
        input[type="text"] { padding: 5px; width: 250px; }
        input[type="submit"] { padding: 5px 10px; }
    </style>
</head>
<body>

<div class="top-bar">
    <p>Logged in as: <%= role %> | <a href="Logout">Logout</a></p>
    <% if ("manager".equals(role)) { %>
        <a href="AddStaff.jsp" class="btn-add">Add New Staff</a>
    <% } %>
</div>

<h2 style="text-align:center;">Staff List</h2>

<!-- Search Form -->
<form method="get" class="search-form">
    <input type="text" name="search" placeholder="Search by Staff ID or Name" value="<%= keyword != null ? keyword : "" %>">
    <input type="submit" value="Search">
</form>

<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Contact</th>
            <th>Position</th>
            <th>Username</th>
            <th>Password</th>
            <% if ("manager".equals(role)) { %>
                <th>Actions</th>
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
            <td>
                <!-- Edit Button -->
                <form action="editStaff.jsp" method="get" style="display:inline;">
                    <input type="hidden" name="staffId" value="<%= rs.getString("staffId") %>">
                    <input type="submit" value="Edit" class="btn-edit">
                </form>
                <!-- Delete Button -->
                <form method="get" style="display:inline;">
                    <input type="hidden" name="delete" value="<%= rs.getString("staffId") %>">
                    <input type="submit" value="Delete" class="btn-delete" onclick="return confirm('Are you sure?')">
                </form>
            </td>
            <% } %>
        </tr>
        <%
            }
            if (!hasData) {
        %>
        <tr>
            <td colspan="<%= "manager".equals(role) ? "8" : "7" %>">No staff found.</td>
        </tr>
        <%
            }
        %>
    </tbody>
</table>

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
