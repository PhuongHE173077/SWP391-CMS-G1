<%-- Document : update-mantenance Created on : Dec 16, 2025, 11:08:42 PM Author : admin --%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update Maintenance Request</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
              rel="stylesheet">
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <style>
            body {
                background-color: #f5f5f5;
            }

            .back-btn {
                position: fixed;
                left: 20px;
                top: 10px;
            }

            .preview-image {
                max-width: 200px;
                max-height: 200px;
                object-fit: cover;
                border-radius: 2px;
                border: 1px solid #ccc;
            }

            .device-info {
                background-color: #343a40;
                color: white;
                border-radius: 2px;
            }

            .card {
                border-radius: 2px;
                border: 1px solid #ddd;
            }

            .card-header {
                border-radius: 0;
            }

            .form-control {
                border-radius: 2px;
            }

            .btn {
                border-radius: 2px;
            }

            .alert {
                border-radius: 2px;
            }

            .badge {
                border-radius: 2px;
            }
        </style>
    </head>

    <body>
        <!-- Back Button - Outside Container -->
        <a href="${pageContext.request.contextPath}/customer-maintenance"
           class="btn btn-outline-secondary back-btn">
            <i class="fas fa-arrow-left me-2"></i>Back
        </a>

        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <!-- Header -->


                    <!-- Error Message -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Device Info Card -->
                    <div class="card device-info shadow-sm mb-4">
                        <div class="card-body">
                            <h5 class="card-title mb-3">
                                <i class="fas fa-laptop me-2"></i>Device Information
                            </h5>
                            
                            <div class="row">
                                <div class="col-md-4">
                                <img src="${empty maintenanceRequest.contractItem.subDevice.device.image 
                                        ? 'https://sudospaces.com/phonglien-vn/2025/11/motokawa-mdg-9800se-1-large.png'
                                        : maintenanceRequest.contractItem.subDevice.device.image}" alt="alt" width="80"/>
                                </div>
                                <div class="col-md-4">
                                    <p class="mb-2">
                                        <strong><i class="fas fa-tag me-2"></i>Device Name:</strong><br>
                                        <span
                                            class="fs-5">${maintenanceRequest.contractItem.subDevice.device.name}</span>
                                    </p>
                                </div>
                                <div class="col-md-4">
                                    <p class="mb-2">
                                        <strong><i class="fas fa-barcode me-2"></i>Serial
                                            Number:</strong><br>
                                        <span
                                            class="fs-5">${maintenanceRequest.contractItem.subDevice.seriId}</span>
                                    </p>
                                </div>
                            </div>
                            

                        </div>
                    </div>

                    <!-- Update Form -->
                    <div class="card shadow-sm">
                        <div class="card-header bg-white py-3">
                            <h5 class="mb-0 text-secondary">
                                <i class="fas fa-file-alt me-2"></i>Request Details
                            </h5>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/UpdateMaintainaceRequest"
                                  method="post" enctype="multipart/form-data">
                                <input type="hidden" name="id" value="${maintenanceRequest.id}">

                                <!-- Title -->
                                <div class="mb-4">
                                    <label for="title" class="form-label fw-bold">
                                        <i class="fas fa-heading me-1"></i>Title <span
                                            class="text-danger">*</span>
                                    </label>
                                    <input type="text" class="form-control form-control-lg" id="title"
                                           name="title" value="${maintenanceRequest.title}" required
                                           placeholder="Enter request title">
                                </div>

                                <!-- Content -->
                                <div class="mb-4">
                                    <label for="content" class="form-label fw-bold">
                                        <i class="fas fa-align-left me-1"></i>Description <span
                                            class="text-danger">*</span>
                                    </label>
                                    <textarea class="form-control" id="content" name="content" rows="5"
                                              required
                                              placeholder="Describe the issue in detail...">${maintenanceRequest.content}</textarea>
                                    <div class="form-text">Please provide detailed information about the
                                        maintenance issue.</div>
                                </div>

                                <!-- Current Image -->
                                <c:if test="${not empty maintenanceRequest.image}">
                                    <div class="mb-3">
                                        <label class="form-label fw-bold">
                                            <i class="fas fa-image me-1"></i>Current Image
                                        </label>
                                        <div>
                                            <img src="${pageContext.request.contextPath}/${maintenanceRequest.image}"
                                                 alt="Current Image" class="preview-image">
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Upload New Image -->
                                <div class="mb-4">
                                    <label for="image" class="form-label fw-bold">
                                        <i class="fas fa-upload me-1"></i>Upload New Image (Optional)
                                    </label>
                                    <input type="file" class="form-control" id="image" name="image"
                                           accept="image/*">
                                    <div class="form-text">Leave empty to keep the current image. Supported
                                        formats: JPG, PNG, GIF (Max: 10MB)</div>
                                </div>

                                <!-- Image Preview -->
                                <div class="mb-4" id="imagePreviewContainer" style="display: none;">
                                    <label class="form-label fw-bold">
                                        <i class="fas fa-eye me-1"></i>New Image Preview
                                    </label>
                                    <div>
                                        <img id="imagePreview" src="" alt="Preview" class="preview-image">
                                    </div>
                                </div>

                                <!-- Buttons -->
                                <div class="d-flex gap-3 justify-content-end pt-3 border-top">
                                    <a href="${pageContext.request.contextPath}/customer-maintenance"
                                       class="btn btn-outline-secondary btn-lg">
                                        <i class="fas fa-times me-2"></i>Cancel
                                    </a>
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        <i class="fas fa-save me-2"></i>Update Request
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Image preview
            document.getElementById('image').addEventListener('change', function (e) {
                const file = e.target.files[0];
                const previewContainer = document.getElementById('imagePreviewContainer');
                const preview = document.getElementById('imagePreview');

                if (file) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        preview.src = e.target.result;
                        previewContainer.style.display = 'block';
                    };
                    reader.readAsDataURL(file);
                } else {
                    previewContainer.style.display = 'none';
                }
            });
        </script>
    </body>

</html>