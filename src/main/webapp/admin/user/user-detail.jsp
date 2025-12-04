<%-- 
    Document   : user-detail
    Created on : Dec 3, 2025, 9:01:17 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../adminLayout.jsp">
    <jsp:param name="pageTitle" value="List danh sách ng dùng" />
</jsp:include>
<div class="detail-card">
    <h2 style="text-align: center;">User Information</h2>

    <div class="row">
        <span class="label">ID:</span>
        <span class="value">${user.id}</span>
    </div>

    <div class="row">
        <span class="label">Full Name:</span>
        <span class="value">${user.displayname}</span>
    </div>

    <div class="row">
        <span class="label">Email:</span>
        <span class="value">${user.email}</span>
    </div>

    <div class="row">
        <span class="label">Password:</span>
        <span class="value">${user.password}</span>
    </div>

    <div class="row">
        <span class="label">Phone Number:</span>
        <span class="value">${user.phone}</span>
    </div>

    <div class="row">
        <span class="label">Address:</span>
        <span class="value">${user.address}</span>
    </div>

    <div class="row">
        <span class="label">Role:</span>
        <span class="value">${user.roles.name}</span>
    </div>

    <div class="row">
        <span class="label">Gender:</span>
        <span class="value">
            ${user.gender ? "Male" : "Female"}
        </span>
    </div>

    <div class="row">
        <span class="label">Status:</span>
        <span class="value" style="color: ${user.active ? 'green' : 'red'}; font-weight: bold;">
            ${user.active ? "Active" : "Inactive"}
        </span>
    </div>

    <a href="user-list" class="btn-back">Back to List</a>
</div>
<jsp:include page="../adminFooter.jsp" />

