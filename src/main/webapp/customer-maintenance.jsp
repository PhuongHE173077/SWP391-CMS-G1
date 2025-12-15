<%-- 
    Document   : user-maintenance
    Created on : Dec 15, 2025, 10:46:43 AM
    Author     : ADMIN
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- <jsp:include page="../../customerLayout.jsp"> --%>
<%-- <jsp:param name="pageTitle" value="My Maintenance Requests" /> --%>
<%-- </jsp:include> --%>

<head>
    <title>My Maintenance Requests</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <div class="container">
            <a class="navbar-brand" href="#">Customer Portal</a>
        </div>
    </nav>

    <div class="container px-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary fw-bold"><i class="fas fa-history me-2"></i>My Maintenance History</h2>
            <a href="create-request" class="btn btn-success shadow-sm fw-bold">
                <i class="fas fa-plus-circle me-2"></i>New Request
            </a>
        </div>
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white py-3">
                <h5 class="m-0 font-weight-bold text-secondary"><i class="fas fa-search me-2"></i>Search & Filter</h5>
            </div>
            <div class="card-body">
                <form action="customer-maintenance" method="get">
                    <div class="row mb-3 align-items-center bg-light p-2 rounded mx-0">
                        <div class="col-md-8 d-flex align-items-center gap-3 flex-wrap">
                            <span class="fw-bold text-dark">Sort by:</span>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortBy" value="created_at" ${sortBy == 'created_at' ? 'checked' : ''}>
                                <label class="form-check-label">Date Sent</label>
                            </div>                
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortBy" value="status" ${sortBy == 'status' ? 'checked' : ''}>
                                <label class="form-check-label">Status</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="sortBy" value="content" ${sortBy == 'content' ? 'checked' : ''}>
                                <label class="form-check-label">Content</label>
                            </div>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="sortBy" value="content" ${sortBy == 'content' ? 'checked' : ''}>
                            <label class="form-check-label">Content</label>
                        </div>
                    </div>

                    <div class="col-md-4 d-flex align-items-center gap-3 justify-content-end">
                        <span class="fw-bold text-dark">Order:</span>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="sortOrder" value="DESC" ${sortOrder == 'DESC' ? 'checked' : ''}>
                            <label class="form-check-label">Descending</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="sortOrder" value="ASC" ${sortOrder == 'ASC' ? 'checked' : ''}>
                            <label class="form-check-label">Ascending</label>
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
                <div class="col-md-3">
                    <div class="input-group">
                        <input type="text" name="search" class="form-control" placeholder="Search device name, serial number..." value="${searchValue}">
                        <button type="submit" class="btn btn-primary fw-bold">Search</button>
                    </div>
                </div>
                <div class="row mt-2">
                    <div class="col-12 text-end">
                        <a href="customer-maintenance" class="text-secondary text-decoration-none"><i class="fas fa-sync-alt me-1"></i>Reset Filter</a>
                    </div>
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
                                <th class="py-3" style="width: 30%;">Issue Content</th>
                                <th class="py-3 text-center">Date Sent</th>
                                <th class="py-3 text-center">Status</th>
                                <th class="py-3 text-center" style="width: 100px;">Action</th>
                            </tr>
                        </thead>