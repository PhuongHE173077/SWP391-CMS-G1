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
                        <div class="card-header bg-white d-flex justify-content-between align-items-center py-3">
                            <h5 class="m-0 font-weight-bold text-secondary">
                                <i class="fas fa-list me-2"></i>Deleted Contracts List
                            </h5>
                            <div>
                                <button type="button" id="restoreSelectedBtn" class="btn btn-success btn-sm fw-bold"
                                    disabled>
                                    <i class="fas fa-undo me-1"></i>Restore Selected (<span id="selectedCount">0</span>)
                                </button>
                            </div>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover table-bordered align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="py-3 ps-3" style="width: 50px;">
                                                <input type="checkbox" id="selectAll" class="form-check-input">
                                            </th>
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
                                                <td class="ps-3 text-center">
                                                    <input type="checkbox" class="form-check-input contract-checkbox"
                                                        value="${c.id}" name="contractIds">
                                                </td>
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
                                                     <div class="d-flex gap-2 justify-content-center">
                                                         <button type="button" class="btn btn-sm btn-outline-success fw-bold"
                                                             data-bs-toggle="modal" data-bs-target="#restoreModal${c.id}">
                                                             <i class="fas fa-undo me-1"></i>Restore
                                                         </button>
                                                         
                                                         <button type="button" class="btn btn-sm btn-outline-danger fw-bold"
                                                             data-bs-toggle="modal" data-bs-target="#deleteModal${c.id}">
                                                             <i class="fas fa-trash-alt me-1"></i>Delete
                                                         </button>
                                                     </div>

                                                     <!-- Restore Confirmation Modal -->
                                                     <div class="modal fade" id="restoreModal${c.id}" tabindex="-1"
                                                         aria-labelledby="restoreModalLabel${c.id}" aria-hidden="true">
                                                         <div class="modal-dialog modal-dialog-centered">
                                                             <div class="modal-content">
                                                                 <div class="modal-header bg-success text-white">
                                                                     <h5 class="modal-title"
                                                                         id="restoreModalLabel${c.id}">
                                                                         <i class="fas fa-undo me-2"></i>Xác nhận khôi
                                                                         phục
                                                                     </h5>
                                                                     <button type="button"
                                                                         class="btn-close btn-close-white"
                                                                         data-bs-dismiss="modal"
                                                                         aria-label="Close"></button>
                                                                 </div>
                                                                 <div class="modal-body">
                                                                     <p class="mb-0">Bạn có chắc chắn muốn khôi phục hợp
                                                                         đồng <strong>#${c.id}</strong> không?</p>
                                                                 </div>
                                                                 <div class="modal-footer">
                                                                     <button type="button" class="btn btn-secondary"
                                                                         data-bs-dismiss="modal">
                                                                         <i class="fas fa-times me-1"></i>Hủy
                                                                     </button>
                                                                     <form
                                                                         action="${pageContext.request.contextPath}/list-contract-delete"
                                                                         method="post" style="display: inline;">
                                                                         <input type="hidden" name="action"
                                                                             value="restore">
                                                                         <input type="hidden" name="id" value="${c.id}">
                                                                         <c:if test="${not empty searchValue}">
                                                                             <input type="hidden" name="search"
                                                                                 value="${searchValue}">
                                                                         </c:if>
                                                                         <c:if test="${not empty currentPage}">
                                                                             <input type="hidden" name="page"
                                                                                 value="${currentPage}">
                                                                         </c:if>
                                                                         <c:if test="${not empty sortBy}">
                                                                             <input type="hidden" name="sortBy"
                                                                                 value="${sortBy}">
                                                                         </c:if>
                                                                         <c:if test="${not empty sortOrder}">
                                                                             <input type="hidden" name="sortOrder"
                                                                                 value="${sortOrder}">
                                                                         </c:if>
                                                                         <button type="submit" class="btn btn-success">
                                                                             <i class="fas fa-check me-1"></i>Khôi phục
                                                                         </button>
                                                                     </form>
                                                                 </div>
                                                             </div>
                                                         </div>
                                                     </div>

                                                     <!-- Delete Confirmation Modal -->
                                                     <div class="modal fade" id="deleteModal${c.id}" tabindex="-1"
                                                         aria-labelledby="deleteModalLabel${c.id}" aria-hidden="true">
                                                         <div class="modal-dialog modal-dialog-centered">
                                                             <div class="modal-content">
                                                                 <div class="modal-header bg-danger text-white">
                                                                     <h5 class="modal-title"
                                                                         id="deleteModalLabel${c.id}">
                                                                         <i class="fas fa-exclamation-triangle me-2"></i>Xác nhận xóa cứng
                                                                     </h5>
                                                                     <button type="button"
                                                                         class="btn-close btn-close-white"
                                                                         data-bs-dismiss="modal"
                                                                         aria-label="Close"></button>
                                                                 </div>
                                                                 <div class="modal-body">
                                                                     <div class="alert alert-warning mb-3">
                                                                         <i class="fas fa-exclamation-triangle me-2"></i>
                                                                         <strong>Cảnh báo:</strong> Hành động này không thể hoàn tác!
                                                                     </div>
                                                                     <p class="mb-2">Bạn có chắc chắn muốn <strong>XÓA CỨNG</strong> hợp đồng <strong>#${c.id}</strong> không?</p>
                                                                     <p class="mb-0 text-muted">
                                                                         <i class="fas fa-info-circle me-1"></i>
                                                                         Các Sub Device liên quan sẽ được khôi phục.
                                                                     </p>
                                                                 </div>
                                                                 <div class="modal-footer">
                                                                     <button type="button" class="btn btn-secondary"
                                                                         data-bs-dismiss="modal">
                                                                         <i class="fas fa-times me-1"></i>Hủy
                                                                     </button>
                                                                     <form
                                                                         action="${pageContext.request.contextPath}/list-contract-delete"
                                                                         method="post" style="display: inline;">
                                                                         <input type="hidden" name="action"
                                                                             value="hardDelete">
                                                                         <input type="hidden" name="id" value="${c.id}">
                                                                         <c:if test="${not empty searchValue}">
                                                                             <input type="hidden" name="search"
                                                                                 value="${searchValue}">
                                                                         </c:if>
                                                                         <c:if test="${not empty currentPage}">
                                                                             <input type="hidden" name="page"
                                                                                 value="${currentPage}">
                                                                         </c:if>
                                                                         <c:if test="${not empty sortBy}">
                                                                             <input type="hidden" name="sortBy"
                                                                                 value="${sortBy}">
                                                                         </c:if>
                                                                         <c:if test="${not empty sortOrder}">
                                                                             <input type="hidden" name="sortOrder"
                                                                                 value="${sortOrder}">
                                                                         </c:if>
                                                                         <button type="submit" class="btn btn-danger">
                                                                             <i class="fas fa-trash-alt me-1"></i>Xóa cứng
                                                                         </button>
                                                                     </form>
                                                                 </div>
                                                             </div>
                                                         </div>
                                                     </div>
                                                 </td>
                                            </tr>
                                        </c:forEach>

                                        <c:if test="${empty contractList}">
                                            <tr>
                                                <td colspan="8" class="text-center py-5 text-muted">
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

                <!-- Restore Multiple Confirmation Modal -->
                <div class="modal fade" id="restoreMultipleModal" tabindex="-1"
                    aria-labelledby="restoreMultipleModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header bg-success text-white">
                                <h5 class="modal-title" id="restoreMultipleModalLabel">
                                    <i class="fas fa-undo me-2"></i>Xác nhận khôi phục nhiều hợp đồng
                                </h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <p class="mb-0">Bạn có chắc chắn muốn khôi phục <strong id="restoreCount">0</strong> hợp
                                    đồng đã chọn không?</p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                    <i class="fas fa-times me-1"></i>Hủy
                                </button>
                                <form id="restoreMultipleForm"
                                    action="${pageContext.request.contextPath}/list-contract-delete" method="post"
                                    style="display: inline;">
                                    <input type="hidden" name="action" value="restoreMultiple">
                                    <button type="submit" class="btn btn-success">
                                        <i class="fas fa-check me-1"></i>Khôi phục
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    // Select All functionality
                    document.getElementById('selectAll').addEventListener('change', function () {
                        const checkboxes = document.querySelectorAll('.contract-checkbox');
                        checkboxes.forEach(checkbox => {
                            checkbox.checked = this.checked;
                        });
                        updateSelectedCount();
                    });

                    // Update selected count when individual checkboxes change
                    document.querySelectorAll('.contract-checkbox').forEach(checkbox => {
                        checkbox.addEventListener('change', function () {
                            updateSelectedCount();
                            updateSelectAllState();
                        });
                    });

                    function updateSelectedCount() {
                        const checkedBoxes = document.querySelectorAll('.contract-checkbox:checked');
                        const count = checkedBoxes.length;
                        document.getElementById('selectedCount').textContent = count;
                        document.getElementById('restoreSelectedBtn').disabled = count === 0;
                    }

                    function updateSelectAllState() {
                        const checkboxes = document.querySelectorAll('.contract-checkbox');
                        const selectAll = document.getElementById('selectAll');
                        const checkedCount = document.querySelectorAll('.contract-checkbox:checked').length;
                        selectAll.checked = checkedCount === checkboxes.length && checkboxes.length > 0;
                        selectAll.indeterminate = checkedCount > 0 && checkedCount < checkboxes.length;
                    }

                    // Restore Selected button click
                    document.getElementById('restoreSelectedBtn').addEventListener('click', function () {
                        const checkedBoxes = document.querySelectorAll('.contract-checkbox:checked');
                        if (checkedBoxes.length === 0) {
                            alert('Vui lòng chọn ít nhất một hợp đồng để khôi phục!');
                            return;
                        }

                        // Get all selected IDs
                        const selectedIds = Array.from(checkedBoxes).map(cb => cb.value);

                        // Update modal count
                        document.getElementById('restoreCount').textContent = selectedIds.length;

                        // Clear and add hidden inputs for selected IDs
                        const form = document.getElementById('restoreMultipleForm');
                        // Remove existing hidden inputs for IDs
                        form.querySelectorAll('input[name="contractIds"]').forEach(input => input.remove());

                        // Add new hidden inputs for selected IDs
                        selectedIds.forEach(id => {
                            const input = document.createElement('input');
                            input.type = 'hidden';
                            input.name = 'contractIds';
                            input.value = id;
                            form.appendChild(input);
                        });

                        // Add filter parameters
                        const existingParams = form.querySelectorAll('input[name="search"], input[name="page"], input[name="sortBy"], input[name="sortOrder"]');
                        existingParams.forEach(input => input.remove());

                        <c:if test="${not empty searchValue}">
                            const searchInput = document.createElement('input');
                            searchInput.type = 'hidden';
                            searchInput.name = 'search';
                            searchInput.value = '${searchValue}';
                            form.appendChild(searchInput);
                        </c:if>
                        <c:if test="${not empty currentPage}">
                            const pageInput = document.createElement('input');
                            pageInput.type = 'hidden';
                            pageInput.name = 'page';
                            pageInput.value = '${currentPage}';
                            form.appendChild(pageInput);
                        </c:if>
                        <c:if test="${not empty sortBy}">
                            const sortByInput = document.createElement('input');
                            sortByInput.type = 'hidden';
                            sortByInput.name = 'sortBy';
                            sortByInput.value = '${sortBy}';
                            form.appendChild(sortByInput);
                        </c:if>
                        <c:if test="${not empty sortOrder}">
                            const sortOrderInput = document.createElement('input');
                            sortOrderInput.type = 'hidden';
                            sortOrderInput.name = 'sortOrder';
                            sortOrderInput.value = '${sortOrder}';
                            form.appendChild(sortOrderInput);
                        </c:if>

                        // Show modal
                        const modal = new bootstrap.Modal(document.getElementById('restoreMultipleModal'));
                        modal.show();
                    });

                    // Initialize count on page load
                    updateSelectedCount();
                </script>
            </body>

            <jsp:include page="../managerFooter.jsp" />