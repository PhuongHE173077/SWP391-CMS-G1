<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Tạo Yêu Cầu Bảo Trì</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
        crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            padding: 20px;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
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

        .contract-item-option {
            padding: 10px;
        }

        .contract-item-info {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .device-name {
            font-weight: 600;
            color: #212529;
        }

        .serial-id {
            color: #0d6efd;
            font-size: 0.9rem;
        }

        .contract-dates {
            color: #6c757d;
            font-size: 0.85rem;
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
</head>

<body>
    <div class="container">
        <div class="card">
            <div class="card-header">
                <h4><i class="fas fa-tools me-2"></i>Tạo Yêu Cầu Bảo Trì</h4>
            </div>
            <div class="card-body">
                <!-- Hiển thị thông báo -->
                <c:if test="${not empty sessionScope.msg}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${sessionScope.msg}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="msg" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="error" scope="session" />
                </c:if>

                <!-- Thông tin hướng dẫn -->
                <div class="info-box">
                    <i class="fas fa-info-circle"></i>
                    <strong>Hướng dẫn:</strong> Vui lòng chọn thiết bị từ hợp đồng của bạn và mô tả chi tiết vấn đề cần bảo trì.
                </div>

                <form action="CreateRequestMaintance" method="POST" id="maintenanceForm">
                    <!-- Tiêu đề yêu cầu -->
                    <div class="mb-4">
                        <label for="title" class="form-label">
                            Tiêu đề yêu cầu <span class="required">*</span>
                        </label>
                        <input type="text" class="form-control" id="title" name="title"
                               placeholder="Ví dụ: Máy in không hoạt động, Máy lạnh kêu to, ..." required>
                        <small class="text-muted">Nhập tiêu đề ngắn gọn mô tả vấn đề cần bảo trì</small>
                    </div>

                    <!-- Chọn Contract Item -->
                    <div class="mb-4">
                        <label for="contractItemId" class="form-label">
                            Chọn Thiết Bị <span class="required">*</span>
                        </label>
                        <select class="form-select" id="contractItemId" name="contractItemId" required>
                            <option value="">-- Chọn thiết bị --</option>
                            <c:if test="${not empty contractItems}">
                                <c:forEach var="item" items="${contractItems}">
                                    <c:if test="${item.subDevice != null && item.subDevice.device != null}">
                                        <option value="${item.id}" 
                                            data-device-name="${item.subDevice.device.name}"
                                            data-serial="${item.subDevice.seriId}"
                                            data-start-date="<fmt:formatDate value="${item.startAt}" pattern="dd/MM/yyyy" />"
                                            data-end-date="<fmt:formatDate value="${item.endDate}" pattern="dd/MM/yyyy" />">
                                            ${item.subDevice.device.name} - 
                                            Serial: ${item.subDevice.seriId} 
                                            (<fmt:formatDate value="${item.startAt}" pattern="dd/MM/yyyy" /> - 
                                            <fmt:formatDate value="${item.endDate}" pattern="dd/MM/yyyy" />)
                                        </option>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </select>
                        <c:if test="${empty contractItems}">
                            <div class="alert alert-warning mt-2" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                Bạn chưa có thiết bị nào trong hợp đồng. Vui lòng liên hệ với nhân viên để được hỗ trợ.
                            </div>
                        </c:if>
                        <small class="text-muted">Chọn thiết bị từ hợp đồng của bạn để tạo yêu cầu bảo trì</small>
                    </div>

                    <!-- Hiển thị thông tin thiết bị đã chọn -->
                    <div id="selectedDeviceInfo" class="mb-4" style="display: none;">
                        <div class="card bg-light">
                            <div class="card-body">
                                <h6 class="card-title"><i class="fas fa-info-circle me-2"></i>Thông tin thiết bị đã chọn:</h6>
                                <div class="row mt-3">
                                    <div class="col-md-6">
                                        <strong>Tên thiết bị:</strong>
                                        <p id="deviceName" class="mb-0"></p>
                                    </div>
                                    <div class="col-md-6">
                                        <strong>Số Serial:</strong>
                                        <p id="serialId" class="mb-0"></p>
                                    </div>
                                </div>
                                <div class="row mt-2">
                                    <div class="col-md-6">
                                        <strong>Ngày bắt đầu:</strong>
                                        <p id="startDate" class="mb-0"></p>
                                    </div>
                                    <div class="col-md-6">
                                        <strong>Ngày kết thúc:</strong>
                                        <p id="endDate" class="mb-0"></p>
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
                        <small class="text-muted">Vui lòng mô tả chi tiết vấn đề cần bảo trì để chúng tôi có thể hỗ trợ bạn tốt nhất</small>
                    </div>

                    <!-- Ảnh minh họa (URL) -->
                    <div class="mb-4">
                        <label for="image" class="form-label">
                            Ảnh minh họa (URL)
                        </label>
                        <input type="text" class="form-control" id="image" name="image"
                               placeholder="Dán link ảnh mô tả lỗi vào đấy">
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

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL"
        crossorigin="anonymous"></script>

    <script>
        // Hiển thị thông tin thiết bị khi chọn
        document.getElementById('contractItemId').addEventListener('change', function() {
            const selectedOption = this.options[this.selectedIndex];
            const infoDiv = document.getElementById('selectedDeviceInfo');
            
            if (this.value && selectedOption.dataset.deviceName) {
                document.getElementById('deviceName').textContent = selectedOption.dataset.deviceName;
                document.getElementById('serialId').textContent = selectedOption.dataset.serial;
                document.getElementById('startDate').textContent = selectedOption.dataset.startDate;
                document.getElementById('endDate').textContent = selectedOption.dataset.endDate;
                infoDiv.style.display = 'block';
            } else {
                infoDiv.style.display = 'none';
            }
        });

        // Validation form
        document.getElementById('maintenanceForm').addEventListener('submit', function(e) {
            const title = document.getElementById('title').value.trim();
            const contractItemId = document.getElementById('contractItemId').value;
            const content = document.getElementById('content').value.trim();

            if (!title) {
                e.preventDefault();
                alert('Vui lòng nhập tiêu đề yêu cầu!');
                return false;
            }

            if (!contractItemId) {
                e.preventDefault();
                alert('Vui lòng chọn thiết bị!');
                return false;
            }

            if (!content || content.length < 10) {
                e.preventDefault();
                alert('Vui lòng nhập nội dung yêu cầu (ít nhất 10 ký tự)!');
                return false;
            }
        });
    </script>
</body>

</html>

