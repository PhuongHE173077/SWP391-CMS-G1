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
import jakarta.servlet.http.HttpSession;
import java.nio.charset.StandardCharsets;
import java.net.URLEncoder;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "ChangeUserStatus", urlPatterns = {"/change-user-status"})
public class ChangeUserStatus extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String URL = "";
        try {
            String idRaw = request.getParameter("id");
            String statusRaw = request.getParameter("status");

            int id = Integer.parseInt(idRaw);
            int status = Integer.parseInt(statusRaw);

            UserDAO dao = new UserDAO();
            dao.changeStatus(id, status);
            // === THÊM ĐOẠN NÀY: Gửi thông báo vào Session ===
            HttpSession session = request.getSession();
            if (status == 1) {
                session.setAttribute("msg", "Activated user successfully!");
            } else {
                session.setAttribute("msg", "Deactivated user successfully!");
            }

            // LẤY THAM SỐ ĐỂ GIỮ TRẠNG THÁI cho User list jsp
            String page = request.getParameter("page");
            String search = request.getParameter("search");
            String role = request.getParameter("role");
            String gender = request.getParameter("gender");
            String currentStatus = request.getParameter("currentStatus"); // Status của bộ lọc cũ

            // Xử lý null để tránh lỗi (nếu null thì gán rỗng)
            if (page == null) {
                page = "1";
            }
            if (search == null) {
                search = "";
            }
            if (role == null) {
                role = "";
            }
            if (gender == null) {
                gender = "";
            }
            if (currentStatus == null) {
                currentStatus = "";
            }

            // --- PHẦN 3: XÂY DỰNG URL REDIRECT ---
            // URLEncoder giúp xử lý nếu search có dấu cách hoặc tiếng Việt
            String redirectURL = "user-list?"
                    + "page=" + page
                    + "&role=" + role
                    + "&gender=" + gender
                    + "&status=" + currentStatus
                    // Trả lại tên biến là 'status' cho UserListServlet hiểu
                    + "&search=" + URLEncoder.encode(search, StandardCharsets.UTF_8);

            // Chuyển hướng về trang cũ với đầy đủ tham số
            response.sendRedirect(redirectURL);

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
            response.sendRedirect("user-list");
        }
    }

}
