<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Beauty Promotions</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px 0;
        }
        h1 {
            text-align: center;
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 40px;
        }
        .offers-container {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
        }
        .offer-card {
            width: 30%;
            margin-bottom: 30px;
            text-align: center;
        }
        .offer-image {
            background-color: #f0e5d3;
            height: 300px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
        }
        .offer-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 15px;
            text-transform: uppercase;
        }
        .offer-description {
            font-size: 14px;
            color: #666;
            line-height: 1.4;
            margin-bottom: 15px;
        }
        .shop-button {
            background-color: #000;
            color: #fff;
            padding: 10px 30px;
            text-transform: uppercase;
            border: none;
            font-size: 14px;
            cursor: pointer;
            display: inline-block;
            text-decoration: none;
            margin-top: 10px;
        }
        .terms {
            font-size: 11px;
            color: #999;
            margin-top: 5px;
            margin-bottom: 15px;
        }
        @media (max-width: 768px) {
            .offer-card {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>OUR CURRENT OFFERS</h1><br><br>
        
        <div class="offers-container">
            <div class="offer-card">
                <div class="offer-image">
                    <img src="src/image/offer1.jpg" alt="Fragrance Week" />
                </div>
                <h2 class="offer-title">FREE SHIPPING</h2>
                <p class="offer-description">
                    Enjoy free delivery when you shop for RM1000 or more.<br>
                    No hidden fees—just a great deal for you!
                </p>
                <p class="terms">*T&Cs apply</p>
                <a href="ProductPage.jsp" class="shop-button">SHOP NOW</a>
            </div>
            
            <div class="offer-card">
                <div class="offer-image">
                    <img src="src/image/offer2.jpg" alt="Join The Club" />
                </div>
                <h2 class="offer-title">JOIN THE MEMBERSHIP</h2>
                <p class="offer-description">
                    Get RM10 off your first order<br>
                    with no minimum spend!<br>
                    Enjoy member benefits and discounts.
                </p>
                <p class="terms">*While stocks last. T&Cs apply.</p>
                <a href="CustomerRegister.jsp" class="shop-button">SIGNUP NOW</a>
            </div>
            
            <div class="offer-card">
                <div class="offer-image">
                    <img src="src/image/offer3.jpg" alt="Monthly Gifts" />
                </div>
                <h2 class="offer-title">YOUR MONTHLY GIFTS</h2>
                <p class="offer-description">
                    Free More Voucher<br>
                    RM200OFF10 and RM350OFF20<br>
                    when you register
                </p>
                <p class="terms">*While stocks last. T&Cs apply.</p>
                <a href="ProductPage.jsp" class="shop-button">SHOP NOW</a>
            </div>
        </div>
    </div>
    
    <!-- Optional: Include JavaScript -->
    <script>
        // You can add any JavaScript functionality here
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Promotions page loaded');
        });
    </script>
</body>
</html>