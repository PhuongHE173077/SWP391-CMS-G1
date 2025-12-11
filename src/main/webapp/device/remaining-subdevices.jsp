<%-- 
    Document   : remaining-subdevices
    Created on : Dec 2025
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../admin/adminLayout.jsp">
    <jsp:param name="pageTitle" value="Danh sách Sub Device còn lại" />
</jsp:include>

<style>
    .subdevice-table {
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    
    .table-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
    }
    
    .table-header th {
        border: none;
        font-weight: 600;
        text-transform: uppercase;
        font-size: 0.875rem;
        letter-spacing: 0.5px;
        padding: 1rem;
    }
    
    .table tbody tr {
        transition: all 0.3s ease;
    }
    
    .table tbody tr:hover {
        background-color: #f8f9fa;
        transform: translateY(-1px);
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    
    .seri-badge {
        font-family: 'Courier New', monospace;
        font-weight: 600;
        padding: 0.5rem 1rem;
        background: #e7f3ff;
        color: #0066cc;
        border-radius: 6px;
        border: 1px solid #b3d9ff;
    }
    
    .empty-state {
        text-align: center;
        padding: 3rem;
        color: #6c757d;
    }
    
    .empty-state i {
        font-size: 4rem;
        margin-bottom: 1rem;
        color: #dee2e6;
    }
</style>

<body class="bg-light">
    <div class="container mt-4 mb-5">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="mb-1">
                    <i class="fas fa-boxes text-primary me-2"></i>
                    Danh sách Sub Device còn lại
                </h3>
                <p class="text-muted mb-0">
                    Thiết bị: <strong>${device.name}</strong> | 
                    Tổng số: <strong>${remainingSubDevices.size()}</strong> sản phẩm
                </p>
            </div>
            <div>
                <a href="ViewDetailDevice?id=${device.id}" class="btn btn-outline-primary">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại chi tiết
                </a>
            </div>
        </div>
        
        <!-- Device Info Card -->
        <div class="card mb-4 shadow-sm">
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3">
                        <small class="text-muted d-block mb-1">ID Thiết bị</small>
                        <strong>#${device.id}</strong>
                    </div>
                    <div class="col-md-3">
                        <small class="text-muted d-block mb-1">Tên thiết bị</small>
                        <strong>${device.name}</strong>
                    </div>
                    <div class="col-md-3">
                        <small class="text-muted d-block mb-1">Danh mục</small>
                        <span class="badge bg-info">${device.category.name}</span>
                    </div>
                    <div class="col-md-3">
                        <small class="text-muted d-block mb-1">Trạng thái</small>
                        <c:choose>
                            <c:when test="${!device.isDelete}">
                                <span class="badge bg-success">Hoạt động</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-danger">Đã xóa</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Sub Devices Table -->
        <div class="card shadow-sm">
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${not empty remainingSubDevices}">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0 subdevice-table">
                                <thead class="table-header">
                                    <tr>
                                        <th style="width: 80px;">ID</th>
                                        <th>Số Seri</th>
                                        <th>Tên Thiết bị</th>
                                        <th>Ngày tạo</th>
                                        <th style="width: 120px;">Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="subDevice" items="${remainingSubDevices}" varStatus="status">
                                        <tr>
                                            <td class="align-middle">
                                                <strong>#${subDevice.id}</strong>
                                            </td>
                                            <td class="align-middle">
                                                <span class="seri-badge">
                                                    <i class="fas fa-barcode me-2"></i>${subDevice.seriId}
                                                </span>
                                            </td>
                                            <td class="align-middle">
                                                <i class="fas fa-microchip text-primary me-2"></i>
                                                ${subDevice.device.name}
                                            </td>
                                            <td class="align-middle">
                                                <i class="fas fa-calendar text-muted me-2"></i>
                                                ${subDevice.createdAt != null ? subDevice.createdAt : 'N/A'}
                                            </td>
                                            <td class="align-middle">
                                                <c:choose>
                                                    <c:when test="${!subDevice.isDelete}">
                                                        <span class="badge bg-success">
                                                            <i class="fas fa-check-circle me-1"></i>Còn lại
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger">
                                                            <i class="fas fa-times-circle me-1"></i>Đã xóa
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fas fa-inbox"></i>
                            <h5 class="mt-3">Không có Sub Device nào còn lại</h5>
                            <p class="text-muted">Tất cả các sản phẩm con của thiết bị này đã bị xóa hoặc chưa được tạo.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- Summary -->
        <div class="mt-4 text-center">
            <div class="card bg-light">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            <h5 class="text-primary mb-1">${remainingSubDevices.size()}</h5>
                            <small class="text-muted">Tổng số Sub Device</small>
                        </div>
                        <div class="col-md-4">
                            <h5 class="text-success mb-1">
                                ${remainingSubDevices.size()}
                            </h5>
                            <small class="text-muted">Còn lại</small>
                        </div>
                        <div class="col-md-4">
                            <h5 class="text-info mb-1">${device.name}</h5>
                            <small class="text-muted">Thiết bị</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>

<jsp:include page="../admin/adminFooter.jsp" />

