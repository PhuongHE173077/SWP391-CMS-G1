/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.ContractDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.*;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "ViewContractDetailServlet", urlPatterns = {"/contract-detail"})
public class ViewContractDetailServlet extends HttpServlet {

    String URL_CONTRACT_DETAIL_DIRECTION = "manager/contract/contract-detail.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user"); // Giả sử object user lưu trong session tên là "user"

        if (user == null) {
            response.sendRedirect("login.jsp"); // Chưa đăng nhập thì đá về login
            return;
        }
        try {
            String idRaw = request.getParameter("id");
            if (idRaw == null) {
                response.sendRedirect("contract-list");
                return;
            }
            int contractId = Integer.parseInt(idRaw);

            // 1. Lấy thông tin Hợp đồng
            ContractDAO contractDAO = new ContractDAO();
            Contract contract = contractDAO.getContractById(contractId);
            if (contract == null) {
                response.sendRedirect("contract-list");
                return;
            }

            // 2. Lấy tham số Filter & Sort
            String searchItem = request.getParameter("searchItem");
            if (searchItem != null) {
                searchItem = searchItem.trim();
            }

            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");

            // --- THÊM PHẦN NÀY ---
            String sortBy = request.getParameter("sortBy");
            String sortOrder = request.getParameter("sortOrder");

            // Mặc định
            if (sortBy == null) {
                sortBy = "id"; // Mặc định sort item id (hoặc deviceId tùy bạn)
            }
            if (sortOrder == null) {
                sortOrder = "ASC";
            }
            // ---------------------

            String pageRaw = request.getParameter("page");
            int pageIndex = (pageRaw == null) ? 1 : Integer.parseInt(pageRaw);
            int pageSize = 2;

            // 3. Gọi DAO
            ContractDAO itemDAO = new ContractDAO();
            int totalItems = itemDAO.countItems(contractId, searchItem, startDate, endDate);
            int totalPages = (totalItems % pageSize == 0) ? (totalItems / pageSize) : (totalItems / pageSize + 1);

            // Gọi hàm getItemsByContractId MỚI (có thêm sortBy, sortOrder)
            List<ContractItem> itemList = itemDAO.getItemsByContractId(contractId, searchItem, startDate, endDate, pageIndex, pageSize, sortBy, sortOrder);

            // 4. Gửi sang JSP
            request.setAttribute("c", contract);
            request.setAttribute("itemList", itemList);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", pageIndex);

            // Giữ lại tham số filter & sort
            request.setAttribute("searchItem", searchItem);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);

            request.getRequestDispatcher(URL_CONTRACT_DETAIL_DIRECTION).forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("contract-list");
        }
    }
}
