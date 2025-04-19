<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    String dbUrl = "jdbc:derby://localhost:1527/ass";
    String dbUser = "nbuser";
    String dbPass = "nbuser";

    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || !"customer".equals(role)) {
        response.sendRedirect("CustomerLogin.jsp?error=Please login first.");
        return;
    }

    String custId = "", custName = "", custContact = "", custEmail = "", custPswd = "";
    int cartCount = 0, orderCount = 0, reviewCount = 0;
    List<String[]> vouchers = new ArrayList<String[]>();

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        // Get customer info
        String sql = "SELECT * FROM customer WHERE custUserName = ?";  // Changed from custUsername to custUserName
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, username);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            custId = rs.getString("custId");
            custName = rs.getString("custName");
            custContact = rs.getString("custContactNo");
            custEmail = rs.getString("custEmail");
            custPswd = rs.getString("custPswd");
        }

        // Get cart count
        stmt = conn.prepareStatement("SELECT COUNT(*) FROM cart WHERE custId = ?");
        stmt.setString(1, custId);
        rs = stmt.executeQuery();
        if (rs.next()) cartCount = rs.getInt(1);
        rs.close();

        // Get order count - Fixed to use JOIN with cart table
        stmt = conn.prepareStatement(
            "SELECT COUNT(DISTINCT r.receiptId) FROM receipt r " +
            "JOIN cart c ON r.cartId = c.cartId " +
            "WHERE c.custId = ?"
        );
        stmt.setString(1, custId);
        rs = stmt.executeQuery();
        if (rs.next()) orderCount = rs.getInt(1);
        rs.close();

        // Get review count - Fixed to use JOIN with receipt and cart tables
        stmt = conn.prepareStatement(
            "SELECT COUNT(*) FROM productRating pr " +
            "JOIN receipt r ON pr.receiptId = r.receiptId " +
            "JOIN cart c ON r.cartId = c.cartId " +
            "WHERE c.custId = ?"
        );
        stmt.setString(1, custId);
        rs = stmt.executeQuery();
        if (rs.next()) reviewCount = rs.getInt(1);
        rs.close();

        // Get unused vouchers - Fixed column names
        stmt = conn.prepareStatement("SELECT code, discount FROM voucher WHERE custId = ? AND used = FALSE");
        stmt.setString(1, custId);
        rs = stmt.executeQuery();
        while (rs.next()) {
            vouchers.add(new String[]{ rs.getString("code"), rs.getString("discount") });
        }
        rs.close();
        stmt.close();

        conn.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <script>
        function confirmUpdate() {
            return confirm("Are you sure you want to update your profile?");
        }

        function goBack() {
            window.location.href = "index.jsp";
        }
    </script>

    <title>Customer Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 40px;
        }

        .container {
            max-width: 700px;
            margin: auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 12px rgba(0,0,0,0.1);
        }

        h2 {
            color: #2c3e50;
            text-align: center;
        }

        .profile-section {
            margin-top: 20px;
        }

        .profile-section label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }

        .profile-section input {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            box-sizing: border-box;
        }

        .quick-access {
            margin-top: 30px;
        }

        .quick-access ul {
            list-style: none;
            padding: 0;
        }

        .quick-access li {
            margin-bottom: 10px;
            background-color: #e1f5fe;
            padding: 12px 20px;
            border-radius: 5px;
            font-size: 18px;
        }

        .quick-access a {
            text-decoration: none;
            color: #0277bd;
            font-weight: bold;
        }

        .quick-access span {
            float: right;
            color: #555;
        }

        .voucher-section {
            margin-top: 30px;
        }

        .voucher-section ul {
            list-style: none;
            padding: 0;
        }

        .voucher-section li {
            background-color: #f9fbe7;
            padding: 10px 15px;
            border-radius: 5px;
            margin-bottom: 8px;
        }

        button {
            margin-top: 20px;
            padding: 10px 18px;
            background-color: #0277bd;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        button:hover {
            background-color: #01579b;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Welcome, <%= custName %>!</h2>

    <div class="profile-section">
        <form action="editCustomer" method="post" onsubmit="return confirmUpdate();">
            <input type="hidden" name="custId" value="<%= custId %>">
            <label>Name:</label>
            <input type="text" name="custName" value="<%= custName %>" required>

            <label>Contact No:</label>
            <input type="text" name="custContactNo" value="<%= custContact %>" required>

            <label>Email:</label>
            <input type="email" name="custEmail" value="<%= custEmail %>" required>

            <label>Username:</label>
            <input type="text" name="custUserName" value="<%= username %>" readonly>

            <label>Password:</label>
            <input type="password" name="custPswd" value="<%= custPswd %>" required>

            <button type="submit">Update Profile</button>
            <button type="button" onclick="goBack()">Back</button>
        </form>
    </div>

    <div class="quick-access">
        <h3>Quick Access</h3>
        <ul>
            <li><a href="ShoppingCart.jsp">🛒 My Cart</a> <span><%= cartCount %></span></li>
            <li><a href="MyOrders.jsp">📦 My Orders</a> <span><%= orderCount %></span></li>
            <li><a href="MyReviews.jsp">⭐ My Reviews</a> <span><%= reviewCount %></span></li>
        </ul>
    </div>

    <div class="voucher-section">
        <h3>🎁 My Vouchers</h3>
        <% if (vouchers.size() == 0) { %>
            <p style="color: gray;">You have no unused vouchers.</p>
        <% } else { %>
            <ul>
                <% for (String[] voucher : vouchers) { %>
                    <li>
                        <strong>Code:</strong> <%= voucher[0] %><br/>
                        <strong>Discount:</strong> RM <%= voucher[1] %>
                    </li>
                <% } %>
            </ul>
        <% } %>
    </div>
</div>
</body>
</html>