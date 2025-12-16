/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.MaintenanceRequestDAO;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.MaintanceRequest;
import model.Users;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "SellerViewMaintenanceRequestServlet", urlPatterns = {"/seller-maintenance"})
public class SellerViewMaintenanceRequestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String MAINTENANCE_LIST_URL = "manager/maintenance/seller-maintenance.jsp";
        // 1. Nhận tham số từ Request
        String search = request.getParameter("search");
        String status = request.getParameter("status");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String customerIdRaw = request.getParameter("customerId");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        String pageRaw = request.getParameter("page");

        // 2. Xử lý giá trị mặc định
        int customerId = 0;
        try {
            if (customerIdRaw != null && !customerIdRaw.isEmpty()) {
                customerId = Integer.parseInt(customerIdRaw);
            }
        } catch (NumberFormatException e) {
            customerId = 0;
        }

        if (sortBy == null) {
            sortBy = "created_at"; // Mặc định sort theo ngày
        }
        if (sortOrder == null) {
            sortOrder = "DESC"; // Mới nhất lên đầu
        }
        int pageIndex = 1;
        try {
            if (pageRaw != null) {
                pageIndex = Integer.parseInt(pageRaw);
            }
        } catch (NumberFormatException e) {
            pageIndex = 1;
        }

        int pageSize = 5; // Số lượng record trên 1 trang

        // 3. Gọi DAO
        MaintenanceRequestDAO mrDao = new MaintenanceRequestDAO();
        UserDAO userDao = new UserDAO(); // Giả sử bạn có UserDAO để lấy danh sách khách hàng
        List<String> statusList = mrDao.getAllStatuses();
        int totalRecords = mrDao.countTotalRequests(search, status, fromDate, toDate, customerId);
        int totalPages = (totalRecords % pageSize == 0) ? (totalRecords / pageSize) : (totalRecords / pageSize + 1);

        List<MaintanceRequest> list = mrDao.searchRequests(search, status, fromDate, toDate, customerId, pageIndex, pageSize, sortBy, sortOrder);

        // Lấy danh sách Customer để đổ vào Dropdown Filter
        List<Users> customerList = userDao.getAllCustomers(); // Bạn cần viết hàm này trong UserDAO

        // 4. Set Attribute gửi sang JSP
        request.setAttribute("statusList", statusList);
        request.setAttribute("requestList", list);
        request.setAttribute("customerList", customerList);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", pageIndex);

        // Giữ lại giá trị filter
        request.setAttribute("searchValue", search);
        request.setAttribute("statusValue", status);
        request.setAttribute("fromDateValue", fromDate);
        request.setAttribute("toDateValue", toDate);
        request.setAttribute("customerIdValue", customerId);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);

        // 5. Forward về JSP
        request.getRequestDispatcher(MAINTENANCE_LIST_URL).forward(request, response);
    }
}
