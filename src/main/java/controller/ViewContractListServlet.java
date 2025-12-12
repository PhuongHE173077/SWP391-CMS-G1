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
            response.sendRedirect("login.jsp"); // Chưa đăng nhập thì đá về login
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
        String status = request.getParameter("status");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        //page hiện tại lấy về từ jsp
        String indexPage = request.getParameter("page");

        if (indexPage == null) {
            indexPage = "1";
        }
        if (sortBy == null) {
            sortBy = "id";
        }
        if (sortOrder == null) {
            sortOrder = "DESC";
        }

        try {
            int pageIndex = Integer.parseInt(indexPage);
            //set 2 record trên 1 trang
            int pageSize = 2;
            ContractDAO dao = new ContractDAO();

            // Lấy ID của người đang đăng nhập
            int currentStaffId = user.getId();

            // TÍNH TỔNG SỐ RECORDS
            int totalRecords = dao.countContractsByStaff(currentStaffId, search, status);

            //totalRecords và pageSize đều là int => khi chia lấy thương,ví dụ 15:2= 7.5 thì thương nó sẽ lấy là kiểu int (cắt bỏ phần thập phân phía sau)
            //=> totalPages là 7 + 1=8
            int totalPages = (totalRecords % pageSize == 0) ? (totalRecords / pageSize) : (totalRecords / pageSize + 1);

            List<Contract> list = dao.getContractsByStaff(currentStaffId, search, status, pageIndex, pageSize, sortBy, sortOrder);

            // Gửi dữ liệu sang JSP
            request.setAttribute("contractList", list);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", pageIndex);

            // Giữ lại trạng thái Filter
            request.setAttribute("searchValue", search);
            request.setAttribute("statusValue", status);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);
            request.setAttribute("totalRecords", totalRecords); // Tổng số tìm thấy
            request.setAttribute("pageSize", pageSize);         // Số lượng setting 1 trang

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
