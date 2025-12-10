<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Update Category</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f4f6f9;
                margin: 0;
                padding: 0;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
            }

            .container {
                background: white;
                width: 400px;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                text-align: center;
            }

            h2 {
                margin-bottom: 20px;
                color: #333;
            }

            label {
                display: block;
                text-align: left;
                margin-bottom: 6px;
                font-weight: bold;
                color: #555;
            }

            input[type=text] {
                width: 100%;
                padding: 10px 12px;
                margin-bottom: 15px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 14px;
            }

            input[type=submit] {
                width: 100%;
                padding: 10px;
                background: #007bff;
                color: white;
                border: none;
                border-radius: 6px;
                font-size: 16px;
                cursor: pointer;
                transition: 0.2s ease-in-out;
                margin-bottom: 12px;
            }

            input[type=submit]:hover {
                background: #0056b3;
            }

            .back-btn {
                display: block;
                width: 100%;
                padding: 10px;
                background: #6c757d;
                color: white;
                text-decoration: none;
                border-radius: 6px;
                transition: 0.2s;
                font-size: 15px;
            }

            .back-btn:hover {
                background: #555;
            }

            .message {
                margin-top: 15px;
                font-size: 14px;
            }

            .error {
                color: #d9534f;
            }
            .success {
                color: #28a745;
            }

        </style>
    </head>

    <body>

        <div class="container">

            <h2>Cập nhật danh mục thiết bị</h2>

            <form action="UpdateCategory" method="post">
                <!-- Lấy ID -->
                <input type="hidden" name="id" value="${category.id}">

                <label for="name">Tên danh mục</label>
                <input type="text" name="name" id="name" 
                       value="${category.name}" required>

                <input type="submit" value="Cập nhật">
            </form>

            <a href="ViewListCategory" class="back-btn">Quay lại danh sách</a>

            <!-- Hiển thị message -->
            <p class="message error">${sessionScope.error}</p>
            <p class="message success">${sessionScope.success}</p>

            <!-- Xoá message sau khi hiển thị -->
            <% 
                session.removeAttribute("error");
                session.removeAttribute("success");
            %>
        </div>

    </body>
</html>
