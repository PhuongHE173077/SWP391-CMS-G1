<%-- Document : addUser Created on : Dec 3, 2025, 7:40:18 PM Author : Hai Nam --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

            <jsp:include page="../adminLayout.jsp">
                <jsp:param name="pageTitle" value="Thêm người dùng" />
            </jsp:include>

            <div class="container-fluid">
                <div class="row justify-content-center">
                    <div class="col-md-8 col-lg-6">
                        <div class="card shadow-sm">
                            <div class="card-header bg-primary text-white">
                                <h4 class="mb-0">Thêm người dùng mới</h4>
                            </div>
                            <div class="card-body">

                                <!-- Hiển thị thông báo lỗi/thành công nếu có -->
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger" role="alert">
                                        ${error}
                                    </div>
                                </c:if>
                                <c:if test="${not empty success}">
                                    <div class="alert alert-success" role="alert">
                                        ${success}
                                    </div>
                                </c:if>

                                <!-- Thông tin User -->
                                <form action="AddUser" method="post">
                                    <div class="mb-3">
                                        <label for="displayname" class="form-label">Họ và tên</label>
                                        <input type="text" class="form-control" id="displayname" name="displayname"
                                            value="${param.displayname}" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="email" class="form-label">Email</label>
                                        <input type="email" class="form-control" id="email" name="email"
                                            value="${param.email}" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="password" class="form-label">Mật khẩu</label>
                                        <input type="password" class="form-control" id="password" name="password"
                                            required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="confirmPassword" class="form-label">Nhập lại mật khẩu</label>
                                        <input type="password" class="form-control" id="confirmPassword"
                                            name="confirmPassword" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="phone" class="form-label">Số điện thoại</label>
                                        <input type="text" class="form-control" id="phone" name="phone"
                                            value="${param.phone}">
                                    </div>

                                    <div class="mb-3">
                                        <label for="address" class="form-label">Địa chỉ</label>
                                        <textarea class="form-control" id="address" name="address"
                                            rows="2">${param.address}</textarea>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label d-block">Giới tính</label>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="gender" id="genderMale"
                                                value="true" ${param.gender=='true' ? 'checked' : '' }>
                                            <label class="form-check-label" for="genderMale">Nam</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="gender" id="genderFemale"
                                                value="false" ${param.gender=='false' ? 'checked' : '' }>
                                            <label class="form-check-label" for="genderFemale">Nữ</label>
                                        </div>
                                    </div>

                                    <!-- Active -->
                                    <div class="mb-3 form-check">
                                        <input type="checkbox" class="form-check-input" id="active" name="active"
                                            value="true" ${empty param.active || param.active=='true' ? 'checked' : ''
                                            }>
                                        <label class="form-check-label" for="active">Hoạt động</label>
                                    </div>

                                    <!-- Role -->
                                    <div class="mb-3">
                                        <label for="roleId" class="form-label">Vai trò</label>
                                        <select class="form-select" id="roleId" name="roleId" required>
                                            <option value="">-- Chọn vai trò --</option>
                                            <c:forEach var="role" items="${listRoles}">
                                                <option value="${role.id}" ${param.roleId==role.id ? 'selected' : '' }>
                                                    ${role.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="d-flex justify-content-between">
                                        <a href="" class="btn btn-secondary">Quay lại</a>
                                        <button type="submit" class="btn btn-primary">Lưu người dùng</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <jsp:include page="../adminFooter.jsp" />