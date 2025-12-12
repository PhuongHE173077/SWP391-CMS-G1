<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%><jsp:include page="../managerLayout.jsp">

    <jsp:param name="pageTitle" value="Deleted Contract Management" />
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
        gap: 20px;
        align-items: center;
        padding: 15px;
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    }


    .filter-bar select {

        width: 200px;
        padding: 8px 12px;
        border-radius: 6px;
        border: 1px solid #ced4da;
    }


    .filter-bar .search-flex-group {

        max-width: 450px;

        flex-shrink: 1;
    }


    .filter-bar .search-flex-group .form-control {
        width: auto;
    }

    .add-device-btn {
        white-space: nowrap;
        text-decoration: none;
        padding: 10px 15px;
        background-color: #007bff;
        color: white;
        border-radius: 6px;
        font-size: 14px;
        font-weight: 500;
        margin-left: auto;
    }

    .filter-bar .btn-primary {
        font-size: 14px;
        padding: 8px 12px;
        height: 100%;
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
        width: 280px;
        padding: 8px;
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
        <form action="ViewListDevice" method="get" id="filterForm">
            <div class="filter-bar">
                <select id="category_id" name="category_id" onchange="document.getElementById('filterForm').submit()">
                    <option value="0" ${selectedCategoryId == 0 ? 'selected' : ''}>-- Tất cả Danh mục --</option>
                    <c:forEach var="dc" items="${deviceCategory}"> 
                        <option value="${dc.id}" ${dc.id == selectedCategoryId ? 'selected' : ''}>${dc.name}</option>
                    </c:forEach>
                </select>

                <div class="input-group search-flex-group"> 
                    <input class="form-control" type="text" name="textSearch" value="${currentSearchText}" placeholder="Tìm kiếm theo tên...">
                    <button class="btn btn-primary" type="submit" name="btnGo" value="Tìm Kiếm">
                        <i class="fas fa-search"></i> Tìm Kiếm
                    </button>
                </div>
                <a href="AddDevice" class="add-device-btn">➕ Thêm Thiết bị</a> 
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
                    <th>Ngày Tạo </th>
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
                        <td >
                            ${d.createdAt}
                        </td>
                        <td>
                            <div class="action-col-wrapper">
                                <a href="ViewDetailDevice?id=${d.id}">Xem Chi tiết</a>
                                <a href="EditDevice?id=${d.id}">Sửa Sản Phẩm</a>
                                <a href="#" onClick= " showMess(${d.id})">Xóa Sản Phẩm</a>
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
                        <a href="ViewListDevice?page=${i}${urlParams}" class="active">${i}</a>
                    </c:when>
                    <c:otherwise>
                        <a href="ViewListDevice?page=${i}${urlParams}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

        </div>

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
