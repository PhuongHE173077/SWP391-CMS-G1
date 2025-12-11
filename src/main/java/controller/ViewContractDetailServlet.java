/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "ViewContractDetailServlet", urlPatterns = {"/contract-detail"})
public class ViewContractDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Lấy ID Contract
            String idRaw = request.getParameter("id");
            if (idRaw == null) {
                response.sendRedirect("contract-list");
                return;
            }
            int contractId = Integer.parseInt(idRaw);

            // 2. Lấy thông tin Hợp đồng (Phần trên cùng)
            ContractDAO contractDAO = new ContractDAO();
            Contract contract = contractDAO.getContractById(contractId);
            if (contract == null) {
                response.sendRedirect("contract-list");
                return;
            }

            // 3. Lấy tham số Filter cho Item (Phần dưới)
            String searchItem = request.getParameter("searchItem");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            String pageRaw = request.getParameter("page");

            int pageIndex = (pageRaw == null) ? 1 : Integer.parseInt(pageRaw);
            int pageSize = 5; // 5 máy mỗi trang

            // 4. Gọi DAO lấy danh sách Item
            ContractItemDAO itemDAO = new ContractItemDAO();
            int totalItems = itemDAO.countItems(contractId, searchItem, startDate, endDate);
            int totalPages = (totalItems % pageSize == 0) ? (totalItems / pageSize) : (totalItems / pageSize + 1);
            List<ContractItem> itemList = itemDAO.getItemsByContractId(contractId, searchItem, startDate, endDate, pageIndex, pageSize);

            // 5. Gửi hết sang JSP
            request.setAttribute("c", contract);
            request.setAttribute("itemList", itemList);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", pageIndex);

            // Giữ lại tham số filter
            request.setAttribute("searchItem", searchItem);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);

            request.getRequestDispatcher("manager/contract/contract-detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("contract-list");
        }
    }
}


