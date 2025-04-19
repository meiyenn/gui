<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <style>
        /* General Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background-image: url('src/image/banner-bg.png'); 
            background-size: cover; 
            background-position: center; 
            background-repeat: no-repeat; 
        }

        /* Container with background image */
        .container {
            display: flex;
            height: 70vh;
            width: 60%;
            background-image: url('src/image/login-container.jpg'); /* Background image */
            background-size: cover;  /* Ensures the image fills the container while maintaining its aspect ratio */
            background-position: center;  /* Center the image */
            background-repeat: no-repeat; /* Prevent image from repeating */
            border-radius: 10px 10px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }


        /* Left Section Styles */
        .left-section {
            width: 50%;
            height: 100%;  /* Ensure full height */
            padding: 20px;
            color: #333;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            position: relative;  /* Needed for absolute positioning */
            overflow: hidden; /* Prevents the image from overflowing */
        }


        /* Welcome heading styling */
        .left-section h1 {
            font-size: 2.5rem;
            margin-bottom: 50px;
            font-weight: 700;
            z-index: 1;  /* Ensure text stays above the image */
            color:white;
        }

        /* Paragraph text styling */
        .left-section p {
            color:white;
            font-size: 1rem;
            line-height: 1.6;
            font-weight: 300;
            z-index: 1;  /* Ensure text stays above the image */
        }

        .right-section {
            width: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #f9f9f9;
            padding: 20px;
        }

        .login-form {
            width: 80%;
            max-width: 400px;
        }

        .login-form h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #444;
        }

        .input-group {
            margin-bottom: 15px;
        }

        .input-group input {
            width: 100%;
            padding: 12px;
            font-size: 1rem;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        .options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .remember-me input {
            margin-right: 10px;
        }

        a {
            text-decoration: none;
            font-size: 0.9rem;
            color: #a5a5ff;
        }

        a:hover {
            text-decoration: underline;
        }

        .login-btn {
            width: 100%;
            padding: 12px;
            background-color: #a5a5ff;
            color: #fff;
            font-size: 1.1rem;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-bottom: 20px;
        }

        .login-btn:hover {
            background-color: #7070db;
        }

    </style>
</head>
<body>
    
    <div class="container">
        <!-- Left Section with Welcome Text -->
        <div class="left-section">
            <h1>Welcome to Unstoppable</h1>
            <p>Log in to explore a world of luxurious skincare and beauty solutions. Access personalized product recommendations, enjoy exclusive discounts, and track your orders with ease.</p>
        </div>

        <!-- Right Section with Login Form -->
        <div class="right-section">
            <div class="login-form">
                <h2>Login</h2>
                <form action="LoginServlet" method="POST">
                    <div class="input-group">
                        <input type="text" name="custUserName" placeholder="Username" required>
                    </div>
                    <div class="input-group">
                        <input type="password" name="custPswd" placeholder="Password" required>
                    </div>
                    <div class="options">
                        <label class="remember-me">
                            <input type="checkbox" name="rememberMe"> Remember me
                        </label>
                        <a href="forgotPassword.jsp">Forgot password?</a>
                    </div>
                    <button type="submit" class="login-btn">Login</button>
                    <div>
                        <p>Not a member? <a href="CustomerRegister.jsp">Register now</a></p>
                    </div>
                </form>
                <div>
                    <p style="color: red;">
                        <% String error = request.getParameter("error");
                            if (error != null) {
                                out.print(error);
                            }%>
                    </p>
                </div>
                    
            </div>
        </div>
    </div>

</body>
</html>
