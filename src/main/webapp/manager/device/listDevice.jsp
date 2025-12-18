<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<jsp:include page="../managerLayout.jsp">   
    <jsp:param name="pageTitle" value="View List Device" />
</jsp:include>

<!-- Tính toán quyền cho màn hình thiết bị -->
<c:set var="canViewDevice" value="false" />
<c:set var="canAddDevice" value="false" />
<c:set var="canViewDetailDevice" value="false" />
<c:set var="canEditDevice" value="false" />
<c:set var="canDeleteDevice" value="false" />
<c:set var="canViewDeletedDevices" value="false" />

<c:if test="${not empty sessionScope.role && not empty sessionScope.rolePermissions}">
    <c:forEach var="rp" items="${sessionScope.rolePermissions}">
        <c:if test="${rp.roles.id == sessionScope.role.id}">
            <c:if test="${rp.router == '/ViewListDevice'}">
                <c:set var="canViewDevice" value="true" />
            </c:if>
            <c:if test="${rp.router == '/AddDevice'}">
                <c:set var="canAddDevice" value="true" />
            </c:if>
            <c:if test="${rp.router == '/ViewDetailDevice'}">
                <c:set var="canViewDetailDevice" value="true" />
            </c:if>
            <c:if test="${rp.router == '/EditDevice'}">
                <c:set var="canEditDevice" value="true" />
            </c:if>
            <c:if test="${rp.router == '/DeleteDevice'}">
                <c:set var="canDeleteDevice" value="true" />
            </c:if>
            <c:if test="${rp.router == '/ViewDeletedDevices'}">
                <c:set var="canViewDeletedDevices" value="true" />
            </c:if>
        </c:if>
    </c:forEach>
</c:if>
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
                border-radius: 8px;
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
            
            /* SỬA ĐỔI CHÍNH: Căn giữa tất cả các ô trong bảng */
            .device-table th, .device-table td {
                padding: 12px 15px;
                text-align: center; /* ĐÃ SỬA: Căn giữa nội dung toàn bộ ô */
                border-bottom: 1px solid #f0f0f0;
                color: #333;
                font-size: 14px;
            }
            
            /* BỔ SUNG: Class để giữ các cột văn bản dài căn trái (tùy chọn) */
            .text-left-col {
                text-align: left;
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
                margin: 0 auto; /* Căn giữa hình ảnh */
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

            .action-col-wrapper a:nth-child(1), .action-col-wrapper button:nth-child(1) {
                background-color: #f8f9fa;  
                color: #495057;
            }
            .action-col-wrapper a:nth-child(1):hover, .action-col-wrapper button:nth-child(1):hover {
                background-color: #e2e6ea;
            }

            .action-col-wrapper a:nth-child(2), .action-col-wrapper button:nth-child(2) {
                background-color: #ffc107;
                color: #343a40;
            }
            .action-col-wrapper a:nth-child(2):hover, .action-col-wrapper button:nth-child(2):hover {
                background-color: #e0a800;
            }

            .action-col-wrapper a:nth-child(3), .action-col-wrapper button:nth-child(3) {
                background-color: #dc3545;
                color: #fff;
            }
            .action-col-wrapper a:nth-child(3):hover, .action-col-wrapper button:nth-child(3):hover {
                background-color: #c82333;
            }
            /* Lặp lại không cần thiết, đã có ở trên */
            .action-col-wrapper a:nth-child(1), .action-col-wrapper button:nth-child(1) {
                background-color: #f8f9fa;  
                color: #495057;
            }
            .action-col-wrapper a:nth-child(1):hover, .action-col-wrapper button:nth-child(1):hover {
                background-color: #e2e6ea;
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

        </style>
    </head>
    <body>
        <div class="container">

            <div class="header">
                <h1>🛠️ Danh sách Thiết bị</h1>
                <div style="display: flex; gap: 10px;">
                    <!-- Nút xem thiết bị đã xóa -->
                    <c:choose>
                        <c:when test="${canViewDeletedDevices}">
                            <a href="ViewDeletedDevices" class="add-device-btn" style="background-color: #6c757d;">🗑️ Thiết Bị Đã Xóa</a>
                        </c:when>
                        <c:otherwise>
                            <button type="button" class="add-device-btn" style="background-color: #6c757d; opacity: 0.6; cursor: not-allowed;" disabled title="Bạn không có quyền xem thiết bị đã xóa">🗑️ Thiết Bị Đã Xóa</button>
                        </c:otherwise>
                    </c:choose>
                    
                    <!-- Nút thêm thiết bị -->
                    <c:choose>
                        <c:when test="${canAddDevice}">
                            <a href="AddDevice" class="add-device-btn">➕ Thêm Thiết bị</a>
                        </c:when>
                        <c:otherwise>
                            <button type="button" class="add-device-btn" style="opacity: 0.6; cursor: not-allowed;" disabled title="Bạn không có quyền thêm thiết bị">➕ Thêm Thiết bị</button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <form action="ViewListDevice" method="get" id="filterForm">
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

            <c:if test="${canViewDevice}">
            <table class="device-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th class="text-left-col">Tên</th>
                        <th class="text-left-col">Mô tả</th>
                        <th>Thương hiệu</th>
                        <th>Thời gian Bảo trì</th>
                         <th>SL tồn kho</th>
                        <th>Ngày Tạo </th>
                        <th class="action-col">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="d" items="${devices}">
                        <tr>
                            <td>${d.id}</td>
                            <td class="text-left-col">${d.name}</td>
                            <td class="description-cell text-left-col">${d.description}</td>
                            <td>${d.category.name}</td>
                            <td>${d.maintenanceTime}</td>
                            <td>${fn:length(d.subDevices)}</td>
                            <td >
                                ${d.createdAt}
                            </td>
                            <td>
                                <div class="action-col-wrapper">
                                    <!-- Nút Xem Chi tiết -->
                                    <c:choose>
                                        <c:when test="${canViewDetailDevice}">
                                            <a href="ViewDetailDevice?id=${d.id}">Xem Chi tiết</a>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" style="opacity: 0.6; cursor: not-allowed;" disabled title="Bạn không có quyền xem chi tiết">Xem Chi tiết</button>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <!-- Nút Sửa -->
                                    <c:choose>
                                        <c:when test="${canEditDevice}">
                                            <a href="EditDevice?id=${d.id}">Sửa Sản Phẩm</a>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" style="opacity: 0.6; cursor: not-allowed;" disabled title="Bạn không có quyền sửa thiết bị">Sửa Sản Phẩm</button>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <!-- Nút Xóa - giữ nguyên logic onclick nhưng disable nếu không có quyền -->
                                    <c:choose>
                                        <c:when test="${canDeleteDevice}">
                                            <a href="#" onClick="showMess(${d.id})">Xóa Sản Phẩm</a>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" style="opacity: 0.6; cursor: not-allowed;" disabled title="Bạn không có quyền xóa thiết bị">Xóa Sản Phẩm</button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>

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
                            <a href="ViewListDevice?indexPage=${i}${urlParams}" class="active">${i}</a>
                        </c:when>
                        <c:otherwise>
                            <a href="ViewListDevice?indexPage=${i}${urlParams}">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

            </div>
            </c:if>

            <c:if test="${!canViewDevice}">
                <div style="text-align: center; padding: 40px; color: #999;">
                    <h3>Bạn không có quyền xem danh sách thiết bị</h3>
                </div>
            </c:if>

        </div>

    </body>
    <script>
        function showMess(id) {
            var option = confirm("Are you sure to delete ?");
            if (option === true) {
                window.location.href = "DeleteDevice?id=" + id;
            }
        }
    </script>
    
    <jsp:include page="../managerFooter.jsp" />