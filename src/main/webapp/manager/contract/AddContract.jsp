<%-- Document : AddContract Created on : Dec 9, 2025, 11:47:36 AM Author : admin --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Tạo Đơn Hàng</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
                    integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
                    crossorigin="anonymous">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
                <style>
                    .h-90vh {
                        height: 90vh;
                    }

                    .product-img {
                        width: 60px;
                        height: 60px;
                        object-fit: cover;
                        border-radius: 0.5rem;
                    }

                    .serial-col {
                        color: #0d6efd;
                        font-size: 0.8rem;
                    }

                    .product-name {
                        font-weight: 500;
                    }

                    .product-link {
                        color: #fd7e14;
                        font-size: 0.8rem;
                        cursor: pointer;
                    }

                    .summary-label {
                        color: #6c757d;
                    }

                    .summary-value {
                        font-weight: 500;
                    }

                    .name.warning {
                        color: #dc3545;
                    }

                    #userResult {
                        max-height: 250px;
                        overflow-y: auto;
                        position: absolute;
                        z-index: 9999;
                        width: 400px;
                    }


                    #subDeviceResult {
                        max-height: 300px;
                        overflow-y: auto;
                        position: absolute;
                        z-index: 9999;
                        width: calc(100% - 2rem);
                        background: white;
                    }

                    .subdevice-item {
                        cursor: pointer;
                    }

                    .subdevice-item:hover {
                        background-color: #f8f9fa;
                    }
                </style>
            </head>


            <body class="bg-light py-4 position-relative">
                <div class="position-absolute d-flex justify-content-between align-items-center bg-white"
                    style="top: 10px; left: 10px;">
                    <div class="d-flex align-items-center gap-2">
                        <button type="button" class="btn btn-outline-secondary btn-sm" onclick="window.history.back()">
                            <i class="fas fa-arrow-left"></i>
                            Back
                        </button>
                    </div>
                </div>
                <div class="container-xl ">

                    <div class="row g-3">
                        <!-- Left Panel -->
                        <div class="col-lg-8 h-90vh">
                            <div class="border p-2 shadow-sm h-100">


                                <div class="card-body">
                                    <!-- Search Bar -->
                                    <div class="mb-3 position-relative">
                                        <div class="input-group">
                                            <span class="input-group-text bg-white"><i class="fas fa-search"></i></span>
                                            <input type="text" class="form-control" id="searchSubDevice"
                                                placeholder="Nhập số seri thiết bị">
                                        </div>
                                        <ul id="subDeviceResult" class="list-group mt-2"></ul>
                                    </div>

                                    <!-- Product Table -->
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle">
                                            <thead class="table-light">
                                                <tr>
                                                    <th scope="col" style="width: 60px;">STT</th>
                                                    <th scope="col">Số Seri</th>
                                                    <th scope="col">Ảnh</th>
                                                    <th scope="col">Sản phẩm</th>
                                                    <th scope="col">Thời gian hành</th>
                                                    <th scope="col" class="text-center">Chức năng</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <!-- Rows will be added dynamically via JavaScript -->
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Right Panel -->
                        <div class="col-lg-4">
                            <div class="border p-2
                         shadow-sm h-100">
                                <div class="card-body d-flex flex-column">
                                    <!-- Customer Info -->
                                    <div class="mb-3">
                                        <div class="input-group mb-3">
                                            <span class="input-group-text bg-white"><i class="fas fa-search"></i></span>
                                            <input type="text" class="form-control" id="searchUser"
                                                placeholder="Nhập tên, SĐT hoặc email">
                                            <button class="btn btn-success" type="button"><i
                                                    class="fas fa-plus"></i></button>
                                        </div>
                                        <ul id="userResult" class="list-group mt-2"></ul>

                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <h6 class="mb-0">
                                                Họ &amp; Tên:
                                                <span class="name warning">Chưa có thông tin</span>
                                            </h6>
                                            <button type="button" class="btn btn-link text-danger p-0"><i
                                                    class="fas fa-times"></i></button>
                                        </div>

                                        <div class="mb-2 small d-flex">
                                            <h6 class="me-2" style="width: 110px;">Số đ.thoại:</h6>
                                            <h6 class="phone flex-grow-1"></h6>
                                        </div>

                                        <div class="mb-2 small d-flex">
                                            <h6 class="me-2 text-muted" style="width: 110px;">Địa chỉ:</h6>
                                            <h6 class="flex-grow-1"></h6>
                                        </div>

                                        <div class="d-flex gap-2 mt-2">
                                            <!--                        <button class="btn-update">Cập nhật</button>-->
                                        </div>
                                    </div>

                                    <!-- Order Summary -->
                                    <div class="border-top pt-3 mb-3">
                                        <div class="d-flex justify-content-between mb-2 small">
                                            <span class="summary-label">Tổng sản phẩm:</span>
                                            <span class="summary-value">0 sp</span>
                                        </div>
                                    </div>

                                    <!-- Payment Section -->
                                    <div class="mb-3">
                                        <label class="form-label mb-1">Nội dung hợp đồng</label>
                                        <textarea id="myText" class="form-control" rows="6"></textarea>
                                    </div>

                                    <!-- Submit Button -->
                                    <div class="mt-auto">
                                        <button type="button" class="btn btn-primary w-100">Tạo hợp đồng</button>
                                    </div>
                                </div>
                            </div>

                            <!-- Order Summary -->
                            <div class="border-top pt-3 mb-3">
                                <div class="d-flex justify-content-between mb-2 small">
                                    <span class="summary-label">Tổng sản phẩm:</span>
                                    <span class="summary-value">10 sp</span>
                                </div>
                            </div>

                            <!-- Payment Section -->
                            <div class="mb-3">
                                <label class="form-label mb-1">Nội dung hợp đồng</label>
                                <textarea id="myText" class="form-control" rows="6"></textarea>
                            </div>

                            <!-- Submit Button -->
                            <div class="mt-auto">
                                <button type="button" class="btn btn-primary w-100">Tạo hợp đồng</button>

                            </div>
                        </div>
                    </div>
                </div>

                <script
                    src="${pageContext.request.contextPath}/assets/js/add-contract/add-contract.js?v=<%=System.currentTimeMillis()%>"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
                    integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL"
                    crossorigin="anonymous"></script>
            </body>

            </html>