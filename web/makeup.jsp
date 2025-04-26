<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String categoryFilter = "makeup";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Makeup Products</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #fff0f5;
            margin: 0;
            padding: 40px;
        }

        h1 {
            text-align: center;
            font-size: 28px;
            margin-bottom: 40px;
            color: #99004d;
        }

        .category-nav {
            display: flex;
            justify-content: center;
            gap: 40px;
            margin-bottom: 30px;
            font-size: 16px;
            font-weight: bold;
            border-bottom: 1px solid #ccc;
            padding-bottom: 10px;
        }

        .category-nav a {
            text-decoration: none;
            color: #777;
        }

        .category-nav a.active {
            color: #000;
            border-bottom: 2px solid black;
        }

        .product-row {
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
            justify-content: center;
        }

        .product-card {
            width: 250px;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            overflow: hidden;
            text-align: center;
            padding: 10px;
            background-color: #fff;
        }

        .product-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .product-name {
            font-weight: 600;
            margin: 10px 0 5px;
        }

        .product-size {
            color: #666;
            font-size: 13px;
        }

        .product-price {
            font-size: 16px;
            margin: 8px 0;
            color: #000;
        }

        .btn-add {
            display: block;
            background-color: #000;
            color: #fff;
            border: none;
            padding: 10px 0;
            width: 100%;
            font-weight: bold;
            text-transform: uppercase;
            cursor: pointer;
        }

        .btn-add:hover {
            background-color: #444;
        }
    </style>
</head>
<body>

<h1>Makeup Products</h1>

<div class="category-nav">
    <a href="productList.jsp">ALL</a>
    <a href="makeup.jsp" class="active">MAKEUP</a>
    <a href="skincare.jsp">SKINCARE</a>
</div>

<div class="product-row">
<%
    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/assignment", "nbuser", "nbuser");

        String sql = "SELECT * FROM Product WHERE status = 1 AND LOWER(productDescription) LIKE ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, "%" + categoryFilter.toLowerCase() + "%");

        ResultSet rs = ps.executeQuery();

        while(rs.next()) {
%>
    <div class="product-card">
        <img src="<%= rs.getString("imgLocation")%>" alt="Product">
        <div class="product-name"><%= rs.getString("productName")%></div>
        <div class="product-size">One size only</div>
        <div class="product-size"><%= rs.getString("productDescription")%></div>
        <div class="product-price">RM <%= rs.getDouble("price")%></div>

        <form method="get" action="AddToCartServlet">
            <input type="hidden" name="pid" value="<%= rs.getString("productId")%>">
            <input type="hidden" name="pqty" value="1">
            <button class="btn-add" type="submit">Add to Cart</button>
        </form>

        <form method="get" action="ProductDetails.jsp">
            <input type="hidden" name="productId" value="<%= rs.getString("productId")%>">
            <button class="btn-add" type="submit">View Details</button>
        </form>
    </div>

<%
        }

        rs.close();
        ps.close();
        conn.close();
    } catch(Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
</div>

</body>
</html>
