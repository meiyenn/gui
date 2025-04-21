<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Registration</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            height: 100vh;
            background-image: url('src/image/login-container.jpg'); 
            background-size: cover;  
            background-position: center;  
            background-repeat: no-repeat; 
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .form-container {
            background-color: white;
            padding: 100px 80px;
            border-radius: 5px;
            width: 100%;
            max-width: 500px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }

        .form-container h2 {
            text-align: center;
            margin-bottom: 25px;
            font-size: 22px;
            color: #333;
        }

        .input-group {
            margin-bottom: 15px;
        }

        .input-group input {
            width: 100%;
            padding: 12px;
            font-size: 1rem;
            border: 1px solid #ccc;
            border-radius: 6px;
            outline: none;
        }

        .input-group input:focus {
            border-color: #a5a5ff;
        }

        .login-btn {
            width: 100%;
            padding: 12px;
            background-color: #a5a5ff;
            border: none;
            border-radius: 6px;
            color: white;
            font-weight: bold;
            cursor: pointer;
            margin-top: 10px;
        }

        .login-btn:hover {
            background-color: #7f7fd5;
        }

        .login-link {
            text-align: center;
            margin-top: 15px;
            font-size: 0.9rem;
        }

        .login-link a {
            color: #7a5eff;
            text-decoration: none;
            font-weight: bold;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        .error-message {
            background-color: rgba(255, 0, 0, 0.1);
            color: red;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 15px;
            text-align: center;
        }
    </style>
</head>
<body>

<div class="form-container">
    <h2>Customer Registration</h2>

    <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="error-message"><%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <form action="RegisterServlet" method="post" onsubmit="return validatePassword()">
        <div class="input-group">
            <input type="text" id="fullName" name="fullName" placeholder="Full Name" required maxlength="30">
        </div>
        <div class="input-group">
            <input type="tel" id="phone" name="phone" placeholder="Contact Number" required maxlength="13" pattern="[0-9]+">
        </div>
        <div class="input-group">
            <input type="email" id="email" name="email" placeholder="Email" required maxlength="35">
        </div>
        <div class="input-group">
            <input type="text" id="username" name="username" placeholder="Username" required maxlength="35">
        </div>
        <div class="input-group">
            <input type="password" id="password" name="password" placeholder="Password" required maxlength="25">
        </div>
        <div class="input-group">
            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm Password" required maxlength="25" oninput="validatePassword()">
            <span id="passwordError" style="color: red; display: none;">Passwords do not match</span>
        </div>

        <button type="submit" class="login-btn" id="submitBtn">Register</button>

        <div class="login-link">
            Already have an account? <a href="CustomerLogin.jsp">Login here</a>
        </div>
    </form>
</div>

<script>
    function validatePassword() {
        const pw = document.getElementById("password").value;
        const cpw = document.getElementById("confirmPassword").value;
        const err = document.getElementById("passwordError");
        const btn = document.getElementById("submitBtn");

        if (pw !== cpw) {
            err.style.display = "block";
            btn.disabled = true;
            return false;
        } else {
            err.style.display = "none";
            btn.disabled = false;
            return true;
        }
    }
</script>

</body>
</html>
