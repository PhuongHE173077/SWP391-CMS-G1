<%-- Document : user-maintenance Created on : Dec 15, 2025, 10:46:43 AM Author : ADMIN --%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../customerLayout.jsp">
    <jsp:param name="pageTitle" value="My Maintenance Requests" />
</jsp:include>

<!-- Tính toán quyền cho màn hình yêu cầu bảo hành customer -->
<c:set var="canViewOwnMaintenances" value="false" />
<c:set var="canCreateMaintenance" value="false" />
<c:set var="canViewMaintenanceDetail" value="false" />

<c:if test="${not empty sessionScope.role && not empty sessionScope.rolePermissions}">
    <c:forEach var="rp" items="${sessionScope.rolePermissions}">
        <c:if test="${rp.roles.id == sessionScope.role.id}">
            <c:if test="${rp.router == '/customer-maintenance'}">
                <c:set var="canViewOwnMaintenances" value="true" />
            </c:if>
            <c:if test="${rp.router == '/CreateRequestMaintance'}">
                <c:set var="canCreateMaintenance" value="true" />
            </c:if>
            <c:if test="${rp.router == '/maintenance-detail'}">
                <c:set var="canViewMaintenanceDetail" value="true" />
            </c:if>
        </c:if>
    </c:forEach>
</c:if>

<style>
    .page-header {
        margin-bottom: 1.5rem;
    }

    .page-header h2 {
        color: #1e293b;
        font-weight: 600;
    }
</style>

<body class="bg-light">
    <div class="container-fluid px-4 mt-4">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary fw-bold"><i class="fas fa-history me-2"></i>Yêu cầu bảo hành của tôi
            </h2>
            <c:choose>
                <c:when test="${canCreateMaintenance}">
                    <a href="CreateRequestMaintance" class="btn btn-primary shadow-sm fw-bold">
                        <i class="fas fa-plus me-2"></i>Thêm yêu cầu mới
                    </a>
                </c:when>
                <c:otherwise>
                    <button type="button" class="btn btn-secondary shadow-sm fw-bold" disabled
                        title="Bạn không có quyền tạo yêu cầu bảo hành mới">
                        <i class="fas fa-plus me-2"></i>Thêm yêu cầu mới
                    </button>
                </c:otherwise>
            </c:choose>
        </div>

        <c:if test="${not empty msg}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="fas fa-check-circle me-2"></i>${msg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"
                        aria-label="Close"></button>
            </div>
        </c:if>

        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white py-3">
                <h5 class="m-0 font-weight-bold text-secondary"><i class="fas fa-filter me-2"></i>Filter
                    & Sort</h5>
            </div>
            <div class="card-body">
                <form action="customer-maintenance" method="get">
                    <div class="row mb-3 align-items-center bg-light p-2 rounded mx-0">
                        <div class="col-md-7 d-flex align-items-center gap-3 flex-wrap">
                            <span class="fw-bold text-dark">Sort by:</span>

                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortBy" value="id"
                                       ${sortBy=='id' ? 'checked' : '' }>
                                <label class="form-check-label">ID của yêu cầu</label>
                            </div>

                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortBy"
                                       value="created_at" ${sortBy=='created_at' ? 'checked' : '' }>
                                <label class="form-check-label">Ngày tạo</label>
                            </div>

                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortBy"
                                       value="content" ${sortBy=='content' ? 'checked' : '' }>
                                <label class="form-check-label">Nội dung</label>
                            </div>

                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortBy"
                                       value="seri" ${sortBy=='seri' ? 'checked' : '' }>
                                <label class="form-check-label">Số Seri của thiết bị</label>
                            </div>
                        </div>

                        <div class="col-md-5 d-flex align-items-center gap-3 justify-content-end">
                            <span class="fw-bold text-dark">Order:</span>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortOrder"
                                       value="ASC" ${sortOrder=='ASC' ? 'checked' : '' }>
                                <label class="form-check-label">Tăng dần</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortOrder"
                                       value="DESC" ${sortOrder=='DESC' ? 'checked' : '' }>
                                <label class="form-check-label">Giảm dần</label>
                            </div>
                        </div>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-2">
                            <div class="form-floating">
                                <select name="status" id="statusSelect" class="form-select">
                                    <option value="">All Status</option>
                                    <c:forEach items="${statusList}" var="s">
                                        <option value="${s}" ${statusValue==s ? 'selected' : '' }>${s}
                                        </option>
                                    </c:forEach>
                                </select>
                                <label for="statusSelect">Status</label>
                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="form-floating">
                                <input type="date" name="fromDate" class="form-control" id="fromDate"
                                       value="${fromDateValue}">
                                <label for="fromDate">From Date</label>
                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="form-floating">
                                <input type="date" name="toDate" class="form-control" id="toDate"
                                       value="${toDateValue}">
                                <label for="toDate">To Date</label>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-floating">
                                <input type="text" name="search" class="form-control" id="searchInput"
                                       placeholder="Search..." value="${searchValue}">
                                <label for="searchInput"><i class="fas fa-search me-1"></i>Search device
                                    name...</label>
                            </div>
                        </div>

                        <div class="col-md-1">
                            <button type="submit" class="btn btn-primary fw-bold w-100 h-100">
                                Search
                            </button>
                        </div>

                        <div class="col-md-1">
                            <a href="customer-maintenance"
                               class="btn btn-outline-secondary w-100 h-100 d-flex align-items-center justify-content-center"
                               title="Reset Filter">
                                <i class="fas fa-sync-alt"></i>
                            </a>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <c:if test="${canViewOwnMaintenances}">
        <div class="card shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover table-bordered align-middle mb-0">
                        <thead class="table-light text-secondary">
                            <tr>
                                <th class="ps-3 py-3 text-center">ID của yêu cầu</th>
                                <th class="py-3 text-center">Tên thiết bị</th>
                                <th class="py-3 text-center">Số Seri của thiết bị</th>
                                <th class="py-3 text-center">Ảnh</th>
                                <th class="py-3 text-center" style="width: 25%;">Nội dung</th>
                                <th class="py-3 text-center">Ngày tạo</th>
                                <th class="py-3 text-center">Trạng thái</th>
                                <th class="py-3 text-center" style="width: 150px;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${requestList}" var="r">
                                <tr>
                                    <td class="text-center">${r.id}</td>
                                    <td class="text-center">
                                        ${r.contractItem.subDevice.device.name}
                                    </td>
                                    <td class="text-center">
                                        ${r.contractItem.subDevice.seriId}
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${not empty r.image}">
                                                <img src="${r.image}" alt="Request Image"
                                                     class="img-thumbnail mb-1"
                                                     style="width: 80px; height: 60px; object-fit: cover;">

                                                <a href="${r.image}" target="_blank"
                                                   class="d-block small text-decoration-none mt-1">
                                                    <i class="fas fa-external-link-alt me-1"></i>Xem ảnh
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted small">
                                                    <i class="fas fa-image me-1"></i>No Image
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-muted">
                                        <div
                                            style="max-height: 60px; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;">
                                            ${r.content}
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <fmt:formatDate value="${r.createdAtDate}"
                                                        pattern="dd-MMM-yyyy" />
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${r.status == 'PENDING'}">
                                                <span class="badge bg-warning text-dark">PENDING</span>
                                            </c:when>
                                            <c:when test="${r.status == 'APPROVE'}">
                                                <span class="badge bg-success">APPROVE</span>
                                            </c:when>
                                            <c:when test="${r.status == 'REJECT'}">
                                                <span class="badge bg-danger">REJECT</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${r.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex justify-content-center gap-2">
                                            <!-- Nút View -->
                                            <c:choose>
                                                <c:when test="${canViewMaintenanceDetail}">
                                                    <a href="maintenance-detail?id=${r.id}"
                                                       class="btn btn-sm btn-outline-primary fw-bold">
                                                        <i class="fas fa-eye me-1"></i>View
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" class="btn btn-sm btn-outline-secondary fw-bold" disabled
                                                        title="Bạn không có quyền xem chi tiết yêu cầu">
                                                        <i class="fas fa-eye me-1"></i>View
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                            
                                            
                                        </div>
                                        
                                        
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty requestList}">
                                <tr>
                                    <td colspan="7" class="text-center py-5 text-muted">
                                        <i class="fas fa-inbox fa-3x mb-3"></i><br>
                                        No maintenance requests found.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <div class="card-footer bg-white d-flex justify-content-center py-3">
                    <c:if test="${totalPages > 0}">
                        <nav aria-label="Page navigation">
                            <ul class="pagination m-0">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link"
                                       href="customer-maintenance?page=${currentPage - 1}&search=${searchValue}&status=${statusValue}&fromDate=${fromDateValue}&toDate=${toDateValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">Previous</a>
                                </li>

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link"
                                           href="customer-maintenance?page=${i}&search=${searchValue}&status=${statusValue}&fromDate=${fromDateValue}&toDate=${toDateValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">${i}</a>
                                    </li>
                                </c:forEach>

                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link"
                                       href="customer-maintenance?page=${currentPage + 1}&search=${searchValue}&status=${statusValue}&fromDate=${fromDateValue}&toDate=${toDateValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">Next</a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>
        </c:if>
        
        <c:if test="${!canViewOwnMaintenances}">
            <div class="card shadow-sm">
                <div class="card-body text-center py-5">
                    <h4 class="text-muted">Bạn không có quyền xem danh sách yêu cầu bảo hành</h4>
                </div>
            </div>
        </c:if>

        <jsp:include page="../customerFooter.jsp" />