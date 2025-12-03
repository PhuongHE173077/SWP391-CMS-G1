<%-- Document : RoleEdit Created on : Dec 3, 2025, 11:11:53 PM Author : admin --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Chỉnh sửa Role - ${role.name}</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css"
                    rel="stylesheet">
                <style>
                    
                </style>
            </head>

            <body>
                <div class="container mt-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2> Chỉnh sửa Role</h2>
                        <a href="ViewRole" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Quay lại
                        </a>
                    </div>

                    <form action="EditRole" method="POST">
                        <input type="hidden" name="id" value="${role.id}">

                       
                        <div class="border mb-4">
                            <div class="p-2 bg-primary text-white">
                                <h5 class="mb-0"> Thông tin Role</h5>
                            </div>
                            <div class="p-2">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="name" class="form-label">Tên Role <span
                                                class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="name" name="name"
                                            value="${role.name}" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="description" class="form-label">Mô tả</label>
                                        <input type="text" class="form-control" id="description" name="description"
                                            value="${role.description}">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-check form-switch">
                                            <input class="form-check-input" type="checkbox" id="status" name="status"
                                                ${role.status ? 'checked' : '' }>
                                            <label class="form-check-label" for="status">Trạng thái hoạt động</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                       
                        <div class="border mb-4">
                            <div
                                class="p-1 bg-success text-white d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Phân quyền Permission</h5>
                                <div>
                                    <button type="button" class="btn btn-light btn-sm" onclick="selectAll()">
                                        <i class="bi bi-check-all"></i> Chọn tất cả
                                    </button>
                                    <button type="button" class="btn btn-outline-light btn-sm" onclick="deselectAll()">
                                        <i class="bi bi-x-lg"></i> Bỏ chọn tất cả
                                    </button>
                                </div>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${not empty routerGroups}">
                                        <ul class="permission-tree">
                                            <c:forEach var="group" items="${routerGroups}">
                                                <li class="group-item">
                                                    <div class="group-header" onclick="toggleGroup(this)">
                                                        <div class="group-title">
                                                            <input type="checkbox"
                                                                class="form-check-input group-checkbox"
                                                                id="group_${group.id}"
                                                                onclick="toggleGroupCheckbox(event, ${group.id})">
                                                            <i class="bi bi-folder2"></i>
                                                            <span>${group.name}</span>
                                                            <span class="badge bg-secondary badge-count">
                                                                <span class="selected-count"
                                                                    data-group="${group.id}">0</span>/${group.routerses.size()}
                                                            </span>
                                                        </div>
                                                        <i class="bi bi-chevron-down toggle-icon"></i>
                                                    </div>
                                                    <ul class="router-list" id="routers_${group.id}">
                                                        <c:forEach var="router" items="${group.routerses}">
                                                            <li class="router-item">
                                                                <input type="checkbox"
                                                                    class="form-check-input router-checkbox"
                                                                    id="router_${router.router}" name="permissions"
                                                                    value="${router.router}" data-group="${group.id}"
                                                                    onchange="updateGroupCheckbox(${group.id})"
                                                                    ${currentRouters.contains(router.router) ? 'checked'
                                                                    : '' }>
                                                                <label for="router_${router.router}">
                                                                    <i class="bi bi-link-45deg"></i>
                                                                    <strong>${router.name}</strong>
                                                                    <span class="router-path">${router.router}</span>
                                                                </label>
                                                            </li>
                                                        </c:forEach>
                                                    </ul>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-warning mb-0">
                                            <i class="bi bi-exclamation-triangle"></i> Chưa có RouterGroup nào được định
                                            nghĩa.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                      
                        <div class="d-flex gap-2 mb-4">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-lg"></i> Lưu thay đổi
                            </button>
                            <a href="RoleDetail?id=${role.id}" class="btn btn-outline-secondary">
                                <i class="bi bi-x-lg"></i> Hủy
                            </a>
                        </div>
                    </form>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    
                    function toggleGroup(header) {
                        if (event.target.type === 'checkbox') return;

                        header.classList.toggle('collapsed');
                        const routerList = header.nextElementSibling;
                        if (routerList.style.display === 'none') {
                            routerList.style.display = 'block';
                        } else {
                            routerList.style.display = 'none';
                        }
                    }

                    
                    function toggleGroupCheckbox(event, groupId) {
                        event.stopPropagation();
                        const isChecked = event.target.checked;
                        const routers = document.querySelectorAll('input[data-group="' + groupId + '"]');
                        routers.forEach(router => {
                            router.checked = isChecked;
                        });
                        updateSelectedCount(groupId);
                    }

                   
                    function updateGroupCheckbox(groupId) {
                        const routers = document.querySelectorAll('input[data-group="' + groupId + '"]');
                        const groupCheckbox = document.getElementById('group_' + groupId);
                        const checkedCount = Array.from(routers).filter(r => r.checked).length;

                        groupCheckbox.checked = checkedCount === routers.length;
                        groupCheckbox.indeterminate = checkedCount > 0 && checkedCount < routers.length;

                        updateSelectedCount(groupId);
                    }

                    
                    function updateSelectedCount(groupId) {
                        const routers = document.querySelectorAll('input[data-group="' + groupId + '"]');
                        const checkedCount = Array.from(routers).filter(r => r.checked).length;
                        const countSpan = document.querySelector('.selected-count[data-group="' + groupId + '"]');
                        if (countSpan) {
                            countSpan.textContent = checkedCount;
                        }
                    }

                    
                    function selectAll() {
                        document.querySelectorAll('.router-checkbox').forEach(cb => cb.checked = true);
                        document.querySelectorAll('.group-checkbox').forEach(cb => {
                            cb.checked = true;
                            cb.indeterminate = false;
                        });
                        updateAllCounts();
                    }

                    
                    function deselectAll() {
                        document.querySelectorAll('.router-checkbox').forEach(cb => cb.checked = false);
                        document.querySelectorAll('.group-checkbox').forEach(cb => {
                            cb.checked = false;
                            cb.indeterminate = false;
                        });
                        updateAllCounts();
                    }

                    
                    function updateAllCounts() {
                        document.querySelectorAll('.group-checkbox').forEach(cb => {
                            const groupId = cb.id.replace('group_', '');
                            updateSelectedCount(groupId);
                        });
                    }

                    
                    document.addEventListener('DOMContentLoaded', function () {
                        document.querySelectorAll('.group-checkbox').forEach(cb => {
                            const groupId = cb.id.replace('group_', '');
                            updateGroupCheckbox(groupId);
                        });
                    });
                </script>
            </body>

            </html>