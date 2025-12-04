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

                <c:choose>
                    <c:when test="${not empty user}">

                        <h2>My Profile</h2>

                        <div class="item">
                            <div class="label">Full Name</div>
                            <div class="value">${user.displayname}</div>
                        </div>

                        <div class="item">
                            <div class="label">Email</div>
                            <div class="value">${user.email}</div>
                        </div>

                        <div class="item">
                            <div class="label">Phone</div>
                            <div class="value">${user.phone}</div>
                        </div>

                        <div class="item">
                            <div class="label">Gender</div>
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
                            <div class="label">Address</div>
                            <div class="value">${user.address}</div>
                        </div>                     

                        <div class="actions">
                            <a href="EditProfile?id=${user.id}" class="btn">Edit Profile</a>
                        </div>

                    </c:when>

                    <c:otherwise>
                        <h2>User not found</h2>
                        <p style="text-align:center;">Please login again.</p>
                        <div class="actions">
                            <a href="login.jsp" class="btn">Login</a>
                        </div>
                    </c:otherwise>

                </c:choose>

            </div>

        </body>

        </html>