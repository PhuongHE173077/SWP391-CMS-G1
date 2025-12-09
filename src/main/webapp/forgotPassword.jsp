<%-- 
    Document   : forgotPassword
    Created on : Dec 5, 2025, 10:03:52 AM
    Author     : Dell
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <form action="ForgotPassword" method="post">
            <h3>Quên mật khẩu</h3>

            <label>Email:</label>
            <input type="email" name="email" required>

            <button type="submit">Gửi mã xác nhận</button>

            <p style="color:red">${error}</p>
            <p style="color:green">${success}</p>
        </form>
    </body>
</html>
