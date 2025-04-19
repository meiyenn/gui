<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null) {
        response.sendRedirect("login.jsp?error=Please login first.");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            display: flex;
        }

        .sidebar {
            width: 240px;
            background-color: #2c3e50;
            color: white;
            min-height: 100vh;
            padding: 20px;
        }

        .profile {
            text-align: center;
            margin-bottom: 30px;
        }

        .profile img {
            width: 80px;
            border-radius: 50%;
        }

        .profile h3 {
            margin: 10px 0 0 0;
        }

        .nav-links {
            list-style-type: none;
            padding: 0;
        }

        .nav-links li {
            margin: 20px 0;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            font-weight: bold;
        }

        .nav-links a:hover {
            text-decoration: underline;
        }

        .main-content {
            flex: 1;
            padding: 40px;
            background-color: #f4f4f4;
        }

    </style>
</head>
<body>
<div class="sidebar">
    <div class="profile">
        <img src="src/image/profile-manager.jpg" alt="Profile Pic" />
        <h3><%= username %></h3>
        <p><%= role.toUpperCase() %></p>
    </div>

    <ul class="nav-links">
        <% if ("staff".equals(role)) { %>
            <li><a href="StaffProfile.jsp">My Profile</a></li>
            <li><a href="CustomerManagement.jsp">Customer Management</a></li>
            <li><a href="ProductManagement.jsp">Product Management</a></li>
            <li><a href="ReviewManagement.jsp">Review Management</a></li>
        <% } else if ("admin".equals(role) || "manager".equals(role)) { %>
            <li><a href="CustomerManagement.jsp">Customer Management</a></li>
            <li><a href="ProductManagement.jsp">Product Management</a></li>
            <li><a href="ReviewManagement.jsp">Review Management</a></li>
            <li><a href="StaffManagement.jsp">Staff Management</a></li>
            <li><a href="Reports.jsp">Reports</a></li>
        <% } %>
        <li><a href="Logout">Logout</a></li>
    </ul>
</div>

<div class="main-content">
    <h2>Welcome, <%= username %>!</h2>
    <p>Role: <%= role %></p>
    <!-- You can add content cards or stats here -->
</div>
</body>
</html>
