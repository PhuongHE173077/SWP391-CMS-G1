<%-- 
    Document   : editprofile
    Created on : Dec 4, 2025, 9:10:47 AM
    Author     : Dell
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Profile</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f4f4f4;
                padding: 20px;
            }

            h2 {
                text-align: center;
            }

            form {
                width: 350px;
                background: white;
                padding: 20px;
                margin: 0 auto;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }

            form input[type="text"],
            form input[type="email"] {
                width: 100%;
                padding: 8px;
                margin: 8px 0;
                border: 1px solid #ccc;
                border-radius: 5px;
            }

            .gender-group {
                margin: 10px 0;
                display: flex;
                gap: 15px;
                align-items: center;
            }

            input[type="submit"] {
                width: 100%;
                padding: 10px;
                background: blue;
                color: white;
                font-size: 16px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }

            

            .error {
                color: red;
                text-align: center;
                margin-top: 15px;
            }
        </style>

    </head>
    <body>       
        <form action="EditProfile" method="post">
            <h2>Edit Profile</h2>
            <input type="hidden" name="id" value="${user.id}">

            <label>Display Name:</label>
            <input type="text" name="displayname" value="${user.displayname}">

            <label>Email:</label>
            <input type="email" name="email" value="${user.email}">

            <label>Phone:</label>
            <input type="text" name="phone" value="${user.phone}">

            <label>Address:</label>
            <input type="text" name="address" value="${user.address}">

            <div class="gender-group">
                <label>Gender:</label>
                <label><input type="radio" name="gender" value="male" ${user.gender ? "checked" : ""}> Male</label>
                <label><input type="radio" name="gender" value="female" ${!user.gender ? "checked" : ""}> Female</label>
            </div>

            <input type="submit" value="Update">
        </form>

        <p class="error">${error}</p>
    </body>
</html>
