<%-- 
    Document   : contract-list
    Created on : Dec 10, 2025, 10:44:22 AM
    Author     : ADMIN
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../../admin/adminLayout.jsp">
    <jsp:param name="pageTitle" value="My Contracts" />
</jsp:include>

<body class="bg-light">
    <div class="container-fluid px-4 mt-4">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary fw-bold"><i class="fas fa-file-contract me-2"></i>My Contracts</h2>
            <a href="AddContract" class="btn btn-primary shadow-sm fw-bold">
                <i class="fas fa-plus me-2"></i>Create New Contract
            </a>
        </div>

        <c:if test="${not empty msg}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${msg} <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <form action="contract-list" method="get">

                    <div class="d-flex gap-3 mb-3 bg-light p-2 rounded">
                        <div class="d-flex align-items-center gap-2">
                            <span class="fw-bold text-dark">Sort:</span>
                            <label><input type="radio" name="sortBy" value="id" ${sortBy == 'id' ? 'checked' : ''}> ID</label>
                            <label><input type="radio" name="sortBy" value="content" ${sortBy == 'content' ? 'checked' : ''}> Content</label>
                            <label><input type="radio" name="sortBy" value="customer" ${sortBy == 'customer' ? 'checked' : ''}> Customer</label>
                        </div>
                        <div class="vr"></div>
                        <div class="d-flex align-items-center gap-2">
                            <span class="fw-bold text-dark">Order:</span>
                            <label><input type="radio" name="sortOrder" value="ASC" ${sortOrder == 'ASC' ? 'checked' : ''}> Ascending</label>
                            <label><input type="radio" name="sortOrder" value="DESC" ${sortOrder == 'DESC' ? 'checked' : ''}> Descending</label>
                        </div>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-2">
                            <select name="status" class="form-select">
                                <option value="">All Status</option>
                                <option value="1" ${statusValue == '1' ? 'selected' : ''}>Active</option>
                                <option value="0" ${statusValue == '0' ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="fas fa-search"></i></span>
                                <input type="text" name="search" class="form-control" placeholder="Search content or customer name..." value="${searchValue}">
                            </div>
                        </div>
                        <div class="col-md-2 d-flex gap-2">
                            <button type="submit" class="btn btn-primary w-100 fw-bold">Search</button>
                            <a href="contract-list" class="btn btn-outline-secondary w-100">Reset Filter</a>
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
                                <th class="ps-3">ID</th>
                                <th>Content</th>
                                <th>Customer</th>
                                <th class="text-center">PDF filed</th>
                                <th class="text-center">Status</th>
                                <th class="text-center" style="width: 200px;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${contractList}" var="c">
                                <tr>
                                    <td class="ps-3 fw-bold text-secondary">#${c.id}</td>
                                    <td><span class="fw-bold text-dark">${c.content}</span></td>
                                    <td class="text-primary">${c.user.displayname}</td>

                                    <td class="text-center">
                                        <c:if test="${not empty c.urlContract}">
                                            <a href="${c.urlContract}" target="_blank" class="text-info"><i class="fas fa-file-pdf fa-lg"></i></a>
                                            </c:if>
                                            <c:if test="${empty c.urlContract}">-</c:if>
                                        </td>

                                        <td class="text-center">
                                        <c:if test="${c.isDelete}"><span class="badge bg-success">Active</span></c:if>
                                        <c:if test="${!c.isDelete}"><span class="badge bg-secondary">Inactive</span></c:if>
                                        </td>

                                        <td class="text-center">
                                            <div class="d-flex justify-content-center gap-2">
                                                <a href="contract-detail?id=${c.id}" class="btn btn-sm btn-outline-primary fw-bold">View</a>
                                            <a href="edit-contract?id=${c.id}" class="btn btn-sm btn-outline-warning fw-bold text-dark">Edit</a>

                                            <form action="change-contract-status" method="post" style="display: inline;">
                                                <input type="hidden" name="id" value="${c.id}">
                                                <input type="hidden" name="status" value="${c.isDelete ? '0' : '1'}">
                                                <input type="hidden" name="page" value="${currentPage}">
                                                <input type="hidden" name="search" value="${searchValue}">
                                                <input type="hidden" name="statusFilter" value="${statusValue}">

                                                <c:if test="${c.isDelete}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger fw-bold" onclick="return confirm('Deactivate?')">Deactivate</button>
                                                </c:if>
                                                <c:if test="${!c.isDelete}">
                                                    <button type="submit" class="btn btn-sm btn-outline-success fw-bold" onclick="return confirm('Activate?')">Activate</button>
                                                </c:if>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty contractList}">
                                <tr><td colspan="6" class="text-center py-4 text-muted">No contracts found.</td></tr>
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
                                <a class="page-link" href="contract-list?page=${currentPage - 1}&search=${searchValue}&status=${statusValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">Previous</a>
                            </li>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="contract-list?page=${i}&search=${searchValue}&status=${statusValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">${i}</a>
                                </li>
                            </c:forEach>

                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="contract-list?page=${currentPage + 1}&search=${searchValue}&status=${statusValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">Next</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>
</div>
</body>
<jsp:include page="../../admin/adminFooter.jsp" />