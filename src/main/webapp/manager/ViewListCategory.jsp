<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <jsp:include page="managerLayout.jsp">
            <jsp:param name="pageTitle" value="Device Category List" />
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

            .btn-success,
            .btn-success:hover,
            .btn-success:focus {
                background-color: #10b981;
                border-color: #10b981;
            }

            .btn-success:hover {
                background-color: #059669;
                border-color: #059669;
            }

            .btn-outline-success {
                color: #10b981;
                border-color: #10b981;
            }

            .btn-outline-success:hover {
                background-color: #10b981;
                border-color: #10b981;
                color: white;
            }

            .alert-success {
                background-color: #d1fae5;
                border-color: #10b981;
                color: #065f46;
            }

            .pagination .page-link {
                color: #10b981;
                border-color: #10b981;
            }

            .pagination .page-item.active .page-link {
                background-color: #10b981;
                border-color: #10b981;
                color: white;
            }

            .pagination .page-link:hover {
                background-color: #10b981;
                border-color: #10b981;
                color: white;
            }
        </style>

        <script>
            function confirmDelete(id) {
                if (confirm("Bạn có chắc chắn muốn xóa danh mục này?")) {
                    window.location.href = "DeleteCategory?id=" + id;
                }
            }
        </script>

        <body class="bg-light">
            <div class="container-fluid px-4 ">

                <c:if test="${not empty sessionScope.success}">
                    <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${sessionScope.success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="success" scope="session" />
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
                        <h5 class="m-0 font-weight-bold text-secondary"><i class="fas fa-filter me-2"></i>Tìm kiếm</h5>
                    </div>
                    <div class="card-body">
                        <form action="ViewListCategory" method="get">
                            <div class="row g-3">
                                <div class="col-md-8">
                                    <div class="input-group">
                                        <span class="input-group-text bg-white"><i class="fas fa-search"></i></span>
                                        <input type="text" name="search" class="form-control"
                                            placeholder="Tìm theo tên danh mục..." value="${search}">
                                    </div>
                                </div>
                                <div class="col-md-4 d-flex gap-2">
                                    <button type="submit" class="btn btn-success w-100 fw-bold">Search</button>
                                    <a href="ViewListCategory" class="btn btn-outline-secondary w-100"
                                        title="Reset Filter">
                                        Reset
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="card shadow-sm mb-3">
                    <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                        <h5 class="m-0 font-weight-bold text-secondary"><i class="fas fa-list me-2"></i>Danh sách danh
                            mục sản phẩm</h5>
                        <a href="AddCategory" class="btn btn-success fw-bold">
                            <i class="fas fa-plus me-1"></i>Thêm danh mục mới
                        </a>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover table-bordered align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th class="py-3 ps-3">ID</th>
                                        <th class="py-3">Tên danh mục</th>
                                        <th class="py-3 text-center" style="width: 150px;">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${listCategory}" var="c">
                                        <tr>
                                            <td class="ps-3 fw-bold text-secondary">#${c.id}</td>
                                            <td class="text-muted">${c.name}</td>
                                            <td class="text-center">
                                                <a href="UpdateCategory?id=${c.id}"
                                                    class="btn btn-sm btn-outline-success fw-bold me-1">
                                                    <i class="fas fa-edit me-1"></i>Sửa
                                                </a>
                                                <a href="DeleteCategory?id=${c.id}"
                                                    class="btn btn-sm btn-outline-danger fw-bold"
                                                    onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục này?')">
                                                    <i class="fas fa-trash me-1"></i>Xóa
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                    <c:if test="${empty listCategory}">
                                        <tr>
                                            <td colspan="3" class="text-center py-5 text-muted">
                                                <h5>Không tìm thấy danh mục nào</h5>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="card-footer bg-white d-flex justify-content-center py-3">
                        <c:if test="${totalPage > 0}">
                            <nav aria-label="Page navigation">
                                <ul class="pagination m-0">
                                    <c:forEach begin="1" end="${totalPage}" var="p">
                                        <li class="page-item ${p == page ? 'active' : ''}">
                                            <a class="page-link"
                                                href="ViewListCategory?page=${p}&search=${search}">${p}</a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </nav>
                        </c:if>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        <jsp:include page="managerFooter.jsp" />