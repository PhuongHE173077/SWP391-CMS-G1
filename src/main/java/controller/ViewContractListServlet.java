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
        // 1. Xử lý Message từ Session (Flash Attribute)
        HttpSession session = request.getSession();
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

        ContractDAO contractDAO = new ContractDAO();
        // 2. Lấy tham số
        String search = request.getParameter("search");
        String status = request.getParameter("status");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        String indexPage = request.getParameter("page");
        String createByIdRaw = request.getParameter("createById");
        int createById = 0;
  
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
            int pageSize = 20;

            int totalRecords = contractDAO.countContracts(search, status, createById);
            int totalPages = (totalRecords % pageSize == 0) ? (totalRecords / pageSize) : (totalRecords / pageSize + 1);

            List<Contract> list = contractDAO.searchContracts(search, createById, status, pageIndex, pageSize, sortBy, sortOrder);
            

            // 3. Gửi data sang JSP
            request.setAttribute("contractList", list);
 //            request.setAttribute("totalPages", totalPages);
//            request.setAttribute("currentPage", pageIndex);
//            
//            // Giữ lại giá trị filter
//            request.setAttribute("searchValue", search);
//            request.setAttribute("statusValue", status);
//            request.setAttribute("sortBy", sortBy);
//            request.setAttribute("sortOrder", sortOrder);
            request.getRequestDispatcher(URL_CONTRACT_LIST_DIRECTION).forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
//            response.sendRedirect("contract-list");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
