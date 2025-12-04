<%-- 
    Document   : edit-user
    Created on : Dec 4, 2025, 9:51:09 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
 
 <jsp:include page="../adminLayout.jsp">
    <jsp:param name="pageTitle" value="Chỉnh sửa người dùng" />
</jsp:include>
<div class="detail-card">
    <h2 style="text-align: center;">Edit User Information</h2>

    <form action="edit-user" method="post">
        
        <div class="row">
            <span class="label">ID:</span>
            <input type="text" class="value" value="${user.id}" disabled style="background: #eee;">
            <input type="hidden" name="id" value="${user.id}"> </div>

        <div class="row">
            <span class="label">Full Name:</span>
            <input type="text" name="displayname" class="value" value="${user.displayname}" required>
        </div>

        <div class="row">
            <span class="label">Email:</span>
            <input type="email" class="value" value="${user.email}" disabled style="background: #eee;">
        </div>

        <div class="row">
            <span class="label">Phone Number:</span>
            <input type="text" name="phone" class="value" value="${user.phone}">
        </div>

        <div class="row">
            <span class="label">Address:</span>
            <input type="text" name="address" class="value" value="${user.address}">
        </div>

        <div class="row">
            <span class="label">Role:</span>
            <select name="role" class="value" style="padding: 5px;">
                <c:forEach items="${listRole}" var="r">
                    <option value="${r.id}" ${user.roles.id == r.id ? 'selected' : ''}>
                        ${r.name}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="row">
            <span class="label">Gender:</span>
            <select name="gender" class="value" style="padding: 5px;">
                <option value="1" ${user.gender ? 'selected' : ''}>Male</option>
                <option value="0" ${!user.gender ? 'selected' : ''}>Female</option>
            </select>
        </div>

        <div class="row">
            <span class="label">Status:</span>
            <select name="active" class="value" style="padding: 5px;">
                <option value="1" ${user.active ? 'selected' : ''} style="color: green; font-weight: bold;">Active</option>
                <option value="0" ${!user.active ? 'selected' : ''} style="color: red; font-weight: bold;">Inactive</option>
            </select>
        </div>

        <div style="margin-top: 20px; text-align: center;">
            <button type="submit" class="btn-save" style="background: blue; color: white; padding: 10px 20px; border: none; cursor: pointer;">
                Save Changes
            </button>
            
            <a href="user-list" class="btn-back" style="margin-left: 10px; text-decoration: none; color: black; border: 1px solid #ccc; padding: 9px 20px;">
                Cancel
            </a>
        </div>
        
    </form>
</div>

<jsp:include page="../adminFooter.jsp" />