<%-- Document : changePassword Created on : Dec 4, 2025, 10:32:37 AM Author : Dell --%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Change Password</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
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
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }

            h2 {
                text-align: center;
                margin-bottom: 20px;
            }

            label {
                font-weight: bold;
            }

            .password-container {
                position: relative;
                margin: 5px 0 15px;
            }

            input[type="password"],
            input[type="text"] {
                width: 100%;
                padding: 8px 40px 8px 8px;
                border-radius: 4px;
                border: 1px solid #ccc;
                box-sizing: border-box;
            }

            .toggle-password {
                position: absolute;
                right: 12px;
                top: 50%;
                transform: translateY(-50%);
                cursor: pointer;
                font-size: 16px;
                color: #6c757d;
                user-select: none;
                padding: 4px;
                transition: color 0.2s;
            }

            .toggle-password:hover {
                color: #495057;
            }

            .toggle-password:active {
                color: #212529;
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

            .home-btn {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 6px 12px;
                font-size: 14px;
                text-decoration: none;
                border-radius: 5px;
                transition: all 0.2s;
                margin-bottom: 15px;
            }

            .home-btn:hover {
                transform: translateY(-1px);
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }
        </style>
    </head>

    <body>


        <div class="container">
            <a href="ViewRole" class=" btn-primary btn-sm home-btn"
               style="background: blue; color: white">
                <i class="fas fa-home"></i>
                <span>Trang chủ</span>
            </a>
            <h2>Đổi mật khẩu</h2>

            <c:if test="${not empty error}">
                <div class="message error">${error}</div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="message success">${success}</div>
            </c:if>

            <form action="ChangePassword" method="post">

                <label>Nhập mật khẩu cũ:</label>
                <div class="password-container">
                    <input type="password" name="oldPassword" id="oldPassword" required>
                    <i class="fas fa-eye toggle-password" onclick="togglePassword('oldPassword', this)"></i>
                </div>

                <label>Nhập mật khẩu mới:</label>
                <div class="password-container">
                    <input type="password" name="newPassword" id="newPassword" required>
                    <i class="fas fa-eye toggle-password" onclick="togglePassword('newPassword', this)"></i>
                </div>

                <label>Nhập lại mật khẩu mới:</label>
                <div class="password-container">
                    <input type="password" name="confirmPassword" id="confirmPassword" required>
                    <i class="fas fa-eye toggle-password" onclick="togglePassword('confirmPassword', this)"></i>
                </div>

                <button type="submit" class="btn">Cập nhật mật khẩu</button>
            </form>

            <script>
                function togglePassword(inputId, iconElement) {
                    const input = document.getElementById(inputId);
                    if (input.type === 'password') {
                        input.type = 'text';
                        iconElement.classList.remove('fa-eye');
                        iconElement.classList.add('fa-eye-slash');
                    } else {
                        input.type = 'password';
                        iconElement.classList.remove('fa-eye-slash');
                        iconElement.classList.add('fa-eye');
                    }
                }
            </script>
            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </div>

    </body>

</html>