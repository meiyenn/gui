<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%

    String role = (String) session.getAttribute("role");
    if (role == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String keyword = request.getParameter("search");
    String deleteId = request.getParameter("delete");

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        conn = DriverManager.getConnection("jdbc:derby://localhost:1527/ass", "nbuser", "nbuser");

        // Delete logic (only for manager)
        if ("manager".equals(role) && deleteId != null && !deleteId.isEmpty()) {
            stmt = conn.prepareStatement("DELETE FROM Customer WHERE custId = ?");
            stmt.setString(1, deleteId);
            stmt.executeUpdate();
            stmt.close();
        }

        // Search query
        String sql = "SELECT * FROM Customer";
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " WHERE custId LIKE ? OR custName LIKE ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, "%" + keyword + "%");
            stmt.setString(2, "%" + keyword + "%");
        } else {
            stmt = conn.prepareStatement(sql);
        }

        rs = stmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Management</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
        }
        table { 
            width: 90%; 
            margin: auto; 
            border-collapse: collapse; 
        }
        th, td { 
            border: 1px solid #ccc; 
            padding: 8px; 
            text-align: center; 
        }
        th { 
            background-color: #eee; 
        }
        form { 
            text-align: center; 
            margin: 20px; 
        }
        .btn-delete { 
            background-color: red; 
            color: white; 
            border: none; 
            padding: 5px 10px; 
            cursor: pointer; 
        }
        .btn-search, .btn-edit { 
            padding: 5px 10px; 
        }
        .role-banner { 
            text-align: center; 
            margin-bottom: 10px; 
            color: darkblue; 
            font-weight: bold; 
        }
    </style>
</head>
<body>

<div class="role-banner">
    Logged in as: <%= role %> | <a href="logout.jsp">Logout</a>
</div>

<h2 style="text-align:center;">Customer List</h2>

<!-- Search Form -->
<form method="get">
    <input type="text" name="search" placeholder="Search by ID or Name" value="<%= (keyword != null ? keyword : "") %>">
    <input type="submit" value="Search" class="btn-search">
</form>

<!-- Customer Table -->
<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Contact No</th>
            <th>Email</th>
            <th>Username</th>
            <% if ("manager".equals(role)) { %>
                <th>Password</th>
            <% } else { %>
                <th>Password</th>
            <% } %>
            <th>Action</th>
        </tr>
    </thead>
    <tbody>
        <%
            boolean hasData = false;
            while (rs.next()) {
                hasData = true;
        %>
        <tr>
            <td><%= rs.getString("custId") %></td>
            <td><%= rs.getString("custName") %></td>
            <td><%= rs.getString("custContactNo") %></td>
            <td><%= rs.getString("custEmail") %></td>
            <td><%= rs.getString("custUserName") %></td>
            <td>
                <% if ("manager".equals(role)) { %>
                    <%= rs.getString("custPswd") %>
                <% } else { %>
                    •••••••• 
                <% } %>
            </td>
            <td>
                <% if ("manager".equals(role)) { %>
                    <!-- Delete Button -->
                    <form method="get" style="display:inline;">
                        <input type="hidden" name="delete" value="<%= rs.getString("custId") %>">
                        <input type="submit" value="Delete" class="btn-delete" onclick="return confirm('Are you sure?')">
                    </form>
                    <!-- Edit Button -->
                    <form action="editCustomer.jsp" method="get" style="display:inline;">
                        <input type="hidden" name="custId" value="<%= rs.getString("custId") %>">
                        <input type="submit" value="Edit" class="btn-edit">
                    </form>
                <% } else { %>
                    <em>View Only</em>
                <% } %>
            </td>
        </tr>
        <%
            }
            if (!hasData) {
        %>
        <tr><td colspan="7">No customers found.</td></tr>
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
