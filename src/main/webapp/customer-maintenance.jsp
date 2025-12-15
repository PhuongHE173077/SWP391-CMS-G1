<%-- 
    Document   : user-maintenance
    Created on : Dec 15, 2025, 10:46:43 AM
    Author     : ADMIN
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- <jsp:include page="../../customerLayout.jsp"> --%>
    <%-- <jsp:param name="pageTitle" value="My Maintenance Requests" /> --%>
<%-- </jsp:include> --%>

<head>
    <title>My Maintenance Requests</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
 <body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <div class="container">
            <a class="navbar-brand" href="#">Customer Portal</a>
        </div>
    </nav>

    <div class="container px-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary fw-bold"><i class="fas fa-history me-2"></i>My Maintenance History</h2>
            <a href="create-request" class="btn btn-success shadow-sm fw-bold">
                <i class="fas fa-plus-circle me-2"></i>New Request
            </a>
        </div>