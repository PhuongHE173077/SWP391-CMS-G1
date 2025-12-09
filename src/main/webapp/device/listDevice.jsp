<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>List Device </title>
    <style>
        /* CSS cơ bản để tạo kiểu */
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f4f4f4;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            border: 1px solid #ddd;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        /* Phần tiêu đề và nút Add Device */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .header h1 {
            font-size: 24px;
            font-weight: bold;
            color: #333;
        }

        .add-device-btn {
            padding: 8px 15px;
            background-color: #ddd; /* Màu xám nhạt */
            border: 1px solid #ccc;
            border-radius: 3px;
            cursor: pointer;
            text-decoration: none;
            color: #333;
            font-size: 14px;
        }

        .add-device-btn:hover {
            background-color: #ccc;
        }

        /* Phần thanh lọc/tìm kiếm */
        .filter-bar {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }

        .filter-bar select {
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 3px;
            background-color: #fff;
            appearance: none; /* Ẩn mũi tên mặc định của select */
            -webkit-appearance: none;
            -moz-appearance: none;
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="10" height="10" fill="#333" viewBox="0 0 16 16"><path d="M7.247 11.14 2.451 5.658C1.885 5.018 2.305 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z"/></svg>');
            background-repeat: no-repeat;
            background-position: right 8px center;
            padding-right: 25px;
        }

        /* Phần bảng */
        .device-table {
            width: 100%;
            border-collapse: collapse;
            /* Tạo kiểu màu kem cho bảng */
            background-color: #f7f3ed; /* Màu nền giống như hình ảnh */
            border: 1px solid #bba078; /* Viền nâu nhạt */
        }

        .device-table th, .device-table td {
            border: 1px solid #bba078;
            padding: 10px;
            text-align: left;
        }

        .device-table th {
            background-color: #e8e4dc; /* Màu nền cho tiêu đề */
            font-weight: bold;
            color: #333;
        }

        .device-table .action-col {
            text-align: center;
            width: 380px;
            display: flex; 
            justify-content: space-around; 
            align-items: center;
            padding: 19px;
            padding-left: 0px;
        }

        .action-col button {
            display: inline-block; 
            width: auto; 
            padding: 5px 10px;
            margin: 0 3px;
            background-color: #e0e0e0; /* Nền nút xám nhạt */
            border: 1px solid #ccc;
            border-radius: 3px;
            cursor: pointer;
            font-size: 13px;
            color: #333;
            white-space: nowrap;
        }

        .action-col button:hover {
            background-color: #d0d0d0;
        }

        /* Phân trang */
        .pagination {
            margin-top: 20px;
            text-align: left;
        }

        .pagination a {
            margin-right: 5px;
            text-decoration: none;
            color: #007bff; /* Màu xanh */
            font-size: 14px;
        }

        .pagination a:nth-child(1) { /* Trang 1 hiện tại */
             font-weight: bold;
             color: #333; /* Màu đậm hơn cho trang hiện tại */
        }
        
    </style>
</head>
<body>

    <div class="container">
        
        <div class="header">
            <h1>List Device</h1>
            <button class="add-device-btn">Add Device</button>
        </div>

        <div class="filter-bar">
            <select name="name">
                <option value="">Name</option>
                </select>
            <select name="maintenance_time">
                <option value="">Maintance_time</option>
                </select>
            <select name="category">
                <option value="">Category</option>
                </select>
        </div>

        <table class="device-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Image</th>
                    <th>Maintance_time</th>
                    <th>Created At</th>
                    <th class="action-col">Action</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td class="action-col">
                        <button>View Detail</button>
                        <button>Edit Device</button>
                        <button>Delete Device</button>
                    </td>
                </tr>
                </tbody>
        </table>

        <div class="pagination">
            <a href="#">1</a>
            <a href="#">&gt;</a>
            <a href="#">2</a>
            <a href="#">&gt;</a>
            <a href="#">3</a>
        </div>

    </div>

</body>
</html>