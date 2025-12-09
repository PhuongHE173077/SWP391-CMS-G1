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
        </style>
    </head>

    <body class="bg-light py-4">
        <div class="container-xl">
            <div class="row g-3">
                <!-- Left Panel -->
                <div class="col-lg-8 h-90vh">
                    <div class="card shadow-sm h-100">
                        <div class="card-header d-flex justify-content-between align-items-center bg-white">
                            <div class="d-flex align-items-center gap-2">
                                <button type="button" class="btn btn-outline-secondary btn-sm"
                                        onclick="window.history.back()">
                                    <i class="fas fa-arrow-left"></i>
                                </button>
                            </div>
                        </div>

                        <div class="card-body">
                            <!-- Search Bar -->
                            <div class="mb-3">
                                <div class="input-group">
                                    <span class="input-group-text bg-white"><i class="fas fa-search"></i></span>
                                    <input type="text" class="form-control"
                                           placeholder="Nhập SKU hoặc tên sản phẩm">
                                </div>
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
                                        <tr>
                                            <td>1</td>
                                            <td class="serial-col">SN001</td>
                                            <td>
                                                <img src="https://via.placeholder.com/60x60?text=Adidas"
                                                     alt="Product" class="product-img border">
                                            </td>
                                            <td>
                                                <div class="product-name">adidas Adizero Evo SLBlack White</div>
                                                <span class="product-link"><i
                                                        class="fas fa-arrow-right"></i></span>
                                            </td>
                                            <td>12</td>
                                            <td class="text-center">
                                                <button type="button"
                                                        class="btn btn-sm btn-warning">Xóa</button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>2</td>
                                            <td class="serial-col">SN002</td>
                                            <td>
                                                <img src="https://via.placeholder.com/60x60?text=Adidas2"
                                                     alt="Product" class="product-img border">
                                            </td>
                                            <td>
                                                <div class="product-name">adidas adiFOM SuperstarWhite Black
                                                </div>
                                                <span class="product-link"><i
                                                        class="fas fa-arrow-right"></i></span>
                                            </td>
                                            <td>12</td>
                                            <td class="text-center">
                                                <button type="button"
                                                        class="btn btn-sm btn-warning">Xóa</button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>3</td>
                                            <td class="serial-col">SN003</td>
                                            <td>
                                                <img src="https://via.placeholder.com/60x60?text=Tiger"
                                                     alt="Product" class="product-img border">
                                            </td>
                                            <td>
                                                <div class="product-name">Onitsuka TigerMexico 66 Slip-On
                                                    'Midnight'</div>
                                                <span class="product-link"><i
                                                        class="fas fa-arrow-right"></i></span>
                                            </td>
                                            <td>12</td>
                                            <td class="text-center">
                                                <button type="button"
                                                        class="btn btn-sm btn-warning">Xóa</button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Panel -->
                <div class="col-lg-4">
                    <div class="card shadow-sm h-100">
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
                                    <span class="me-2 text-muted" style="width: 110px;">Số điện thoại:</span>
                                    <span class="flex-grow-1"></span>
                                </div>
                                <div class="mb-2 small d-flex">
                                    <span class="me-2 text-muted" style="width: 110px;">Số đ.thoại khác:</span>
                                    <span class="flex-grow-1"></span>
                                </div>
                                <div class="mb-2 small d-flex">
                                    <span class="me-2 text-muted" style="width: 110px;">Địa chỉ:</span>
                                    <span class="flex-grow-1">123, Xã Cốc Pàng, Cao Bằng</span>
                                </div>

                                <div class="d-flex gap-2 mt-2">
                                    <!--                        <button class="btn-update">Cập nhật</button>-->
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
                                <textarea class="form-control" rows="3"></textarea>
                            </div>

                            <!-- Submit Button -->
                            <div class="mt-auto">
                                <button type="button" class="btn btn-primary w-100">Tạo hợp đồng</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script>
            const contextPath = '<%=request.getContextPath()%>';
            let debounceTimer;

            document.getElementById("searchUser").addEventListener("input", function () {
                const query = this.value;

                clearTimeout(debounceTimer);

                debounceTimer = setTimeout(() => {
                    searchUser(query);
                }, 300);
            });

            function searchUser(query) {
                if (query.trim() === "") {
                    document.getElementById("userResult").innerHTML = "";
                    return;
                }

                fetch(contextPath + "/search-user?keyword=" + encodeURIComponent(query))
                        .then(res => res.json())
                        .then(data => {
                            console.log(data);
                            renderUserResult(data);
                        })
                        .catch(err => console.error("Search user error:", err));
            }

            function renderUserResult(users) {
                const list = document.getElementById("userResult");
                list.innerHTML = "";

                if (!users || users.length === 0) {
                    const li = document.createElement("li");
                    li.className = "list-group-item text-muted cursor-pointer";
                    li.textContent = "Không tìm thấy người dùng";
                    list.appendChild(li);
                    return;
                }

                users.forEach(u => {
                    console.log("user", u);
                    const li = document.createElement("li");
                    li.className = "list-group-item list-group-item-action";
                    li.textContent = String(u.displayname);
                    li.onclick = () => selectUser(u);
                    list.appendChild(li);
                });
            }

            function selectUser(u) {
                
                const nameSpan = document.querySelector(".name");
                nameSpan.textContent = u.displayname;
                nameSpan.classList.remove('warning');


                document.getElementById("userResult").innerHTML = "";

                document.getElementById("searchUser").value = u.displayname;
            }

        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL"
        crossorigin="anonymous"></script>
    </body>

</html>