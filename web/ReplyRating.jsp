<%-- 
    Document   : ReplyRating
    Created on : Apr 22, 2025, 4:21:46 PM
    Author     : Huay
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.ReviewService" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Reply to Rating</title>
        <style>
            body {
    font-family: Arial, sans-serif;
    padding: 20px;
    }
            form {
    max-width: 500px;
    margin: auto;
    }
            textarea {
    width: 100%;
    height: 100px;
    resize: vertical;
    }
            .btn-submit {
    padding: 8px 20px;
    background-color: #16a34a;
    color: white;
    border: none;
    cursor: pointer;
    }
        </style>
    </head>
    <body>

        <%
            String ratingId = request.getParameter("ratingId");
            String comment = request.getParameter("comment");
        %>

        <h2>Reply to Rating ID: <%= ratingId%></h2>
        <p><strong>Customer Comment:</strong> <%= comment%></p>

        <form method="post" action="SaveReply.jsp">
            <input type="hidden" name="ratingId" value="<%= ratingId%>">
            <label for="reply">Your Reply:</label>
            <textarea name="reply" required></textarea><br><br>
            <button type="submit" class="btn-submit">Submit Reply</button>
        </form>

    </body>
</html>
