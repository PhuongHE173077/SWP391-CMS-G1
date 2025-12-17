<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>${param.pageTitle != null ? param.pageTitle : 'Customer Portal'}</title>
                <!-- Bootstrap CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <!-- Font Awesome -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

                <style>
                    :root {
                        --sidebar-width: 260px;
                        --sidebar-bg: #1e293b;
                        --sidebar-hover: #334155;
                        --primary-color: #667eea;
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
                    .customer-sidebar {
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

                    .customer-sidebar.collapsed {
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

                    .customer-sidebar.collapsed .sidebar-logo span,
                    .customer-sidebar.collapsed .nav-text,
                    .customer-sidebar.collapsed .menu-title {
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
                    .customer-main {
                        margin-left: var(--sidebar-width);
                        min-height: 100vh;
                        transition: margin-left 0.3s ease;
                    }

                    .customer-main.expanded {
                        margin-left: 70px;
                    }

                    /* Top Header */
                    .customer-header {
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
                    .customer-content {
                        padding: 30px;
                    }

                    /* Responsive */
                    @media (max-width: 768px) {
                        .customer-sidebar {
                            transform: translateX(-100%);
                        }

                        .customer-sidebar.show {
                            transform: translateX(0);
                        }

                        .customer-main {
                            margin-left: 0;
                        }

                        .header-search {
                            display: none;
                        }
                    }
                </style>
            </head>

            <body>
                <!-- Sidebar -->
                <aside class="customer-sidebar" id="customerSidebar">
                    <div class="sidebar-header">
                        <a href="${pageContext.request.contextPath}/customer/ViewListContact" class="sidebar-logo">
                            <i class="fas fa-cube"></i>
                            <span>CMS Customer</span>
                        </a>
                        <button class="toggle-btn" onclick="toggleSidebar()">
                            <i class="fas fa-bars"></i>
                        </button>
                    </div>

                    <nav class="sidebar-nav">
                        <div class="menu-title">Main Menu</div>
                        <ul style="padding-left: 0;">
                            <li class="nav-item">
                                <a href="${pageContext.request.contextPath}/customer/ViewListContact" class="nav-link">
                                    <i class="fas fa-file-contract"></i>
                                    <span class="nav-text">Danh sách hợp đồng</span>
                                </a>
                            </li>
                        </ul>

                        <div class="menu-title">Bảo hành</div>
                        <ul style="padding-left: 0;">
                            <li class="nav-item">
                                <a href="${pageContext.request.contextPath}/customer-maintenance" class="nav-link">
                                    <i class="fas fa-tools"></i>
                                    <span class="nav-text">Yêu cầu bảo hành</span>
                                </a>
                            </li>
                        </ul>

                        <div class="menu-title">Hệ thống</div>
                        <ul style="padding-left: 0;">
                            <li class="nav-item">
                                <a href="${pageContext.request.contextPath}/LogOut" class="nav-link">
                                    <i class="fas fa-sign-out-alt"></i>
                                    <span class="nav-text">Đăng xuất</span>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </aside>

                <!-- Main Content Wrapper -->
                <div class="customer-main" id="customerMain">
                    <!-- Top Header -->
                    <header class="customer-header">
                        <div class="header-search">
                            <i class="fas fa-search"></i>
                            <input type="text" placeholder="Tìm kiếm...">
                        </div>

                        <div class="header-actions">
                            <div class="dropdown">
                                <div class="user-profile" data-bs-toggle="dropdown" aria-expanded="false">
                                    <div class="user-avatar">
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.user}">
                                                ${fn:toUpperCase(fn:substring(sessionScope.user.displayname, 0, 1))}
                                            </c:when>
                                            <c:otherwise>C</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="user-info">
                                        <div class="user-name">
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.user}">
                                                    ${sessionScope.user.displayname}
                                                </c:when>
                                                <c:otherwise>Customer</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <i class="fas fa-chevron-down" style="color: #64748b; font-size: 12px;"></i>
                                </div>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li>
                                        <a class="dropdown-item"
                                            href="${pageContext.request.contextPath}/ViewProfile">
                                            <i class="fas fa-user me-2"></i>Xem hồ sơ
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item"
                                            href="${pageContext.request.contextPath}/ChangePassword">
                                            <i class="fas fa-key me-2"></i>Đổi mật khẩu
                                        </a>
                                    </li>
                                    <li>
                                        <hr class="dropdown-divider">
                                    </li>
                                    <li>
                                        <a class="dropdown-item text-danger"
                                            href="${pageContext.request.contextPath}/LogOut">
                                            <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </header>

                    <!-- Page Content -->
                    <main class="customer-content">
