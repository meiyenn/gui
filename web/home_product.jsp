<%@ page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Home | Skincare Store</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #fff;
            margin: 0;
            padding: 10px;
        }

        h1 {
            text-align: center;
            font-size: 28px;
            margin-bottom: 40px;
            color: #1a1a1a;
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

        .category-nav span {
            cursor: pointer;
            color: #000;
        }

        .category-nav span:hover {
            text-decoration: underline;
        }

        .product-row {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 30px;
        }

        .product-card {
            width: 250px;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            overflow: hidden;
            text-align: center;
            padding: 10px;
            background-color: #fafafa;
            transition: box-shadow 0.3s;
        }

        .product-card:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
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

        .product-rating {
            margin: 8px 0;
        }

        .product-rating .star {
            font-size: 16px;
            color: #FFD700;
            margin: 0 1px;
        }

        .product-rating .star.gray {
            color: #ccc;
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
            border-radius: 4px;
        }

        .btn-add:hover {
            background-color: #444;
        }

        .btn-view-all {
            display: block;
            margin: 40px auto 0;
            padding: 10px 25px;
            background-color: #000;
            color: white;
            text-align: center;
            text-decoration: none;
            font-weight: bold;
            border-radius: 5px;
        }

        .btn-view-all:hover {
            background-color: #444;
        }
        
        
    </style>
</head>
<body>

<h1>DISCOVER OUR BESTSELLERS & NEW ICONS</h1>



<div class="product-row">
<%
    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/ass", "nbuser", "nbuser");

        String sql = "SELECT * FROM Product WHERE status = 1 FETCH FIRST 4 ROWS ONLY";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while(rs.next()) {
%>
    <div class="product-card">
        <img src="<%= rs.getString("imgLocation") %>" alt="Product">
        <div class="product-name"><%= rs.getString("productName") %></div>
        <div class="product-price">RM <%= rs.getDouble("price") %></div>
        <form method="get" action="AddToCart">
            <input type="hidden" name="pid" value="<%= rs.getString("productId") %>">
            <input type="hidden" name="pqty" value="1">
            <button class="btn-add" type="submit">Add to Cart</button>
        </form>
    </div>
<%
        }
        rs.close();
        ps.close();
        conn.close();
    } catch(Exception e) {
        out.println("<p>Error loading products: " + e.getMessage() + "</p>");
    }
%>
</div>

<a href="ProductPage.jsp" class="btn-view-all">VIEW ALL PRODUCTS</a>

</body>
</html>
