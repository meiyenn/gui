<%@ page import="java.util.List" %>
<%@ page import="model.Productrating" %>
<%@ page import="model.ReviewService" %>
<%@ page import="model.Product" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%
    String custId = (String) session.getAttribute("custId");

    if (custId == null) {
%>
    <script>
        alert("Please login first.");
        window.location.href = "CustomerLogin.jsp";
    </script>
<%
        return;
    }

    ReviewService service = new ReviewService();
    List<Productrating> reviews = service.getReviewsByCustomer(custId);
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Reviews</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 10px;
        }

        h2 {
            text-align: center;
            color: #333;
        }

        .review-container {
            max-width: 900px;
            margin: auto;
        }

        .review-box {
            display: flex;
            align-items: flex-start;
            background-color: white;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        .product-img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            margin-right: 20px;
            border-radius: 8px;
        }

        .review-details {
            flex: 1;
        }

        .stars {
            color: #ffc107;
            font-size: 18px;
            margin-bottom: 5px;
        }

        .review-date {
            font-size: 12px;
            color: #777;
        }

        .review-comment {
            margin: 10px 0;
            color: #444;
        }

        .product-name {
            font-weight: bold;
            margin-bottom: 6px;
            display: block;
            color: #333;
        }
    </style>
</head>
<body>

    <%@include file="header.jsp" %>
<div class="review-container">
    <h2>My Reviews</h2>

    <% if (reviews == null || reviews.isEmpty()) { %>
        <p style="text-align: center;">You haven't submitted any reviews yet.</p>
    <% } else { 
        for (Productrating review : reviews) {
            Product product = review.getProductid(); 
    %>
        <div class="review-box">
            <img src="<%= product.getImglocation() %>" class="product-img" alt="Product Image">
            <div class="review-details">
                <span class="product-name"><%= product.getProductname() %></span>
                <div class="stars">
                    <% for (int i = 1; i <= 5; i++) { %>
                        <%= i <= review.getSatisfaction() ? "★" : "☆" %>
                    <% } %>
                </div>
                <div class="review-comment"><%= review.getComment() %></div>
                <div class="review-date">Reviewed on: <%= review.getRatingdate() %></div>
            </div>
        </div>
    <%  } 
    } %>
</div>

</body>
</html>
