<%@ page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="header.jsp" %>
<%
    String categoryFilter = request.getParameter("category");
    String searchQuery = request.getParameter("search");
    String userRole = (String) session.getAttribute("role");
    if (userRole == null) {
        userRole = "guest";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>All Products</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #fff;
            margin: 0;
            padding: 40px;
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

        .category-nav a {
            text-decoration: none;
            color: <%= (categoryFilter == null) ? "#000" : "#777"%>;
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
            cursor: pointer;
            transition: transform 0.2s;
        }

        .product-card:hover {
            transform: scale(1.03);
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

        .product-price {
            font-size: 16px;
            margin: 8px 0;
            color: #000;
        }

        .product-rating {
            color: #f5c518;
            font-size: 18px;
            margin: 5px 0;
        }

        /* Modal Style */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.6);
        }

        .modal-content {
            background-color: #fff;
            margin: 10% auto;
            padding: 20px;
            width: 400px;
            border-radius: 8px;
            position: relative;
            text-align: left;
        }

        .close-btn {
            position: absolute;
            top: 10px;
            right: 15px;
            font-size: 20px;
            font-weight: bold;
            cursor: pointer;
        }

        #modalImg {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 6px;
        }

        #modalName {
            font-size: 20px;
            margin: 10px 0 5px;
        }

        #modalPrice {
            font-weight: bold;
            font-size: 16px;
        }

        #modalDesc {
            margin-top: 10px;
            font-size: 14px;
        }

        #modalRating {
            margin-top: 8px;
            font-size: 16px;
            color: #f5c518;
        }

        .btn-add {
            background-color: #000;
            color: white;
            border: none;
            padding: 8px 15px;
            
            cursor: pointer;
            margin-top: 15px;
            font-size: 14px;
            font-weight: bold;
        }

        .btn-add:hover {
            background-color: #333;
        }
        
        .product-stock {
            font-size: 14px;
            color: #888;
            margin-top: 5px;
        }

    </style>
</head>
<body>

<h1>All Products</h1>

<!-- 🔍 Search Bar -->
<form method="post" action="ProductPage.jsp" style="text-align: center; margin-bottom: 30px;">
    <input type="text" name="search" placeholder="Search products..." value="<%= (searchQuery != null) ? searchQuery : "" %>" style="padding: 10px; width: 300px; font-size: 16px;" />
    <input type="hidden" name="category" value="<%= (categoryFilter != null) ? categoryFilter : "" %>" />
    <button type="submit" style="padding: 10px 15px; font-size: 16px;">Search</button>
</form>

<!-- 🗂️ Category Navigation -->
<div class="category-nav">
    <a href="ProductPage.jsp"<%= (categoryFilter == null || categoryFilter.isEmpty()) ? " class='active'" : "" %>>ALL</a>
    <a href="ProductPage.jsp?category=make up<%= (searchQuery != null) ? "&search=" + searchQuery : "" %>"<%= "make up".equalsIgnoreCase(categoryFilter) ? " class='active'" : "" %>>MAKEUP</a>
    <a href="ProductPage.jsp?category=skin care<%= (searchQuery != null) ? "&search=" + searchQuery : "" %>"<%= "skin care".equalsIgnoreCase(categoryFilter) ? " class='active'" : "" %>>SKINCARE</a>
</div>

<!-- 🛍️ Product Cards -->
<div class="product-row">
<%
    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/ass", "nbuser", "nbuser");

        String sql = "SELECT * FROM Product WHERE status = 1";
        boolean hasCategory = categoryFilter != null && !categoryFilter.isEmpty();
        boolean hasSearch = searchQuery != null && !searchQuery.trim().isEmpty();

        if (hasCategory) {
            sql += " AND LOWER(Category) = ?";
        }
        if (hasSearch) {
            sql += " AND LOWER(productName) LIKE ?";
        }

        PreparedStatement ps = conn.prepareStatement(sql);

        int paramIndex = 1;
        if (hasCategory) {
            ps.setString(paramIndex++, categoryFilter.toLowerCase());
        }
        if (hasSearch) {
            ps.setString(paramIndex++, "%" + searchQuery.toLowerCase() + "%");
        }

        ResultSet rs = ps.executeQuery();
        
        
        boolean hasProduct = false;
while(rs.next()) {
    hasProduct = true;
    double rating = 4.5;
    try { rating = rs.getDouble("rating"); } catch(Exception ex) {}

    String name = rs.getString("productName");
    String img = rs.getString("imgLocation");
    double price = rs.getDouble("price");
    String desc = rs.getString("productDescription");
    String pid = rs.getString("productId");
    int stock = rs.getInt("quantity"); 

%>
<div class="product-card" onclick="showProductModal('<%= pid%>', '<%= name.replace("'", "\\'")%>', '<%= img%>', <%= price%>, '<%= desc.replace("'", "\\'")%>', <%= rating%>)">
    <img src="<%= img%>" alt="<%= name%>">
    <div class="product-name"><%= name%></div>
    <div class="product-price">RM <%= price%></div>
    <div class="product-stock">Stock left: <%= stock%></div>
    <% if (stock > 0) {%>
    <form method="post" action="AddToCart">
        <input type="hidden" name="pid" value="<%= pid%>" />
        <input type="hidden" name="pqty" value="1" />
        <% if ("customer".equals(userRole)) { %>
        <button type="submit" class="btn-add">Add to Cart</button>
        <% } else { %>
        <button type="button" class="btn-add" onclick="window.location.href='CustomerLogin.jsp'">Add to Cart</button>
        <% } %>
    </form>
    <% } else { %>
    <div style="color:red; font-weight:bold;">Out of Stock</div>
    <% } %>
</div>

<%
}
if (!hasProduct) {
%>
    <p style="text-align: center; font-size: 18px; color: #888;">No Product is Found !</p>
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

<!-- 📦 Modal for Product Details -->
<div id="productModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal()">&times;</span>
        <img id="modalImg" src="" alt="Product Image" />
        <h2 id="modalName"></h2>
        <p id="modalPrice"></p>
        <p id="modalDesc"></p>
        <p id="modalRating"></p>

        <form id="addToCartForm" method="post" action="AddToCart">
            <input type="hidden" name="pid" id="modalPid" />
            <input type="hidden" name="pqty" value="1" />
            <% if ("customer".equals(userRole)) { %>
            <button type="submit" class="btn-add">Add to Cart</button>
            <% } else { %>
            <button type="button" class="btn-add" onclick="window.location.href='CustomerLogin.jsp'">Add to Cart</button>
            <% } %>
        </form>
    </div>
</div>

<!-- 🧠 Modal JavaScript -->
<script>
    function showProductModal(pid, name, img, price, desc, rating) {
        document.getElementById("modalName").innerText = name;
        document.getElementById("modalImg").src = img;
        document.getElementById("modalPrice").innerText = "RM " + parseFloat(price).toFixed(2);
        document.getElementById("modalDesc").innerText = desc;
        document.getElementById("modalPid").value = pid;

        let stars = "";
        let fullStars = Math.floor(rating);
        let half = (rating - fullStars) >= 0.5;
        for (let i = 0; i < fullStars; i++) stars += "★";
        if (half) stars += "½";
        for (let i = fullStars + (half ? 1 : 0); i < 5; i++) stars += "☆";

        document.getElementById("modalRating").innerText = stars + " (" + rating.toFixed(1) + ")";
        document.getElementById("productModal").style.display = "block";
    }

    function closeModal() {
        document.getElementById("productModal").style.display = "none";
    }

    window.onclick = function(event) {
        let modal = document.getElementById("productModal");
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
</script>

</body>
</html>
