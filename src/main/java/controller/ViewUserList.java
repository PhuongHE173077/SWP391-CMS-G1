/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.RoleDAO;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.*;
import model.*;
 

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "ViewUserList", urlPatterns = {"/user-list"})
public class ViewUserList extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1. Lấy thông tin người dùng nhập từ ô tìm kiếm/filter
        String search = request.getParameter("search"); // Lấy text
        String role = request.getParameter("role");     
        
         String status = request.getParameter("status"); // Lấy value status
        String gender = request.getParameter("gender"); // Lấy value gender
        String indexPage = request.getParameter("page");
        if (indexPage == null) {
            indexPage = "1";  
        }
        int pageIndex = Integer.parseInt(indexPage);
        // 2. Gọi hàm search bên DAO
        UserDAO dao = new UserDAO();
        int pageSize = 5;
        int totalRecords = dao.countUsers(search, role, status, gender);
        int totalPages = (totalRecords % pageSize == 0) ? (totalRecords / pageSize) : (totalRecords / pageSize + 1);
        List<Users> userList = dao.searchUsers(search, role, status, gender, pageIndex);
        
        RoleDAO roleDAO = new RoleDAO();
        List<Roles> roleList = roleDAO.getAllRoleses();
        // 3. Gửi danh sách kết quả sang JSP
        request.setAttribute("userList", userList);
        request.setAttribute("roleList", roleList);
                
        request.setAttribute("totalPages", totalPages); // Gửi tổng số trang
        request.setAttribute("currentPage", pageIndex); // Gửi trang đang xem
        request.setAttribute("searchValue", search);
        request.setAttribute("roleValue", role);
        request.setAttribute("statusValue", status);
        request.setAttribute("genderValue", gender);
        request.getRequestDispatcher("admin/user/user-list.jsp").forward(request, response);
    }
}
