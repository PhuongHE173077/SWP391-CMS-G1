<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<jsp:include page="../managerLayout.jsp">
    <jsp:param name="pageTitle" value="Customer Detail" />
</jsp:include>

<style>
    body {
        background-color: #f8f9fa;
    }

    .customer-card {
        background: white;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
    }

    .customer-header {
        background: linear-gradient(135deg, #10b981 0%, #059669 100%);
        padding: 2rem;
        color: white;
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
    }

    .stat-card {
        background: white;
        border-radius: 10px;
        padding: 1.5rem;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        text-align: center;
        transition: transform 0.2s;
    }

    .stat-card:hover {
        transform: translateY(-5px);
    }

    .stat-number {
        font-size: 2rem;
        font-weight: 700;
        color: #10b981;
    }

    .stat-label {
        color: #6c757d;
        font-size: 0.9rem;
        margin-top: 0.5rem;
    }
</style>

<body class="bg-light">
    <div class="container-fluid px-4 mt-4">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div class="d-flex align-items-center gap-3">
                <a href="ViewCustomer" class="btn btn-outline-secondary fw-bold">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại
                </a>
                <div>
                    <h2 class="text-primary fw-bold mb-1">
                        <i class="fas fa-user me-2"></i>Chi Tiết Khách Hàng
                    </h2>
                    <p class="text-muted mb-0">Mã khách hàng: #${customer.id}</p>
                </div>
            </div>
        </div>

        <!-- SECTION 1: Thông tin khách hàng -->
        <div class="customer-card mb-4">
            <div class="customer-header">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h3 class="mb-2 fw-bold">${customer.displayname}</h3>
                        <p class="mb-0 opacity-75">
                            <i class="fas fa-envelope me-2"></i>${customer.email}
                        </p>
                    </div>
                    <div class="col-md-4 text-end">
                        <span class="badge bg-white text-success fs-6 px-3 py-2">
                            <i class="fas fa-user-check me-1"></i>Khách hàng
                        </span>
                    </div>
                </div>
            </div>
            <div class="p-4">
                <div class="row">
                    <div class="col-md-6">
                        <table class="info-table w-100">
                            <tr>
                                <td class="info-label">
                                    <i class="fas fa-hashtag me-2 text-primary"></i>Mã khách hàng:
                                </td>
                                <td class="fw-bold">#${customer.id}</td>
                            </tr>
                            <tr>
                                <td class="info-label">
                                    <i class="fas fa-user me-2 text-primary"></i>Họ và tên:
                                </td>
                                <td>${customer.displayname}</td>
                            </tr>
                            <tr>
                                <td class="info-label">
                                    <i class="fas fa-envelope me-2 text-primary"></i>Email:
                                </td>
                                <td>${customer.email}</td>
                            </tr>
                            <tr>
                                <td class="info-label">
                                    <i class="fas fa-phone me-2 text-primary"></i>Số điện thoại:
                                </td>
                                <td>${customer.phone != null ? customer.phone : 'Chưa cập nhật'}</td>
                            </tr>
                        </table>
                    </div>
                    <div class="col-md-6">
                        <table class="info-table w-100">
                            <tr>
                                <td class="info-label">
                                    <i class="fas fa-map-marker-alt me-2 text-primary"></i>Địa chỉ:
                                </td>
                                <td>${customer.address != null ? customer.address : 'Chưa cập nhật'}</td>
                            </tr>
                            <tr>
                                <td class="info-label">
                                    <i class="fas fa-venus-mars me-2 text-primary"></i>Giới tính:
                                </td>
                                <td>${customer.gender ? 'Nam' : 'Nữ'}</td>
                            </tr>
                            <tr>
                                <td class="info-label">
                                    <i class="fas fa-toggle-on me-2 text-primary"></i>Trạng thái:
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${customer.active}">
                                            <span class="badge bg-success">Đang hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">Đã khóa</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- SECTION 2: Thống kê -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-number">${contracts.size()}</div>
                    <div class="stat-label">
                        <i class="fas fa-file-contract me-1"></i>Tổng số hợp đồng
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-number">${contractItems.size()}</div>
                    <div class="stat-label">
                        <i class="fas fa-box me-1"></i>Tổng số sản phẩm đã mua
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-number">
                        <c:set var="activeContracts" value="0" />
                        <c:forEach var="contract" items="${contracts}">
                            <c:set var="hasActiveItem" value="false" />
                            <c:forEach var="item" items="${contractItems}">
                                <c:if test="${item.contract.id == contract.id && item.endDate != null}">
                                    <c:set var="endTime" value="${item.endDate.time}" />
                                    <c:set var="currentTime" value="<%= System.currentTimeMillis() %>" />
                                    <c:if test="${endTime > currentTime}">
                                        <c:set var="hasActiveItem" value="true" />
                                    </c:if>
                                </c:if>
                            </c:forEach>
                            <c:if test="${hasActiveItem}">
                                <c:set var="activeContracts" value="${activeContracts + 1}" />
                            </c:if>
                        </c:forEach>
                        ${activeContracts}
                    </div>
                    <div class="stat-label">
                        <i class="fas fa-check-circle me-1"></i>Hợp đồng đang hiệu lực
                    </div>
                </div>
            </div>
        </div>      

        <!-- SECTION 4: Danh sách sản phẩm đã mua -->
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white py-3">
                <h5 class="mb-0 fw-bold text-secondary">
                    <i class="fas fa-file-contract me-2"></i>Danh Sách Hợp Đồng
                </h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover table-bordered align-middle mb-0">
                        <thead class="table-light text-secondary">
                            <tr>
                                <th class="ps-3 py-3 text-center">ID</th>
                                <th class="py-3 text-center">Ngày tạo</th>
                                <th class="py-3 text-center">PDF</th>
                                <th class="py-3 text-center">Seri</th>
                                <th class="py-3 text-center">Tên sản phẩm</th>
                                <th class="py-3 text-center">Ngày bắt đầu bảo hành</th>
                                <th class="py-3 text-center">Ngày kết thúc bảo hành</th>
                                <th class="py-3 text-center">Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${not empty contracts}">
                                <c:forEach items="${contracts}" var="contract">
                                    <c:set var="itemCount" value="0" />
                                    <c:forEach var="item" items="${contractItems}">
                                        <c:if test="${item.contract.id == contract.id}">
                                            <c:set var="itemCount" value="${itemCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    
                                    <c:if test="${itemCount > 0}">
                                        <c:set var="isFirstItem" value="true" />
                                        <c:forEach var="item" items="${contractItems}">
                                            <c:if test="${item.contract.id == contract.id}">
                                                <tr>
                                                    <c:if test="${isFirstItem}">
                                                        <td class="text-center align-middle fw-bold" rowspan="${itemCount}">
                                                            #${contract.id}
                                                        </td>
                                                        <td class="text-center align-middle" rowspan="${itemCount}">
                                                            <fmt:formatDate value="${contract.createdAtDate}" pattern="dd/MM/yyyy" />
                                                        </td>
                                                        <td class="text-center align-middle" rowspan="${itemCount}">
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
                                                        <c:set var="isFirstItem" value="false" />
                                                    </c:if>
                                                    
                                                    <!-- Seri -->
                                                    <td class="text-center">
                                                        ${item.subDevice.seriId != null ? item.subDevice.seriId : '-'}
                                                    </td>
                                                    
                                                    <!-- Tên sản phẩm -->
                                                    <td class="text-center">
                                                        ${item.subDevice.device.name != null ? item.subDevice.device.name : '-'}
                                                    </td>
                                                    
                                                    <!-- Ngày bắt đầu bảo hành -->
                                                    <td class="text-center">
                                                        <c:if test="${item.startAt != null}">
                                                            <fmt:formatDate value="${item.startAt}" pattern="dd/MM/yyyy" />
                                                        </c:if>
                                                        <c:if test="${item.startAt == null}">
                                                            <span class="text-muted">-</span>
                                                        </c:if>
                                                    </td>
                                                    
                                                    <!-- Ngày kết thúc bảo hành -->
                                                    <td class="text-center">
                                                        <c:if test="${item.endDate != null}">
                                                            <fmt:formatDate value="${item.endDate}" pattern="dd/MM/yyyy" />
                                                        </c:if>
                                                        <c:if test="${item.endDate == null}">
                                                            <span class="text-muted">-</span>
                                                        </c:if>
                                                    </td>
                                                    
                                                    <!-- Trạng thái -->
                                                    <td class="text-center">
                                                        <c:choose>
                                                            <c:when test="${item.endDate != null}">
                                                                <c:set var="endTime" value="${item.endDate.time}" />
                                                                <c:set var="currentTime" value="<%= System.currentTimeMillis() %>" />
                                                                <c:choose>
                                                                    <c:when test="${endTime > currentTime}">
                                                                        <span class="badge bg-success">Còn hiệu lực</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-secondary">Hết hiệu lực</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">Hết hiệu lực</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </c:if>
                                </c:forEach>
                            </c:if>

                            <c:if test="${empty contracts || empty contractItems}">
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">
                                        <i class="fas fa-inbox fa-3x mb-3"></i><br>
                                        Khách hàng chưa mua sản phẩm nào.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

<jsp:include page="../managerFooter.jsp" />
