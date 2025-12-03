/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.*;
import model.Users;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="ViewUserList", urlPatterns={"/user-list"})
public class ViewUserList extends HttpServlet {
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
      // 1. Lấy thông tin người dùng nhập từ ô tìm kiếm/filter
        String search = request.getParameter("search"); // Lấy text
        String role = request.getParameter("role");     // Lấy value của option role
        String status = request.getParameter("status"); // Lấy value status
        String gender = request.getParameter("gender"); // Lấy value gender

        // 2. Gọi hàm search bên DAO
        UserDAO dao = new UserDAO();
        List<Users> list = dao.searchUsers(search, role, status, gender);

        // 3. Gửi danh sách kết quả sang JSP
        request.setAttribute("userList", list);
        
        // 4. (QUAN TRỌNG) Gửi lại chính những gì người dùng đã nhập
        // Để khi trang load lại, các ô search vẫn giữ nguyên chữ họ vừa gõ (Sticky Form)
        request.setAttribute("searchVal", search);
        request.setAttribute("roleVal", role);
        request.setAttribute("statusVal", status);
        request.setAttribute("genderVal", gender);
        request.getRequestDispatcher("user-list.jsp").forward(request, response);
    }
    } 


