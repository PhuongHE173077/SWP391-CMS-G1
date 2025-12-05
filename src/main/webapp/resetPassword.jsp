<%-- 
    Document   : resetPassword
    Created on : Dec 5, 2025, 10:07:45 AM
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
        <form action="ResetPassword" method="post">
            <h3>Đặt lại mật khẩu mới</h3>

            <input type="password" name="newPass" placeholder="Mật khẩu mới" required>
            <input type="password" name="confirmPass" placeholder="Xác nhận mật khẩu" required>

            <button type="submit">Lưu mật khẩu</button>

            <p style="color:red">${error}</p>
            <p style="color:green">${success}</p>
        </form>
    </body>
</html>
