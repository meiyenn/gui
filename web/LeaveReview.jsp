<%-- 
    Document   : LeaveReview
    Created on : Apr 21, 2025, 4:38:00 PM
    Author     : Huay
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String productId = request.getParameter("productId");
    String receiptId = request.getParameter("receiptId");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Write a Review</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 40px auto;
                width: 500px;
            }
            .star-rating {
                direction: rtl;
                display: flex;
                justify-content: flex-start;
                font-size: 2em;
            }
            .star-rating input {
                display: none;
            }
            .star-rating label {
                color: #ccc;
                cursor: pointer;
                transition: color 0.2s;
            }
            .star-rating input:checked ~ label,
            .star-rating label:hover,
            .star-rating label:hover ~ label {
                color: #ffc107;
            }
            textarea {
                width: 100%;
                resize: none;
                margin-top: 10px;
            }
            .btn-submit {
                margin-top: 15px;
                background-color: #2563eb;
                color: white;
                padding: 8px 16px;
                border: none;
                cursor: pointer;
                border-radius: 5px;
            }
        </style>
    </head>
    <body>

        <h2>Write a Review</h2>

        <form action="submitReview" method="post">
            <input type="hidden" name="productId" value="<%= productId%>">
            <input type="hidden" name="receiptId" value="<%= receiptId%>">

            <label>Satisfaction:</label>
            <div class="star-rating">
                <input type="radio" id="5-stars" name="rating" value="5" required><label for="5-stars">&#9733;</label>
                <input type="radio" id="4-stars" name="rating" value="4"><label for="4-stars">&#9733;</label>
                <input type="radio" id="3-stars" name="rating" value="3"><label for="3-stars">&#9733;</label>
                <input type="radio" id="2-stars" name="rating" value="2"><label for="2-stars">&#9733;</label>
                <input type="radio" id="1-star"  name="rating" value="1"><label for="1-star">&#9733;</label>
            </div>

            <label for="comment">Comment:</label><br>
            <textarea name="comment" rows="5" maxlength="200" required></textarea><br>

            <button type="submit" class="btn-submit">Submit Review</button>
        </form>

    </body>
</html>
