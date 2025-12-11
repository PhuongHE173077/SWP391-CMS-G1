<%-- 
    Document   : contract-detail
    Created on : Dec 11, 2025, 11:12:33 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <jsp:include page="../../admin/adminLayout.jsp">
    <jsp:param name="pageTitle" value="Contract Detail" />
</jsp:include>

<body class="bg-light">
    <div class="container mt-4 mb-5">
        
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-white border-bottom py-3">
                <h5 class="fw-bold text-dark m-0"><i class="fas fa-file-contract me-2"></i>The Contract Detail</h5>
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
                                <a href="${c.urlContract}" target="_blank" class="btn btn-outline-primary"><i class="fas fa-external-link-alt"></i></a>
                            </c:if>
                        </div>
                    </div>
                </div>
                <div class="row mb-3">
                    <label class="col-sm-2 col-form-label fw-bold text-secondary">Created By</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" value="${c.createBy.displayname}" readonly>
                    </div>
                </div>
                <div class="row mb-3">
                    <label class="col-sm-2 col-form-label fw-bold text-secondary">Status</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control fw-bold ${c.isDelete ? 'text-success' : 'text-danger'}" 
                               value="${c.isDelete ? 'Active' : 'Inactive'}" readonly>
                    </div>
                </div>
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-header bg-white border-bottom py-3">
                <h5 class="fw-bold text-dark m-0"><i class="fas fa-list me-2"></i>Contract Item Detail</h5>
            </div>
            <div class="card-body">
                
                <form action="contract-detail" method="get">
                    <input type="hidden" name="id" value="${c.id}"> <div class="row g-2 mb-3">
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
                        <div class="col-md-4">
                            <div class="form-floating">
                                <input type="text" class="form-control" id="searchItem" name="searchItem" placeholder="Search" value="${searchItem}">
                                <label for="searchItem">Search by Name, Serial Number</label>
                            </div>
                        </div>
                        <div class="col-md-4 d-flex gap-2 align-items-center">
                            <button type="submit" class="btn btn-secondary px-4 py-2">Search</button>
                            <a href="contract-detail?id=${c.id}" class="btn btn-outline-secondary px-4 py-2">Reset Filter</a>
                        </div>
                    </div>
                </form>

                <div class="table-responsive">
                    <table class="table table-bordered table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Id of Electric Generator</th>
                                <th>Name of Electric Generator</th>
                                <th>Serial Number</th>
                                <th>Start Date</th>
                                <th>End Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${itemList}" var="item">
                                <tr>
                                    <td>${item.subDevice.device.id}</td> <td class="fw-bold text-primary">${item.subDevice.device.name}</td>
                                    <td><span class="badge bg-light text-dark border">${item.subDevice.seriId}</span></td>
                                    <td><fmt:formatDate value="${item.startAt}" pattern="dd-MM-yyyy"/></td>
                                    <td><fmt:formatDate value="${item.endDate}" pattern="dd-MM-yyyy"/></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty itemList}">
                                <tr>
                                    <td colspan="5" class="text-center text-muted py-4">No items found in this contract.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <c:if test="${totalPages > 0}">
                    <nav class="mt-3 d-flex justify-content-center">
                        <ul class="pagination">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="contract-detail?id=${c.id}&page=${currentPage - 1}&searchItem=${searchItem}&startDate=${startDate}&endDate=${endDate}">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </li>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="contract-detail?id=${c.id}&page=${i}&searchItem=${searchItem}&startDate=${startDate}&endDate=${endDate}">${i}</a>
                                </li>
                            </c:forEach>

                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="contract-detail?id=${c.id}&page=${currentPage + 1}&searchItem=${searchItem}&startDate=${startDate}&endDate=${endDate}">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
                
                <div class="mt-3">
                    <a href="contract-list" class="text-decoration-none fw-bold"> Back to List</a>
                </div>

            </div>
        </div>
    </div>
</body>
<jsp:include page="../../admin/adminFooter.jsp" />