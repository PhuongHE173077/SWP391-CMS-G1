/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.ContractDAO;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Contract;
import model.ContractItem;
import model.Users;

/**
 *
 * @author Dell
 */
@WebServlet(name="ViewListContractInUser", urlPatterns={"/customer/ViewListContact"})
public class ViewListContractInUser extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Lấy session
        HttpSession session = request.getSession(false);
        
        // Kiểm tra user đã đăng nhập chưa
        Users sessionUser = (session != null) ? (Users) session.getAttribute("user") : null;
        
        if (sessionUser == null) {
            // Nếu chưa đăng nhập, redirect về trang login
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Lấy userId từ session
        int userId = sessionUser.getId();
        
        // Lấy các tham số từ request
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status"); // "active", "expired", hoặc null (all)
        String fromDate = request.getParameter("fromDate"); // Format: yyyy-MM-dd
        String toDate = request.getParameter("toDate"); // Format: yyyy-MM-dd
        
        // Phân trang
        int pageIndex = 1;
        int pageSize = 10; // Số records mỗi trang
        
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                pageIndex = Integer.parseInt(pageParam);
                if (pageIndex < 1) {
                    pageIndex = 1;
                }
            }
        } catch (NumberFormatException e) {
            pageIndex = 1;
        }
        
        // Lấy danh sách contract theo userId với filter và phân trang
        ContractDAO contractDAO = new ContractDAO();
        List<Contract> contractList = contractDAO.getListContractByUserId(userId, keyword, status, fromDate, toDate, pageIndex, pageSize);
        
        // Lấy status map cho các contracts
        List<Integer> contractIds = new ArrayList<>();
        for (Contract c : contractList) {
            contractIds.add(c.getId());
        }
        Map<Integer, String> statusMap = contractDAO.getContractStatusMap(contractIds);
        
        // Format dates for display và load contract items
        Map<Integer, String> dateFormatMap = new HashMap<>();
        Map<Integer, List<ContractItem>> contractItemsMap = new HashMap<>();
        Map<Integer, Map<Integer, String>> itemStartDateMap = new HashMap<>(); // contractId -> (itemId -> startDate)
        Map<Integer, Map<Integer, String>> itemEndDateMap = new HashMap<>(); // contractId -> (itemId -> endDate)
        Map<Integer, Map<Integer, String>> itemStatusMap = new HashMap<>(); // contractId -> (itemId -> status)
        
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        Timestamp now = Timestamp.from(Instant.now());
        
        for (Contract c : contractList) {
            // Format contract creation date
            if (c.getCreatedAt() != null) {
                dateFormatMap.put(c.getId(), c.getCreatedAt().toLocalDate().format(formatter));
            }
            
            // Load contract items
            List<ContractItem> items = contractDAO.getAllItemsByContractId(c.getId());
            contractItemsMap.put(c.getId(), items);
            
            // Format dates và check status cho từng item
            Map<Integer, String> itemStartDates = new HashMap<>();
            Map<Integer, String> itemEndDates = new HashMap<>();
            Map<Integer, String> itemStatuses = new HashMap<>();
            
            for (ContractItem item : items) {
                if (item.getStartAt() != null) {
                    itemStartDates.put(item.getId(), 
                        item.getStartAt().toLocalDateTime().format(formatter));
                }
                if (item.getEndDate() != null) {
                    itemEndDates.put(item.getId(), 
                        item.getEndDate().toLocalDateTime().format(formatter));
                    
                    // Check status: active nếu endDate > now
                    if (item.getEndDate().after(now)) {
                        itemStatuses.put(item.getId(), "active");
                    } else {
                        itemStatuses.put(item.getId(), "expired");
                    }
                } else {
                    itemStatuses.put(item.getId(), "expired");
                }
            }
            
            itemStartDateMap.put(c.getId(), itemStartDates);
            itemEndDateMap.put(c.getId(), itemEndDates);
            itemStatusMap.put(c.getId(), itemStatuses);
        }
        
        // Đếm tổng số contracts để tính số trang
        int totalContracts = contractDAO.countContractsByUserId(userId, keyword, status, fromDate, toDate);
        int totalPages = (int) Math.ceil((double) totalContracts / pageSize);
        
        // Set các attributes vào request
        request.setAttribute("contractList", contractList);
        request.setAttribute("contractItemsMap", contractItemsMap);
        request.setAttribute("itemStartDateMap", itemStartDateMap);
        request.setAttribute("itemEndDateMap", itemEndDateMap);
        request.setAttribute("itemStatusMap", itemStatusMap);
        request.setAttribute("statusMap", statusMap);
        request.setAttribute("dateFormatMap", dateFormatMap);
        request.setAttribute("user", sessionUser);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalContracts", totalContracts);
        request.setAttribute("keyword", keyword != null ? keyword : "");
        request.setAttribute("status", status != null ? status : "");
        request.setAttribute("fromDate", fromDate != null ? fromDate : "");
        request.setAttribute("toDate", toDate != null ? toDate : "");
        request.setAttribute("pageSize", pageSize);
        
        // Forward đến JSP để hiển thị
        request.getRequestDispatcher("/customer/contract-list.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "View List Contract In User";
    }// </editor-fold>

}
