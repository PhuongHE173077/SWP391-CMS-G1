<%-- Document : listRole Created on : Dec 3, 2025, 3:36:42 PM Author : admin --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

            <jsp:include page="../adminLayout.jsp">
                <jsp:param name="pageTitle" value="Danh sách Role" />
            </jsp:include>

            <div class="container mt-4">
                <div class="d-flex justify-content-between">
                    <h2 class="mb-4">Danh sách Role</h2>

                </div>
                <table class="table table-bordered table-striped">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Tên Role</th>
                            <th>Mô tả</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="role" items="${listRoles}">
                            <tr>
                                <td>${role.id}</td>
                                <td>${role.name}</td>
                                <td>${role.description}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${role.status}">
                                            <span class="badge bg-success">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">Không hoạt động</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="RoleDetail?id=${role.id}" class="btn btn-primary btn-sm">View detail</a>
                                    <a href="EditRole?id=${role.id}" class="btn btn-warning btn-sm">Update</a>

                                    <form action="change-role-status" method="post" style="display:inline;">
                                        <input type="hidden" name="id" value="${role.id}"/>
                                        <c:choose>
                                            <c:when test="${role.status}">
                                                <input type="hidden" name="status" value="0"/>
                                                <button type="submit" class="btn btn-danger btn-sm"
                                                        onclick="return confirm('Bạn có chắc muốn vô hiệu hóa role này?');">
                                                    Deactive role
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <input type="hidden" name="status" value="1"/>
                                                <button type="submit" class="btn btn-success btn-sm"
                                                        onclick="return confirm('Bạn có chắc muốn kích hoạt role này?');">
                                                    Active role
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty listRoles}">
                            <tr>
                                <td colspan="5" class="text-center">Không có dữ liệu</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>

            </div>
            <jsp:include page="../adminFooter.jsp" />