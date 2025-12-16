<%-- 
    Document   : dashboard
    Created on : Dec 15, 2025, 10:22:42 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<jsp:include page="managerLayout.jsp">
    <jsp:param name="pageTitle" value="Device Category List" />
</jsp:include>

<style>
    /* --- Global Styles and Variables --- */
    :root {
        --primary-color: #3f51b5; /* Màu xanh tím (như logo) */
        --secondary-color: #f5f5f5; /* Màu nền sáng */
        --text-dark: #333;
        --text-light: #fff;
        --sidebar-width: 250px;
        --navbar-height: 60px;
        --sidebar-dark: #2c3e50; /* Màu nền sidebar tối hơn */
        --sidebar-item-active: #34495e; /* Màu nền item active */
        --highlight-color: #4CAF50; /* Màu xanh lá nổi bật */
    }

    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    }

    a {
        text-decoration: none;
        color: inherit;
    }

    /* --- Layout Structure --- */
    .cms-admin-layout {
        display: flex;
        min-height: 100vh;
        background-color: var(--secondary-color);
    }

    /* --- Sidebar Styling (Left Menu) --- */
    .sidebar {
        width: var(--sidebar-width);
        background-color: var(--sidebar-dark);
        color: var(--text-light);
        box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
        display: flex;
        flex-direction: column;
        padding: 20px 0;
    }

    .sidebar-header {
        padding: 0 20px 20px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    }

    .sidebar-header .logo {
        font-size: 24px;
        font-weight: bold;
        color: var(--text-light);
    }

    .main-menu {
        flex-grow: 1;
        padding-top: 10px;
    }

    .menu-section-title {
        font-size: 12px;
        color: #bdc3c7;
        padding: 10px 20px 5px;
        text-transform: uppercase;
        font-weight: 600;
    }

    .main-menu ul {
        list-style: none;
    }

    .main-menu li a {
        display: flex;
        align-items: center;
        padding: 12px 20px;
        color: var(--text-light);
        transition: background-color 0.2s, color 0.2s;
    }

    .main-menu li a:hover,
    .main-menu li.active a {
        background-color: var(--sidebar-item-active);
        color: var(--highlight-color);
    }

    .main-menu li i {
        margin-right: 10px;
        width: 20px;
        text-align: center;
    }

    /* --- Main Content and Navbar --- */
    .main-content {
        flex-grow: 1;
        display: flex;
        flex-direction: column;
    }

    .navbar {
        height: var(--navbar-height);
        background-color: var(--text-light);
        box-shadow: 0 0 4px rgba(0, 0, 0, 0.1);
        padding: 0 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .search-box {
        display: flex;
        align-items: center;
        border: 1px solid #ccc;
        border-radius: 4px;
        padding: 5px 10px;
        width: 300px;
        background-color: #f9f9f9;
    }

    .search-box i {
        color: #999;
        margin-right: 8px;
    }

    .search-box input {
        border: none;
        outline: none;
        flex-grow: 1;
        background-color: transparent;
        font-size: 14px;
    }

    .user-profile {
        display: flex;
        align-items: center;
        cursor: pointer;
        font-size: 14px;
    }

    .avatar-circle {
        width: 30px;
        height: 30px;
        border-radius: 50%;
        background-color: var(--primary-color);
        color: var(--text-light);
        display: flex;
        justify-content: center;
        align-items: center;
        font-weight: bold;
        margin-right: 8px;
    }

    .user-name {
        font-weight: 500;
        color: var(--text-dark);
    }

    .user-name i {
        margin-left: 5px;
        font-size: 12px;
    }

    /* --- Dashboard Body --- */
    .dashboard-body {
        padding: 20px;
        flex-grow: 1;
    }

    .dashboard-body h1 {
        font-size: 28px;
        color: var(--text-dark);
        margin-bottom: 10px;
    }

    /* --- Dashboard Widgets --- */
    .dashboard-widgets {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }

    .widget {
        background-color: var(--text-light);
        padding: 20px;
        border-radius: 6px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        display: flex;
        align-items: center;
        justify-content: space-between;
        color: var(--text-light);
        overflow: hidden;
        position: relative;
    }

    /* Color classes for widgets (dựa trên màu của các nút trong ảnh gốc) */
    .widget.product-bg {
        background-color: #007bff;
    } /* Blue - View Detail */
    .widget.contract-bg {
        background-color: #ffc107;
    } /* Yellow - Update (Dùng màu nền đậm hơn để chữ trắng nổi) */
    .widget.staff-bg {
        background-color: #28a745;
    } /* Green - Hoạt động */
    .widget.customer-bg {
        background-color: #dc3545;
    } /* Red - Deactive role */

    .widget-icon i {
        font-size: 45px;
        opacity: 0.2;
        position: absolute;
        right: 20px;
        bottom: 10px;
    }

    .widget-content {
        z-index: 1;
    }

    .widget-number {
        display: block;
        font-size: 28px;
        font-weight: bold;
    }

    .widget-title {
        display: block;
        font-size: 14px;
        margin-top: 5px;
        opacity: 0.9;
        font-weight: 500;
    }
    /* --- Section Container and Table --- */
    .section-container {
        background-color: var(--text-light);
        padding: 20px;
        border-radius: 6px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        margin-bottom: 20px;
    }

    .section-container h3 {
        color: var(--text-dark);
        font-size: 18px;
        margin-bottom: 15px;
        border-bottom: 1px solid #eee;
        padding-bottom: 10px;
    }

    .data-table {
        width: 100%;
        border-collapse: collapse;
    }

    .data-table th,
    .data-table td {
        padding: 12px 15px;
        text-align: center;
        border-bottom: 1px solid #eee;
        font-size: 14px;
    }

    .data-table tbody tr:last-child td {
        border-bottom: none;
    }

    .data-table th {
        background-color: #f8f9fa;
        font-weight: 600;
        color: var(--text-dark);
        text-transform: uppercase;
        font-size: 12px;
    }

    .data-table tr:hover {
        background-color: #fcfcfc;
    }

    /* Top 3 Styling */
    .data-table .top-rank {
        font-weight: bold;
        color: var(--primary-color);
    }

    .data-table .rank-1 {
        color: gold;
        font-size: 1.2em;
    }
    .data-table .rank-2 {
        color: silver;
        font-size: 1.1em;
    }
    .data-table .rank-3 {
        color: #cd7f32;
        font-size: 1em;
    }
    :root {
        --sidebar-width: 260px;
        --sidebar-bg: #1e293b;
        --sidebar-hover: #334155;
        --primary-color: #10b981;
        --text-light: #e2e8f0;
        --text-muted: #94a3b8;
    }

    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f1f5f9;
    }

    /* Sidebar */
    .manager-sidebar {
        position: fixed;
        top: 0;
        left: 0;
        width: var(--sidebar-width);
        height: 100vh;
        background: var(--sidebar-bg);
        color: var(--text-light);
        z-index: 1000;
        transition: all 0.3s ease;
        overflow-y: auto;
    }

    .manager-sidebar.collapsed {
        width: 70px;
    }

    .sidebar-header {
        padding: 20px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        border-bottom: 1px solid var(--sidebar-hover);
    }

    .sidebar-logo {
        display: flex;
        align-items: center;
        gap: 12px;
        text-decoration: none;
        color: var(--text-light);
    }

    .sidebar-logo i {
        font-size: 28px;
        color: var(--primary-color);
    }

    .sidebar-logo span {
        font-size: 20px;
        font-weight: 700;
    }

    .manager-sidebar.collapsed .sidebar-logo span,
    .manager-sidebar.collapsed .nav-text,
    .manager-sidebar.collapsed .menu-title {
        display: none;
    }

    .toggle-btn {
        background: none;
        border: none;
        color: var(--text-muted);
        cursor: pointer;
        font-size: 18px;
        padding: 5px;
        transition: color 0.3s;
    }

    .toggle-btn:hover {
        color: var(--text-light);
    }

    /* Navigation Menu */
    .sidebar-nav {
        padding: 15px 0;
    }

    .menu-title {
        padding: 10px 20px;
        font-size: 11px;
        text-transform: uppercase;
        letter-spacing: 1px;
        color: var(--text-muted);
        margin-top: 10px;
    }

    .nav-item {
        list-style: none;
    }

    .nav-link {
        display: flex;
        align-items: center;
        padding: 12px 20px;
        color: var(--text-muted);
        text-decoration: none;
        transition: all 0.3s ease;
        gap: 12px;
        border-left: 3px solid transparent;
    }

    .nav-link:hover {
        background: var(--sidebar-hover);
        color: var(--text-light);
        border-left-color: var(--primary-color);
    }

    .nav-link.active {
        background: var(--sidebar-hover);
        color: var(--primary-color);
        border-left-color: var(--primary-color);
    }

    .nav-link i {
        width: 20px;
        text-align: center;
        font-size: 16px;
    }

    .nav-text {
        font-size: 14px;
    }

    /* Main Content */
    .manager-main {
        margin-left: var(--sidebar-width);
        min-height: 100vh;
        transition: margin-left 0.3s ease;
    }

    .manager-main.expanded {
        margin-left: 70px;
    }

    /* Top Header */
    .manager-header {
        background: #ffffff;
        padding: 15px 30px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
        position: sticky;
        top: 0;
        z-index: 100;
    }

    .header-search {
        position: relative;
        width: 300px;
    }

    .header-search input {
        width: 100%;
        padding: 10px 15px 10px 40px;
        border: 1px solid #e2e8f0;
        border-radius: 8px;
        font-size: 14px;
        transition: border-color 0.3s;
    }

    .header-search input:focus {
        outline: none;
        border-color: var(--primary-color);
    }

    .header-search i {
        position: absolute;
        left: 15px;
        top: 50%;
        transform: translateY(-50%);
        color: var(--text-muted);
    }

    .header-actions {
        display: flex;
        align-items: center;
        gap: 20px;
    }

    .header-icon {
        position: relative;
        color: #64748b;
        font-size: 18px;
        cursor: pointer;
        transition: color 0.3s;
    }

    .header-icon:hover {
        color: var(--primary-color);
    }

    .notification-badge {
        position: absolute;
        top: -5px;
        right: -5px;
        background: #ef4444;
        color: white;
        font-size: 10px;
        padding: 2px 5px;
        border-radius: 10px;
    }

    .user-profile {
        display: flex;
        align-items: center;
        gap: 10px;
        cursor: pointer;
        padding: 5px 10px;
        border-radius: 8px;
        transition: background 0.3s;
    }

    .user-profile:hover {
        background: #f1f5f9;
    }

    .user-avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: var(--primary-color);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 600;
    }

    .user-info {
        text-align: left;
    }

    .user-name {
        font-size: 14px;
        font-weight: 600;
        color: #1e293b;
    }

    .user-role {
        font-size: 12px;
        color: var(--text-muted);
    }

    /* Content Area */
    .manager-content {
        padding: 30px;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .manager-sidebar {
            transform: translateX(-100%);
        }

        .manager-sidebar.show {
            transform: translateX(0);
        }

        .manager-main {
            margin-left: 0;
        }

        .header-search {
            display: none;
        }
    }
</style>

<body>
    <div class="cms-admin-layout">

        <div class="main-content">        
            <main class="dashboard-body">
                <h1>Dashboard</h1>

                <div class="dashboard-widgets">
                    <div class="widget product-bg">
                        <div class="widget-content">
                            <span class="widget-number">${totalDevice}</span>
                            <span class="widget-title">Tổng số Sản phẩm</span>
                        </div>
                        <div class="widget-icon"><i class="fas fa-boxes"></i></div>
                    </div>

                    <div class="widget contract-bg" style="background-color: #f0ad4e;"> <div class="widget-content">
                            <span class="widget-number">${totalContract}</span>
                            <span class="widget-title">Tổng số Hợp đồng</span>
                        </div>
                        <div class="widget-icon"><i class="fas fa-file-contract"></i></div>
                    </div>

                    <div class="widget staff-bg">
                        <div class="widget-content">
                            <span class="widget-number">${totalCategory}</span>
                            <span class="widget-title">Tổng số thương hiệu</span>
                        </div>
                        <div class="widget-icon"><i class="fas fa-user-tie"></i></div>
                    </div>

                    <div class="widget customer-bg">
                        <div class="widget-content">
                            <span class="widget-number">${totalUser}</span>
                            <span class="widget-title">Tổng số Khách hàng</span>
                        </div>
                        <div class="widget-icon"><i class="fas fa-users"></i></div>
                    </div>
                </div>

                <div class="section-container">
                    <h3>Top 3 Khách hàng mua nhiều nhất (Doanh số)</h3>
                    <table class="data-table">
                        <thead class="text-center-col">
                            <tr>
                                <th>#</th>
                                <th >Tên Khách hàng</th>
                                <th >Email</th>
                                <th >Địa chỉ</th>
                                <th>Tổng số đơn đã mua</th>
                            </tr>
                        </thead>
                        <tbody > 
                            <c:forEach var="top" items="${topContractUser}" varStatus="loop">
                                <tr class="text-center-col">
                                    <td class="top-rank rank-${loop.count}"><i class="fas fa-trophy"></i> ${loop.count}</td>
                                    <td >${top.displayName}</td>
                                    <td >${top.email}</td>
                                    <td>${top.address}</td>
                                    <td >${top.totalContracts}</td>
                                </tr>
                            </c:forEach>                           
                        </tbody>
                    </table>
                </div>              

            </main>
        </div>
    </div>
</body>
<jsp:include page="managerFooter.jsp" />

