<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <title>View Profile</title>

        <style>
            body {
                font-family: Arial;
                background: #f2f2f2;
                padding: 20px;
            }

            .container {
                width: 450px;
                margin: auto;
                background: white;
                padding: 20px;
                border-radius: 6px;
                box-shadow: 0 0 10px #ccc;
            }

            h2 {
                text-align: center;
                margin-bottom: 20px;
            }

            .item {
                margin-bottom: 15px;
            }

            .label {
                font-weight: bold;
            }

            .value {
                margin-top: 3px;
                padding: 8px;
                background: #eee;
                border-radius: 4px;
            }

            .actions {
                margin-top: 20px;
                text-align: center;
            }

            .btn {
                padding: 10px 20px;
                background: #4a67ff;
                color: white;
                border: none;
                text-decoration: none;
                border-radius: 4px;
            }

            .btn:hover {
                background: #3b54d6;
            }
        </style>
    </head>

    <body>

        <div class="container">
            <div >
                <a href="ViewRole" class="btn" 
                   style="
                   padding:10px 10px;
                   background: blue;
                   color:white;
                   text-decoration:none;
                   border-radius:5px;">Trang chủ</a>
            </div>

            <c:choose>
                <c:when test="${not empty user}">

                    <h2>Thông tin cá nhân</h2>

                    <div class="item">
                        <div class="label">Họ và tên:</div>
                        <div class="value">${user.displayname}</div>
                    </div>

                    <div class="item">
                        <div class="label">Email:</div>
                        <div class="value">${user.email}</div>
                    </div>

                    <div class="item">
                        <div class="label">Số điện thoại:</div>
                        <div class="value">${user.phone}</div>
                    </div>

                    <div class="item">
                        <div class="label">Giới tính:</div>
                        <div class="value">
                            <c:choose>
                                <c:when test="${user.gender}">
                                    Male
                                </c:when>
                                <c:otherwise>
                                    Female
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="item">
                        <div class="label">Địa chỉ:</div>
                        <div class="value">${user.address}</div>
                    </div>                     

                    <div class="actions">
                        <a href="EditProfile?id=${user.id}" class="btn">Chỉnh sửa thông tin cá nhân</a>

                    </div>

                </c:when>

                <c:otherwise>
                    <h2>Không tìm thấy người dùng</h2>
                    <p style="text-align:center;">Vui lòng đăng nhập lại.</p>
                    <div class="actions">
                        <a href="login.jsp" class="btn">Đăng nhập</a>
                    </div>
                </c:otherwise>

            </c:choose>

        </div>

    </body>

</html>