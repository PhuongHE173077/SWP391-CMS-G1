<%-- 
    Document   : changePassword
    Created on : Dec 4, 2025, 10:32:37 AM
    Author     : Dell
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Change Password</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f2f2f2;
            }

            .container {
                width: 350px;
                margin: 50px auto;
                background: white;
                padding: 20px;
                border-radius: 6px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }

            h2 {
                text-align: center;
                margin-bottom: 20px;
            }

            label {
                font-weight: bold;
            }

            input[type="password"] {
                width: 100%;
                padding: 8px;
                margin: 5px 0 15px;
                border-radius: 4px;
                border: 1px solid #ccc;
            }

            .btn {
                width: 100%;
                padding: 10px;
                background: blue;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 16px;
            }

            .message {
                text-align: center;
                padding: 10px;
                border-radius: 4px;
                margin-bottom: 15px;
            }

            .error {
                background: #ffdddd;
                color: #d8000c;
            }

            .success {
                background: #ddffdd;
                color: #4f8a10;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Change Password</h2>
           
            <c:if test="${not empty error}">
                <div class="message error">${error}</div>
            </c:if>
            
            <c:if test="${not empty success}">
                <div class="message success">${success}</div>
            </c:if>

            <form action="ChangePassword" method="post">

                <label>Old Password</label>
                <input type="password" name="oldPassword" required>

                <label>New Password</label>
                <input type="password" name="newPassword" required>

                <label>Confirm New Password</label>
                <input type="password" name="confirmPassword" required>

                <button type="submit" class="btn">Update Password</button>
            </form>
        </div>

    </body>
</html>
