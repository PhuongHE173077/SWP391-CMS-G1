<%-- 
    Document   : manager-maintenance
    Created on : Dec 15, 2025, 10:46:12 AM
    Author     : ADMIN
--%>
 <%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../managerLayout.jsp">
    <jsp:param name="pageTitle" value="View List Maintenance Request" />
</jsp:include>

<body class="bg-light">
    <div class="container-fluid px-4 mt-4">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary fw-bold"><i class="fas fa-file-contract me-2"></i>Maintenance Request Management</h2>
            <a href="AddContract" class="btn btn-primary shadow-sm fw-bold">
                <i class="fas fa-plus me-2"></i>Create New Contract
            </a>
        </div>

        <c:if test="${not empty msg}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="fas fa-check-circle me-2"></i>${msg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" " aria-label="Close"></button>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>


        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white py-3"> 
                <h5 class="m-0 font-weight-bold text-secondary"><i class="fas fa-filter me-2"></i>Filter & Sort</h5>
            </div>     
            <div class="card-body">
                <form action="contract-list" method="get">
                    <div class="row mb-3 align-items-center bg-light p-2 rounded mx-0">           
                        <div class="col-md-6 d-flex align-items-center gap-3">                            
                            <span class="fw-bold text-dark">Sort:</span>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortBy" value="id" ${sortBy == 'id' ? 'checked' : ''}>
                                <label class="form-check-label">ID</label> 
                            </div>

                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortBy" value="customer" ${sortBy == 'customer' ? 'checked' : ''}>
                                <label class="form-check-label">Customer</label> 
                            </div>
                        </div>

                        <div class="col-md-6 d-flex align-items-center gap-3">                   
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
                            <select name="createBy" class="form-select">
                                <option value="">All Creator</option>
                                <c:forEach items="${lstManagerSaleStaff}" var="lst"> 
                                    <option value="${lst.id}" ${creatorValue == lst.id ? 'selected' : ''}>(${lst.roles.name})-${lst.displayname}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="fas fa-search"></i></span>
                                <input type="text" name="search" class="form-control" placeholder="Search by customer name..." value="${searchValue}">
                            </div>
                        </div>
                        <div class="col-md-3 d-flex gap-2">
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
                                <th class="text-center">ID</th>
                                <th class="py-3 text-center" style="width: 150px">Customer Name</th>
                                <th class="py-3 text-center" style="width: 150px">URL Contract</th>
                                <th class="py-3 text-center" style="width: 100px">Create By</th>
                                <th class="py-3 text-center" style="width: 100px">Status</th>
                                <!--chỉ lấy những contract có status là active-->
                                <th class="py-3 text-center" style="width: 250px;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${contractList}" var="c">
                                <tr>
                                    <td class="fw-bold text-secondary text-center" style="width: 60px;">${c.id}</td>
                                    <td class="text-primary text-center">${c.user.displayname}</td>

                                    <td class="text-center">
                                        <c:if test="${not empty c.urlContract}">
                                            <a href="${c.urlContract}" target="_blank" class="text-info"><i class="fas fa-file-pdf fa-lg"></i></a>
                                            </c:if>
                                            <c:if test="${empty c.urlContract}">-</c:if>
                                        </td>
                                        <td class="text-center">
                                        ${c.createBy.displayname}
                                    </td>

                                    <td class="text-center">
                                        <c:if test="${!c.isDelete}"><span class="badge bg-success">Active</span></c:if>
                                        <c:if test="${c.isDelete}"><span class="badge bg-secondary">Inactive</span></c:if>
                                        </td>

                                        <td class="text-center">
                                            <div class="d-flex justify-content-center gap-2">
                                                <a href="contract-detail?id=${c.id}" class="btn btn-sm btn-outline-primary fw-bold">View</a>
                                            <a href="update-contract?id=${c.id}" class="btn btn-sm btn-outline-warning fw-bold text-dark">Edit</a>

                                            <form action="deactivate-contract" method="post" style="display: inline;">
                                                <input type="hidden" name="id" value="${c.id}">
                                                <input type="hidden" name="page" value="${currentPage}">
                                                <input type="hidden" name="search" value="${searchValue}">
                                                <input type="hidden" name="sortBy" value="${sortBy}">     
                                                <input type="hidden" name="sortOrder" value="${sortOrder}"> 
                                                <input type="hidden" name="createBy" value="${creatorValue}"> 
                                                <c:if test="${!c.isDelete}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger fw-bold" onclick="return confirm('Are you sure to Deactivate this contract?')">Deactivate</button>
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
                                <a class="page-link" href="contract-list?page=${currentPage - 1}&search=${searchValue}&createBy=${creatorValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">Previous</a>
                            </li>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="contract-list?page=${i}&search=${searchValue}&createBy=${creatorValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">${i}</a>
                                </li>
                            </c:forEach>

                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="contract-list?page=${currentPage + 1}&search=${searchValue}&createBy=${creatorValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">Next</a>
                            </li>
                        </ul>
                    </nav>

                </c:if>
            </div>
        </div>
    </div>
</div>
</body>
<jsp:include page="../managerFooter.jsp" />