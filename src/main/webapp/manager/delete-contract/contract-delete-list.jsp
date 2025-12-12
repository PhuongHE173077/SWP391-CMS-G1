<%-- Document : contract-delete-list Created on : Dec 12, 2025, 9:44:43 AM Author : admin --%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<jsp:include page="../managerLayout.jsp">
    <jsp:param name="pageTitle" value="Deleted Contract Management" />
</jsp:include>
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
</style>

<body class="bg-light">
    <div class="container-fluid px-4 mt-4">



        <c:if test="${not empty sessionScope.msg}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="fas fa-check-circle me-2"></i>${sessionScope.msg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="msg" scope="session" />
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="error" scope="session" />
        </c:if>

        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white py-3">
                <h5 class="m-0 font-weight-bold text-secondary"><i class="fas fa-filter me-2"></i>Filter &
                    Sort</h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/list-contract-delete" method="get">

                    <div class="row mb-3 align-items-center bg-light p-2 rounded mx-0">
                        <div class="col-md-6 d-flex align-items-center gap-3">
                            <span class="fw-bold text-dark">Sort by:</span>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortBy" value="c.id"
                                       ${sortBy=='c.id' || empty sortBy ? 'checked' : '' }>
                                <label class="form-check-label">ID</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortBy" value="c.content"
                                       ${sortBy=='c.content' ? 'checked' : '' }>
                                <label class="form-check-label">Content</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortBy"
                                       value="u.displayname" ${sortBy=='u.displayname' ? 'checked' : '' }>
                                <label class="form-check-label">Customer Name</label>
                            </div>
                        </div>

                        <div class="col-md-6 d-flex align-items-center gap-3">
                            <span class="fw-bold text-dark">Order:</span>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortOrder" value="ASC"
                                       ${sortOrder=='ASC' ? 'checked' : '' }>
                                <label class="form-check-label">Ascending</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortOrder" value="DESC"
                                       ${sortOrder=='DESC' || empty sortOrder ? 'checked' : '' }>
                                <label class="form-check-label">Descending</label>
                            </div>
                        </div>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="fas fa-search"></i></span>
                                <input type="text" name="search" class="form-control"
                                       placeholder="Search by ID, Content, Customer Name, Created By..."
                                       value="${searchValue}">
                            </div>
                        </div>
                        <div class="col-md-4 d-flex gap-2">
                            <button type="submit" class="btn btn-primary w-100 fw-bold">Search</button>
                            <a href="${pageContext.request.contextPath}/list-contract-delete"
                               class="btn btn-outline-secondary w-100" title="Reset Filter">
                                Reset Filter
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
                        <thead class="table-light">
                            <tr>
                                <th class="py-3 ps-3">ID</th>
                                
                                <th class="py-3">Customer Name</th>
                                <th class="py-3 text-center">Url Contract</th>
                                <th class="py-3 text-center">Created By</th>
                                <th class="py-3 text-center">Status</th>
                                <th class="py-3 text-center" style="width: 150px;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${contractList}" var="c">
                                <tr>
                                    <td class="ps-3 fw-bold text-secondary">#${c.id}</td>
                                    
                                    <td class="text-muted">
                                        <c:if test="${not empty c.user}">
                                            ${c.user.displayname}
                                        </c:if>
                                    </td>
                                    <td class="text-center">
                                        <c:if test="${not empty c.urlContract}">
                                            <a href="${c.urlContract}" target="_blank"
                                               class="btn btn-sm btn-outline-info">
                                                <i class="fas fa-external-link-alt"></i> View
                                            </a>
                                        </c:if>
                                        <c:if test="${empty c.urlContract}">
                                            <span class="text-muted">N/A</span>
                                        </c:if>
                                    </td>
                                    <td class="text-center">
                                        <c:if test="${not empty c.createBy}">
                                            <span
                                                class="badge bg-info text-dark border">${c.createBy.displayname}</span>
                                        </c:if>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge bg-danger">Deleted</span>
                                    </td>
                                    <td class="text-center">
                                        <form
                                            action="${pageContext.request.contextPath}/list-contract-delete"
                                            method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="restore">
                                            <input type="hidden" name="id" value="${c.id}">
                                            <button type="submit"
                                                    class="btn btn-sm btn-outline-success fw-bold"
                                                    onclick="return confirm('Are you sure you want to restore this contract?')">
                                                <i class="fas fa-undo me-1"></i>Restore
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty contractList}">
                                <tr>
                                    <td colspan="7" class="text-center py-5 text-muted">
                                        <h5>No deleted contracts found</h5>
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
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/list-contract-delete?page=${currentPage - 1}&search=${searchValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">Previous</a>
                            </li>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link"
                                       href="${pageContext.request.contextPath}/list-contract-delete?page=${i}&search=${searchValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">${i}</a>
                                </li>
                            </c:forEach>

                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/list-contract-delete?page=${currentPage + 1}&search=${searchValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">Next</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

<jsp:include page="../managerFooter.jsp" />