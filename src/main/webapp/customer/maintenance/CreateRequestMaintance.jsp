<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <jsp:include page="../customerLayout.jsp">
                <jsp:param name="pageTitle" value="Tạo Yêu Cầu Bảo Trì" />
            </jsp:include>

            <style>
                .page-header {
                    margin-bottom: 1.5rem;
                }

                .page-header h2 {
                    color: #1e293b;
                    font-weight: 600;
                }

                .card {
                    border: none;
                    border-radius: 12px;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                    margin-bottom: 20px;
                }

                .card-header {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                    border-radius: 12px 12px 0 0 !important;
                    padding: 20px;
                }

                .card-header h4 {
                    margin: 0;
                    font-weight: 600;
                }

                .card-body {
                    padding: 30px;
                }

                .form-label {
                    font-weight: 600;
                    color: #495057;
                    margin-bottom: 8px;
                }

                .form-control,
                .form-select {
                    border-radius: 8px;
                    border: 1px solid #dee2e6;
                    padding: 10px 15px;
                    transition: all 0.3s;
                }

                .form-control:focus,
                .form-select:focus {
                    border-color: #667eea;
                    box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
                }

                textarea.form-control {
                    min-height: 150px;
                    resize: vertical;
                }

                .btn-submit {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    border: none;
                    color: white;
                    padding: 12px 30px;
                    border-radius: 8px;
                    font-weight: 600;
                    transition: transform 0.2s, box-shadow 0.2s;
                }

                .btn-submit:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
                    color: white;
                }

                .btn-cancel {
                    background-color: #6c757d;
                    border: none;
                    color: white;
                    padding: 12px 30px;
                    border-radius: 8px;
                    font-weight: 600;
                }

                .btn-cancel:hover {
                    background-color: #5a6268;
                    color: white;
                }

                .alert {
                    border-radius: 8px;
                    border: none;
                }

                .required {
                    color: #dc3545;
                }

                .info-box {
                    background-color: #e7f3ff;
                    border-left: 4px solid #0d6efd;
                    padding: 15px;
                    border-radius: 6px;
                    margin-bottom: 20px;
                }

                .info-box i {
                    color: #0d6efd;
                    margin-right: 8px;
                }
            </style>

            <!-- Page Header -->
            <div class="page-header">
                <h2><i class="fas fa-tools me-2" style="color: #667eea;"></i>Tạo Yêu Cầu Bảo Trì</h2>
            </div>

            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <div class="card">
                        <div class="card-header">
                            <h4><i class="fas fa-tools me-2"></i>Tạo Yêu Cầu Bảo Trì</h4>
                        </div>
                        <div class="card-body">
                            <!-- Hiển thị thông báo -->
                            <c:if test="${not empty sessionScope.msg}">
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    <i class="fas fa-check-circle me-2"></i>${sessionScope.msg}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                                </div>
                                <c:remove var="msg" scope="session" />
                            </c:if>
                            <c:if test="${not empty sessionScope.error}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                                </div>
                                <c:remove var="error" scope="session" />
                            </c:if>

                            <!-- Thông tin hướng dẫn -->
                            <div class="info-box">
                                <i class="fas fa-info-circle"></i>
                                <strong>Hướng dẫn:</strong> Vui lòng kiểm tra lại thông tin thiết bị trong hợp đồng
                                của bạn và mô tả chi tiết vấn đề cần bảo trì.
                            </div>

                            <form action="CreateRequestMaintance" method="POST" id="maintenanceForm"
                                enctype="multipart/form-data">
                                <!-- Ẩn contractItemId để gửi theo form -->
                                <input type="hidden" name="contractItemId" id="contractItemId"
                                    value="${contractItem.id}" />
                                <!-- Tiêu đề yêu cầu -->
                                <div class="mb-4">
                                    <label for="title" class="form-label">
                                        Tiêu đề yêu cầu <span class="required">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="title" name="title"
                                        placeholder="Ví dụ: Máy in không hoạt động, Máy lạnh kêu to, ..." required>
                                    <small class="text-muted">Nhập tiêu đề ngắn gọn mô tả vấn đề cần bảo trì</small>
                                </div>

                                <!-- Thông tin thiết bị trong hợp đồng (hiển thị cố định) -->
                                <div class="mb-4">
                                    <div class="card bg-light">
                                        <div class="card-body">
                                            <h6 class="card-title"><i class="fas fa-info-circle me-2"></i>Thông tin
                                                thiết bị bảo hành:</h6>
                                            <div class="row mt-3">
                                                <div class="col-md-6">
                                                    <strong>Tên thiết bị:</strong>
                                                    <p class="mb-0">
                                                        <c:out value="${contractItem.subDevice.device.name}" />
                                                    </p>
                                                </div>
                                                <div class="col-md-6">
                                                    <strong>Số Serial:</strong>
                                                    <p class="mb-0">
                                                        <c:out value="${contractItem.subDevice.seriId}" />
                                                    </p>
                                                </div>
                                            </div>
                                            <div class="row mt-2">
                                                <div class="col-md-6">
                                                    <strong>Ngày bắt đầu:</strong>
                                                    <p class="mb-0">
                                                        <fmt:formatDate value="${contractItem.startAt}"
                                                            pattern="dd/MM/yyyy" />
                                                    </p>
                                                </div>
                                                <div class="col-md-6">
                                                    <strong>Ngày kết thúc:</strong>
                                                    <p class="mb-0">
                                                        <fmt:formatDate value="${contractItem.endDate}"
                                                            pattern="dd/MM/yyyy" />
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Nội dung yêu cầu -->
                                <div class="mb-4">
                                    <label for="content" class="form-label">
                                        Nội dung Yêu Cầu <span class="required">*</span>
                                    </label>
                                    <textarea class="form-control" id="content" name="content" rows="6"
                                        placeholder="Mô tả chi tiết vấn đề cần bảo trì, các triệu chứng, thời gian xảy ra vấn đề, v.v..."
                                        required></textarea>
                                    <small class="text-muted">Vui lòng mô tả chi tiết vấn đề cần bảo trì để chúng
                                        tôi có thể hỗ trợ bạn tốt nhất</small>
                                </div>


                                <div class="mb-4">
                                    <label for="image" class="form-label">
                                        Ảnh minh họa
                                    </label>
                                    <input type="file" class="form-control" id="image" name="image" accept="image/*">
                                    <small class="text-muted">Chọn ảnh mô tả lỗi (JPG, PNG, GIF - tối đa
                                        10MB)</small>
                                    <!-- Preview ảnh -->
                                    <div id="imagePreview" class="mt-3" style="display: none;">
                                        <img id="previewImg" src="" alt="Preview" class="img-thumbnail"
                                            style="max-width: 300px; max-height: 300px;">
                                    </div>
                                </div>

                                <!-- Nút hành động -->
                                <div class="d-flex justify-content-between gap-3">
                                    <a href="javascript:history.back()" class="btn btn-cancel">
                                        <i class="fas fa-times me-2"></i>Hủy
                                    </a>
                                    <button type="submit" class="btn btn-submit">
                                        <i class="fas fa-paper-plane me-2"></i>Gửi Yêu Cầu
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                document.getElementById('image').addEventListener('change', function (e) {
                    const file = e.target.files[0];
                    if (file) {
                        if (file.size > 10 * 1024 * 1024) {
                            alert('Kích thước file không được vượt quá 10MB!');
                            e.target.value = '';
                            document.getElementById('imagePreview').style.display = 'none';
                            return;
                        }
                        if (!file.type.startsWith('image/')) {
                            alert('Vui lòng chọn file ảnh!');
                            e.target.value = '';
                            document.getElementById('imagePreview').style.display = 'none';
                            return;
                        }
                        const reader = new FileReader();
                        reader.onload = function (e) {
                            document.getElementById('previewImg').src = e.target.result;
                            document.getElementById('imagePreview').style.display = 'block';
                        };
                        reader.readAsDataURL(file);
                    } else {
                        document.getElementById('imagePreview').style.display = 'none';
                    }
                });

                document.getElementById('maintenanceForm').addEventListener('submit', function (e) {
                    const title = document.getElementById('title').value.trim();
                    const content = document.getElementById('content').value.trim();
                    const imageFile = document.getElementById('image').files[0];

                    if (!title) {
                        e.preventDefault();
                        alert('Vui lòng nhập tiêu đề yêu cầu!');
                        return false;
                    }
                    if (!content || content.length < 10) {
                        e.preventDefault();
                        alert('Vui lòng nhập nội dung yêu cầu (ít nhất 10 ký tự)!');
                        return false;
                    }
                    if (imageFile && imageFile.size > 10 * 1024 * 1024) {
                        e.preventDefault();
                        alert('Kích thước file không được vượt quá 10MB!');
                        return false;
                    }
                });
            </script>

            <jsp:include page="../customerFooter.jsp" />