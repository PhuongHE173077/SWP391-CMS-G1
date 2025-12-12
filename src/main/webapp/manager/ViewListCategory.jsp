<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <jsp:include page="managerLayout.jsp">
            <jsp:param name="pageTitle" value="Device Category List" />
        </jsp:include>

        <style>
            .category-container {
                background: white;
                border-radius: 10px;
                padding: 30px;
                box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
            }

            .category-container h2 {
                text-align: center;
                color: #333;
                margin-bottom: 25px;
            }

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
                background: #10b981;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                transition: 0.2s;
            }

            .search-box button:hover {
                background: #059669;
            }

            .add-btn {
                display: inline-block;
                margin-bottom: 20px;
                background: #10b981;
                padding: 10px 15px;
                color: white;
                text-decoration: none;
                border-radius: 6px;
                transition: 0.2s;
            }

            .add-btn:hover {
                background: #059669;
            }

            .category-table {
                width: 100%;
                border-collapse: collapse;
                background: white;
                border-radius: 10px;
                overflow: hidden;
            }

            .category-table th {
                background: #1e293b;
                color: white;
                padding: 12px;
                text-align: left;
            }

            .category-table td {
                padding: 12px;
                border-bottom: 1px solid #eee;
            }

            .category-table tr:hover {
                background: #f1f5f9;
            }

            .pagination {
                text-align: center;
                margin-top: 25px;
            }

            .pagination a {
                margin: 0 5px;
                text-decoration: none;
                padding: 6px 12px;
                border-radius: 6px;
                border: 1px solid #10b981;
                color: #10b981;
                transition: 0.2s;
            }

            .pagination a:hover {
                background: #10b981;
                color: white;
            }

            .active-page {
                background: #10b981 !important;
                color: white !important;
            }

            .msg {
                text-align: center;
                font-size: 16px;
                margin-bottom: 15px;
            }

            .success {
                color: #10b981;
            }

            .error {
                color: #ef4444;
            }
        </style>

        <script>
            function confirmDelete(id) {
                if (confirm("Bạn có chắc chắn muốn xóa danh mục này?")) {
                    window.location.href = "DeleteCategory?id=" + id;
                }
            }
        </script>

        <div class="category-container">
            <h2>Danh sách danh mục sản phẩm</h2>

            <!-- MESSAGE -->
            <c:if test="${not empty sessionScope.success}">
                <p class="msg success">${sessionScope.success}</p>
            </c:if>

            <c:if test="${not empty sessionScope.error}">
                <p class="msg error">${sessionScope.error}</p>
            </c:if>

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
                <table class="category-table">
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
                                    style="color: #10b981; text-decoration:none; margin-right:10px;">
                                    Sửa
                                </a>
                                <a href="DeleteCategory?id=${c.id}"
                                    style="color: #ef4444; text-decoration:none; margin-right:10px;">
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
        </div>

        <jsp:include page="managerFooter.jsp" />