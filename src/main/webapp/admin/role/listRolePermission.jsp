<%-- Document : listRolePermission Created on : Dec 14, 2025, 2:17:34 PM Author : admin --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

            <jsp:include page="../adminLayout.jsp">
                <jsp:param name="pageTitle" value="Quản lý Permission theo Role" />
            </jsp:include>

            <style>
                .permission-table {
                    width: 100%;
                    border-collapse: collapse;
                }

                .permission-table th,
                .permission-table td {
                    border: 1px solid #2d3436;
                    padding: 10px;
                    text-align: center;
                }

                .permission-table thead th {
                    background-color: #f8d7da;
                    color: #721c24;
                    font-weight: 600;
                }

                .permission-table thead th:first-child {
                    background-color: #f8d7da;
                    text-align: left;
                }

                .permission-table tbody td:first-child {
                    text-align: left;
                    font-weight: 500;
                }

                .permission-table tbody tr:nth-child(even) {
                    background-color: #f8f9fa;
                }

                .permission-table tbody tr:hover {
                    background-color: #e9ecef;
                }

                .group-row {
                    background-color: #e2e3e5 !important;
                    font-weight: bold;
                }

                .group-row td {
                    text-align: left !important;
                    padding-left: 10px;
                }

                .screen-name {
                    padding-left: 30px !important;
                }

                .check-mark {
                    color: #28a745;
                    font-weight: bold;
                    font-size: 1.2em;
                }
            </style>

            <div class="container mt-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>Quản lý Permission theo Role</h2>
                    <a href="UpdateRolePermission" class="btn btn-secondary">
                        Update sách Role
                    </a>
                </div>

                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="permission-table">
                                <thead>
                                    <tr>
                                        <th style="min-width: 250px;">Screen</th>
                                        <c:forEach var="role" items="${listRoles}">
                                            <th style="min-width: 120px;">${role.name}</th>
                                        </c:forEach>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="group" items="${routerGroups}">
                                        <tr class="group-row">
                                            <td colspan="${listRoles.size() + 1}">
                                                <i class="fas fa-folder"></i> ${group.name}
                                            </td>
                                        </tr>
                                        <c:forEach var="router" items="${group.routerses}">
                                            <tr>
                                                <td class="screen-name">${router.name}</td>
                                                <c:forEach var="role" items="${listRoles}">
                                                    <td>
                                                        <c:set var="hasPermission" value="false" />
                                                        <c:forEach var="rp" items="${rolePermissions}">
                                                            <c:if
                                                                test="${rp.roles.id == role.id && rp.router == router.router}">
                                                                <c:set var="hasPermission" value="true" />
                                                            </c:if>
                                                        </c:forEach>
                                                        <c:if test="${hasPermission}">
                                                            <span class="check-mark">X</span>
                                                        </c:if>
                                                    </td>
                                                </c:forEach>
                                            </tr>
                                        </c:forEach>
                                    </c:forEach>

                                    <c:if test="${empty routerGroups}">
                                        <tr>
                                            <td colspan="${listRoles.size() + 1}" class="text-center">
                                                Không có dữ liệu màn hình
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="mt-3">
                    <small class="text-muted">
                        <span class="check-mark">X</span> = Role có quyền truy cập màn hình này
                    </small>
                </div>
            </div>

            <jsp:include page="../adminFooter.jsp" />