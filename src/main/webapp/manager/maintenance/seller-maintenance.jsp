<%-- 
    Document   : manager-maintenance
    Created on : Dec 15, 2025, 10:46:12 AM
    Author     : ADMIN
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../../manager/managerLayout.jsp">
    <jsp:param name="pageTitle" value="Maintenance Requests" />
</jsp:include>



<body class="bg-light">
    <div class="container-fluid px-4 mt-4">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary fw-bold"><i class="fas fa-tools me-2"></i>Maintenance Request Management</h2>
        </div>

        <c:if test="${not empty msg}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="fas fa-check-circle me-2"></i>${msg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white py-3">
                <h5 class="m-0 font-weight-bold text-secondary"><i class="fas fa-filter me-2"></i>Filter & Sort</h5>
            </div>
            <div class="card-body">
                <form action="seller-maintenance" method="get">

                    <div class="row mb-3 align-items-center bg-light p-2 rounded mx-0">
                        <div class="col-md-8 d-flex align-items-center gap-3 flex-wrap">
                            <span class="fw-bold text-dark">Sort by:</span>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortBy" value="id" ${sortBy == 'id' ? 'checked' : ''}>
                                <label class="form-check-label">ID</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortBy" value="created_at" ${sortBy == 'created_at' ? 'checked' : ''}>
                                <label class="form-check-label">Created At</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortBy" value="content" ${sortBy == 'content' ? 'checked' : ''}>
                                <label class="form-check-label">Content</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortBy" value="customer" ${sortBy == 'customer' ? 'checked' : ''}>
                                <label class="form-check-label">Customer</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortBy" value="status" ${sortBy == 'status' ? 'checked' : ''}>
                                <label class="form-check-label">Status</label>
                            </div>
                        </div>

                        <div class="col-md-4 d-flex align-items-center gap-3 justify-content-end">
                            <span class="fw-bold text-dark">Order:</span>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortOrder" value="ASC" ${sortOrder == 'ASC' ? 'checked' : ''}>
                                <label class="form-check-label">Ascending</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortOrder" value="DESC" ${sortOrder == 'DESC' ? 'checked' : ''}>
                                <label class="form-check-label">Descending</label>
                            </div>
                        </div>
                    </div>

                    <div class="row g-2">
                        <div class="col-md-2">
                            <div class="form-floating">
                                <select name="status" class="form-select" id="statusSelect">
                                    <option value="">All Status</option>
                                    <c:forEach items="${statusList}" var="s">
                                        <option value="${s}" ${statusValue == s ? 'selected' : ''}>${s}</option>
                                    </c:forEach>
                                </select>
                                <label for="statusSelect">Status</label>
                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="form-floating">
                                <input type="date" name="fromDate" class="form-control" id="fromDate" value="${fromDateValue}">
                                <label for="fromDate">From Date</label>
                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="form-floating">
                                <input type="date" name="toDate" class="form-control" id="toDate" value="${toDateValue}">
                                <label for="toDate">To Date</label>
                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="form-floating">
                                <select name="customerId" class="form-select" id="customerSelect">
                                    <option value="">All Customers</option>
                                    <c:forEach items="${customerList}" var="cus">
                                        <option value="${cus.id}" ${customerIdValue == cus.id ? 'selected' : ''}>${cus.displayname}</option>
                                    </c:forEach>
                                </select>
                                <label for="customerSelect">Customer</label>
                            </div>
                        </div>

                        <div class="col">
                            <div class="form-floating">
                                <input type="text" name="search" class="form-control" id="searchInput" value="${searchValue}">
                                <label for="searchInput"><i class="fas fa-search me-1"></i>Search by keyword</label>
                            </div>
                        </div>

                        <div class="col-auto">
                            <button type="submit" class="btn btn-primary fw-bold w-100 h-100">
                                Search
                            </button>
                        </div>

                        <div class="col-auto">
                            <a href="seller-maintenance" class="btn btn-outline-secondary w-100 h-100 d-flex align-items-center justify-content-center" title="Reset Filter">
                                <i class="fas fa-sync-alt"></i>
                            </a>
                        </div>
                    </div>

                </form>
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover table-bordered align-middle mb-0">
                        <thead class="table-light text-secondary">
                            <tr>
                                <th class="py-3 ps-3 text-center">Request ID</th>
                                <th class="py-3 text-center">Customer Name</th>
                                <th class="py-3 text-center">Device Name</th>
                                <th class="py-3 text-center">Device Serial Number</th>
                                <th class="py-3 text-center">Image</th>
                                <th class="py-3 text-center" style="width: 25%;">Content</th>
                                <th class="py-3 text-center">Date Request</th>
                                <th class="py-3 text-center">Status</th>
                                <th class="py-3 text-center" style="width: 200px;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${requestList}" var="r">
                                <tr>
                                    <td class="text-center">${r.id}</td>
                                    <td class="text-center">${r.user.displayname}</td>
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
                                        <div style="max-height: 60px; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;">
                                            ${r.content}
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <fmt:formatDate value="${r.createdAtDate}" pattern="dd-MMM-yyyy"/>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${r.status == 'PENDING'}">
                                                <span class="badge bg-warning text-dark border border-warning"><i class="fas fa-clock me-1"></i>PENDING</span>
                                            </c:when>
                                            <c:when test="${r.status == 'APPROVE'}">
                                                <span class="badge bg-success border border-success"><i class="fas fa-check-circle me-1"></i>APPROVE</span>
                                            </c:when>
                                            <c:when test="${r.status == 'REJECT'}">
                                                <span class="badge bg-danger border border-danger"><i class="fas fa-times-circle me-1"></i>REJECT</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${r.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex justify-content-center gap-2">

                                            <a href="ViewDetaiRequestMaintance?id=${r.id}" class="btn btn-sm btn-outline-success fw-bold" title="Send Reply to Customer">
                                                <i class="fas fa-paper-plane me-1"></i>Reply
                                            </a>
                                            <!-- Change Status Dropdown -->
                                            <div class="dropdown">
                                                <button class="btn btn-sm btn-outline-warning fw-bold dropdown-toggle" type="button" id="statusDropdown${r.id}" data-bs-toggle="dropdown" aria-expanded="false" style="min-width: 80px;">
                                                    <i class="fas fa-edit me-1"></i>Status
                                                </button>
                                                <ul class="dropdown-menu" aria-labelledby="statusDropdown${r.id}">
                                                    <li>
                                                        <form action="change-maintenance-status" method="POST" class="statusForm" data-request-id="${r.id}" data-status="PENDING" data-current-status="${r.status}">
                                                            <input type="hidden" name="id" value="${r.id}">
                                                            <input type="hidden" name="status" value="PENDING">
                                                            <input type="hidden" name="page" value="${currentPage}">
                                                            <input type="hidden" name="search" value="${searchValue}">
                                                            <input type="hidden" name="statusFilter" value="${statusValue}">
                                                            <input type="hidden" name="fromDate" value="${fromDateValue}">
                                                            <input type="hidden" name="toDate" value="${toDateValue}">
                                                            <input type="hidden" name="customerId" value="${customerIdValue}">
                                                            <input type="hidden" name="sortBy" value="${sortBy}">
                                                            <input type="hidden" name="sortOrder" value="${sortOrder}">
                                                            <button type="button" class="dropdown-item ${r.status == 'PENDING' ? 'active' : ''} changeStatusBtn" ${r.status == 'PENDING' ? 'disabled' : ''}>
                                                                <i class="fas fa-clock me-2"></i>PENDING
                                                            </button>
                                                        </form>
                                                    </li>
                                                    <li>
                                                        <form action="change-maintenance-status" method="POST" class="statusForm" data-request-id="${r.id}" data-status="APPROVE" data-current-status="${r.status}">
                                                            <input type="hidden" name="id" value="${r.id}">
                                                            <input type="hidden" name="status" value="APPROVE">
                                                            <input type="hidden" name="page" value="${currentPage}">
                                                            <input type="hidden" name="search" value="${searchValue}">
                                                            <input type="hidden" name="statusFilter" value="${statusValue}">
                                                            <input type="hidden" name="fromDate" value="${fromDateValue}">
                                                            <input type="hidden" name="toDate" value="${toDateValue}">
                                                            <input type="hidden" name="customerId" value="${customerIdValue}">
                                                            <input type="hidden" name="sortBy" value="${sortBy}">
                                                            <input type="hidden" name="sortOrder" value="${sortOrder}">
                                                            <button type="button" class="dropdown-item ${r.status == 'APPROVE' ? 'active' : ''} changeStatusBtn" ${r.status == 'APPROVE' ? 'disabled' : ''}>
                                                                <i class="fas fa-check-circle me-2"></i>APPROVE
                                                            </button>
                                                        </form>
                                                    </li>
                                                    <li>
                                                        <form action="change-maintenance-status" method="POST" class="statusForm" data-request-id="${r.id}" data-status="REJECT" data-current-status="${r.status}">
                                                            <input type="hidden" name="id" value="${r.id}">
                                                            <input type="hidden" name="status" value="REJECT">
                                                            <input type="hidden" name="page" value="${currentPage}">
                                                            <input type="hidden" name="search" value="${searchValue}">
                                                            <input type="hidden" name="statusFilter" value="${statusValue}">
                                                            <input type="hidden" name="fromDate" value="${fromDateValue}">
                                                            <input type="hidden" name="toDate" value="${toDateValue}">
                                                            <input type="hidden" name="customerId" value="${customerIdValue}">
                                                            <input type="hidden" name="sortBy" value="${sortBy}">
                                                            <input type="hidden" name="sortOrder" value="${sortOrder}">
                                                            <button type="button" class="dropdown-item ${r.status == 'REJECT' ? 'active' : ''} changeStatusBtn" ${r.status == 'REJECT' ? 'disabled' : ''}>
                                                                <i class="fas fa-times-circle me-2"></i>REJECT
                                                            </button>
                                                        </form>
                                                    </li>
                                                </ul>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty requestList}">
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">
                                        <i class="fas fa-inbox fa-3x mb-3 text-secondary"></i><br>
                                        No maintenance requests found matching your criteria.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="card-footer bg-white d-flex justify-content-center py-3">
                <c:if test="${totalPages > 0}">
                    <nav aria-label="Page navigation">
                        <ul class="pagination m-0">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="seller-maintenance?page=${currentPage - 1}&search=${searchValue}&status=${statusValue}&fromDate=${fromDateValue}&toDate=${toDateValue}&customerId=${customerIdValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">Previous</a>
                            </li>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="seller-maintenance?page=${i}&search=${searchValue}&status=${statusValue}&fromDate=${fromDateValue}&toDate=${toDateValue}&customerId=${customerIdValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">${i}</a>
                                </li>
                            </c:forEach>

                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="seller-maintenance?page=${currentPage + 1}&search=${searchValue}&status=${statusValue}&fromDate=${fromDateValue}&toDate=${toDateValue}&customerId=${customerIdValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">Next</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>

    
    <div class="modal fade" id="statusChangeModal" tabindex="-1" aria-labelledby="statusChangeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-warning text-dark">
                    <h5 class="modal-title fw-bold" id="statusChangeModalLabel">
                        <i class="fas fa-exclamation-triangle me-2"></i>Xác nhận thay đổi trạng thái
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="d-flex align-items-center mb-3">
                        <div class="flex-shrink-0">
                            <i class="fas fa-info-circle fa-2x text-primary"></i>
                        </div>
                        <div class="flex-grow-1 ms-3">
                            <p class="mb-2 fw-bold">Bạn có chắc chắn muốn thay đổi trạng thái?</p>
                            <div id="statusChangeMessage" class="text-muted"></div>
                        </div>
                    </div>
                    <div class="alert alert-info mb-0">
                        <i class="fas fa-lightbulb me-2"></i>
                        <small>Hành động này sẽ cập nhật trạng thái của yêu cầu bảo trì.</small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Hủy
                    </button>
                    <button type="button" class="btn btn-warning fw-bold" id="confirmStatusChangeBtn">
                        <i class="fas fa-check me-2"></i>Xác nhận
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Xử lý confirmation khi thay đổi status
        let pendingForm = null;
        let statusChangeModal = null;
        
        document.addEventListener('DOMContentLoaded', function() {
            // Khởi tạo modal
            const modalElement = document.getElementById('statusChangeModal');
            if (modalElement && typeof bootstrap !== 'undefined') {
                statusChangeModal = new bootstrap.Modal(modalElement);
            }
            
            const statusButtons = document.querySelectorAll('.changeStatusBtn');
            
            statusButtons.forEach(function(button) {
                button.addEventListener('click', function(e) {
                    e.preventDefault();
                    
                    const form = this.closest('form');
                    const requestId = form.dataset.requestId;
                    const newStatus = form.dataset.status;
                    const currentStatus = form.dataset.currentStatus;
                    
                    // Bỏ qua nếu status hiện tại giống status mới
                    if (currentStatus === newStatus) {
                        return;
                    }
                    
                    // Đóng dropdown
                    const dropdownElement = this.closest('.dropdown').querySelector('[data-bs-toggle="dropdown"]');
                    if (dropdownElement && typeof bootstrap !== 'undefined') {
                        const dropdown = bootstrap.Dropdown.getInstance(dropdownElement);
                        if (dropdown) {
                            dropdown.hide();
                        }
                    }
                    pendingForm = form;
                    
                    const statusBadges = {
                        'PENDING': '<span class="badge bg-warning text-dark">PENDING</span>',
                        'APPROVE': '<span class="badge bg-success">APPROVED</span>',
                        'REJECT': '<span class="badge bg-danger">REJECTED</span>'
                    };
                    
                    const message = ``;
                    
                    // Cập nhật nội dung modal
                    document.getElementById('statusChangeMessage').innerHTML = message;
                    
                    // Hiển thị modal
                    if (statusChangeModal) {
                        statusChangeModal.show();
                    } else if (modalElement && typeof bootstrap !== 'undefined') {
                        statusChangeModal = new bootstrap.Modal(modalElement);
                        statusChangeModal.show();
                    }
                });
            });
            
            document.getElementById('confirmStatusChangeBtn').addEventListener('click', function() {
                if (pendingForm) {
                    if (statusChangeModal) {
                        statusChangeModal.hide();
                    }
                    pendingForm.submit();
                    pendingForm = null;
                }
            });
        });
    </script>
</body>
<jsp:include page="../../manager/managerFooter.jsp" />