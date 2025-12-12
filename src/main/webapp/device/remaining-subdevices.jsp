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
    
    .pagination {
        margin: 0;
    }
    
    .pagination .page-link {
        color: #667eea;
        border-color: #dee2e6;
        padding: 0.5rem 0.75rem;
    }
    
    .pagination .page-item.active .page-link {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-color: #667eea;
        color: white;
    }
    
    .pagination .page-link:hover {
        background-color: #f8f9fa;
        border-color: #667eea;
        color: #667eea;
    }
    
    .pagination .page-item.disabled .page-link {
        color: #6c757d;
        background-color: #fff;
        border-color: #dee2e6;
        cursor: not-allowed;
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
                    Tổng số: <strong>${totalRecords != null ? totalRecords : remainingSubDevices.size()}</strong> sản phẩm
                    <c:if test="${totalPages > 1}">
                        | Trang <strong>${currentPage}</strong>/<strong>${totalPages}</strong>
                    </c:if>
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
        
        <!-- Search and Filter Form -->
        <div class="card mb-4 shadow-sm">
            <div class="card-body">
                <form action="ViewRemainingSubDevices" method="get" class="row g-3 align-items-end">
                    <input type="hidden" name="deviceId" value="${device.id}">
                    
                    <!-- Search by Seri -->
                    <div class="col-md-4">
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
                                   placeholder="Nhập số seri..."
                                   value="${searchKeyword != null ? searchKeyword : param.search}">
                        </div>
                    </div>
                    
                    <!-- Date From -->
                    <div class="col-md-3">
                        <label for="dateFrom" class="form-label fw-bold">
                            <i class="fas fa-calendar-alt me-2 text-info"></i>Từ ngày
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-light">
                                <i class="fas fa-calendar"></i>
                            </span>
                            <input type="date" 
                                   class="form-control" 
                                   id="dateFrom" 
                                   name="dateFrom" 
                                   value="${dateFrom != null ? dateFrom : param.dateFrom}">
                        </div>
                    </div>
                    
                    <!-- Date To -->
                    <div class="col-md-3">
                        <label for="dateTo" class="form-label fw-bold">
                            <i class="fas fa-calendar-check me-2 text-info"></i>Đến ngày
                        </label>
                        <div class="input-group">
                            <span class="input-group-text bg-light">
                                <i class="fas fa-calendar"></i>
                            </span>
                            <input type="date" 
                                   class="form-control" 
                                   id="dateTo" 
                                   name="dateTo" 
                                   value="${dateTo != null ? dateTo : param.dateTo}">
                        </div>
                    </div>
                    
                    <!-- Buttons -->
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100 mb-2">
                            <i class="fas fa-search me-2"></i>Lọc
                        </button>
                        <a href="ViewRemainingSubDevices?deviceId=${device.id}" class="btn btn-outline-secondary w-100 btn-sm">
                            <i class="fas fa-redo me-2"></i>Reset
                        </a>
                    </div>
                    
                    <!-- Filter Info -->
                    <c:if test="${not empty searchKeyword || not empty dateFrom || not empty dateTo}">
                        <div class="col-12 mt-2">
                            <div class="alert alert-info mb-0 py-2">
                                <i class="fas fa-filter me-2"></i>
                                <strong>Bộ lọc đang áp dụng:</strong>
                                <c:if test="${not empty searchKeyword}">
                                    <span class="badge bg-primary ms-2">Seri: "${searchKeyword}"</span>
                                </c:if>
                                <c:if test="${not empty dateFrom}">
                                    <span class="badge bg-info ms-2">Từ: ${dateFrom}</span>
                                </c:if>
                                <c:if test="${not empty dateTo}">
                                    <span class="badge bg-info ms-2">Đến: ${dateTo}</span>
                                </c:if>
                                <span class="ms-2">| Tìm thấy: <strong>${totalRecords}</strong> kết quả</span>
                            </div>
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
                        
                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <div class="card-footer bg-white border-top">
                                <nav aria-label="Page navigation">
                                    <ul class="pagination justify-content-center mb-0">
                                        <!-- Nút Previous -->
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <c:choose>
                                                <c:when test="${currentPage > 1}">
                                                    <a class="page-link" 
                                                       href="ViewRemainingSubDevices?deviceId=${device.id}&page=${currentPage - 1}${not empty searchKeyword ? '&search=' : ''}${not empty searchKeyword ? searchKeyword : ''}${not empty dateFrom ? '&dateFrom=' : ''}${not empty dateFrom ? dateFrom : ''}${not empty dateTo ? '&dateTo=' : ''}${not empty dateTo ? dateTo : ''}">
                                                        <i class="fas fa-chevron-left"></i>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="page-link">
                                                        <i class="fas fa-chevron-left"></i>
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                        
                                        <!-- Các số trang -->
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <c:choose>
                                                <c:when test="${i == currentPage}">
                                                    <li class="page-item active">
                                                        <span class="page-link">${i}</span>
                                                    </li>
                                                </c:when>
                                                <c:when test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                                    <li class="page-item">
                                                        <a class="page-link" 
                                                           href="ViewRemainingSubDevices?deviceId=${device.id}&page=${i}${not empty searchKeyword ? '&search=' : ''}${not empty searchKeyword ? searchKeyword : ''}${not empty dateFrom ? '&dateFrom=' : ''}${not empty dateFrom ? dateFrom : ''}${not empty dateTo ? '&dateTo=' : ''}${not empty dateTo ? dateTo : ''}">
                                                            ${i}
                                                        </a>
                                                    </li>
                                                </c:when>
                                                <c:when test="${i == currentPage - 3 || i == currentPage + 3}">
                                                    <li class="page-item disabled">
                                                        <span class="page-link">...</span>
                                                    </li>
                                                </c:when>
                                            </c:choose>
                                        </c:forEach>
                                        
                                        <!-- Nút Next -->
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <c:choose>
                                                <c:when test="${currentPage < totalPages}">
                                                    <a class="page-link" 
                                                       href="ViewRemainingSubDevices?deviceId=${device.id}&page=${currentPage + 1}${not empty searchKeyword ? '&search=' : ''}${not empty searchKeyword ? searchKeyword : ''}${not empty dateFrom ? '&dateFrom=' : ''}${not empty dateFrom ? dateFrom : ''}${not empty dateTo ? '&dateTo=' : ''}${not empty dateTo ? dateTo : ''}">
                                                        <i class="fas fa-chevron-right"></i>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="page-link">
                                                        <i class="fas fa-chevron-right"></i>
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                    </ul>
                                </nav>
                                                              
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <c:choose>
                                <c:when test="${not empty searchKeyword}">
                                    <i class="fas fa-search"></i>
                                    <h5 class="mt-3">Không tìm thấy kết quả</h5>                                   
                                </c:when>
                                <c:otherwise>
                                    <i class="fas fa-inbox"></i>
                                    <h5 class="mt-3">Không có Sub Device nào còn lại</h5>
                                    <p class="text-muted">Tất cả các sản phẩm con của thiết bị này đã bị xóa hoặc chưa được tạo.</p>
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

