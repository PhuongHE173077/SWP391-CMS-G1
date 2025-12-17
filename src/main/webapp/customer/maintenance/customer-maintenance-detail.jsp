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
                            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
                            border-radius: 12px;
                            padding: 1.5rem;
                            border: 1px solid #e9ecef;
                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                            position: relative;
                            overflow: hidden;
                        }

                        .content-box::before {
                            content: '';
                            position: absolute;
                            left: 0;
                            top: 0;
                            bottom: 0;
                            width: 4px;
                            background: linear-gradient(180deg, #0d6efd 0%, #0a58ca 100%);
                            border-radius: 0 4px 4px 0;
                        }

                        .content-box p {
                            margin: 0;
                            color: #495057;
                            font-size: 1rem;
                            line-height: 1.8;
                            white-space: pre-wrap;
                            word-wrap: break-word;
                        }

                        .content-section-title {
                            font-size: 1.1rem;
                            font-weight: 600;
                            color: #212529;
                            margin-bottom: 1rem;
                            display: flex;
                            align-items: center;
                            gap: 0.5rem;
                        }

                        .content-section-title i {
                            color: #0d6efd;
                            font-size: 1.2rem;
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

                        .replies-container {
                            position: relative;
                            padding-left: 2rem;
                        }

                        .reply-item {
                            background: white;
                            border-radius: 12px;
                            padding: 1.25rem;
                            margin-bottom: 1.25rem;
                            border: 1px solid #e9ecef;
                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                            position: relative;
                            transition: all 0.3s ease;
                        }

                        .reply-item:hover {
                            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                            transform: translateY(-2px);
                        }

                        .reply-item:last-child {
                            margin-bottom: 0;
                        }

                        .reply-item::before {
                            content: '';
                            position: absolute;
                            left: -2rem;
                            top: 1.5rem;
                            width: 12px;
                            height: 12px;
                            background: #198754;
                            border-radius: 50%;
                            border: 3px solid white;
                            box-shadow: 0 0 0 2px #198754;
                        }

                        .reply-item::after {
                            content: '';
                            position: absolute;
                            left: -1.5rem;
                            top: 2rem;
                            width: 2px;
                            height: calc(100% + 1.25rem);
                            background: #dee2e6;
                        }

                        .reply-item:last-child::after {
                            display: none;
                        }

                        .reply-header {
                            display: flex;
                            align-items: flex-start;
                            gap: 1rem;
                            margin-bottom: 1rem;
                        }

                        .reply-avatar {
                            width: 45px;
                            height: 45px;
                            border-radius: 50%;
                            background: linear-gradient(135deg, #198754 0%, #157347 100%);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: white;
                            font-size: 1.2rem;
                            flex-shrink: 0;
                            box-shadow: 0 2px 8px rgba(25, 135, 84, 0.3);
                        }

                        .reply-info {
                            flex: 1;
                        }

                        .reply-title {
                            font-weight: 600;
                            color: #212529;
                            font-size: 1.05rem;
                            margin-bottom: 0.25rem;
                        }

                        .reply-meta {
                            display: flex;
                            align-items: center;
                            gap: 1rem;
                            flex-wrap: wrap;
                        }

                        .reply-date {
                            color: #6c757d;
                            font-size: 0.875rem;
                            display: flex;
                            align-items: center;
                            gap: 0.25rem;
                        }

                        .reply-badge {
                            background: #e7f5ef;
                            color: #198754;
                            padding: 0.25rem 0.75rem;
                            border-radius: 20px;
                            font-size: 0.75rem;
                            font-weight: 600;
                        }

                        .reply-content {
                            color: #495057;
                            line-height: 1.7;
                            white-space: pre-wrap;
                            margin: 0;
                            padding-left: 3.5rem;
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
                                                <a href="customer-maintenance"
                                                    class="btn btn-outline-secondary fw-bold">
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
                                                        <i
                                                            class="fas fa-barcode me-2"></i>${req.contractItem.subDevice.seriId}
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
                                                                class="fas fa-hashtag me-2 text-primary"></i>Mã yêu cầu:
                                                        </td>
                                                        <td class="fw-bold">#${req.id}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="info-label"><i
                                                                class="fas fa-heading me-2 text-primary"></i>Tiêu đề:
                                                        </td>
                                                        <td>${req.title != null ? req.title : 'Không có tiêu đề'}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="info-label"><i
                                                                class="fas fa-calendar-alt me-2 text-primary"></i>Ngày
                                                            tạo:</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${req.createdAtDate != null}">
                                                                    <fmt:formatDate value="${req.createdAtDate}"
                                                                        pattern="dd/MM/yyyy" />
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">Chưa có thời gian</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <div class="col-md-6">
                                                <table class="info-table w-100">
                                                    <tr>
                                                        <td class="info-label"><i
                                                                class="fas fa-user me-2 text-primary"></i>Khách hàng:
                                                        </td>
                                                        <td>${req.user.displayname}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="info-label"><i
                                                                class="fas fa-info-circle me-2 text-primary"></i>Trạng
                                                            thái:
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${req.status == 'PENDING'}">
                                                                    <span
                                                                        class="badge bg-warning text-dark">PENDING</span>
                                                                </c:when>
                                                                <c:when test="${req.status == 'APPROVE'}">
                                                                    <span class="badge bg-success">APPROVE</span>
                                                                </c:when>
                                                                <c:when test="${req.status == 'REJECT'}">
                                                                    <span class="badge bg-danger">REJECT</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span
                                                                        class="badge bg-secondary">${req.status}</span>
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
                                            <h6 class="content-section-title">
                                                <i class="fas fa-align-left"></i>
                                                <span>Nội dung yêu cầu</span>
                                            </h6>
                                            <div class="content-box">
                                                <c:choose>
                                                    <c:when test="${req.content != null && req.content != ''}">
                                                        <p>${req.content}</p>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <p class="text-muted fst-italic">
                                                            <i class="fas fa-info-circle me-2"></i>Không có nội dung yêu
                                                            cầu
                                                        </p>
                                                    </c:otherwise>
                                                </c:choose>
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
                                                        <small><i class="fas fa-search-plus me-1"></i>Nhấp vào hình để
                                                            phóng
                                                            to</small>
                                                    </p>
                                                </div>
                                            </div>
                                        </c:if>

                                        <!-- Nút chỉnh sửa -->
                                        <c:if test="${req.status == 'PENDING'}">
                                            <div class="d-flex justify-content-end pt-2">
                                                <a href="UpdateMaintainaceRequest?id=${req.id}"
                                                    class="btn btn-warning fw-bold">
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
                                        <span class="badge bg-white text-success fs-6 px-3 py-2">
                                            <c:choose>
                                                <c:when test="${not empty replies}">
                                                    <i class="fas fa-comment-dots me-1"></i>${replies.size()} phản hồi
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-comment-slash me-1"></i>Chưa có phản hồi
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="card-body p-4">
                                        <c:choose>
                                            <c:when test="${not empty replies}">
                                                <div class="replies-container">
                                                    <c:forEach items="${replies}" var="reply" varStatus="status">
                                                        <div class="reply-item">
                                                            <div class="reply-header">
                                                                <div class="reply-avatar">
                                                                    <i class="fas fa-user-shield"></i>
                                                                </div>
                                                                <div class="reply-info">
                                                                    <div class="reply-title">
                                                                        ${reply.title != null ? reply.title : 'Phản hồi
                                                                        từ hệ thống'}
                                                                    </div>
                                                                    <div class="reply-meta">
                                                                        <div class="reply-date">
                                                                            <i class="fas fa-clock"></i>
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${reply.createdAtDate != null}">
                                                                                    <fmt:formatDate
                                                                                        value="${reply.createdAtDate}"
                                                                                        pattern="dd/MM/yyyy" />
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span class="text-muted">Chưa có
                                                                                        thời gian</span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </div>
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${reply.maintanceRequest.status == 'APPROVE'}">
                                                                                <span class="reply-badge"
                                                                                    style="background: #e7f5ef; color: #198754;">
                                                                                    <i
                                                                                        class="fas fa-check-circle me-1"></i>Đã
                                                                                    duyệt
                                                                                </span>
                                                                            </c:when>
                                                                            <c:when
                                                                                test="${reply.maintanceRequest.status == 'REJECT'}">
                                                                                <span class="reply-badge"
                                                                                    style="background: #f8e7e7; color: #dc3545;">
                                                                                    <i
                                                                                        class="fas fa-times-circle me-1"></i>Đã
                                                                                    từ chối
                                                                                </span>
                                                                            </c:when>
                                                                            <c:when
                                                                                test="${reply.maintanceRequest.status == 'PENDING'}">
                                                                                <span class="reply-badge"
                                                                                    style="background: #fff3cd; color: #856404;">
                                                                                    <i
                                                                                        class="fas fa-clock me-1"></i>Đang
                                                                                    xử lý
                                                                                </span>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="reply-badge"
                                                                                    style="background: #e7f5ef; color: #198754;">
                                                                                    <i
                                                                                        class="fas fa-info-circle me-1"></i>Đã
                                                                                    phản hồi
                                                                                </span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <p class="reply-content">${reply.content}</p>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="empty-state">
                                                    <div class="mb-3">
                                                        <i class="fas fa-comment-slash"
                                                            style="font-size: 4rem; color: #dee2e6;"></i>
                                                    </div>
                                                    <h5 class="text-muted mb-2">Chưa có phản hồi</h5>
                                                    <p class="text-muted mb-0"
                                                        style="max-width: 500px; margin: 0 auto;">
                                                        Yêu cầu của bạn đang được xử lý. Vui lòng chờ phản hồi từ hệ
                                                        thống.
                                                        Bạn sẽ nhận được thông báo khi có cập nhật mới.
                                                    </p>
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
                                            <button type="button" class="btn-close btn-close-white"
                                                data-bs-dismiss="modal" aria-label="Đóng"></button>
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