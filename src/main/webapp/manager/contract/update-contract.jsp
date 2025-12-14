<%-- Document : update-contract Created on : Dec 12, 2025, 11:26:20 AM Author : admin --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <title>Cập Nhật Hợp Đồng</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
                        rel="stylesheet"
                        integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
                        crossorigin="anonymous">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
                    <style>
                        .h-90vh {
                            height: 90vh;
                        }

                        #pageLoadingOverlay {
                            position: fixed;
                            inset: 0;
                            background: rgba(255, 255, 255, 0.75);
                            display: none;
                            align-items: center;
                            justify-content: center;
                            z-index: 10000;
                        }

                        #pageLoadingOverlay.show {
                            display: flex;
                        }

                        .product-img {
                            width: 60px;
                            height: 60px;
                            object-fit: cover;
                            border-radius: 0.5rem;
                        }

                        .serial-col {
                            color: #0d6efd;
                            font-size: 0.8rem;
                        }

                        .product-name {
                            font-weight: 500;
                        }

                        .product-link {
                            color: #fd7e14;
                            font-size: 0.8rem;
                            cursor: pointer;
                        }

                        .summary-label {
                            color: #6c757d;
                        }

                        .summary-value {
                            font-weight: 500;
                        }

                        .name.warning {
                            color: #dc3545;
                        }

                        #subDeviceResult {
                            max-height: 300px;
                            overflow-y: auto;
                            position: absolute;
                            z-index: 9999;
                            width: calc(100% - 2rem);
                            background: white;
                        }

                        .subdevice-item {
                            cursor: pointer;
                        }

                        .subdevice-item:hover {
                            background-color: #f8f9fa;
                        }

                        .user-info-readonly {
                            background-color: #f8f9fa;
                            padding: 1rem;
                            border-radius: 0.5rem;
                            border: 1px solid #dee2e6;
                        }

                        .edit-disabled-notice {
                            background-color: #fff3cd;
                            border: 1px solid #ffc107;
                            border-radius: 0.5rem;
                            padding: 1rem;
                            margin-bottom: 1rem;
                        }

                        .btn-remove-item {
                            color: #dc3545;
                        }

                        .btn-remove-item:hover {
                            color: #bb2d3b;
                        }
                    </style>
                </head>

                <body class="bg-light py-4 position-relative">
                    <div id="pageLoadingOverlay" aria-hidden="true">
                        <div class="text-center">
                            <div class="spinner-border text-primary" role="status" aria-label="Loading"></div>
                            <div class="mt-2 fw-medium">Đang cập nhật hợp đồng...</div>
                        </div>
                    </div>
                    <div class="position-absolute d-flex justify-content-between align-items-center bg-white"
                        style="top: 10px; left: 10px;">
                        <div class="d-flex align-items-center gap-2">
                            <button type="button" class="btn btn-outline-secondary btn-sm"
                                onclick="window.history.back()">
                                <i class="fas fa-arrow-left"></i>
                                Back
                            </button>
                        </div>
                    </div>
                    <div class="container-xl">
                        <div class="row g-3">
                            <!-- Left Panel -->
                            <div class="col-lg-8 h-90vh">
                                <div class="border p-2 shadow-sm h-100">
                                    <div class="card-body">
                                        <!-- Thông báo nếu không thể chỉnh sửa sản phẩm -->
                                        <c:if test="${!canEdit}">
                                            <div class="edit-disabled-notice">
                                                <i class="fas fa-exclamation-triangle text-warning me-2"></i>
                                                <strong>Lưu ý:</strong> Hợp đồng đã được tạo quá 6 ngày, bạn không thể
                                                thêm hoặc xóa sản phẩm.
                                            </div>
                                        </c:if>

                                        <!-- Search Bar - chỉ hiển thị nếu có thể edit -->
                                        <c:if test="${canEdit}">
                                            <div class="mb-3 position-relative">
                                                <div class="input-group">
                                                    <span class="input-group-text bg-white"><i
                                                            class="fas fa-search"></i></span>
                                                    <input type="text" class="form-control" id="searchSubDevice"
                                                        placeholder="Nhập số seri thiết bị để thêm">
                                                </div>
                                                <ul id="subDeviceResult" class="list-group mt-2"></ul>
                                            </div>
                                        </c:if>

                                        <!-- Product Table -->
                                        <div class="table-responsive">
                                            <table class="table table-hover align-middle">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th scope="col" style="width: 60px;">STT</th>
                                                        <th scope="col">Số Seri</th>
                                                        <th scope="col">Ảnh</th>
                                                        <th scope="col">Sản phẩm</th>
                                                        <th scope="col">Thời gian bảo hành</th>
                                                        <c:if test="${canEdit}">
                                                            <th scope="col" class="text-center">Chức năng</th>
                                                        </c:if>
                                                    </tr>
                                                </thead>
                                                <tbody id="contractItemsTable">
                                                    <c:forEach var="item" items="${contractItems}" varStatus="status">
                                                        <tr data-item-id="${item.id}"
                                                            data-serial="${item.subDevice.seriId}">
                                                            <td>${status.index + 1}</td>
                                                            <td class="serial-col">${item.subDevice.seriId}</td>
                                                            <td>
                                                                <img src="${item.subDevice.device.image != null ? item.subDevice.device.image : 'https://sudospaces.com/phonglien-vn/2025/07/df36f4bc988f11d1489e-large.jpg'}"
                                                                    alt="Product" class="product-img border">
                                                            </td>
                                                            <td>
                                                                <div class="product-name">${item.subDevice.device.name}
                                                                </div>
                                                                <span class="product-link"><i
                                                                        class="fas fa-arrow-right"></i></span>
                                                            </td>
                                                            <td>${item.subDevice.device.maintenanceTime} tháng</td>
                                                            <c:if test="${canEdit}">
                                                                <td class="text-center">
                                                                    <button type="button" class="btn btn-sm btn-warning"
                                                                        onclick="removeExistingItem(${item.id}, '${item.subDevice.seriId}')">
                                                                        Xóa
                                                                    </button>
                                                                </td>
                                                            </c:if>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Right Panel -->
                            <div class="col-lg-4">
                                <div class="border p-2 shadow-sm h-100">
                                    <div class="card-body d-flex flex-column">
                                        <!-- Customer Info - Chỉ đọc, không cho sửa -->
                                        <div class="mb-3">
                                            <h6 class="mb-3"><i class="fas fa-user me-2"></i>Thông tin khách hàng</h6>
                                            <div class="user-info-readonly">
                                                <div class="d-flex justify-content-between align-items-center mb-2">
                                                    <span class="text-muted">Họ & Tên:</span>
                                                    <span class="fw-medium">${contract.user.displayname}</span>
                                                </div>
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <span class="text-muted">Số điện thoại:</span>
                                                    <span class="fw-medium">${contract.user.phone}</span>
                                                </div>
                                            </div>
                                            <small class="text-muted mt-2 d-block">
                                                <i class="fas fa-info-circle me-1"></i>Không thể thay đổi khách hàng của
                                                hợp đồng
                                            </small>
                                        </div>

                                        <!-- Order Summary -->
                                        <div class="border-top pt-3 mb-3">
                                            <div class="d-flex justify-content-between mb-2 small">
                                                <span class="summary-label">Tổng sản phẩm:</span>
                                                <span class="summary-value" id="totalProducts">${contractItems.size()}
                                                    sp</span>
                                            </div>
                                        </div>

                                        <!-- Payment Section -->
                                        <div class="mb-3">
                                            <label class="form-label mb-1">Nội dung hợp đồng</label>
                                            <textarea id="myText" class="form-control" rows="6" readonly
                                                disabled>${contract.content}</textarea>
                                            <small class="text-muted mt-1 d-block">
                                                <i class="fas fa-info-circle me-1"></i>Không thể thay đổi nội dung hợp
                                                đồng
                                            </small>
                                        </div>

                                        <!-- Submit Button -->
                                        <div class="mt-auto">
                                            <button type="button" id="submit-button" class="btn btn-primary w-100">
                                                Cập nhật hợp đồng
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Hidden data for JavaScript -->
                    <input type="hidden" id="contractId" value="${contract.id}">
                    <input type="hidden" id="canEdit" value="${canEdit}">

                    <script
                        src="${pageContext.request.contextPath}/assets/js/update-contract/update-contract.js?v=<%=System.currentTimeMillis()%>"></script>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
                        integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL"
                        crossorigin="anonymous"></script>
                </body>

                </html>