<%-- Document : customer-maintenance-detail Created on : Dec 17, 2025 Author : ADMIN --%>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Chi Tiết Yêu Cầu Bảo Trì</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    <style>
                        body {
                            background-color: #f8f9fa;
                        }

                        .product-card {
                            background: white;
                            border-radius: 10px;
                            overflow: hidden;
                            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
                        }

                        .product-image-wrapper {
                            background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
                            padding: 2rem;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            min-height: 220px;
                        }

                        .product-image {
                            max-height: 180px;
                            max-width: 100%;
                            object-fit: contain;
                            border-radius: 8px;
                            background: white;
                            padding: 0.75rem;
                            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
                        }

                        .product-info {
                            padding: 1.5rem;
                        }

                        .product-name {
                            font-size: 1.4rem;
                            font-weight: 700;
                            color: #0d6efd;
                            margin-bottom: 0.5rem;
                        }

                        .serial-badge {
                            display: inline-flex;
                            align-items: center;
                            background: #0d6efd;
                            color: white;
                            padding: 0.4rem 0.9rem;
                            border-radius: 50px;
                            font-family: 'Courier New', monospace;
                            font-weight: 600;
                            font-size: 0.9rem;
                        }

                        .info-table td {
                            padding: 0.6rem 0;
                            border-bottom: 1px solid #f1f3f4;
                        }

                        .info-table tr:last-child td {
                            border-bottom: none;
                        }

                        .info-label {
                            font-weight: 600;
                            color: #6c757d;
                            width: 140px;
                        }

                        .content-box {
                            background: #f8f9fa;
                            border-radius: 8px;
                            padding: 1rem;
                            border-left: 4px solid #0d6efd;
                        }

                        .request-image {
                            max-width: 100%;
                            max-height: 280px;
                            object-fit: contain;
                            border-radius: 8px;
                            cursor: pointer;
                            transition: transform 0.2s ease;
                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        }

                        .request-image:hover {
                            transform: scale(1.02);
                        }

                        .reply-item {
                            background: #f8f9fa;
                            border-radius: 8px;
                            padding: 1rem;
                            margin-bottom: 0.75rem;
                            border-left: 4px solid #198754;
                        }

                        .reply-item:last-child {
                            margin-bottom: 0;
                        }

                        .reply-title {
                            font-weight: 600;
                            color: #198754;
                        }

                        .empty-state {
                            text-align: center;
                            padding: 2.5rem;
                            color: #adb5bd;
                        }

                        .empty-state i {
                            font-size: 3rem;
                            margin-bottom: 0.75rem;
                        }
                    </style>
                </head>

                <body class="bg-light">
                    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
                    
                    <!-- Tính toán quyền cho màn hình chi tiết yêu cầu bảo hành -->
                    <c:set var="canViewMaintenanceDetail" value="false" />
                    <c:set var="canViewOwnMaintenances" value="false" />
                    
                    <c:if test="${not empty sessionScope.role && not empty sessionScope.rolePermissions}">
                        <c:forEach var="rp" items="${sessionScope.rolePermissions}">
                            <c:if test="${rp.roles.id == sessionScope.role.id}">
                                <c:if test="${rp.router == '/maintenance-detail'}">
                                    <c:set var="canViewMaintenanceDetail" value="true" />
                                </c:if>
                                <c:if test="${rp.router == '/customer-maintenance'}">
                                    <c:set var="canViewOwnMaintenances" value="true" />
                                </c:if>
                            </c:if>
                        </c:forEach>
                    </c:if>
                    
                    <div class="container-fluid px-4 mt-4">
                        <c:if test="${canViewMaintenanceDetail}">

                        <!-- Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div class="d-flex align-items-center gap-3">
                                <!-- Nút Quay lại -->
                                <c:choose>
                                    <c:when test="${canViewOwnMaintenances}">
                                        <a href="customer-maintenance" class="btn btn-outline-secondary fw-bold">
                                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" class="btn btn-outline-secondary fw-bold" disabled
                                            title="Bạn không có quyền xem danh sách yêu cầu">
                                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                                <div>
                                    <h2 class="text-primary fw-bold mb-1">
                                        <i class="fas fa-tools me-2"></i>Chi Tiết Yêu Cầu Bảo Trì
                                    </h2>
                                    <p class="text-muted mb-0">Mã yêu cầu: #${req.id}</p>
                                </div>
                            </div>
                            <div class="d-flex align-items-center gap-2">
                                <c:choose>
                                    <c:when test="${req.status == 'PENDING'}">
                                        <span class="badge bg-warning text-dark fs-6 px-3 py-2">
                                            <i class="fas fa-clock me-1"></i>PENDING
                                        </span>
                                    </c:when>
                                    <c:when test="${req.status == 'APPROVE'}">
                                        <span class="badge bg-success fs-6 px-3 py-2">
                                            <i class="fas fa-check-circle me-1"></i>APPROVE
                                        </span>
                                    </c:when>
                                    <c:when test="${req.status == 'REJECT'}">
                                        <span class="badge bg-danger fs-6 px-3 py-2">
                                            <i class="fas fa-times-circle me-1"></i>REJECT
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary fs-6 px-3 py-2">${req.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- SECTION 1: Thông tin sản phẩm -->
                        <div class="product-card mb-4">
                            <div class="row g-0">
                                <div class="col-md-4">
                                    <div class="product-image-wrapper h-100">
                                        <c:choose>
                                            <c:when
                                                test="${req.contractItem.subDevice.device.image != null && req.contractItem.subDevice.device.image != ''}">
                                                <img src="${req.contractItem.subDevice.device.image}"
                                                    alt="Hình ảnh sản phẩm" class="product-image">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="text-white text-center">
                                                    <i class="fas fa-laptop fa-4x mb-2 opacity-75"></i>
                                                    <p class="mb-0">Không có hình ảnh</p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="col-md-8">
                                    <div class="product-info h-100 d-flex flex-column justify-content-center">
                                        <p class="text-muted text-uppercase mb-2"
                                            style="font-size: 0.8rem; letter-spacing: 1px;">
                                            <i class="fas fa-box me-1"></i>Thông tin sản phẩm
                                        </p>
                                        <h3 class="product-name">${req.contractItem.subDevice.device.name}</h3>
                                        <div class="mb-3">
                                            <span class="serial-badge">
                                                <i class="fas fa-barcode me-2"></i>${req.contractItem.subDevice.seriId}
                                            </span>
                                        </div>
                                        <p class="text-muted mb-0">
                                            <i class="fas fa-file-contract me-2"></i>Mã hợp đồng: <strong
                                                class="text-dark">#${req.contractItem.id}</strong>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- SECTION 2: Thông tin yêu cầu -->
                        <div class="card shadow-sm mb-4">
                            <div class="card-header bg-white py-3">
                                <h5 class="mb-0 fw-bold text-secondary">
                                    <i class="fas fa-clipboard-list me-2"></i>Thông Tin Yêu Cầu
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <table class="info-table w-100">
                                            <tr>
                                                <td class="info-label"><i
                                                        class="fas fa-hashtag me-2 text-primary"></i>Mã yêu cầu:</td>
                                                <td class="fw-bold">#${req.id}</td>
                                            </tr>
                                            <tr>
                                                <td class="info-label"><i
                                                        class="fas fa-heading me-2 text-primary"></i>Tiêu đề:</td>
                                                <td>${req.title != null ? req.title : 'Không có tiêu đề'}</td>
                                            </tr>
                                            <tr>
                                                <td class="info-label"><i
                                                        class="fas fa-calendar-alt me-2 text-primary"></i>Ngày tạo:</td>
                                                <td>
                                                    <fmt:formatDate value="${req.createdAtDate}"
                                                        pattern="dd/MM/yyyy - HH:mm" />
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                    <div class="col-md-6">
                                        <table class="info-table w-100">
                                            <tr>
                                                <td class="info-label"><i
                                                        class="fas fa-user me-2 text-primary"></i>Khách hàng:</td>
                                                <td>${req.user.displayname}</td>
                                            </tr>
                                            <tr>
                                                <td class="info-label"><i
                                                        class="fas fa-info-circle me-2 text-primary"></i>Trạng thái:
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${req.status == 'PENDING'}">
                                                            <span class="badge bg-warning text-dark">PENDING</span>
                                                        </c:when>
                                                        <c:when test="${req.status == 'APPROVE'}">
                                                            <span class="badge bg-success">APPROVE</span>
                                                        </c:when>
                                                        <c:when test="${req.status == 'REJECT'}">
                                                            <span class="badge bg-danger">REJECT</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">${req.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>

                                <hr class="my-4">

                                <!-- Nội dung yêu cầu -->
                                <div class="mb-4">
                                    <h6 class="fw-bold text-secondary mb-3">
                                        <i class="fas fa-align-left me-2"></i>Nội dung yêu cầu
                                    </h6>
                                    <div class="content-box">
                                        <p class="mb-0" style="white-space: pre-wrap; line-height: 1.7;">${req.content}
                                        </p>
                                    </div>
                                </div>

                                <!-- Hình ảnh đính kèm -->
                                <c:if test="${req.image != null && req.image != ''}">
                                    <div class="mb-4">
                                        <h6 class="fw-bold text-secondary mb-3">
                                            <i class="fas fa-image me-2"></i>Hình ảnh đính kèm
                                        </h6>
                                        <div class="bg-light rounded p-3 text-center">
                                            <img src="${req.image}" alt="Hình ảnh yêu cầu" class="request-image"
                                                data-bs-toggle="modal" data-bs-target="#imageModal">
                                            <p class="text-muted mt-2 mb-0">
                                                <small><i class="fas fa-search-plus me-1"></i>Nhấp vào hình để phóng
                                                    to</small>
                                            </p>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Nút chỉnh sửa -->
                                <c:if test="${req.status == 'PENDING'}">
                                    <div class="d-flex justify-content-end pt-2">
                                        <a href="UpdateMaintainaceRequest?id=${req.id}" class="btn btn-warning fw-bold">
                                            <i class="fas fa-edit me-2"></i>Chỉnh sửa yêu cầu
                                        </a>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- SECTION 3: Phản hồi -->
                        <div class="card shadow-sm mb-4">
                            <div
                                class="card-header bg-success text-white py-3 d-flex justify-content-between align-items-center">
                                <h5 class="mb-0 fw-bold">
                                    <i class="fas fa-comments me-2"></i>Phản Hồi Từ Hệ Thống
                                </h5>
                                <span class="badge bg-white text-success fs-6">
                                    <c:choose>
                                        <c:when test="${not empty replies}">${replies.size()}</c:when>
                                        <c:otherwise>0</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${not empty replies}">
                                        <c:forEach items="${replies}" var="reply" varStatus="status">
                                            <div class="reply-item">
                                                <div class="d-flex justify-content-between align-items-start mb-2">
                                                    <h6 class="reply-title mb-0">
                                                        <i class="fas fa-reply me-2"></i>
                                                        ${reply.title != null ? reply.title : 'Phản hồi
                                                        #'.concat(status.index + 1)}
                                                    </h6>
                                                    <small class="text-muted">
                                                        <i class="fas fa-clock me-1"></i>
                                                        <fmt:formatDate value="${reply.createdAtDate}"
                                                            pattern="dd/MM/yyyy - HH:mm" />
                                                    </small>
                                                </div>
                                                <p class="mb-0 text-dark" style="white-space: pre-wrap;">
                                                    ${reply.content}</p>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="empty-state">
                                            <i class="fas fa-comment-slash d-block"></i>
                                            <h5 class="text-muted">Chưa có phản hồi</h5>
                                            <p class="mb-0">Yêu cầu của bạn đang được xử lý. Vui lòng chờ phản hồi từ hệ
                                                thống.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- Image Modal -->
                    <c:if test="${req.image != null && req.image != ''}">
                        <div class="modal fade" id="imageModal" tabindex="-1" aria-labelledby="imageModalLabel"
                            aria-hidden="true">
                            <div class="modal-dialog modal-xl modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header bg-primary text-white">
                                        <h5 class="modal-title" id="imageModalLabel">
                                            <i class="fas fa-image me-2"></i>Hình ảnh đính kèm
                                        </h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                            aria-label="Đóng"></button>
                                    </div>
                                    <div class="modal-body text-center bg-light p-4">
                                        <img src="${req.image}" alt="Hình ảnh yêu cầu" class="img-fluid"
                                            style="max-height: 70vh;">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                    </c:if>
                    
                    <c:if test="${!canViewMaintenanceDetail}">
                        <div class="card shadow-sm">
                            <div class="card-body text-center py-5">
                                <h4 class="text-muted">Bạn không có quyền xem chi tiết yêu cầu bảo hành</h4>
                            </div>
                        </div>
                    </c:if>
                </div>
                </body>

                </html>