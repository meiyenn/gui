<%@ page import="java.sql.*" %>
<%@ page import="controller.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Product Review Management</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
        }
        h2 {
            text-align: center;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: center;
        }
        th {
            background-color: #f0f0f0;
        }
        img {
            max-width: 80px;
            height: auto;
        }
        .btn-reply {
            padding: 6px 10px;
            background-color: #2563eb;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-reply:hover {
            background-color: #1e40af;
        }
    </style>
</head>
<body>
<h2>Product Review Management</h2>

<table>
    <tr>
        <th>Customer ID</th>
        <th>Product</th>
        <th>Date</th>
        <th>Rating</th>
        <th>Comment</th>
        <th>Reply</th>
        <th>Action</th>
    </tr>

<%
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        String sql = "SELECT pr.ratingId, pr.satisfaction, pr.comment, pr.reply, pr.ratingDate, " +
                     "p.productId, p.productName, p.imgLocation, c.custId " +
                     "FROM productRating pr " +
                     "JOIN product p ON pr.productId = p.productId " +
                     "JOIN receipt r ON pr.receiptId = r.receiptId " +
                     "JOIN cart c ON r.cartId = c.cartId";
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();

        while (rs.next()) {
            String ratingId = rs.getString("ratingId");
            int satisfaction = rs.getInt("satisfaction");
            String comment = rs.getString("comment");
            String reply = rs.getString("reply");
            Timestamp date = rs.getTimestamp("ratingDate");
            String productName = rs.getString("productName");
            String imgLocation = rs.getString("imgLocation");
            String custId = rs.getString("custId");
%>
    <tr>
        <td><%= custId %></td>
        <td>
            <img src="<%= imgLocation %>" alt="Product Image"><br>
            <%= productName %>
        </td>
        <td><%= date %></td>
        <td>
            <% for (int i = 0; i < satisfaction; i++) { %>
                ★
            <% } %>
            <% for (int i = satisfaction; i < 5; i++) { %>
                ☆
            <% } %>
        </td>
        <td><%= comment %></td>
        <td><%= (reply != null && !reply.trim().isEmpty()) ? reply : "No reply yet" %></td>
        <td>
            <form method="get" action="ReplyRating.jsp">
                <input type="hidden" name="ratingId" value="<%= ratingId %>">
                <input type="hidden" name="comment" value="<%= comment %>">
                <button type="submit" class="btn-reply">Reply</button>
            </form>
        </td>
    </tr>
<%
        }
    } catch (Exception e) {
%>
    <tr>
        <td colspan="7" style="color:red;">Error: <%= e.getMessage() %></td>
    </tr>
<%
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception ignore) {}
        if (stmt != null) try { stmt.close(); } catch (Exception ignore) {}
        if (conn != null) try { conn.close(); } catch (Exception ignore) {}
    }
%>
</table>

</body>
</html>
