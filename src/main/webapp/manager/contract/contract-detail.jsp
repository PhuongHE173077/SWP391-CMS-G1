<%-- Document : contract-detail Created on : Dec 11, 2025, 11:12:33 PM Author : ADMIN --%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../managerLayout.jsp">
    <jsp:param name="pageTitle" value="Contract Detail" />
</jsp:include>

<body class="bg-light">
    <div class="container mt-4 mb-5">

        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white border-bottom py-3">
                <h5 class="fw-bold text-dark m-0"><i class="fas fa-file-contract me-2"></i>The Contract
                    Detail</h5>
            </div>
            <div class="card-body">
                <div class="row mb-3">
                    <label class="col-sm-2 col-form-label fw-bold text-secondary">Id</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" value="${c.id}" readonly>
                    </div>
                </div>
                <div class="row mb-3">
                    <label class="col-sm-2 col-form-label fw-bold text-secondary">Content</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" value="${c.content}" readonly>
                    </div>
                </div>
                <div class="row mb-3">
                    <label class="col-sm-2 col-form-label fw-bold text-secondary">Customer Name</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" value="${c.user.displayname}" readonly>
                    </div>
                </div>
                <div class="row mb-3">
                    <label class="col-sm-2 col-form-label fw-bold text-secondary">Url Contract</label>
                    <div class="col-sm-10">
                        <div class="input-group">
                            <input type="text" class="form-control" value="${c.urlContract}" readonly>
                            <c:if test="${not empty c.urlContract}">
                                <a href="${c.urlContract}" target="_blank"
                                   class="btn btn-outline-primary"><i
                                        class="fas fa-external-link-alt"></i></a>
                                </c:if>
                        </div>
                    </div>
                </div>
                <div class="row mb-3">
                    <label class="col-sm-2 col-form-label fw-bold text-secondary">Created By</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" value="${c.createBy.displayname}"
                               readonly>
                    </div>
                </div>
                <div class="row mb-3">
                    <label class="col-sm-2 col-form-label fw-bold text-secondary">Status</label>
                    <div class="col-sm-10">
                        <input type="text"
                               class="form-control fw-bold ${c.isDelete ? 'text-danger' : 'text-success'}"
                               value="${c.isDelete ? 'Inactive' : 'Active'}" readonly>
                    </div>
                </div>
            </div>
        </div>


        <div class="card shadow-sm">
            <div class="card-header bg-white border-bottom py-3">
                <h5 class="fw-bold text-dark m-0"><i class="fas fa-list me-2"></i>Contract Item Detail
                </h5>
            </div>
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-white py-3">
                    <h5 class="m-0 font-weight-bold text-secondary"><i class="fas fa-filter me-2"></i>Filter & Sort Items</h5>
                </div>
                <div class="card-body">
                    <form action="contract-detail" method="get">
                        <input type="hidden" name="id" value="${c.id}">

                        <div class="row mb-3 align-items-center bg-light p-2 rounded mx-0">
                            <div class="col-md-7 d-flex align-items-center gap-3">
                                <span class="fw-bold text-dark">Sort by:</span>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="sortBy" value="deviceId" ${sortBy == 'deviceId' ? 'checked' : ''}>
                                    <label class="form-check-label">Device ID</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="sortBy" value="deviceName" ${sortBy == 'deviceName' ? 'checked' : ''}>
                                    <label class="form-check-label">Device Name</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="sortBy" value="serial" ${sortBy == 'serial' ? 'checked' : ''}>
                                    <label class="form-check-label">Serial Number</label>
                                </div>
                            </div>

                            <div class="col-md-5 d-flex align-items-center gap-3">
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
                                    <input type="date" class="form-control" id="startDate" name="startDate" value="${startDate}">
                                    <label for="startDate">Start Date</label>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="form-floating">
                                    <input type="date" class="form-control" id="endDate" name="endDate" value="${endDate}">
                                    <label for="endDate">End Date</label>
                                </div>
                            </div>
                            <div class="col-md-5">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="searchItem" name="searchItem" placeholder="Search" value="${searchItem}">
                                    <label for="searchItem">Search by Name, Serial Number...</label>
                                </div>
                            </div>
                            <div class="col-md-3 d-flex gap-2 align-items-center">
                                <button type="submit" class="btn btn-primary w-100 fw-bold" style="height: 58px;">Search</button>
                                <a href="contract-detail?id=${c.id}" class="btn btn-outline-secondary w-100 d-flex align-items-center justify-content-center" style="height: 58px;">Reset</a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card shadow-sm">
                <div class="card-header bg-white border-bottom py-3">
                    <h5 class="fw-bold text-dark m-0"><i class="fas fa-list me-2"></i>Item List</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th class="py-3 ps-3 text-center">Id</th>
                                    <th class="py-3 ps-3 text-center">Name of Electric Generator</th>
                                    <th class="py-3 ps-3 text-center">Serial Number</th>
                                    <th class="py-3 ps-3 text-center">Start Date</th>
                                    <th class="py-3 ps-3 text-center">End Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${itemList}" var="item">
                                    <tr>
                                        <td class="text-center fw-bold text-secondary">${item.subDevice.device.id}</td>
                                        <td class="text-center fw-bold text-primary">${item.subDevice.device.name}</td>
                                        <td class="text-center">
                                            <span class="badge bg-light text-dark border font-monospace">${item.subDevice.seriId}</span>
                                        </td>
                                        <td class="text-center">
                                            <fmt:formatDate value="${item.startAt}" pattern="dd-MM-yyyy" />
                                        </td>
                                        <td class="text-center">
                                            <fmt:formatDate value="${item.endDate}" pattern="dd-MM-yyyy" />
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty itemList}">
                                    <tr>
                                        <td colspan="5" class="text-center text-muted py-5">
                                            <i class="fas fa-box-open fa-3x mb-3"></i><br>
                                            No items found matching your criteria.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="card-footer bg-white d-flex justify-content-center py-3">
                    <c:if test="${totalPages > 0}">
                        <nav>
                            <ul class="pagination m-0">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="contract-detail?id=${c.id}&page=${currentPage - 1}&searchItem=${searchItem}&startDate=${startDate}&endDate=${endDate}&sortBy=${sortBy}&sortOrder=${sortOrder}">
                                        Previous
                                    </a>
                                </li>

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="contract-detail?id=${c.id}&page=${i}&searchItem=${searchItem}&startDate=${startDate}&endDate=${endDate}&sortBy=${sortBy}&sortOrder=${sortOrder}">
                                            ${i}
                                        </a>
                                    </li>
                                </c:forEach>

                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="contract-detail?id=${c.id}&page=${currentPage + 1}&searchItem=${searchItem}&startDate=${startDate}&endDate=${endDate}&sortBy=${sortBy}&sortOrder=${sortOrder}">
                                        Next
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>

            <div class="mt-4 mb-5">
                <a href="contract-list" class="text-decoration-none fw-bold text-secondary py-2 px-3 border rounded hover-bg-gray bg-white">
                    <i class="fas fa-arrow-left me-1"></i> Back to Contract List
                </a>
            </div>

            <div class="mt-3 d-flex justify-content-between align-items-center">
                <a href="contract-list" class="text-decoration-none fw-bold"><i
                        class="fas fa-arrow-left me-1"></i>Back to List</a>
                <a href="update-contract?id=${c.id}" class="btn btn-primary"><i
                        class="fas fa-edit me-1"></i>Cập nhật hợp đồng</a>
            </div>
        </div>
</body>
<jsp:include page="../managerFooter.jsp" />