<%-- Document : roleDetail.jsp Created on : Dec 3, 2025, 5:12:15 PM Author : admin --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

            <jsp:include page="../adminLayout.jsp">
                <jsp:param name="pageTitle" value="Chi tiết Role - ${role.name}" />
            </jsp:include>

            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">

            <div class="container-fluid">
                <a href="ViewRole" class="btn btn-secondary mb-4">
                    <i class="bi bi-arrow-left"></i>
                    Quay lại
                </a>

                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h2>Chi tiết Role</h2>
                    <a href="/EditRole?id=${role.id}" class="btn btn-secondary">Cập nhật</a>
                </div>

                <div class="border mb-4">
                    <div class="p-1 bg-primary text-white">
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

                <div class="border">
                    <div class="p-1 bg-success text-white">
                        <h5 class="mb-0">Danh sách Permission</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty permissionGroups}">
                                <div class="permission-tree">
                                    <c:forEach var="group" items="${permissionGroups}">
                                        <div class="group-item mb-3">
                                            <div class="group-header d-flex align-items-center p-2 bg-light rounded">
                                                <i class="bi bi-folder-fill text-warning me-2"></i>
                                                <strong class="text-primary">${group.name}</strong>
                                                <span class="badge bg-secondary ms-2">${group.routerses.size()}
                                                    quyền</span>
                                            </div>
                                            <div class="router-list ms-4 mt-2">
                                                <c:forEach var="router" items="${group.routerses}">
                                                    <div
                                                        class="router-item d-flex align-items-center py-1 ps-3 border-start border-2">
                                                        <i class="bi bi-file-earmark-code text-success me-2"></i>
                                                        <span class="me-2">${router.name}</span>
                                                        <code class="text-muted small">${router.router}</code>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
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

            <jsp:include page="../adminFooter.jsp" />