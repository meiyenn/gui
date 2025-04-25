<%-- 
    Document   : salesReport
    Created on : Apr 22, 2025, 8:38:56 PM
    Author     : Mei Yen
--%>

<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@ page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.ProductDa" %>
<%@include file="staffHeader.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sales Report</title>
        <style>
            .content-area {
                flex: 2;
                padding: 10px;
                width:100%;
                margin-left: 250px;
                margin-right: 50px;
            }
            
            table {
              border-collapse: collapse;
              width: 100%;
            }

            th,td {
                border-bottom: 1px solid gray;
                padding: 12px;
                text-align: center;
            }

            tr:nth-child(even) {
                background-color: #f2f2f2;
            }          
            
        </style>
    </head>
    <body>
        <div class="content-area">
        <h1>Sales Report</h1>
        
        <%
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        // default is based on year if not select
        if (startDate == null || endDate == null || startDate.isEmpty() || endDate.isEmpty()) {
            LocalDateTime now = LocalDateTime.now();
            int currentYear = now.getYear();
            LocalDateTime start = LocalDateTime.of(currentYear, 1, 1, 0, 0, 0);
            LocalDateTime end = LocalDateTime.of(currentYear, 12, 31, 23, 59, 59);
            DateTimeFormatter sqlFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
            startDate = start.format(sqlFormat);
            endDate = end.format(sqlFormat);
        } else {
            // when second load
            startDate = startDate.replace('T', ' ') + ":00.000";
            endDate = endDate.replace('T', ' ') + ":00.000";
        }
        %>
        
        <form method="get">
            <label for="startDate">Start Date & Time:</label>
            <input type="datetime-local" id="startDate" name="startDate" value="<%= startDate.replace(' ', 'T').substring(0, 16) %>">
            <br><br>
            
            <label for="endDate">End Date & Time:</label>
            <input type="datetime-local" id="endDate" name="endDate" value="<%= endDate.replace(' ', 'T').substring(0, 16) %>">
            <br><br>
            <%--checking--%>
            
            <input type="submit" value="Generate Report">
        </form>

    <hr>
    <br>
    <p>Querying sales from <%= startDate %> to <%= endDate %></p>

    <table>
        <tr>
            <th>Product ID</th>
            <th>Name</th>
            <th>Category</th>
            <th>Price</th>
            <th>Units Sold</th>
            <th>Total Sales (RM)</th>
        </tr>
        <% 
            ProductDa pda = new ProductDa(); 
            ResultSet rs=pda.salesRecord(startDate,endDate);
                    
        %>
        <%
            if (rs != null) {
                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("productId") %></td>
            <td><%= rs.getString("productName") %></td>
            <td><%= rs.getString("category") %></td>
            <td><%= rs.getDouble("price") %></td>
            <td><%= rs.getInt("Units_Sold") %></td>
            <td><%= String.format("%.2f", rs.getDouble("Total_Sales")) %></td>
        </tr>
        <%
                }
            }
        %>
    </table>
    </div>    
    </body>
</html>
