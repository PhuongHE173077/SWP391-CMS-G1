<%-- 
    Document   : user-maintenance
    Created on : Dec 15, 2025, 10:46:43 AM
    Author     : ADMIN
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%--<jsp:include page="../../customerLayout.jsp">
    <jsp:param name="pageTitle" value="My Maintenance Requests" />
</jsp:include>--%>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<body class="bg-light">
    <div class="container-fluid px-4 mt-4">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary fw-bold"><i class="fas fa-history me-2"></i>My Maintenance Requests</h2>
            <a href="create-request" class="btn btn-primary shadow-sm fw-bold">
                <i class="fas fa-plus me-2"></i>New Request
            </a>
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
                <form action="customer-maintenance" method="get">
                    <div class="row mb-3 align-items-center bg-light p-2 rounded mx-0">
                        <div class="col-md-7 d-flex align-items-center gap-3 flex-wrap">
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
                                <input class="form-check-input" type="radio" name="sortBy" value="status" ${sortBy == 'status' ? 'checked' : ''}>
                                <label class="form-check-label">Status</label>
                            </div>
                        </div>

                        <div class="col-md-5 d-flex align-items-center gap-3 justify-content-end">
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

                    <div class="row g-3">
                        <div class="col-md-3">
                            <select name="status" class="form-select">
                                <option value="">All Status</option>
                                <c:forEach items="${statusList}" var="s">
                                    <option value="${s}" ${statusValue == s ? 'selected' : ''}>${s}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <input type="date" name="fromDate" class="form-control" value="${fromDateValue}" title="From Date">
                        </div>
                        <div class="col-md-2">
                            <input type="date" name="toDate" class="form-control" value="${toDateValue}" title="To Date">
                        </div>
                        
                        <div class="col-md-5">
                            <div class="input-group">
                                <input type="text" name="search" class="form-control" placeholder="Search device name, content..." value="${searchValue}">
                                <button type="submit" class="btn btn-primary fw-bold">Search</button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row mt-2">
                        <div class="col-12 text-end">
                            <a href="customer-maintenance" class="text-secondary text-decoration-none"><i class="fas fa-sync-alt me-1"></i>Reset Filter</a>
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
                                <th class="text-center">Req ID</th>
                                <th class="py-3">Device Name</th>
                                <th class="py-3">Device Serial Number</th>
                                <th class="py-3" style="width: 25%;">Content</th>
                                <th class="py-3 text-center">Date Request</th>
                                <th class="py-3 text-center">Status</th>
                                <th class="py-3 text-center" style="width: 150px;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${requestList}" var="r">
                                <tr>
                                    <td class="fw-bold text-center">#${r.id}</td>
                                    <td class="fw-bold text-dark">
                                        ${r.contractItem.subDevice.device.name}
                                    </td>
                                    <td class="text-secondary font-monospace">
                                        ${r.contractItem.subDevice.seriId}
                                    </td>
                                    <td class="text-muted">
                                        <div style="max-height: 60px; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;">
                                            ${r.content}
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <%
                                            model.MaintanceRequest item = (model.MaintanceRequest) pageContext.getAttribute("r");
                                            java.util.Date dateDisplay = null;
                                            if (item.getCreatedAt() != null) {
                                                dateDisplay = java.util.Date.from(item.getCreatedAt().toInstant());
                                            }
                                            pageContext.setAttribute("dateDisplay", dateDisplay);
                                        %>
                                        <fmt:formatDate value="${dateDisplay}" pattern="dd-MMM-yyyy HH:mm"/>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${r.status == 'Pending'}">
                                                <span class="badge bg-warning text-dark">Pending</span>
                                            </c:when>
                                            <c:when test="${r.status == 'Completed'}">
                                                <span class="badge bg-success">Completed</span>
                                            </c:when>
                                            <c:when test="${r.status == 'Rejected'}">
                                                <span class="badge bg-danger">Rejected</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${r.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex justify-content-center gap-2">
                                            <a href="maintenance-detail?id=${r.id}" class="btn btn-sm btn-outline-primary fw-bold">
                                                <i class="fas fa-eye me-1"></i>View
                                            </a>
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
            </div>

            <div class="card-footer bg-white d-flex justify-content-center py-3">
                <c:if test="${totalPages > 0}">
                    <nav aria-label="Page navigation">
                        <ul class="pagination m-0">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="customer-maintenance?page=${currentPage - 1}&search=${searchValue}&status=${statusValue}&fromDate=${fromDateValue}&toDate=${toDateValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">Previous</a>
                            </li>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="customer-maintenance?page=${i}&search=${searchValue}&status=${statusValue}&fromDate=${fromDateValue}&toDate=${toDateValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">${i}</a>
                                </li>
                            </c:forEach>

                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="customer-maintenance?page=${currentPage + 1}&search=${searchValue}&status=${statusValue}&fromDate=${fromDateValue}&toDate=${toDateValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">Next</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
<%--<jsp:include page="../../managerFooter.jsp" />--%>