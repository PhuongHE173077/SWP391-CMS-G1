<%-- 
    Document   : Test
    Created on : Dec 16, 2025, 10:47:27 PM
    Author     : ADMIN
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi Tiết Yêu Cầu Bảo Trì (Mã: 27)</title>

        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f7f6;
                color: #333;
                line-height: 1.6;
                margin: 0;
                padding: 0;
            }

            .back-btn {
                display: inline-block;
                margin-bottom: 15px;
                padding: 8px 14px;
                background-color: #6c757d;
                color: #fff;
                text-decoration: none;
                border-radius: 4px;
                font-size: 0.9em;
                transition: background-color 0.3s;
            }

            .back-btn:hover {
                background-color: #5a6268;
            }
            .container {
                max-width: 900px;
                margin: 40px auto;
                padding: 25px;
                background: #fff;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                border-radius: 8px;
            }

            h1 {
                color: #007bff;
                border-bottom: 2px solid #eee;
                padding-bottom: 10px;
                margin-bottom: 20px;
            }

            h2.section-heading {
                color: #0056b3;
                margin-top: 30px;
                margin-bottom: 15px;
            }

            /* --- THÔNG TIN YÊU CẦU CHÍNH --- */
            .request-detail-card {
                border: 1px solid #ddd;
                padding: 20px;
                border-radius: 6px;
                background-color: #f9f9f9;
            }

            .request-title {
                color: #333;
                font-size: 1.8em;
                margin-top: 0;
            }

            .meta-info {
                font-size: 0.9em;
                color: #666;
                margin-bottom: 15px;
            }

            .status-badge {
                display: inline-block;
                padding: 5px 10px;
                border-radius: 4px;
                font-weight: bold;
                color: white;
                margin-bottom: 15px;
            }

            .status-open {
                background-color: #ffc107; /* Vàng */
                color: #333;
            }

            .status-completed {
                background-color: #28a745; /* Xanh lá */
                color: white;
            }

            .content-section h3 {
                color: #007bff;
                font-size: 1.1em;
                border-left: 3px solid #007bff;
                padding-left: 10px;
                margin-top: 20px;
            }

            /* --- PHẢN HỒI/NHẬT KÝ --- */
            .reply-list {
                margin-top: 20px;
            }

            .reply-item {
                border: 1px solid #e0e0e0;
                padding: 15px;
                margin-bottom: 15px;
                border-radius: 4px;
                background-color: #fff;
                transition: box-shadow 0.3s;
            }

            .reply-item:hover {
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            }

            .reply-staff {
                /* Màu nổi bật cho phản hồi từ Kỹ thuật viên/Nhân viên */
                border-left: 5px solid #28a745;
                background-color: #e6f7eb;
            }

            .reply-completed {
                border-left: 5px solid #007bff;
                background-color: #eaf3ff;
            }

            .reply-header {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
                font-weight: bold;
                border-bottom: 1px dotted #ccc;
                padding-bottom: 5px;
            }

            .reply-date {
                font-size: 0.8em;
                color: #999;
                font-weight: normal;
            }

            .reply-content small {
                display: block;
                margin-top: 10px;
                color: #777;
            }

            /* --- FORM PHẢN HỒI --- */
            .reply-form input, .reply-form textarea {
                width: 100%;
                padding: 10px;
                margin-bottom: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
            }

            .reply-form textarea {
                resize: vertical;
                min-height: 100px;
            }

            .reply-form button {
                background-color: #007bff;
                color: white;
                padding: 10px 15px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-weight: bold;
                transition: background-color 0.3s;
            }

            .reply-form button:hover {
                background-color: #0056b3;
            }

            .attachment {
                margin-top: 15px;
                font-size: 0.9em;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <a href="seller-maintenance" class="back-btn">← Quay lại</a>
            <h1>Chi Tiết Yêu Cầu Bảo Trì</h1>


            <div class="request-detail-card">
                <h2 class="request-title">${maintanceRequest.title}</h2>
                <div class="meta-info">
                    <span>${maintanceRequest.id}</span> | 
                    <span>Người Yêu Cầu: User K. Dinh (ID: 27)</span> |
                    <span>${maintanceRequest.createdAt}</span>
                </div>

                <div class="status-badge status-open">${maintanceRequest.status}</div>

                <div class="content-section">
                    <h3>Nội Dung Chi Tiết:</h3>
                    <p>${maintanceRequest.content}</p>
                    <p><strong>Thông tin liên hệ (ID):</strong> 7</p>
                    <div class="attachment">
                        <strong>${maintanceRequest.image}</strong> 
                        <a href="#">[Xem ảnh]</a>
                    </div>
                </div>
            </div>



            <hr>

            <h2 class="section-heading">Phản Hồi và Nhật Ký Xử Lý</h2>
            <c:forEach var="rmr" items="${replyMaintanceRequest}" varStatus="st">
                <div class="reply-list">           
                    <div class="reply-item reply-staff">
                        <div class="reply-header">
                            <span class="reply-title">Phản Hồi ${st.index + 1}: ${rmr.title}</span>
                            <span class="reply-date">${rmr.createdAt}</span>
                        </div>
                        <div class="reply-content">
                            <p>${rmr.content}</p>
                            <small>CMS ...</small>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <h2 class="section-heading">Thêm Phản Hồi</h2>

            <form class="reply-form" method="post" action="ViewDetaiRequestMaintance">
                <input type="hidden" name="id" value="${maintanceRequest.id}">
                <input type="text" name="title" placeholder="Tiêu đề phản hồi (Title)" required>
                <textarea name="content" placeholder="Nội dung chi tiết phản hồi (Content)" required></textarea>
                <button type="submit">Gửi Phản Hồi</button>
            </form>

        </div>
    </body>
</html>
