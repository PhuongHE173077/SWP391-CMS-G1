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
import jakarta.servlet.http.HttpSession;
import model.Users;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="CustomerViewMaintenanceServlet", urlPatterns={"/customer-maintenance"})
public class CustomerViewMaintenanceServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
       // 1. Kiểm tra đăng nhập (BẮT BUỘC)
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user"); // Giả sử object user lưu trong session tên là "user"

        if (user == null) {
            response.sendRedirect("login.jsp"); // Chưa đăng nhập thì đá về login
            return;
        }
        // 2. Nhận tham số Filter từ JSP
        String search = request.getParameter("search");
        String status = request.getParameter("status");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        String pageRaw = request.getParameter("page");
    } 
 
}
