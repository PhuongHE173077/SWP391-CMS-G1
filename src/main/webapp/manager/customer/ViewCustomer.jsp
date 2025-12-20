<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<jsp:include page="../managerLayout.jsp">
    <jsp:param name="pageTitle" value="Customer Statistics" />
</jsp:include>

<!-- Tính toán quyền cho màn hình khách hàng -->
<c:set var="canViewCustomer" value="false" />
<c:set var="canViewCustomerDetail" value="false" />

<c:if test="${not empty sessionScope.role && not empty sessionScope.rolePermissions}">
    <c:forEach var="rp" items="${sessionScope.rolePermissions}">
        <c:if test="${rp.roles.id == sessionScope.role.id}">
            <c:if test="${rp.router == '/ViewCustomer'}">
                <c:set var="canViewCustomer" value="true" />
            </c:if>
            <c:if test="${rp.router == '/customer-detail'}">
                <c:set var="canViewCustomerDetail" value="true" />
            </c:if>
        </c:if>
    </c:forEach>
</c:if>

<style>
    .card,
    .btn,
    .form-control,
    .input-group-text,
    .table,
    .pagination .page-link,
    .alert,
    .badge {
        border-radius: 0 !important;
    }

    .btn-success,
    .btn-success:hover,
    .btn-success:focus {
        background-color: #10b981;
        border-color: #10b981;
    }

    .btn-success:hover {
        background-color: #059669;
        border-color: #059669;
    }

    .btn-outline-success {
        color: #10b981;
        border-color: #10b981;
    }

    .btn-outline-success:hover {
        background-color: #10b981;
        border-color: #10b981;
        color: white;
    }

    .alert-success {
        background-color: #d1fae5;
        border-color: #10b981;
        color: #065f46;
    }

    .pagination .page-link {
        color: #10b981;
        border-color: #10b981;
    }

    .pagination .page-item.active .page-link {
        background-color: #10b981;
        border-color: #10b981;
        color: white;
    }

    .pagination .page-link:hover {
        background-color: #10b981;
        border-color: #10b981;
        color: white;
    }
</style>

<body class="bg-light">
    <div class="container-fluid px-4">

        <div class="card shadow-sm mb-4 mt-4">
            <div class="card-header bg-white py-3">
                <h5 class="m-0 font-weight-bold text-secondary"><i class="fas fa-filter me-2"></i>Tìm kiếm Khách hàng</h5>
            </div>
            <div class="card-body">
                <form action="ViewCustomer" method="get">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="fas fa-search"></i></span>
                                <input type="text" name="keyword" class="form-control"
                                    placeholder="Tìm theo tên, email hoặc số điện thoại..." value="${keyword}">
                            </div>
                        </div>
                        <div class="col-md-4 d-flex gap-2">
                            <button type="submit" class="btn btn-success w-100 fw-bold">Search</button>
                            <a href="ViewCustomer" class="btn btn-outline-secondary w-100" title="Reset Filter">
                                Reset
                            </a>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <c:if test="${canViewCustomer}">
        <div class="card shadow-sm mb-3">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h5 class="m-0 font-weight-bold text-secondary"><i class="fas fa-chart-bar me-2"></i>Thống kê Khách hàng</h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover table-bordered align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="py-3 ps-3">ID</th>
                                <th class="py-3">Họ và Tên</th>
                                <th class="py-3">Email</th>
                                <th class="py-3">Số điện thoại</th>
                                <th class="py-3 text-center">Số lượng Hợp đồng</th>
                                <th class="py-3 text-center">Số lượng Sản phẩm đã mua</th>
                                <th class="py-3 text-center">Chức năng</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${listStats}" var="s">
                                <tr>
                                    <td class="ps-3 fw-bold text-secondary">#${s.userId}</td>
                                    <td class="fw-bold text-primary">${s.displayName}</td>
                                    <td class="text-muted">${s.email}</td>
                                    <td class="text-muted">${s.phone}</td>
                                    <td class="text-center">
                                        <span class="badge bg-primary rounded-pill px-3">${s.totalContracts}</span>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge bg-success rounded-pill px-3">${s.totalProducts}</span>
                                    </td>
                                    <td class="text-center">
                                        <!-- Nút Xem chi tiết -->
                                        <c:choose>
                                            <c:when test="${canViewCustomerDetail}">
                                                <a href="customer-detail?id=${s.userId}" class="btn btn-success btn-sm fw-bold">
                                                    <i class="fas fa-eye me-1"></i>Xem chi tiết
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="button" class="btn btn-secondary btn-sm fw-bold" disabled
                                                    title="Bạn không có quyền xem chi tiết khách hàng">
                                                    <i class="fas fa-eye me-1"></i>Xem chi tiết
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty listStats}">
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <h5>Không tìm thấy khách hàng nào</h5>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="card-footer bg-white d-flex justify-content-center py-3">
                <c:if test="${totalPage > 1}">
                    <nav aria-label="Page navigation">
                        <ul class="pagination m-0">
                            <c:forEach begin="1" end="${totalPage}" var="p">
                                <li class="page-item ${p == pageIndex ? 'active' : ''}">
                                    <a class="page-link" href="ViewCustomer?page=${p}&keyword=${keyword}">${p}</a>
                                </li>
                            </c:forEach>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
        </c:if>
        
        <c:if test="${!canViewCustomer}">
            <div class="card shadow-sm mb-3">
                <div class="card-body text-center py-5">
                    <h4 class="text-muted">Bạn không có quyền xem danh sách khách hàng</h4>
                </div>
            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

<jsp:include page="../managerFooter.jsp" />
