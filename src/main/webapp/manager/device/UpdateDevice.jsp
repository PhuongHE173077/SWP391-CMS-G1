<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cập nhật Thiết bị</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Poppins', sans-serif;
                margin: 0;
                padding: 20px;
                background-color: #f0f2f5;
                color: #333;
            }

            .container {
                max-width: 600px;
                margin: 0 auto;
                padding: 30px;
                background-color: #fff;
                border-radius: 10px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            }

            .header h1 {
                font-size: 28px;
                font-weight: 700;
                color: #1a1a1a;
                margin-bottom: 25px;
                border-bottom: 2px solid #e0e0e0;
                padding-bottom: 10px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #555;
            }

            .form-group input[type="text"],
            .form-group input[type="file"],
            .form-group textarea,
            .form-group select {
                width: 100%;
                padding: 12px;
                border: 1px solid #ccc;
                border-radius: 6px;
                box-sizing: border-box;
                font-size: 14px;
                transition: border-color 0.3s;
            }

            .form-group input:focus,
            .form-group textarea:focus,
            .form-group select:focus {
                outline: none;
                border-color: #007bff;
                box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
            }

            .form-group textarea {
                resize: vertical;
                min-height: 100px;
            }

            .btn-submit {
                padding: 12px 25px;
                background-color: #007bff; /* Đổi màu để phân biệt với thêm mới */
                color: #fff;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 16px;
                font-weight: 600;
                transition: background-color 0.3s, transform 0.2s;
                display: block;
                width: 100%;
                margin-top: 15px;
            }

            .btn-submit:hover {
                background-color: #0056b3;
                transform: translateY(-2px);
            }

            .message {
                margin-bottom: 15px;
                padding: 10px;
                border-radius: 5px;
                font-weight: 500;
            }

            .success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            .back-link-top {
                display: inline-block;
                margin-bottom: 20px;
                color: #007bff;
                text-decoration: none;
                font-weight: 600;
                transition: color 0.2s;
            }

            .error {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }
            /* Thêm CSS cho ảnh xem trước */
            .image-preview {
                margin-top: 10px;
                margin-bottom: 15px;
                text-align: center;
            }
            .image-preview img {
                max-width: 100%;
                height: auto;
                max-height: 150px;
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }
        </style>
    </head>
    <body>

        <div class="container">
            <a href="/ViewListDevice" class="back-link-top">← Quay lại Danh sách Thiết bị</a>
            <div class="header">
                <h1>️ Cập nhật Thiết bị</h1>
            </div>

            <c:if test="${not empty requestScope.message}">
                <div class="message ${requestScope.success ? 'success' : 'error'}">
                    ${requestScope.message}
                </div>
            </c:if>

            <c:set var="device" value="${device}" />

            <form action="EditDevice" method="POST" enctype="multipart/form-data">

                <input type="hidden" name="id" value="${device.id}">

                <div class="form-group">
                    <label for="name">Tên Thiết bị (*):</label>
                    <input type="text" id="name" name="name" required placeholder="Nhập tên thiết bị..." value="${device.name}">
                </div>

                <div class="form-group">
                    <label for="category_id">Danh mục (*):</label>
                    <select id="category_id" name="category_id" required>
                        <option value="" disabled selected>-- Chọn Danh mục --</option>

                        <c:forEach var="dc" items="${deviceCategory}">
                            <option value="${dc.id}" ${dc.id == device.category.id ? 'selected' : ''}>
                                ${dc.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="image">Hình ảnh:</label>
                    <!-- Hiển thị ảnh hiện tại nếu có -->
                    <c:if test="${not empty device.image}">
                        <div class="image-preview">
                            <p style="margin-bottom: 10px; font-weight: 600; color: #555;">Ảnh hiện tại:</p>
                            <img src="${device.image}" alt="Current image" id="currentImage">
                        </div>
                    </c:if>
                    <input type="file" id="image" name="image" accept="image/*">
                    <small style="display: block; margin-top: 5px; color: #666;">Chọn file ảnh mới để thay thế (JPG, PNG, GIF - tối đa 10MB). Để trống nếu giữ nguyên ảnh cũ.</small>
                    <div id="imagePreview" style="margin-top: 10px; display: none;">
                        <p style="margin-bottom: 5px; font-weight: 600; color: #555;">Ảnh mới:</p>
                        <img id="previewImg" src="" alt="Preview" style="max-width: 300px; max-height: 300px; border-radius: 6px; border: 1px solid #ccc;">
                    </div>
                </div>

                <div class="form-group">
                    <label for="maintenance_time">Thời gian Bảo trì :</label>
                    <input type="text" id="maintenance_time" name="maintenance_time" placeholder="Nhập chu kỳ bảo trì..." value="${device.maintenanceTime}">
                </div>

                <div class="form-group">
                    <label for="description">Mô tả:</label>
                    <textarea id="description" name="description" placeholder="Nhập mô tả chi tiết về thiết bị...">${device.description}</textarea>
                </div>

                <button type="submit" class="btn-submit">Cập nhật Thông tin Thiết bị</button>
            </form>

        </div>

        <script>
            // Preview ảnh khi chọn file
            const imageInput = document.getElementById('image');
            if (imageInput) {
                imageInput.addEventListener('change', function(e) {
                    const file = e.target.files[0];
                    if (file) {
                        // Kiểm tra kích thước file (tối đa 10MB)
                        if (file.size > 10 * 1024 * 1024) {
                            alert('Kích thước file không được vượt quá 10MB!');
                            e.target.value = '';
                            const previewDiv = document.getElementById('imagePreview');
                            if (previewDiv) previewDiv.style.display = 'none';
                            return;
                        }
                        
                        // Kiểm tra loại file
                        if (!file.type.startsWith('image/')) {
                            alert('Vui lòng chọn file ảnh!');
                            e.target.value = '';
                            const previewDiv = document.getElementById('imagePreview');
                            if (previewDiv) previewDiv.style.display = 'none';
                            return;
                        }
                        
                        // Hiển thị preview
                        const reader = new FileReader();
                        reader.onload = function(e) {
                            const previewImg = document.getElementById('previewImg');
                            const previewDiv = document.getElementById('imagePreview');
                            if (previewImg) previewImg.src = e.target.result;
                            if (previewDiv) previewDiv.style.display = 'block';
                        };
                        reader.readAsDataURL(file);
                    } else {
                        const previewDiv = document.getElementById('imagePreview');
                        if (previewDiv) previewDiv.style.display = 'none';
                    }
                });
            }
        </script>

    </body>
</html>
