<%-- 
    Document   : user-list
    Created on : Dec 3, 2025, 7:14:52 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>User management</h1>
        <form action="user-list" method="get">
            <div class="filter-box">

                <select name="gender">
                    <option value="">-- All Gender --</option>
                    <option value="1" ${genderValue == '1' ? 'selected' : ''}>Male</option>
                    <option value="0" ${genderValue == '0' ? 'selected' : ''}>Female</option>
                </select>

                <select name="role">
                    <option value="">-- All Role --</option>
                    <option value="1" ${roleValue == '1' ? 'selected' : ''}>Admin</option>
                    <option value="2" ${roleValue == '2' ? 'selected' : ''}>Manager</option>
                    <option value="3" ${roleValue == '3' ? 'selected' : ''}>Sale Staff</option>
                    <option value="4" ${roleValue == '4' ? 'selected' : ''}>Customer</option>
                </select>

                <select name="status">
                    <option value="">-- All Status --</option>
                    <option value="1" ${statusValue == '1' ? 'selected' : ''}>Active</option>
                    <option value="0" ${statusValue == '0' ? 'selected' : ''}>Inactive</option>
                </select>

                <input type="text" name="search" placeholder="Search name..." value="${searchValue}">

                <button type="submit">Search</button>
            </div>
        </form>

        <table style="border: 1px solid black">
            <thead>
                <tr>
                    <th>Id</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Status</th>
                    <th>Role</th>
                    <th>Gender</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach items="${userList}" var="u">
                    <tr>
                        <td>${u.id}</td>
                        <td>${u.displayname}</td>
                        <td>${u.email}</td>
                        <td>
                            <c:if test="${u.active}">
                                <span style="color: green ; font-weight: bold">Active</span>
                            </c:if>
                            <c:if test="${!u.active}">
                                <span style="color: red; font-weight: bold;">Inactive</span>
                            </c:if>

                        </td>
                        <td>
                            ${u.roles.name}
                        </td>
                        <td>
                            ${u.gender ? "Male" : "Female"}
                        </td>

                        <td>

                        <td>
                            <a href="user-detail?id=${u.id}">View</a> | 
                            <a href="edit?id=${u.id}">Edit</a> | 
                            <a href="#">Delete</a>
                            <c:if test="${u.active}">
                                <form action="change-user-status" method="post" style="display: inline;">
                                    <input type="hidden" name="id" value="${u.id}">
                                    <input type="hidden" name="status" value="0"> <button type="submit" 
                                                                                          style="background-color: red; color: white"
                                                                                          onclick="return confirm('Are you sure to Deactive this user?')">
                                        Deactivate
                                    </button>
                                </form>
                            </c:if>

                            <c:if test="${!u.active}">
                                <form action="change-user-status" method="post" style="display: inline;">
                                    <input type="hidden" name="id" value="${u.id}">
                                    <input type="hidden" name="status" value="1"> <button type="submit" 
                                                                                          style="background-color: green; color: white"
                                                                                          onclick="return confirm('Are you sure to Activate this user?')">
                                        Activate
                                    </button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <div style="margin-top: 20px; text-align: center;">
            <c:if test="${totalPages > 0}">
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="user-list?page=${i}&search=${searchValue}&role=${roleValue}&status=${statusValue}&gender=${genderValue}" 
                       style="${i == currentPage ? 'background-color: blue; color: white;' : ''}
                       padding: 8px 16px;
                       text-decoration: none;
                       border: 1px solid #ddd;
                       margin: 0 4px;">
                        ${i}
                    </a>
                </c:forEach>
            </c:if>
        </div>
        <p>Tổng số trang nhận được: ${totalPages}</p>
        <p>Trang hiện tại: ${currentPage}</p>
    </body>
</html>
