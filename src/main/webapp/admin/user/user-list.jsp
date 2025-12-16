<%-- 
    Document   : user-list
    Created on : Dec 3, 2025, 7:14:52 PM
    Author     : ADMIN
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<jsp:include page="../adminLayout.jsp">
    <jsp:param name="pageTitle" value="User Management" />
</jsp:include>

<body class="bg-light">
    <div class="container-fluid px-4 mt-4">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary fw-bold"><i class="fas fa-users-cog me-2"></i>User Management</h2>
            <a href="AddUser" class="btn btn-primary shadow-sm fw-bold">
                <i class="fas fa-plus me-2"></i>Add New User
            </a>
        </div>

        <c:if test="${not empty msg}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="fas fa-check-circle me-2"></i>${msg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
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
                <form action="user-list" method="get">

                    <div class="row mb-3 align-items-center bg-light p-2 rounded mx-0">
                        <div class="col-md-6 d-flex align-items-center gap-3">
                            <span class="fw-bold text-dark">Sort by:</span>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortBy" value="id" ${sortBy == 'id' ? 'checked' : ''}>
                                <label class="form-check-label">ID</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortBy" value="createdAt" ${sortBy == 'createdAt' ? 'checked' : ''}>
                                <label class="form-check-label">Created At</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortBy" value="fullname" ${sortBy == 'fullname' ? 'checked' : ''}>
                                <label class="form-check-label">Full Name</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortBy" value="email" ${sortBy == 'email' ? 'checked' : ''}>
                                <label class="form-check-label">Email</label>
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
                        <div class="col-md-2">
                            <select name="gender" class="form-select">
                                <option value="">All Genders</option>
                                <c:forEach items="${genderList}" var="g"> 
                                    <option value="${g}" ${genderValue == g ? 'selected' : ''}>${g == 1 ? 'Male' : 'Female'}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <select name="role" class="form-select">
                                <option value="">All Roles</option>
                                <c:forEach items="${roleList}" var="r"> 
                                    <option value="${r.id}" ${roleValue == r.id ? 'selected' : ''}>${r.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <select name="status" class="form-select">
                                <option value="">All Status</option>
                                <c:forEach items="${statusList}" var="s">
                                    <option value="${s}" ${String.valueOf(s) == statusValue ? 'selected' : ''}>
                                        ${s == 1 ? 'Active' : 'Inactive'}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="fas fa-search"></i></span>
                                <input type="text" name="search" class="form-control" placeholder="Search by name..." value="${searchValue}">
                            </div>
                        </div>
                        <div class="col-md-2 d-flex gap-2">
                            <button type="submit" class="btn btn-primary w-100 fw-bold">Search</button>
                            <a href="user-list" class="btn btn-outline-secondary w-100" title="Reset Filter">
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
                                <th class="py-3">Full Name</th>
                                <th class="py-3 text-center">Created At</th>
                                <th class="py-3">Email</th>
                                <th class="py-3 text-center">Gender</th>
                                <th class="py-3 text-center">Role</th>
                                <th class="py-3 text-center">Status</th>
                                <th class="py-3 text-center" style="width: 250px;">Action</th> </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${userList}" var="u">
                                <tr>
                                    <td class="ps-3 fw-bold text-secondary">${u.id}</td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <span class="fw-bold text-dark">${u.displayname}</span>
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <fmt:formatDate value="${u.createdAtDate}" pattern="dd-MMM-yyyy"/>
                                    </td>

                                    <td class="text-muted">${u.email}</td>
                                    <td class="text-center">
                                        <c:if test="${u.gender}"><span class="badge bg-light text-primary border">Male</span></c:if>
                                        <c:if test="${!u.gender}"><span class="badge bg-light text-danger border">Female</span></c:if>
                                        </td>
                                        <td class="text-center"><span class="badge bg-info text-dark border">${u.roles.name}</span></td>
                                    <td class="text-center">
                                        <c:if test="${u.active}">
                                            <span class="badge bg-success">Active</span>
                                        </c:if>
                                        <c:if test="${!u.active}">
                                            <span class="badge bg-secondary">Inactive</span>
                                        </c:if>
                                    </td>

                                    <td class="text-center">
                                        <div class="d-flex justify-content-center gap-2">

                                            <a href="user-detail?id=${u.id}" class="btn btn-sm btn-outline-primary fw-bold" style="min-width: 60px;">
                                                View
                                            </a>

                                            <a href="edit?id=${u.id}" class="btn btn-sm btn-outline-warning fw-bold text-dark" style="min-width: 60px;">
                                                Edit
                                            </a>

                                            <form action="change-user-status" method="post" style="display: inline;">
                                                <input type="hidden" name="id" value="${u.id}">
                                                <input type="hidden" name="page" value="${currentPage}">
                                                <input type="hidden" name="search" value="${searchValue}">
                                                <input type="hidden" name="role" value="${roleValue}">
                                                <input type="hidden" name="gender" value="${genderValue}">
                                                <input type="hidden" name="status" value="${u.active ? '0' : '1'}"> 
                                                <input type="hidden" name="lastStatus" value="${statusValue}">

                                                <c:if test="${u.active}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger fw-bold" 
                                                            style="min-width: 80px;"
                                                            onclick="return confirm('Are you sure you want to Deactivate this user?')">
                                                        Deactivate
                                                    </button>
                                                </c:if>

                                                <c:if test="${!u.active}">
                                                    <button type="submit" class="btn btn-sm btn-outline-success fw-bold" 
                                                            style="min-width: 80px;"
                                                            onclick="return confirm('Are you sure you want to Activate this user?')">
                                                        Activate
                                                    </button>
                                                </c:if>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty userList}">
                                <tr>
                                    <td colspan="7" class="text-center py-5 text-muted">
                                        <h5>No users found</h5>
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
                                <a class="page-link" href="user-list?page=${currentPage - 1}&search=${searchValue}&role=${roleValue}&status=${statusValue}&gender=${genderValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">Previous</a>
                            </li>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="user-list?page=${i}&search=${searchValue}&role=${roleValue}&status=${statusValue}&gender=${genderValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">${i}</a>
                                </li>
                            </c:forEach>

                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="user-list?page=${currentPage + 1}&search=${searchValue}&role=${roleValue}&status=${statusValue}&gender=${genderValue}&sortBy=${sortBy}&sortOrder=${sortOrder}">Next</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

<jsp:include page="../adminFooter.jsp" />