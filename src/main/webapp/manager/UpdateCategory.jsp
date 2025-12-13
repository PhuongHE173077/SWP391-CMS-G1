<%@page contentType="text/html" pageEncoding="UTF-8" %>

    <jsp:include page="managerLayout.jsp">
        <jsp:param name="pageTitle" value="Update Category" />
    </jsp:include>

    <style>
        .form-container {
            background: white;
            max-width: 500px;
            margin: 0 auto;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .form-container h2 {
            margin-bottom: 20px;
            color: #333;
            text-align: center;
        }

        .form-container label {
            display: block;
            text-align: left;
            margin-bottom: 6px;
            font-weight: bold;
            color: #555;
        }

        .form-container input[type=text] {
            width: 100%;
            padding: 10px 12px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            box-sizing: border-box;
        }

        .form-container input[type=submit] {
            width: 100%;
            padding: 10px;
            background: #10b981;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            transition: 0.2s ease-in-out;
            margin-bottom: 12px;
        }

        .form-container input[type=submit]:hover {
            background: #059669;
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
            text-align: center;
            box-sizing: border-box;
        }

        .back-btn:hover {
            background: #555;
        }

        .message {
            margin-top: 15px;
            font-size: 14px;
            text-align: center;
        }

        .error {
            color: #ef4444;
        }

        .success {
            color: #10b981;
        }
    </style>

    <div class="form-container">
        <h2>Cập nhật danh mục thiết bị</h2>

        <form action="UpdateCategory" method="post">
            <input type="hidden" name="id" value="${category.id}">

            <label for="name">Tên danh mục</label>
            <input type="text" name="name" id="name" value="${category.name}" required>

            <input type="submit" value="Cập nhật">
        </form>

        <a href="ViewListCategory" class="back-btn">Quay lại danh sách</a>

        <p class="message error">${sessionScope.error}</p>
        <p class="message success">${sessionScope.success}</p>

        <% session.removeAttribute("error"); session.removeAttribute("success"); %>
    </div>

    <jsp:include page="managerFooter.jsp" />