<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../adminLayout.jsp">
    <jsp:param name="pageTitle" value="Chỉnh sửa người dùng" />
</jsp:include>

<div class="container-fluid">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">Chỉnh sửa người dùng</h4>
                </div>
                <div class="card-body">

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

                    <form action="edit" method="post">
                        <input type="hidden" name="id" value="${user.id}" />

                        <div class="mb-3">
                            <label for="displayname" class="form-label">Họ và tên</label>
                            <input type="text" class="form-control" id="displayname" name="displayname"
                                   value="${not empty param.displayname ? param.displayname : user.displayname}" required>
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email"
                                   value="${not empty param.email ? param.email : user.email}" required>
                        </div>

                        <div class="mb-3">
                            <label for="phone" class="form-label">Số điện thoại</label>
                            <input type="text" class="form-control" id="phone" name="phone"
                                   value="${not empty param.phone ? param.phone : user.phone}">
                        </div>

                        <div class="mb-3">
                            <label for="address" class="form-label">Địa chỉ</label>
                            <textarea class="form-control" id="address" name="address" rows="2">${not empty param.address ? param.address : user.address}</textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label d-block">Giới tính</label>
                            <c:set var="genderValue" value="${not empty param.gender ? param.gender : (user.gender ? 'true' : 'false')}" />
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="gender" id="genderMale"
                                       value="true" ${genderValue == 'true' ? 'checked' : ''}>
                                <label class="form-check-label" for="genderMale">Nam</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="gender" id="genderFemale"
                                       value="false" ${genderValue == 'false' ? 'checked' : ''}>
                                <label class="form-check-label" for="genderFemale">Nữ</label>
                            </div>
                        </div>

                        <div class="mb-3 form-check">
                            <c:set var="activeValue"
                                   value="${not empty param.active ? param.active : (user.active ? 'true' : 'false')}"/>
                            <input type="checkbox" class="form-check-input" id="active" name="active"
                                   value="true" ${activeValue == 'true' ? 'checked' : ''}>
                            <label class="form-check-label" for="active">Hoạt động</label>
                        </div>

                        <div class="mb-3">
                            <label for="roleId" class="form-label">Vai trò</label>
                            <c:set var="roleSelected"
                                   value="${not empty param.roleId ? param.roleId : user.roles.id}" />
                            <select class="form-select" id="roleId" name="roleId" required>
                                <option value="">-- Chọn vai trò --</option>
                                <c:forEach var="role" items="${roleList}">
                                    <option value="${role.id}" ${roleSelected == role.id ? 'selected' : ''}>
                                        ${role.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="d-flex justify-content-between">
                            <a href="user-list" class="btn btn-secondary">Quay lại</a>
                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../adminFooter.jsp" />


