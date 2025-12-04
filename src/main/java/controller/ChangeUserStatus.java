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

/**
 *
 * @author ADMIN
 */
@WebServlet(name="ChangeUserStatus", urlPatterns={"/change-user-status"})
public class ChangeUserStatus extends HttpServlet {
 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
          try {
            // 1. Lấy id và status từ URL
            String idRaw = request.getParameter("id");
            String statusRaw = request.getParameter("status");

            // 2. Ép kiểu (Parse) sang số
            int id = Integer.parseInt(idRaw);
            int status = Integer.parseInt(statusRaw);

            // 3. Gọi DAO để update
            UserDAO dao = new UserDAO();
            dao.changeStatus(id, status);

            // 4. Update xong thì quay lại trang danh sách user
            // Dùng sendRedirect để load lại trang user-list mới nhất
            response.sendRedirect("user-list");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("user-list"); // Lỗi cũng quay về list
        }
    }

 
}
