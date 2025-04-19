<%-- 
    Document   : header
    Created on : Apr 13, 2025, 7:31:04 PM
    Author     : Huay
--%>
<%@page import="java.sql.Blob"%>
<%@page import="java.util.List"%>
<%@page import="model.*"%>

<%
    Customer customer = (Customer) session.getAttribute("customer");
%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>

        <!-- css -->
        <link rel="stylesheet" type="text/css" href="src/css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="src/css/style.css">
        <link rel="stylesheet" href="src/css/responsive.css">
        <link rel="stylesheet" href="src/css/jquery.mCustomScrollbar.min.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/owl-carousel/1.3.3/owl.carousel.css" rel="stylesheet" />

        <!-- font-->
        <link rel="stylesheet" href="https://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
        <link href="https://fonts.googleapis.com/css?family=Poppins:400,700&display=swap" rel="stylesheet">
        
    </head>

    <body>
        <!-- header section-->
        <div class="header_section">
            <div class="container-fluid">
                <nav class="navbar navbar-expand-lg navbar-light bg-light">
                    <a class="logo" href="index.jsp"><img src="src/image/logo.png"></a>
                    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>

                    <div class="collapse navbar-collapse" id="navbarSupportedContent">
                        <ul class="navbar-nav mr-auto">
                            <li class="nav-item active">
                                <a class="nav-link" href="index.jsp">Home</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="ProductPage.jsp">Product</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href=".jsp">Review</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="about.jsp">About & Contact</a>
                            </li>
                        </ul>

                        <form class="form-inline my-2 my-lg-0">
                            <div class="login_menu">
                                <div class="login_menu">
                                    <%
                                        String role = (String) session.getAttribute("role");
                                        String username = (String) session.getAttribute("username");
                                    %>

                                    <ul>
                                        <% if (username != null && role != null) {%>
                                        <li>
                                            <div class="profile-wrapper">
                                            <a class="nav-link profile-container"
                                               href="<%="manager".equals(role) ? "StaffManagerDashboard.jsp"
                                                      : "staff".equals(role) ? "StaffManagerDashboard.jsp"
                                                       : "CustomerDashboard.jsp"%>">
                                                <!--<img src="src/image/profile-icon.png" alt="Profile">-->
                                                <span><%= "Profile "+ username%></span>
                                            </a>
                                                <div class="logout-dropdown">
                                                 <a href="Logout">Logout</a>
                                            </div>
                                            </div>
                                        </li>
                                            <% } else { %>
                                        <li><a href="CustomerLogin.jsp"><img src="src/image/user-icon.png" alt="Login"></a></li>
                                                <% }%>
                                        <li><a href="ShoppingCart.jsp"><img src="src/image/trolly-icon.png"></a></li>
                                                <%
                                                    String currentCategory = request.getParameter("category");
                                                %>

                                        <li>
                                            <form method="get" action="ProductPage.jsp" style="display: flex; align-items: center;">
                                                <input type="text" name="search" placeholder="Search products..." style="padding: 5px; font-size: 14px;" />

                                                <% if (currentCategory != null && !currentCategory.isEmpty()) {%>
                                                <input type="hidden" name="category" value="<%= currentCategory%>"/>
                                                <% }%>

                                                <button type="submit" style="border: none; background: none; cursor: pointer;">
                                                    <img src="src/image/search-icon.png" alt="Search" onclick="search()" style="width: 20px; height: 20px;">
                                                </button>
                                            </form>
                                        </li>
                                    </ul>
                                </div>
                        </form>
                    </div>
                </nav>
            </div>
        </div>
    </body>
</html>
