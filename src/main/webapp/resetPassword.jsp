<%-- Document : resetPassword Created on : Dec 5, 2025, 10:07:45 AM Author : Dell --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Đặt lại mật khẩu</title>
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

                    .password-toggle {
                        cursor: pointer;
                        position: absolute;
                        right: 15px;
                        top: 50%;
                        transform: translateY(-50%);
                        color: #6c757d;
                    }

                    .password-toggle:hover {
                        color: #667eea;
                    }

                    .password-field {
                        position: relative;
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
                        <div class="loading-text">Đang xử lý...</div>
                    </div>
                </div>

                <div class="container">
                    <div class="card">
                        <div class="card-header text-center">
                            <h3 class="mb-0">
                                <i class="fas fa-lock me-2"></i>Đặt lại mật khẩu mới
                            </h3>
                        </div>
                        <div class="card-body p-4">
                            <form action="ResetPassword" method="post" id="resetForm">
                                <div class="mb-3">
                                    <label for="newPass" class="form-label">
                                        <i class="fas fa-key me-2"></i>Mật khẩu mới
                                    </label>
                                    <div class="password-field">
                                        <input type="password" class="form-control form-control-lg" id="newPass"
                                            name="newPass" placeholder="Nhập mật khẩu mới" required>
                                        <span class="password-toggle"
                                            onclick="togglePassword('newPass', 'toggleNewPass')">
                                            <i class="fas fa-eye" id="toggleNewPass"></i>
                                        </span>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="confirmPass" class="form-label">
                                        <i class="fas fa-key me-2"></i>Xác nhận mật khẩu
                                    </label>
                                    <div class="password-field">
                                        <input type="password" class="form-control form-control-lg" id="confirmPass"
                                            name="confirmPass" placeholder="Nhập lại mật khẩu" required>
                                        <span class="password-toggle"
                                            onclick="togglePassword('confirmPass', 'toggleConfirmPass')">
                                            <i class="fas fa-eye" id="toggleConfirmPass"></i>
                                        </span>
                                    </div>
                                    <div id="passwordMatch" class="invalid-feedback d-none">
                                        Mật khẩu không khớp
                                    </div>
                                </div>

                                <div class="d-grid">
                                    <button type="submit" class="btn btn-primary btn-lg" id="submitBtn">
                                        <i class="fas fa-save me-2"></i>Lưu mật khẩu
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
                    </div>
                </div>

                <!-- Bootstrap JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    function togglePassword(inputId, iconId) {
                        const input = document.getElementById(inputId);
                        const icon = document.getElementById(iconId);

                        if (input.type === 'password') {
                            input.type = 'text';
                            icon.classList.remove('fa-eye');
                            icon.classList.add('fa-eye-slash');
                        } else {
                            input.type = 'password';
                            icon.classList.remove('fa-eye-slash');
                            icon.classList.add('fa-eye');
                        }
                    }

                    // Validate password match
                    document.getElementById('confirmPass').addEventListener('input', function () {
                        const newPass = document.getElementById('newPass').value;
                        const confirmPass = this.value;
                        const matchDiv = document.getElementById('passwordMatch');

                        if (confirmPass && newPass !== confirmPass) {
                            this.classList.add('is-invalid');
                            matchDiv.classList.remove('d-none');
                        } else {
                            this.classList.remove('is-invalid');
                            matchDiv.classList.add('d-none');
                        }
                    });

                    // Form validation
                    document.getElementById('resetForm').addEventListener('submit', function (e) {
                        const newPass = document.getElementById('newPass').value;
                        const confirmPass = document.getElementById('confirmPass').value;
                        const submitBtn = document.getElementById('submitBtn');
                        const loadingOverlay = document.getElementById('loadingOverlay');

                        if (newPass !== confirmPass) {
                            e.preventDefault();
                            alert('Mật khẩu không khớp. Vui lòng kiểm tra lại!');
                            return false;
                        }

                        // Show loading
                        loadingOverlay.classList.add('show');
                        submitBtn.disabled = true;
                        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Đang xử lý...';
                    });
                </script>
            </body>

            </html>