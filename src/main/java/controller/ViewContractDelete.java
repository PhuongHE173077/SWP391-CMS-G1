/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dal.ContractDAO;
import dal.SubDeviceDAO;
import model.Contract;

/**
 *
 * @author admin
 */
@WebServlet(name = "ViewContractDelete", urlPatterns = { "/list-contract-delete" })
public class ViewContractDelete extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String search = request.getParameter("search");
        String pageStr = request.getParameter("page");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");

        int currentPage = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
                if (currentPage < 1)
                    currentPage = 1;
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        ContractDAO contractDAO = new ContractDAO();
        List<Contract> contractList = contractDAO.getDeletedContracts(search, currentPage, PAGE_SIZE, sortBy,
                sortOrder);
        int totalContracts = contractDAO.countDeletedContracts(search);
        int totalPages = (int) Math.ceil((double) totalContracts / PAGE_SIZE);

        request.setAttribute("contractList", contractList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchValue", search);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);

        request.getRequestDispatcher("manager/delete-contract/contract-delete-list.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("restore".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                try {
                    int contractId = Integer.parseInt(idStr);
                    ContractDAO contractDAO = new ContractDAO();
                    boolean success = contractDAO.restoreContract(contractId);
                    
                    if (success) {
                        session.setAttribute("msg", "Khôi phục hợp đồng thành công!");
                    } else {
                        session.setAttribute("error", "Không thể khôi phục hợp đồng. Vui lòng thử lại!");
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("error", "ID hợp đồng không hợp lệ!");
                }
            } else {
                session.setAttribute("error", "Thiếu thông tin ID hợp đồng!");
            }
        } else if ("hardDelete".equals(action)) {
            // Hard delete contract và restore sub devices
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                try {
                    int contractId = Integer.parseInt(idStr);
                    SubDeviceDAO subDeviceDAO = new SubDeviceDAO();
                    ContractDAO contractDAO = new ContractDAO();
                    
                    // 1. Restore sub devices trước (set isDelete = 0)
                    boolean restoreSuccess = subDeviceDAO.restoreSubDevicesByContractId(contractId);
                    
                    // 2. Xóa cứng contract
                    boolean deleteSuccess = contractDAO.hardDeleteContract(contractId);
                    
                    if (deleteSuccess) {
                        session.setAttribute("msg", "Xóa cứng hợp đồng thành công. " + 
                            (restoreSuccess ? "Đã khôi phục các Sub Device liên quan." : ""));
                    } else {
                        session.setAttribute("error", "Có lỗi xảy ra khi xóa hợp đồng.");
                    }
                } catch (NumberFormatException e) {
                    session.setAttribute("error", "ID hợp đồng không hợp lệ!");
                } catch (Exception e) {
                    e.printStackTrace();
                    session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
                }
            } else {
                session.setAttribute("error", "Thiếu thông tin ID hợp đồng!");
            }
        } else if ("restoreMultiple".equals(action)) {
            String[] contractIds = request.getParameterValues("contractIds");
            if (contractIds != null && contractIds.length > 0) {
                try {
                    List<Integer> ids = new ArrayList<>();
                    for (String idStr : contractIds) {
                        ids.add(Integer.parseInt(idStr));
                    }
                    
                    ContractDAO contractDAO = new ContractDAO();
                    int restoredCount = contractDAO.restoreMultipleContracts(ids);
                    
                    if (restoredCount > 0) {
                        request.getSession().setAttribute("msg", "Đã khôi phục thành công " + restoredCount + " hợp đồng!");
                    } else {
                        request.getSession().setAttribute("error", "Không thể khôi phục các hợp đồng đã chọn. Vui lòng thử lại!");
                    }
                } catch (NumberFormatException e) {
                    request.getSession().setAttribute("error", "Có ID hợp đồng không hợp lệ!");
                }
            } else {
                request.getSession().setAttribute("error", "Vui lòng chọn ít nhất một hợp đồng để khôi phục!");
            }
        }

        // Lấy lại các tham số để giữ nguyên filter và pagination
        String search = request.getParameter("search");
        String pageStr = request.getParameter("page");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        
        StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/list-contract-delete");
        boolean hasParam = false;
        
        if (search != null && !search.isEmpty()) {
            redirectUrl.append(hasParam ? "&" : "?").append("search=").append(java.net.URLEncoder.encode(search, "UTF-8"));
            hasParam = true;
        }
        if (pageStr != null && !pageStr.isEmpty()) {
            redirectUrl.append(hasParam ? "&" : "?").append("page=").append(pageStr);
            hasParam = true;
        }
        if (sortBy != null && !sortBy.isEmpty()) {
            redirectUrl.append(hasParam ? "&" : "?").append("sortBy=").append(sortBy);
            hasParam = true;
        }
        if (sortOrder != null && !sortOrder.isEmpty()) {
            redirectUrl.append(hasParam ? "&" : "?").append("sortOrder=").append(sortOrder);
        }
        
        response.sendRedirect(redirectUrl.toString());
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
