/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.ContractDAO;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.*;
import model.*;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "ViewContractListServlet", urlPatterns = {"/contract-list"})
public class ViewContractListServlet extends HttpServlet {

    String URL_CONTRACT_LIST_DIRECTION = "manager/contract/contract-list.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //1. Lấy id sale staff đang đăng nhập
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");  
            return;
        }

        String msg = (String) session.getAttribute("msg");
        String error = (String) session.getAttribute("error");
        if (msg != null) {
            request.setAttribute("msg", msg);
            session.removeAttribute("msg");
        }
        if (error != null) {
            request.setAttribute("error", error);
            session.removeAttribute("error");
        }

        // Lấy tham số Filter/Sort từ JSP
        String search = request.getParameter("search");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        //page hiện tại lấy về từ jsp
        String indexPage = request.getParameter("page");
        String createByRaw = request.getParameter("createBy");
        int createById = 0;
        try {
            if (createByRaw != null && !createByRaw.isEmpty()) {
                createById = Integer.parseInt(createByRaw);
            }
        } catch (NumberFormatException e) {
            createById = 0;
        }
        int pageIndex = 1;
        if (indexPage != null && !indexPage.isEmpty()) {
            try {
                pageIndex = Integer.parseInt(indexPage);
            } catch (NumberFormatException e) {
                pageIndex = 1;
            }
        }
        if (sortBy == null || sortBy.isEmpty()) {
            sortBy = "id";
        }
        if (sortOrder == null || sortOrder.isEmpty()) {
            sortOrder = "DESC";
        }
        if (search != null) {
            search = search.trim();
        }
        try {
             int pageSize = 5;
            ContractDAO dao = new ContractDAO();

            // TÍNH TỔNG SỐ RECORDS
            int totalRecords = dao.countAllContracts(search, createById);

            //totalRecords và pageSize đều là int => khi chia lấy thương,ví dụ 23:5= 4,6 thì thương nó sẽ lấy là kiểu int (cắt bỏ phần thập phân phía sau)
            //=> totalPages là 4 + 1= 5
            int totalPages = (totalRecords % pageSize == 0) ? (totalRecords / pageSize) : (totalRecords / pageSize + 1);

            List<Contract> list = dao.getAllActiveContracts(search, createById, pageIndex, pageSize, sortBy, sortOrder);
            UserDAO userDao = new UserDAO();
            List<Users> lstManagerSaleStaff = userDao.getAllManagerSaleStaff();
            // Gửi dữ liệu sang JSP
            request.setAttribute("lstManagerSaleStaff", lstManagerSaleStaff);
            request.setAttribute("contractList", list);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", pageIndex);

            // Giữ lại trạng thái Filter
            request.setAttribute("creatorValue", createById);
            request.setAttribute("searchValue", search);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);

            request.getRequestDispatcher(URL_CONTRACT_LIST_DIRECTION).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("contract-list");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
