<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="model.ReviewService" %>
<%@ include file="header.jsp" %>

<%
    String categoryFilter = request.getParameter("category");
    String searchQuery = request.getParameter("search");
    String userRole = (String) session.getAttribute("role");
    if (userRole == null) userRole = "guest";
%>

<!DOCTYPE html>
<html>
<head>
    <title>All Products</title>
    <link rel="stylesheet" type="text/css" href="src/css/productpage.css">
    <style>
        .category-nav a {
            text-decoration: none;
            color: <%= (categoryFilter == null) ? "#000" : "#777"%>;
        }
        .category-nav a.active {
            color: #000;
            border-bottom: 2px solid black;
        }
        .product-rating {
            color: #f5c518;
            font-size: 18px;
            margin-top: 5px;
        }
    </style>
</head>
<body>

<h1>All Products</h1>

<form method="post" action="ProductPage.jsp" style="text-align: center; margin-bottom: 30px;">
    <input type="text" name="search" placeholder="Search products..." value="<%= (searchQuery != null) ? searchQuery : "" %>" style="padding: 10px; width: 300px; font-size: 16px;" />
    <input type="hidden" name="category" value="<%= (categoryFilter != null) ? categoryFilter : "" %>" />
    <button type="submit" style="padding: 10px 15px; font-size: 16px;">Search</button>
</form>

<div class="category-nav">
    <a href="ProductPage.jsp"<%= (categoryFilter == null || categoryFilter.isEmpty()) ? " class='active'" : "" %>>ALL</a>
    <a href="ProductPage.jsp?category=make up<%= (searchQuery != null) ? "&search=" + searchQuery : "" %>"<%= "make up".equalsIgnoreCase(categoryFilter) ? " class='active'" : "" %>>MAKEUP</a>
    <a href="ProductPage.jsp?category=skin care<%= (searchQuery != null) ? "&search=" + searchQuery : "" %>"<%= "skin care".equalsIgnoreCase(categoryFilter) ? " class='active'" : "" %>>SKINCARE</a>
</div>

<div class="product-row">
<%
    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/ass", "nbuser", "nbuser");

        String sql = "SELECT * FROM Product WHERE status = 1";
        boolean hasCategory = categoryFilter != null && !categoryFilter.isEmpty();
        boolean hasSearch = searchQuery != null && !searchQuery.trim().isEmpty();

        if (hasCategory) sql += " AND LOWER(Category) = ?";
        if (hasSearch) sql += " AND LOWER(productName) LIKE ?";

        PreparedStatement ps = conn.prepareStatement(sql);
        int paramIndex = 1;
        if (hasCategory) ps.setString(paramIndex++, categoryFilter.toLowerCase());
        if (hasSearch) ps.setString(paramIndex++, "%" + searchQuery.toLowerCase() + "%");

        ResultSet rs = ps.executeQuery();

        boolean hasProduct = false;
        ReviewService reviewService = new ReviewService();

        while(rs.next()) {
            hasProduct = true;

            String pid = rs.getString("productId");
            String name = rs.getString("productName");
            String img = rs.getString("imgLocation");
            double price = rs.getDouble("price");
            String desc = rs.getString("productDescription");
            int stock = rs.getInt("quantity");

            double rating = reviewService.getAverageRating(pid);
            int reviewCount = reviewService.getReviewCount(pid);

%>
    <div class="product-card" onclick="showProductModal('<%= pid %>', '<%= name.replace("'", "\\'") %>', '<%= img %>', <%= price %>, '<%= desc.replace("'", "\\'") %>', <%= rating %>)">
        <img src="imgUpload/<%= img %>" alt="<%= name %>">
        <div class="product-name"><%= name %></div>
        <div class="product-price">RM <%= price %></div>
        <div class="product-stock">Stock left: <%= stock %></div>
        <div class="product-rating">
            <%
                int fullStars = (int) rating;
                boolean halfStar = (rating - fullStars) >= 0.5;
                for (int i = 0; i < fullStars; i++) {
                    out.print("★");
                }
                if (halfStar) {
                    out.print("½");
                }
                for (int i = fullStars + (halfStar ? 1 : 0); i < 5; i++)
                    out.print("☆");
            %>
            (<%= String.format("%.1f", rating)%>) · <%= reviewCount%> review<%= (reviewCount != 1) ? "s" : ""%>
        </div>
        <% if (stock > 0) { %>
            <form method="post" action="AddToCart">
                <input type="hidden" name="pid" value="<%= pid %>" />
                <input type="hidden" name="pqty" value="1" />
                <% if ("customer".equals(userRole)) { %>
                    <button type="submit" class="btn-add">Add to Cart</button>
                <% } else { %>
                    <button type="button" class="btn-add" onclick="showLoginAlert()">Add to Cart</button>
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

<!-- 📦 Modal -->
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

<script>
    function showLoginAlert() {
        alert("Please login first to add items to your cart.");
        window.location.href = 'CustomerLogin.jsp';
    }

    function showProductModal(pid, name, img, price, desc, rating) {
        document.getElementById("modalName").innerText = name;
        document.getElementById("modalImg").src = "imgUpload/" + img;;
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
