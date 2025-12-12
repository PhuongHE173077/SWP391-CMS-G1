<%-- 
    Document   : addSubDevice
    Created on : Dec 2025
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../admin/adminLayout.jsp">
    <jsp:param name="pageTitle" value="Thêm Sub Device" />
</jsp:include>

<style>
    .device-info-card {
        background: #f8f9fa;
        border-left: 4px solid #007bff;
        padding: 1rem;
        border-radius: 4px;
        margin-bottom: 1.5rem;
    }
    
    .form-container {
        max-width: 800px;
        margin: 0 auto;
    }
    
    .seri-input-group {
        position: relative;
    }
    
    .seri-input-group .input-icon {
        position: absolute;
        left: 12px;
        top: 50%;
        transform: translateY(-50%);
        color: #6c757d;
        z-index: 10;
    }
    
    .seri-input-group input {
        padding-left: 40px;
    }
</style>

<body class="bg-light">
    <div class="container mt-4 mb-5">
        <div class="form-container">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white py-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <h4 class="mb-0">
                            <i class="fas fa-plus-circle me-2"></i>Thêm Sub Device mới
                        </h4>
                        <a href="ViewRemainingSubDevices?deviceId=${device.id}" class="btn btn-light btn-sm">
                            <i class="fas fa-arrow-left me-1"></i>Quay lại
                        </a>
                    </div>
                </div>
                
                <div class="card-body p-4">
                    <!-- Hiển thị thông báo lỗi/thành công -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- Thông tin Device (Read-only) -->
                    <div class="device-info-card">
                        <h6 class="text-primary mb-3">
                            <i class="fas fa-info-circle me-2"></i>Thông tin Thiết bị
                        </h6>
                        <div class="row">
                            <div class="col-md-4 mb-2">
                                <small class="text-muted d-block">ID Thiết bị</small>
                                <strong>#${device.id}</strong>
                            </div>
                            <div class="col-md-4 mb-2">
                                <small class="text-muted d-block">Tên thiết bị</small>
                                <strong>${device.name}</strong>
                            </div>
                            <div class="col-md-4 mb-2">
                                <small class="text-muted d-block">Danh mục</small>
                                <span class="badge bg-info">${device.category.name}</span>
                            </div>
                        </div>
                    </div>

                    <!-- Form thêm Sub Device -->
                    <form action="AddSubDevice" method="post">
                        <input type="hidden" name="deviceId" value="${device.id}">
                        
                        <div class="mb-4">
                            <label for="seriId" class="form-label fw-bold">
                                <i class="fas fa-barcode me-2 text-primary"></i>Số Seri <span class="text-danger">*</span>
                            </label>
                            <div class="seri-input-group">
                                <i class="fas fa-barcode input-icon"></i>
                                <input type="text" 
                                       class="form-control form-control-lg" 
                                       id="seriId" 
                                       name="seriId" 
                                       placeholder="Nhập số seri (ví dụ: SERI001, DEV001-001)"
                                       value="${param.seriId != null ? param.seriId : seriId}"
                                       required
                                       autofocus>
                            </div>
                            <small class="form-text text-muted">
                                <i class="fas fa-info-circle me-1"></i>
                                Số seri phải là duy nhất trong hệ thống. Ví dụ: SERI001, DEV001-001, ABC-12345
                            </small>
                        </div>

                        <div class="alert alert-info">
                            <i class="fas fa-lightbulb me-2"></i>
                            <strong>Lưu ý:</strong>
                            <ul class="mb-0 mt-2">
                                <li>Số seri phải là duy nhất, không được trùng với các Sub Device khác</li>
                            </ul>
                        </div>

                        <div class="d-flex justify-content-between mt-4 pt-3 border-top">
                            <a href="ViewRemainingSubDevices?deviceId=${device.id}" class="btn btn-secondary">
                                <i class="fas fa-times me-2"></i>Hủy
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>Lưu Sub Device
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>

<jsp:include page="../admin/adminFooter.jsp" />
