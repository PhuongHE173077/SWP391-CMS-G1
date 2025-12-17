/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.MaintenanceRequestDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.MaintanceRequest;
import model.ReplyMaintanceRequest;
import model.Users;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "CustomerMaintenanceDetailServlet", urlPatterns = {"/maintenance-detail"})
public class CustomerMaintenanceDetailServlet extends HttpServlet {

    private static final String MAINTENANCE_DETAIL_URL = "customer/maintenance/customer-maintenance-detail.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Kiểm tra đăng nhập
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // 2. Lấy ID từ parameter
            String idRaw = request.getParameter("id");
            if (idRaw == null || idRaw.trim().isEmpty()) {
                response.sendRedirect("customer-maintenance");
                return;
            }

            int requestId = Integer.parseInt(idRaw);

            // 3. Gọi DAO để lấy thông tin maintenance request
            MaintenanceRequestDAO mrDao = new MaintenanceRequestDAO();
            MaintanceRequest maintenanceRequest = mrDao.getMaintenanceRequestById(requestId);

            if (maintenanceRequest == null) {
                request.setAttribute("errorMsg", "Maintenance request not found.");
                response.sendRedirect("customer-maintenance");
                return;
            }

            // 4. Kiểm tra quyền truy cập - chỉ user sở hữu request mới được xem
            if (maintenanceRequest.getUser().getId() != user.getId()) {
                request.setAttribute("errorMsg", "You do not have permission to view this request.");
                response.sendRedirect("customer-maintenance");
                return;
            }

            // 5. Lấy danh sách replies
            List<ReplyMaintanceRequest> replies = mrDao.getRepliesByRequestId(requestId);

            // 6. Set attributes và forward
            request.setAttribute("req", maintenanceRequest);
            request.setAttribute("replies", replies);

            request.getRequestDispatcher(MAINTENANCE_DETAIL_URL).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("customer-maintenance");
        }
    }
}

