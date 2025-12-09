<%-- 
    Document   : enterOtp
    Created on : Dec 5, 2025, 10:43:02 AM
    Author     : Dell
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Nhập mã OTP</title>
    </head>
    <body>
        <form action="VerifyOtp" method="post">
            <h3>Nhập mã OTP</h3>

            <input type="text" name="otp" placeholder="Nhập OTP" required>

            <button type="submit">Xác minh</button>

            <p style="color:red">${error}</p>
        </form>
    </body>
</html>
