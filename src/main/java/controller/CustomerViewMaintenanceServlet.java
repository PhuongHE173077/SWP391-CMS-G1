/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.MaintenanceRequestDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.MaintanceRequest;
import model.Users;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="CustomerViewMaintenanceServlet", urlPatterns={"/customer-maintenance"})
public class CustomerViewMaintenanceServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String MAINTENANCE_LIST_URL ="customer/maintenance/customer-maintenance.jsp";
       // 1. Kiểm tra đăng nhập (BẮT BUỘC)
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user"); // Giả sử object user lưu trong session tên là "user"

        if (user == null) {
            response.sendRedirect("login.jsp"); // Chưa đăng nhập thì đá về login
            return;
        }
        // 2. Nhận tham số Filter từ JSP
        String search = request.getParameter("search");
        String status = request.getParameter("status");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        String pageRaw = request.getParameter("page");
        // 3. Xử lý mặc định
        if (sortBy == null) sortBy = "id";
        if (sortOrder == null) sortOrder = "DESC";
        
        int pageIndex = 1;
        try {
            if (pageRaw != null) pageIndex = Integer.parseInt(pageRaw);
        } catch (NumberFormatException e) { pageIndex = 1; }
        
        if (search != null) {
            search = search.trim();
        }
        int pageSize = 5;
        // 4. Gọi DAO
        MaintenanceRequestDAO mrDao = new MaintenanceRequestDAO();

        // QUAN TRỌNG: Truyền user.getId() vào tham số customerId
        // Để DAO chỉ lọc ra các request của chính user này
        int totalRecords = mrDao.countTotalRequests(search, status, fromDate, toDate, user.getId());
        int totalPages = (totalRecords % pageSize == 0) ? (totalRecords / pageSize) : (totalRecords / pageSize + 1);

        List<MaintanceRequest> list = mrDao.searchRequests(search, status, fromDate, toDate, user.getId(), pageIndex, pageSize, sortBy, sortOrder);
        
        // Lấy danh sách Status để đổ vào dropdown filter
        List<String> statusList = mrDao.getAllStatuses();
        // 5. Gửi dữ liệu sang JSP
        request.setAttribute("requestList", list);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("statusList", statusList);

        // Giữ lại trạng thái filter
        request.setAttribute("searchValue", search);
        request.setAttribute("statusValue", status);
        request.setAttribute("fromDateValue", fromDate);
        request.setAttribute("toDateValue", toDate);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);

        // 6. Forward về giao diện Customer
        request.getRequestDispatcher(MAINTENANCE_LIST_URL).forward(request, response);
    } 
 
}
