<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<jsp:include page="../managerLayout.jsp">    
    <jsp:param name="pageTitle" value="Thiết Bị Đã Xóa" />
</jsp:include>
        <style>

            body {
                font-family: 'Poppins', sans-serif;
                margin: 0;
                padding: 20px;
                background-color: #f0f2f5;
                color: #333;
            }

            .container {
                max-width: 1100px;
                margin: 0 auto;
                padding: 30px;
                background-color: #fff;
                border-radius: 8px; /* Bo góc nhẹ */
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            }

            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
                padding-bottom: 10px;
                border-bottom: 2px solid #e0e0e0;
            }

            .header h1 {
                font-size: 28px;
                font-weight: 700;
                color: #1a1a1a;
                margin: 0;
            }

            .add-device-btn {
                padding: 10px 20px;
                background-color: #007bff;
                color: #fff;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
                font-size: 15px;
                font-weight: 600;
                transition: background-color 0.3s, transform 0.2s;
            }

            .add-device-btn:hover {
                background-color: #0056b3;
                transform: translateY(-1px);
            }

            .filter-bar {
                display: flex;
                gap: 15px;
                margin-bottom: 25px;
                background-color: #f9f9f9;
                padding: 15px;
                border-radius: 6px;
                border: 1px solid #eee;
            }

            .filter-bar select {
                flex-grow: 1;
                max-width: 250px;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
                background-color: #fff;
                font-size: 14px;
                color: #555;

                appearance: none;
                -webkit-appearance: none;
                -moz-appearance: none;
                background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" fill="#555" viewBox="0 0 16 16"><path d="M7.247 11.14 2.451 5.658C1.885 5.018 2.305 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z"/></svg>');
                background-repeat: no-repeat;
                background-position: right 10px center;
                padding-right: 30px;
                transition: border-color 0.3s;
            }

            .filter-bar select:focus {
                outline: none;
                border-color: #007bff;
            }

            .device-table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                background-color: #fff;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
                border-radius: 6px;
                overflow: hidden;
            }

            .device-table th, .device-table td {
                padding: 12px 15px;
                text-align: left;
                border-bottom: 1px solid #f0f0f0;
                color: #333;
                font-size: 14px;
            }

            .device-table th {
                background-color: #eef1f6;
                font-weight: 600;
                text-transform: uppercase;
                color: #555;
                border-bottom: 2px solid #ddd;
            }

            .device-table tbody tr:last-child td {
                border-bottom: none;
            }

            .device-table tbody tr:hover {
                background-color: #f5f5f5;
            }

            .device-table img {
                display: block;
                border-radius: 4px;
                object-fit: cover;
                width: 80px;
                height: 60px;
            }

            .device-table .action-col {
                text-align: center;
                width: 300px;
                padding: 8px;
            }

            .action-col-wrapper {
                display: flex;
                justify-content: center;
                gap: 8px;
                padding: 0;
                margin: 0;
            }

            .action-col-wrapper a, .action-col-wrapper button {
                padding: 6px 10px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 13px;
                font-weight: 500;
                transition: background-color 0.2s, box-shadow 0.2s;
                white-space: nowrap;
                text-decoration: none;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            }

            /* Xem Chi tiết (Info/Màu xám) */
            .action-col-wrapper a:nth-child(1), .action-col-wrapper button:nth-child(1) {
                background-color: #f8f9fa;
                color: #495057;
            }
            .action-col-wrapper a:nth-child(1):hover, .action-col-wrapper button:nth-child(1):hover {
                background-color: #e2e6ea;
            }

            /* Khôi phục (Success/Màu xanh lá) */
            .action-col-wrapper a:nth-child(2), .action-col-wrapper button:nth-child(2) {
                background-color: #28a745;
                color: #fff;
            }
            .action-col-wrapper a:nth-child(2):hover, .action-col-wrapper button:nth-child(2):hover {
                background-color: #218838;
            }

            .pagination {
                margin-top: 25px;
                text-align: right;
            }

            .pagination a {
                display: inline-block;
                padding: 8px 14px;
                margin-left: 5px;
                text-decoration: none;
                color: #007bff;
                background-color: #fff;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
                font-weight: 500;
                transition: background-color 0.2s, color 0.2s, border-color 0.2s;
            }

            .pagination a.active {
                font-weight: 600;
                color: #fff;
                background-color: #007bff;
                border-color: #007bff;
                cursor: default;
            }

            .pagination a:hover:not(.active) {
                background-color: #e9ecef;
                border-color: #c9c9c9;
            }

            .description-cell {
                max-width: 200px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .deleted-badge {
                background-color: #dc3545;
                color: #fff;
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: 600;
            }

        </style>
    </head>
    <body>

        <div class="container">
            <!-- Hiển thị thông báo -->
            <c:if test="${not empty sessionScope.msg}">
                <div class="alert alert-success alert-dismissible fade show" role="alert" style="margin-bottom: 20px;">
                    <i class="fas fa-check-circle me-2"></i>${sessionScope.msg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="msg" scope="session" />
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert" style="margin-bottom: 20px;">
                    <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="error" scope="session" />
            </c:if>

            <div class="header">
                <h1>🗑️ Thiết Bị Đã Xóa</h1>
                <a href="ViewListDevice" class="add-device-btn">← Quay lại Danh sách</a> 
            </div>

            <form action="ViewDeletedDevices" method="get" id="filterForm">
                <div class="filter-bar">
                    <select id="category_id" name="category_id" onchange="document.getElementById('filterForm').submit()">
                        <option value="0" ${selectedCategoryId == 0 ? 'selected' : ''}>-- Tất cả Danh mục --</option>
                        <c:forEach var="dc" items="${deviceCategory}"> 
                            <option value="${dc.id}" ${dc.id == selectedCategoryId ? 'selected' : ''}>${dc.name}</option>
                        </c:forEach>
                    </select>

                    <input class="searchBox" type="text" name="textSearch" size="50" value="${currentSearchText}" placeholder="Tìm kiếm theo tên...">

                    <input class="SearchButton" type="submit" name="btnGo" value="Tìm Kiếm">
                </div>
            </form>

            <table class="device-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên</th>
                        <th>Mô tả</th>
                        <th>Thương hiệu</th>
                        <th>Thời gian Bảo trì</th>
                        <th>Ngày Tạo</th>
                        <th>Trạng thái</th>
                        <th class="action-col">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="d" items="${devices}">
                        <tr>
                            <td>${d.id}</td>
                            <td>${d.name}</td>
                            <td class="description-cell">${d.description}</td>
                            <td>${d.category.name}</td>
                            <td>${d.maintenanceTime}</td>
                            <td>${d.createdAt}</td>
                            <td>
                                <span class="deleted-badge">Đã xóa</span>
                            </td>
                            <td>
                                <div class="action-col-wrapper">
                                    <a href="ViewDetailDevice?id=${d.id}">Xem Chi tiết</a>
                                    <a href="#" onclick="restoreDevice('${d.id}'); return false;">Khôi phục</a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty devices}">
                        <tr>
                            <td colspan="8" style="text-align: center; padding: 40px; color: #6c757d;">
                                <h5>Không có thiết bị nào đã bị xóa</h5>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>

            <div class="pagination">
                <c:set var="urlParams" value=""/>
                <c:if test="${selectedCategoryId > 0}">
                    <c:set var="urlParams" value="${urlParams}&category_id=${selectedCategoryId}"/>
                </c:if>
                <c:if test="${currentSearchText != null && currentSearchText != ''}">
                    <c:set var="urlParams" value="${urlParams}&textSearch=${currentSearchText}"/>
                </c:if>

                <c:forEach begin="1" end="${maxp}" var="i">
                    <c:choose>
                        <c:when test="${crPage == i}">
                            <a href="ViewDeletedDevices?page=${i}${urlParams}" class="active">${i}</a>
                        </c:when>
                        <c:otherwise>
                            <a href="ViewDeletedDevices?page=${i}${urlParams}">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>

        </div>

    </body>
    <script>
        function restoreDevice(id) {
            var option = confirm("Bạn có chắc chắn muốn khôi phục thiết bị này?");
            if (option === true) {
                window.location.href = "RestoreDevice?id=" + id;
            }
            return false;
        }
    </script>
    
    <jsp:include page="../managerFooter.jsp" />

