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
import jakarta.servlet.http.HttpSession;
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
        HttpSession session = request.getSession();
        // === PHẦN 1: XỬ LÝ MESSAGE TỪ CÁC SERVLET KHÁC GỬI VỀ ===
        // Logic: Lấy từ Session -> Nạp vào Request -> Xóa khỏi Session
        String msg = (String) session.getAttribute("msg");
        String error = (String) session.getAttribute("error");

        // 2. Nếu có, lấy ra nhét vào request để JSP hiện
        if (msg != null) {
            request.setAttribute("msg", msg);
            session.removeAttribute("msg"); // QUAN TRỌNG: Xóa ngay để F5 không hiện lại
        }

        if (error != null) {
            request.setAttribute("error", error);
            session.removeAttribute("error"); // QUAN TRỌNG: Xóa ngay
        }
        // ===========================
// === PHẦN 2: LOGIC LẤY DANH SÁCH (GIỮ NGUYÊN CODE CỦA BẠN) ===
        String search = request.getParameter("search");
        String role = request.getParameter("role");
        String status = request.getParameter("status");
        String gender = request.getParameter("gender");
        String indexPage = request.getParameter("page");
        if (indexPage == null) {
            indexPage = "1";
        }
        try {
            int pageIndex = Integer.parseInt(indexPage);
            UserDAO dao = new UserDAO();
            int pageSize = 5;
            int totalUsers = dao.countUsers(search, role, status, gender);
            int totalPages = (totalUsers % pageSize == 0) ? (totalUsers / pageSize) : (totalUsers / pageSize + 1);
            List<Users> userList = dao.searchUsers(search, role, status, gender, pageIndex, pageSize);

            RoleDAO roleDAO = new RoleDAO();
            List<Roles> roleList = roleDAO.getAllRoleses();
            request.setAttribute("userList", userList);
            request.setAttribute("roleList", roleList);

            request.setAttribute("totalPages", totalPages); // Gửi tổng số trang
            request.setAttribute("currentPage", pageIndex); // Gửi trang đang xem
            request.setAttribute("searchValue", search);
            request.setAttribute("roleValue", role);
            request.setAttribute("statusValue", status);
            request.setAttribute("genderValue", gender);
            request.getRequestDispatcher("admin/user/user-list.jsp").forward(request, response);
        } catch (Exception e) {
            // Nếu người dùng nhập page=abc thì quay về trang 1
            response.sendRedirect("user-list");
        }
    }
}
