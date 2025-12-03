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
import model.Users;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="ViewUserDetailServlet", urlPatterns={"/user-detail"})
public class ViewUserDetailServlet extends HttpServlet {
   
      
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // 1. Lấy ID từ trên URL xuống
            String idRaw = request.getParameter("id");
            int id = Integer.parseInt(idRaw);
            
            // 2. Gọi DAO lấy thông tin chi tiết
            UserDAO dao = new UserDAO();
            Users user = dao.getUserById(id);
            
            // 3. Đóng gói và gửi sang JSP
            request.setAttribute("user", user);
            
            request.getRequestDispatcher("user-detail.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Nếu có lỗi (ví dụ id không phải số), quay về trang list
            response.sendRedirect("user-list");
        }
    } 
 
 
}
