<%-- Document : contract-list Created on : Dec 10, 2025 Author : Customer Contract List --%>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Danh Sách Hợp Đồng Của Tôi</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
                    integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
                    crossorigin="anonymous">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
                <style>
                    body {
                        background-color: #f8f9fa;
                    }

                    .header-section {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        padding: 2rem 0;
                        margin-bottom: 2rem;
                    }

                    .filter-section {
                        background: white;
                        border-radius: 8px;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                        padding: 1.5rem;
                        margin-bottom: 2rem;
                    }

                    .table-section {
                        background: white;
                        border-radius: 8px;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                        overflow: hidden;
                    }

                    .table thead {
                        background-color: #667eea;
                        color: white;
                    }

                    .table tbody tr:hover {
                        background-color: #f8f9fa;
                    }

                    .badge-active {
                        background-color: #28a745;
                        color: white;
                        padding: 0.35em 0.65em;
                        border-radius: 0.375rem;
                    }

                    .badge-expired {
                        background-color: #dc3545;
                        color: white;
                        padding: 0.35em 0.65em;
                        border-radius: 0.375rem;
                    }

                    .no-contracts {
                        text-align: center;
                        padding: 4rem 2rem;
                        color: #6c757d;
                    }

                    .pagination-info {
                        color: #6c757d;
                        font-size: 0.9rem;
                    }

                    .warranty-request-btn {
                        background-color: #28a745;
                        color: white;
                        border: none;
                        padding: 0.375rem 0.75rem;
                        border-radius: 0.375rem;
                        font-size: 0.875rem;
                    }

                    .warranty-request-btn:hover {
                        background-color: #218838;
                        color: white;
                    }
                </style>
            </head>

            <body>
                <!-- Header Section -->
                <div class="header-section">
                    <div class="container">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h2 class="mb-0"><i class="fas fa-file-contract me-2"></i>Danh Sách Hợp Đồng Của Tôi
                                </h2>
                                <p class="mb-0 mt-2 opacity-75">Xem và quản lý tất cả hợp đồng của bạn</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Main Content -->
                <div class="container my-4">
                    <!-- Filter Section -->
                    <div class="filter-section">
                        <form action="${pageContext.request.contextPath}/customer/ViewListContact" method="get"
                            id="filterForm">
                            <div class="row g-3 align-items-end">
                                <!-- Search Input -->
                                <div class="col-md-3">
                                    <label for="keyword" class="form-label fw-bold">
                                        <i class="fas fa-search me-1"></i>Tìm kiếm
                                    </label>
                                    <input type="text" class="form-control" id="keyword" name="keyword"
                                        placeholder="Tìm theo tên người tạo..." value="${keyword}">
                                </div>

                                <!-- Status Filter -->
                                <div class="col-md-2">
                                    <label for="status" class="form-label fw-bold">
                                        <i class="fas fa-filter me-1"></i>Trạng thái
                                    </label>
                                    <select class="form-select" id="status" name="status">
                                        <option value="">Tất cả</option>
                                        <option value="active" ${status=='active' ? 'selected' : '' }>Còn hiệu lực
                                        </option>
                                        <option value="expired" ${status=='expired' ? 'selected' : '' }>Hết hiệu lực
                                        </option>
                                    </select>
                                </div>

                                <!-- Date Range Filters -->
                                <div class="col-md-2">
                                    <label for="fromDate" class="form-label fw-bold">
                                        <i class="fas fa-calendar-alt me-1"></i>Từ ngày
                                    </label>
                                    <input type="date" class="form-control" id="fromDate" name="fromDate"
                                        value="${fromDate}">
                                </div>

                                <div class="col-md-2">
                                    <label for="toDate" class="form-label fw-bold">
                                        <i class="fas fa-calendar-alt me-1"></i>Đến ngày
                                    </label>
                                    <input type="date" class="form-control" id="toDate" name="toDate" value="${toDate}">
                                </div>

                                <!-- Action Buttons -->
                                <div class="col-md-3">
                                    <div class="d-flex gap-2">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-search me-1"></i>Tìm kiếm
                                        </button>
                                        <a href="${pageContext.request.contextPath}/customer/ViewListContact"
                                            class="btn btn-outline-secondary">
                                            <i class="fas fa-redo me-1"></i>Reset
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>

                    <!-- Table Section -->
                    <div class="table-section">
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th class="text-center">Ngày tạo</th>
                                        <th class="text-center">PDF</th>
                                        <th class="text-center">Seri</th>
                                        <th class="text-center">Tên sản phẩm</th>
                                        <th class="text-center">Ngày bắt đầu bảo hành</th>
                                        <th class="text-center">Ngày kết thúc bảo hành</th>
                                        <th class="text-center">Trạng thái</th>
                                        <th class="text-center">Chức năng</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:if test="${not empty contractList}">
                                        <c:forEach items="${contractList}" var="contract" varStatus="contractStatus">
                                            <c:set var="items" value="${contractItemsMap[contract.id]}" />
                                            <c:set var="itemCount" value="${items != null ? items.size() : 0}" />
                                            <c:set var="startDateMap" value="${itemStartDateMap[contract.id]}" />
                                            <c:set var="endDateMap" value="${itemEndDateMap[contract.id]}" />
                                            <c:set var="statusMap" value="${itemStatusMap[contract.id]}" />

                                            <c:choose>
                                                <c:when test="${itemCount > 0}">
                                                    <c:forEach items="${items}" var="item" varStatus="itemStatus">
                                                        <tr>
                                                            <c:if test="${itemStatus.index == 0}">
                                                                <td class="text-center align-middle"
                                                                    rowspan="${itemCount}">
                                                                    <c:set var="formattedDate"
                                                                        value="${dateFormatMap[contract.id]}" />
                                                                    <c:if test="${not empty formattedDate}">
                                                                        ${formattedDate}
                                                                    </c:if>
                                                                    <c:if test="${empty formattedDate}">
                                                                        <span class="text-muted">-</span>
                                                                    </c:if>
                                                                </td>
                                                                <td class="text-center align-middle"
                                                                    rowspan="${itemCount}">
                                                                    <c:if test="${not empty contract.urlContract}">
                                                                        <a href="${contract.urlContract}"
                                                                            target="_blank"
                                                                            class="btn btn-sm btn-outline-primary">
                                                                            <i class="fas fa-file-pdf me-1"></i>Xem PDF
                                                                        </a>
                                                                    </c:if>
                                                                    <c:if test="${empty contract.urlContract}">
                                                                        <span class="text-muted">-</span>
                                                                    </c:if>
                                                                </td>
                                                            </c:if>

                                                            <!-- Seri -->
                                                            <td class="text-center">
                                                                ${item.subDevice.seriId != null ? item.subDevice.seriId
                                                                : '-'}
                                                            </td>

                                                            <!-- Tên sản phẩm -->
                                                            <td class="text-center">
                                                                ${item.subDevice.device.name != null ?
                                                                item.subDevice.device.name : '-'}
                                                            </td>

                                                            <!-- Ngày bắt đầu bảo hành -->
                                                            <td class="text-center">
                                                                <c:set var="startDate"
                                                                    value="${startDateMap[item.id]}" />
                                                                <c:if test="${not empty startDate}">
                                                                    ${startDate}
                                                                </c:if>
                                                                <c:if test="${empty startDate}">
                                                                    <span class="text-muted">-</span>
                                                                </c:if>
                                                            </td>

                                                            <!-- Ngày kết thúc bảo hành -->
                                                            <td class="text-center">
                                                                <c:set var="endDate" value="${endDateMap[item.id]}" />
                                                                <c:if test="${not empty endDate}">
                                                                    ${endDate}
                                                                </c:if>
                                                                <c:if test="${empty endDate}">
                                                                    <span class="text-muted">-</span>
                                                                </c:if>
                                                            </td>

                                                            <!-- Trạng thái -->
                                                            <td class="text-center">
                                                                <c:set var="itemStatus" value="${statusMap[item.id]}" />
                                                                <c:if test="${itemStatus == 'active'}">
                                                                    <span class="badge badge-active">Còn hiệu lực</span>
                                                                </c:if>
                                                                <c:if
                                                                    test="${itemStatus == 'expired' || empty itemStatus}">
                                                                    <span class="badge badge-expired">Hết hiệu
                                                                        lực</span>
                                                                </c:if>
                                                            </td>

                                                            <!-- Chức năng -->
                                                            <td class="text-center">
                                                                <c:set var="itemStatus" value="${statusMap[item.id]}" />
                                                                <c:if test="${itemStatus == 'active'}">
                                                                    <button type="button" class="warranty-request-btn"
                                                                        onclick="sendWarrantyRequest(${item.id})">
                                                                        <i class="fas fa-paper-plane me-1"></i>Gửi yêu
                                                                        cầu bảo hành
                                                                    </button>
                                                                </c:if>
                                                                <c:if test="${itemStatus != 'active'}">
                                                                    <span class="text-muted">-</span>
                                                                </c:if>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <!-- Contract không có items -->
                                                    <tr>
                                                        <td class="text-center">
                                                            <c:set var="formattedDate"
                                                                value="${dateFormatMap[contract.id]}" />
                                                            <c:if test="${not empty formattedDate}">
                                                                ${formattedDate}
                                                            </c:if>
                                                            <c:if test="${empty formattedDate}">
                                                                <span class="text-muted">-</span>
                                                            </c:if>
                                                        </td>
                                                        <td class="text-center">
                                                            <c:if test="${not empty contract.urlContract}">
                                                                <a href="${contract.urlContract}" target="_blank"
                                                                    class="btn btn-sm btn-outline-primary">
                                                                    <i class="fas fa-file-pdf me-1"></i>Xem PDF
                                                                </a>
                                                            </c:if>
                                                            <c:if test="${empty contract.urlContract}">
                                                                <span class="text-muted">-</span>
                                                            </c:if>
                                                        </td>
                                                        <td colspan="6" class="text-center text-muted">Không có sản phẩm
                                                        </td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </c:if>
                                    <c:if test="${empty contractList}">
                                        <tr>
                                            <td colspan="8" class="text-center py-5">
                                                <div class="no-contracts">
                                                    <i class="fas fa-file-contract fa-4x text-muted mb-3"></i>
                                                    <h5 class="text-muted">Không tìm thấy hợp đồng nào</h5>
                                                    <p class="text-muted">Vui lòng thử lại với từ khóa hoặc bộ lọc khác.
                                                    </p>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${not empty contractList && totalPages > 1}">
                            <div class="card-footer bg-white d-flex justify-content-between align-items-center py-3">
                                <div class="pagination-info">
                                    Hiển thị ${(currentPage - 1) * pageSize + 1} -
                                    ${currentPage * pageSize > totalContracts ? totalContracts : currentPage * pageSize}
                                    trong tổng số ${totalContracts} hợp đồng
                                </div>
                                <nav aria-label="Page navigation">
                                    <ul class="pagination mb-0">
                                        <!-- Previous Button -->
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link"
                                                href="${pageContext.request.contextPath}/customer/ViewListContact?page=${currentPage - 1}&keyword=${keyword}&status=${status}&fromDate=${fromDate}&toDate=${toDate}">
                                                <i class="fas fa-chevron-left"></i>
                                            </a>
                                        </li>

                                        <!-- Page Numbers -->
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <c:if
                                                test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                    <a class="page-link"
                                                        href="${pageContext.request.contextPath}/customer/ViewListContact?page=${i}&keyword=${keyword}&status=${status}&fromDate=${fromDate}&toDate=${toDate}">
                                                        ${i}
                                                    </a>
                                                </li>
                                            </c:if>
                                            <c:if test="${i == currentPage - 3 || i == currentPage + 3}">
                                                <li class="page-item disabled">
                                                    <span class="page-link">...</span>
                                                </li>
                                            </c:if>
                                        </c:forEach>

                                        <!-- Next Button -->
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link"
                                                href="${pageContext.request.contextPath}/customer/ViewListContact?page=${currentPage + 1}&keyword=${keyword}&status=${status}&fromDate=${fromDate}&toDate=${toDate}">
                                                <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </c:if>

                        <c:if test="${not empty contractList && totalPages <= 1}">
                            <div class="card-footer bg-white py-3">
                                <div class="pagination-info text-center">
                                    Tổng số: ${totalContracts} hợp đồng
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Bootstrap JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
                    integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+"
                    crossorigin="anonymous"></script>

                <script>
                    // Auto submit form khi thay đổi status filter
                    document.getElementById('status').addEventListener('change', function () {
                        document.getElementById('filterForm').submit();
                    });

                    // Function để gửi yêu cầu bảo hành
                    function sendWarrantyRequest(itemId) {
                        // TODO: Implement logic để gửi yêu cầu bảo hành
                        // Có thể redirect đến form hoặc hiển thị modal
                        window.location.href = '/CreateRequestMaintance?id=' + itemId;
                        // Ví dụ: window.location.href = 'warranty-request?itemId=' + itemId;
                    }
                </script>
            </body>

            </html>