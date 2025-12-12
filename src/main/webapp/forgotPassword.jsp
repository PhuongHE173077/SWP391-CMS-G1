<%-- Document : forgotPassword Created on : Dec 5, 2025, 10:03:52 AM Author : Dell --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Quên mật khẩu</title>
                <!-- Bootstrap CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <!-- Font Awesome -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
                <style>
                    * {
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                    }

                    html,
                    body {
                        height: 100%;
                        width: 100%;
                    }

                    body {
                        min-height: 100vh;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        padding: 20px;
                    }

                    .container {
                        width: 100%;
                        max-width: 450px;
                        margin: 0 auto;
                        padding: 0;
                    }

                    .card {
                        border: none;
                        border-radius: 15px;
                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
                        width: 100%;
                    }

                    .card-header {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        border-radius: 15px 15px 0 0 !important;
                        padding: 1.5rem;
                    }

                    .btn-primary {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        border: none;
                        padding: 10px 30px;
                        position: relative;
                    }

                    .btn-primary:hover:not(:disabled) {
                        background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
                        transform: translateY(-2px);
                        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
                    }

                    .btn-primary:disabled {
                        opacity: 0.7;
                        cursor: not-allowed;
                    }

                    .form-control:focus {
                        border-color: #667eea;
                        box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
                    }

                    /* Loading Overlay */
                    .loading-overlay {
                        display: none;
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(0, 0, 0, 0.5);
                        z-index: 9999;
                        justify-content: center;
                        align-items: center;
                    }

                    .loading-overlay.show {
                        display: flex;
                    }

                    .spinner-container {
                        background: white;
                        padding: 30px 40px;
                        border-radius: 15px;
                        text-align: center;
                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
                    }

                    .spinner-border {
                        width: 3rem;
                        height: 3rem;
                        border-width: 0.3em;
                        color: #667eea;
                    }

                    .loading-text {
                        margin-top: 15px;
                        color: #333;
                        font-weight: 500;
                    }
                </style>
            </head>

            <body>
                <!-- Loading Overlay -->
                <div class="loading-overlay" id="loadingOverlay">
                    <div class="spinner-container">
                        <div class="spinner-border" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        <div class="loading-text">Đang gửi email...</div>
                    </div>
                </div>

                <div class="container">
                    <div class="card">
                        <div class="card-header text-center">
                            <h3 class="mb-0">
                                <i class="fas fa-key me-2"></i>Quên mật khẩu
                            </h3>
                        </div>
                        <div class="card-body p-4">
                            <form action="ForgotPassword" method="post" id="forgotPasswordForm">
                                <div class="mb-3">
                                    <label for="email" class="form-label">
                                        <i class="fas fa-envelope me-2"></i>Email
                                    </label>
                                    <input type="email" class="form-control form-control-lg" id="email" name="email"
                                        placeholder="Nhập email của bạn" required>
                                </div>

                                <div class="d-grid">
                                    <button type="submit" class="btn btn-primary btn-lg" id="submitBtn">
                                        <i class="fas fa-paper-plane me-2"></i>Gửi mã xác nhận
                                    </button>
                                </div>

                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger mt-3 mb-0" role="alert">
                                        <i class="fas fa-exclamation-circle me-2"></i>${error}
                                    </div>
                                </c:if>
                                <c:if test="${not empty success}">
                                    <div class="alert alert-success mt-3 mb-0" role="alert">
                                        <i class="fas fa-check-circle me-2"></i>${success}
                                    </div>
                                </c:if>
                            </form>
                        </div>
                        <div class="card-footer text-center bg-transparent">
                            <a href="login.jsp" class="text-decoration-none">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại đăng nhập
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Bootstrap JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    document.getElementById('forgotPasswordForm').addEventListener('submit', function (e) {
                        const submitBtn = document.getElementById('submitBtn');
                        const loadingOverlay = document.getElementById('loadingOverlay');

                        // Show loading
                        loadingOverlay.classList.add('show');
                        submitBtn.disabled = true;
                        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Đang gửi...';

                        // Form will submit normally, loading will be hidden when page reloads
                    });
                </script>
            </body>

            </html>