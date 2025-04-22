<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Customer</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 40px;
        }

        .container {
            max-width: 700px;
            margin: auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 12px rgba(0,0,0,0.1);
        }

        h2 {
            color: #2c3e50;
            text-align: center;
        }

        label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }

        input {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            box-sizing: border-box;
        }

        button {
            margin-top: 20px;
            padding: 10px 18px;
            background-color: #0277bd;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        button:hover {
            background-color: #01579b;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Add New Customer</h2>
        <form action="AddCustomer" method="post">
            <label>Name:</label>
            <input type="text" name="custName" required>

            <label>Contact No:</label>
            <input type="text" name="custContactNo" required>

            <label>Email:</label>
            <input type="email" name="custEmail" required>

            <label>Username:</label>
            <input type="text" name="custUserName" required>

            <label>Password:</label>
            <input type="password" name="custPswd" required>

            <button type="submit">Add Customer</button>
            <button type="button" onclick="window.location.href='CustomerManagement.jsp'">Back</button>
        </form>
    </div>
</body>
</html>
