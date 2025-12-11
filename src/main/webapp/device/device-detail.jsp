<%-- 
    Document   : device-detail
    Created on : Dec 2025
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../admin/adminLayout.jsp">
    <jsp:param name="pageTitle" value="Chi tiết Thiết bị" />
</jsp:include>

<style>
    .device-detail-card {
        max-width: 1200px;
        margin: 0 auto;
    }
    
    .device-image-container {
        text-align: center;
        padding: 20px;
        background: #f8f9fa;
        border-radius: 8px;
    }
    
    .device-image {
        max-width: 100%;
        max-height: 400px;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
    
    .info-label {
        font-weight: 600;
        color: #495057;
        font-size: 0.875rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 0.5rem;
    }
    
    .info-value {
        font-size: 1rem;
        color: #212529;
        padding: 0.75rem;
        background: #f8f9fa;
        border-radius: 4px;
        border: 1px solid #dee2e6;
    }
    
    .badge-custom {
        padding: 0.5rem 1rem;
        border-radius: 20px;
        font-weight: 500;
    }
    
    .action-buttons {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
    }
</style>

<body class="bg-light">
    <div class="container mt-4 mb-5">
        <div class="card shadow-sm device-detail-card">
            <div class="card-header bg-primary text-white py-3">
                <div class="d-flex justify-content-between align-items-center">
                    <h4 class="mb-0">
                        <i class="fas fa-info-circle me-2"></i>Chi tiết Thiết bị
                    </h4>
                    <a href="ViewListDevice" class="btn btn-light btn-sm">
                        <i class="fas fa-arrow-left me-1"></i>Quay lại
                    </a>
                </div>
            </div>
            
            <div class="card-body p-4">
                <div class="row">
                    <!-- Hình ảnh thiết bị -->
                    <div class="col-md-4 mb-4">
                        <div class="device-image-container">
                            <c:choose>
                                <c:when test="${not empty device.image}">
                                    <img src="${device.image}" alt="${device.name}" class="device-image" 
                                         onerror="this.src='https://via.placeholder.com/400x300?text=No+Image'">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://via.placeholder.com/400x300?text=No+Image" 
                                         alt="No Image" class="device-image">
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <!-- Thông tin thiết bị -->
                    <div class="col-md-8">
                        <div class="row mb-3">
                            <div class="col-md-6 mb-3">
                                <div class="info-label">ID Thiết bị</div>
                                <div class="info-value">#${device.id}</div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="info-label">Trạng thái</div>
                                <div>
                                    <c:choose>
                                        <c:when test="${!device.isDelete}">
                                            <span class="badge bg-success badge-custom">
                                                <i class="fas fa-check-circle me-1"></i>Hoạt động
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger badge-custom">
                                                <i class="fas fa-times-circle me-1"></i>Đã xóa
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-12 mb-3">
                                <div class="info-label">Tên thiết bị</div>
                                <div class="info-value">
                                    <strong>${device.name}</strong>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6 mb-3">
                                <div class="info-label">Danh mục</div>
                                <div class="info-value">
                                    <i class="fas fa-tag me-2 text-primary"></i>${device.category.name}
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="info-label">Thời gian bảo trì</div>
                                <div class="info-value">
                                    <i class="fas fa-clock me-2 text-warning"></i>
                                    ${device.maintenanceTime != null ? device.maintenanceTime : 'Chưa cập nhật'}
                                </div>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-12 mb-3">
                                <div class="info-label">Mô tả</div>
                                <div class="info-value" style="min-height: 80px;">
                                    ${device.description != null ? device.description : 'Chưa có mô tả'}
                                </div>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6 mb-3">
                                <div class="info-label">Ngày tạo</div>
                                <div class="info-value">
                                    <i class="fas fa-calendar me-2 text-info"></i>
                                    ${device.createdAt != null ? device.createdAt : 'N/A'}
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="info-label">Số lượng Sub Device còn lại</div>
                                <div class="info-value">
                                    <span class="badge bg-info badge-custom">
                                        <i class="fas fa-boxes me-1"></i>${remainingCount} sản phẩm
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Action Buttons -->
                <div class="row mt-4 pt-3 border-top">
                    <div class="col-12">
                        <div class="action-buttons">
                            <a href="ViewRemainingSubDevices?deviceId=${device.id}" 
                               class="btn btn-primary">
                                <i class="fas fa-list me-2"></i>Xem danh sách Sub Device còn lại
                            </a>
                            <a href="EditDevice?id=${device.id}" class="btn btn-warning">
                                <i class="fas fa-edit me-2"></i>Chỉnh sửa
                            </a>
                            <a href="ViewListDevice" class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>

<jsp:include page="../admin/adminFooter.jsp" />

