<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html>

        <head>
            <title>Device Category List</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background: #f2f2f2;
                    padding: 40px;
                }

                h2 {
                    text-align: center;
                    color: #333;
                    margin-bottom: 25px;
                }

                /* Search Box */
                .search-box {
                    text-align: center;
                    margin-bottom: 20px;
                }

                .search-box input[type=text] {
                    width: 300px;
                    padding: 10px;
                    border: 1px solid #ccc;
                    border-radius: 6px;
                }

                .search-box button {
                    padding: 10px 15px;
                    background: #007bff;
                    color: white;
                    border: none;
                    border-radius: 6px;
                    cursor: pointer;
                    transition: 0.2s;
                }

                .search-box button:hover {
                    background: #0056b3;
                }

                /* Add button */
                .add-btn {
                    display: inline-block;
                    margin-bottom: 20px;
                    background: #28a745;
                    padding: 10px 15px;
                    color: white;
                    text-decoration: none;
                    border-radius: 6px;
                    transition: 0.2s;
                }

                .add-btn:hover {
                    background: #1e7e34;
                }

                /* Table */
                table {
                    width: 70%;
                    margin: auto;
                    border-collapse: collapse;
                    background: white;
                    border-radius: 10px;
                    overflow: hidden;
                    box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
                }

                th {
                    background: #007bff;
                    color: white;
                    padding: 12px;
                }

                td {
                    padding: 12px;
                    border-bottom: 1px solid #eee;
                }

                tr:hover {
                    background: #f1f7ff;
                }

                /* Delete button */
                .delete-btn {
                    color: red;
                    cursor: pointer;
                    text-decoration: none;
                    margin-left: 10px;
                }

                /* Pagination */
                .pagination {
                    text-align: center;
                    margin-top: 25px;
                }

                .pagination a {
                    margin: 0 5px;
                    text-decoration: none;
                    padding: 6px 12px;
                    border-radius: 6px;
                    border: 1px solid #007bff;
                    color: #007bff;
                    transition: 0.2s;
                }

                .pagination a:hover {
                    background: #007bff;
                    color: white;
                }

                .active-page {
                    background: #007bff !important;
                    color: white !important;
                }

                /* Alert messages */
                .msg {
                    text-align: center;
                    font-size: 16px;
                    margin-bottom: 15px;
                }

                .success {
                    color: green;
                }

                .error {
                    color: red;
                }
            </style>

            <script>
                function confirmDelete(id) {
                    if (confirm("Bạn có chắc chắn muốn xóa danh mục này?")) {
                        window.location.href = "DeleteCategory?id=" + id;
                    }
                }
            </script>

        </head>

        <body>

            <h2>Danh sách danh mục sản phẩm</h2>

            <!-- MESSAGE -->
            <c:if test="${not empty sessionScope.success}">
                <p class="msg success">${sessionScope.success}</p>
            </c:if>

            <c:if test="${not empty sessionScope.error}">
                <p class="msg error">${sessionScope.error}</p>
            </c:if>

            <!-- Xóa thông báo sau khi hiển thị để khi F5 sẽ không còn hiện -->
            <% session.removeAttribute("success"); session.removeAttribute("error"); %>

                <!-- SEARCH FORM -->
                <div class="search-box">
                    <form action="ViewListCategory" method="get">
                        <input type="text" name="search" value="${search}" placeholder="Tìm theo tên...">
                        <button type="submit">Search</button>
                    </form>
                </div>

                <div style="text-align:center;">
                    <a href="AddCategory" class="add-btn">Thêm danh mục mới</a>
                </div>

                <!-- TABLE -->
                <table>
                    <tr>
                        <th>ID</th>
                        <th>Tên danh mục</th>
                        <th>Actions</th>
                    </tr>

                    <c:forEach items="${listCategory}" var="c">
                        <tr>
                            <td>${c.id}</td>
                            <td>${c.name}</td>
                            <td>
                                <a href="UpdateCategory?id=${c.id}"
                                    style="color: #007bff; text-decoration:none; margin-right:10px;">
                                    Sửa
                                </a>

                                <!-- DELETE BUTTON -->
                                <a href="DeleteCategory?id=${c.id}"
                                    style="color: red; text-decoration:none; margin-right:10px;">
                                    Xóa
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </table>

                <!-- PAGINATION -->
                <div class="pagination">
                    <c:forEach begin="1" end="${totalPage}" var="p">
                        <a href="ViewListCategory?page=${p}&search=${search}" class="${p == page ? 'active-page' : ''}">
                            ${p}
                        </a>
                    </c:forEach>
                </div>

        </body>

        </html>