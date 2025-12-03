<%-- Document : roleDetail.jsp Created on : Dec 3, 2025, 5:12:15 PM Author : admin --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Chi tiết Role - ${role.name}</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            </head>

            <body>
                <div class="container mt-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2>Chi tiết Role</h2>
                        <a href="ViewRole" class="btn btn-secondary">Quay lại</a>
                    </div>

                    <!-- Thông tin Role -->
                    <div class="card mb-4">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">Thông tin Role</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong>ID:</strong> ${role.id}</p>
                                    <p><strong>Tên Role:</strong> ${role.name}</p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>Mô tả:</strong> ${role.description}</p>
                                    <p><strong>Trạng thái:</strong>
                                        <c:choose>
                                            <c:when test="${role.status}">
                                                <span class="badge bg-success">Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Không hoạt động</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Danh sách Permission -->
                    <div class="card">
                        <div class="card-header bg-success text-white">
                            <h5 class="mb-0">Danh sách Permission</h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty permissionList}">
                                    <table class="table table-bordered table-striped">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>#</th>
                                                <th>Nhóm chức năng</th>
                                                <th>Tên quyền</th>
                                                <th>Router</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="perm" items="${permissionList}" varStatus="status">
                                                <tr>
                                                    <td>${status.index + 1}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty perm.groupName}">
                                                                <span class="badge bg-info">${perm.groupName}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">Không xác định</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${perm.name}</td>
                                                    <td><code>${perm.router}</code></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-warning mb-0">
                                        Role này chưa được gán quyền nào.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                </div>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>