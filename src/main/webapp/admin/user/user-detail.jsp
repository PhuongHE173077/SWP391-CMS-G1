<%-- 
    Document   : user-detail
    Created on : Dec 3, 2025, 9:01:17 PM
    Author     : ADMIN
--%>
 <%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<jsp:include page="../adminLayout.jsp">
    <jsp:param name="pageTitle" value="User Details" />
</jsp:include>

<body class="bg-light">
    <div class="container mt-5 mb-5">
        <div class="card shadow-sm" style="max-width: 1000px; margin: 0 auto;">
            
            <div class="card-header bg-white py-3 border-bottom">
                <h4 class="m-0 text-center text-uppercase fw-bold text-secondary">User Detail</h4>
            </div>
            
            <div class="card-body p-4">
                
                <div class="row mb-4">
                    <div class="col-md-6">
                        <label class="fw-bold text-secondary small text-uppercase mb-1">ID</label>
                        <div class="p-2 border rounded bg-light text-dark fw-bold">
                            ${user.id}
                        </div>
                    </div>
                    <div class="col-md-6 mt-3 mt-md-0">
                        <label class="fw-bold text-secondary small text-uppercase mb-1">Full Name</label>
                        <div class="p-2 border rounded bg-light text-dark fw-bold">
                            ${user.displayname}
                        </div>
                    </div>
                </div>

                <div class="row mb-4">
                    <div class="col-md-6">
                        <label class="fw-bold text-secondary small text-uppercase mb-1">Email</label>
                        <div class="p-2 border rounded bg-white text-dark">
                            ${user.email}
                        </div>
                    </div>
                    <div class="col-md-6 mt-3 mt-md-0">
                        <label class="fw-bold text-secondary small text-uppercase mb-1">Phone Number</label>
                        <div class="p-2 border rounded bg-white text-dark">
                            ${user.phone}
                        </div>
                    </div>
                </div>

                <div class="row mb-4">
                    <div class="col-md-6">
                        <label class="fw-bold text-secondary small text-uppercase mb-1">Password (Hashed)</label>
                        <div class="p-2 border rounded bg-white text-muted text-break">
                            <%-- Lưu ý: Không thể giải mã BCrypt ngược lại thành text --%>
                            ${user.password}
                        </div>
                    </div>
                    <div class="col-md-6 mt-3 mt-md-0">
                        <label class="fw-bold text-secondary small text-uppercase mb-1">Created At</label>
                        <div class="p-2 border rounded bg-white text-dark">
                            <fmt:formatDate value="${user.createdAtDate}" pattern="dd-MMM-yyyy"/>
                        </div>
                    </div>
                </div>

                <div class="row mb-4">
                    <div class="col-md-12">
                        <label class="fw-bold text-secondary small text-uppercase mb-1">Address</label>
                        <div class="p-2 border rounded bg-white text-dark">
                            ${user.address != null ? user.address : '-'}
                        </div>
                    </div>
                </div>

                <div class="row mb-4">
                    <div class="col-md-4">
                        <label class="fw-bold text-secondary small text-uppercase mb-1">Role</label>
                        <div class="p-2 border rounded bg-light text-primary fw-bold">
                            ${user.roles.name}
                        </div>
                    </div>
                    <div class="col-md-4 mt-3 mt-md-0">
                        <label class="fw-bold text-secondary small text-uppercase mb-1">Gender</label>
                        <div class="p-2 border rounded bg-white text-dark">
                            ${user.gender ? "Male" : "Female"}
                        </div>
                    </div>
                    <div class="col-md-4 mt-3 mt-md-0">
                        <label class="fw-bold text-secondary small text-uppercase mb-1">Status</label>
                        <div class="p-2 border rounded bg-white fw-bold" 
                             style="color: ${user.active ? '#198754' : '#dc3545'};"> ${user.active ? "Active" : "Inactive"}
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-center gap-3 mt-4 pt-3 border-top">
                    <a href="user-list" class="text-decoration-none fw-bold text-secondary py-2 px-3 border rounded hover-bg-gray">
                        <i class="fas fa-arrow-left me-1"></i> Back to List
                    </a>
                    
                    <a href="edit?id=${user.id}" class="btn btn-warning fw-bold text-dark">
                        <i class="fas fa-edit me-1"></i> Edit User
                    </a>
                </div>

            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

<jsp:include page="../adminFooter.jsp" />