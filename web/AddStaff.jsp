<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.StaffDA" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Add New Staff</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                max-width: 600px;
                margin: 2em auto;
            }
            label {
                display: block;
                margin-top: 1em;
            }
            input, select {
                width: 100%;
                padding: .5em;
                margin-top: .3em;
            }
            button {
                margin-top: 1.5em;
                padding: .7em 1.5em;
            }
        </style>
    </head>
    <body>
        <h1>Add New Staff</h1>
        <form action="RegisterStaffServlet" method="post">
            <label for="stfname">Full Name:</label>
            <input type="text" id="stfname" name="stfName" required />

            <label for="stfemail">Email Address:</label>
            <input type="email" id="stfemail" name="stfEmail" required />

            <label for="stfcontactno">Contact Number:</label>
            <input type="tel" id="stfcontactno" name="stfContactNo"
                   pattern="[0-9\-+\s]+" placeholder="e.g. 0123456789" required />

            <label for="stfposition">Position / Title:</label>
            <input type="text" id="stfposition" name="stfPosition" required />

            <label for="stfusername">Username:</label>
            <input type="text" id="stfusername" name="stfUserName" required />

            <label for="stfpswd">Password:</label>
            <input type="password" id="stfpswd" name="stfPswd" required />

            <button type="submit">Add Staff</button>
            <button type="reset" style="margin-left:1em;">Clear</button>
        </form>
        <p><a href="StaffManagement.jsp">Back</a></p>
    </body>
</html>