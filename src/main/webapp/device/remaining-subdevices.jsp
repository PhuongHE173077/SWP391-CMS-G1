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
        <!-- Hiển thị thông báo thành công -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>${param.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        
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
            <div class="d-flex gap-2">
                <a href="AddSubDevice?deviceId=${device.id}" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i>Thêm Sub Device
                </a>
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
        
        <!-- Search Form -->
        <div class="card mb-4 shadow-sm">
            <div class="card-body">
                <form action="ViewRemainingSubDevices" method="get" class="row g-3 align-items-end">
                    <input type="hidden" name="deviceId" value="${device.id}">
                    <div class="col-md-10">
                        <label for="search" class="form-label fw-bold">
                            <i class="fas fa-search me-2 text-primary"></i>Tìm kiếm theo số Seri
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-light">
                                <i class="fas fa-barcode"></i>
                            </span>
                            <input type="text" 
                                   class="form-control" 
                                   id="search" 
                                   name="search" 
                                   placeholder="Nhập số seri để tìm kiếm..."
                                   value="${searchKeyword != null ? searchKeyword : param.search}">
                        </div>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-search me-2"></i>Tìm kiếm
                        </button>
                    </div>
                    <c:if test="${not empty searchKeyword}">
                        <div class="col-12">
                            <a href="ViewRemainingSubDevices?deviceId=${device.id}" class="btn btn-outline-secondary btn-sm">
                                <i class="fas fa-times me-2"></i>Xóa bộ lọc
                            </a>
                            <span class="text-muted ms-2">
                                <i class="fas fa-info-circle me-1"></i>
                                Đang tìm kiếm: <strong>"${searchKeyword}"</strong> - Tìm thấy: <strong>${remainingSubDevices.size()}</strong> kết quả
                            </span>
                        </div>
                    </c:if>
                </form>
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
                            <c:choose>
                                <c:when test="${not empty searchKeyword}">
                                    <i class="fas fa-search"></i>
                                    <h5 class="mt-3">Không tìm thấy kết quả</h5>
                                    <p class="text-muted">Không có Sub Device nào khớp với từ khóa "<strong>${searchKeyword}</strong>"</p>
                                    <a href="ViewRemainingSubDevices?deviceId=${device.id}" class="btn btn-outline-primary mt-3">
                                        <i class="fas fa-arrow-left me-2"></i>Xem tất cả Sub Device
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-inbox"></i>
                                    <h5 class="mt-3">Không có Sub Device nào còn lại</h5>
                                    <p class="text-muted">Tất cả các sản phẩm con của thiết bị này đã bị xóa hoặc chưa được tạo.</p>
                                    <a href="AddSubDevice?deviceId=${device.id}" class="btn btn-primary mt-3">
                                        <i class="fas fa-plus me-2"></i>Thêm Sub Device đầu tiên
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>        
    </div>
</body>

<jsp:include page="../admin/adminFooter.jsp" />

