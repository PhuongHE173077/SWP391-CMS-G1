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
                                            <a href="maintenance-detail?id=${r.id}" class="btn btn-sm btn-outline-primary fw-bold">
                                                View
                                            </a>
                                            <a href="send-reply?id=${r.id}" class="btn btn-sm btn-outline-success fw-bold" title="Send Reply to Customer">
                                                <i class="fas fa-paper-plane me-1"></i>Reply
                                            </a>
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
</body>
<jsp:include page="../../manager/managerFooter.jsp" />