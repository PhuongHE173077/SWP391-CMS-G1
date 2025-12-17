package controller;

import dal.MaintenanceRequestDAO;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.MaintenanceStatus;

@WebServlet(name = "ChangeMaintenanceStatus", urlPatterns = {"/change-maintenance-status"})
public class ChangeMaintenanceStatus extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        try {
            String idRaw = request.getParameter("id");
            String statusRaw = request.getParameter("status");

            if (idRaw == null || statusRaw == null) {
                session.setAttribute("error", "Missing parameters!");
                response.sendRedirect("seller-maintenance");
                return;
            }

            int id = Integer.parseInt(idRaw);
            MaintenanceStatus status;
            try {
                status = MaintenanceStatus.valueOf(statusRaw.toUpperCase());
            } catch (IllegalArgumentException e) {
                session.setAttribute("error", "Invalid status value!");
                response.sendRedirect("seller-maintenance");
                return;
            }

            MaintenanceRequestDAO dao = new MaintenanceRequestDAO();
            boolean success = dao.updateMaintenanceRequestStatus(id, status);

            if (success) {
                session.setAttribute("msg", "Status updated successfully!");
            } else {
                session.setAttribute("error", "Failed to update status!");
            }

            // Lấy các tham số filter để giữ lại trạng thái
            String page = request.getParameter("page");
            String search = request.getParameter("search");
            String statusFilter = request.getParameter("statusFilter");
            String fromDate = request.getParameter("fromDate");
            String toDate = request.getParameter("toDate");
            String customerId = request.getParameter("customerId");
            String sortBy = request.getParameter("sortBy");
            String sortOrder = request.getParameter("sortOrder");

            // Xây dựng URL redirect với các tham số filter
            StringBuilder redirectURL = new StringBuilder("seller-maintenance?");
            if (page != null && !page.isEmpty()) {
                redirectURL.append("page=").append(page).append("&");
            }
            if (search != null && !search.isEmpty()) {
                redirectURL.append("search=").append(URLEncoder.encode(search, StandardCharsets.UTF_8)).append("&");
            }
            if (statusFilter != null && !statusFilter.isEmpty()) {
                redirectURL.append("status=").append(statusFilter).append("&");
            }
            if (fromDate != null && !fromDate.isEmpty()) {
                redirectURL.append("fromDate=").append(fromDate).append("&");
            }
            if (toDate != null && !toDate.isEmpty()) {
                redirectURL.append("toDate=").append(toDate).append("&");
            }
            if (customerId != null && !customerId.isEmpty()) {
                redirectURL.append("customerId=").append(customerId).append("&");
            }
            if (sortBy != null && !sortBy.isEmpty()) {
                redirectURL.append("sortBy=").append(sortBy).append("&");
            }
            if (sortOrder != null && !sortOrder.isEmpty()) {
                redirectURL.append("sortOrder=").append(sortOrder).append("&");
            }

            // Xóa dấu & cuối cùng nếu có
            String finalURL = redirectURL.toString();
            if (finalURL.endsWith("&")) {
                finalURL = finalURL.substring(0, finalURL.length() - 1);
            }
            if (finalURL.endsWith("?")) {
                finalURL = finalURL.substring(0, finalURL.length() - 1);
            }

            response.sendRedirect(finalURL);

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid request ID!");
            response.sendRedirect("seller-maintenance");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error: " + e.getMessage());
            response.sendRedirect("seller-maintenance");
        }
    }
}

