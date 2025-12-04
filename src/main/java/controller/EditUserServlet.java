/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.*;
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
@WebServlet(name="EditUserServlet", urlPatterns={"/edit-user"})
public class EditUserServlet extends HttpServlet {
  // 1. CHỨC NĂNG HIỆN FORM (Khi bấm nút Edit)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idRaw = request.getParameter("id");
            int id = Integer.parseInt(idRaw);

            UserDAO userDAO = new UserDAO();
            Users user = userDAO.getUserById(id);

            // QUAN TRỌNG: Phải lấy cả list Role để đổ vào Dropdown cho Admin chọn
            RoleDAO roleDAO = new RoleDAO();
            List<Roles> listRole = roleDAO.getAllRoleses();

            request.setAttribute("user", user);
            request.setAttribute("listRole", listRole);

            request.getRequestDispatcher("admin/user/edit-user.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect("user-list");
        }
    }

    // 2. CHỨC NĂNG XỬ LÝ UPDATE (Khi bấm nút Save Changes)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy dữ liệu từ form
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("displayname");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            
            // Xử lý giới tính, status, role
            boolean gender = request.getParameter("gender").equals("1");
            boolean active = request.getParameter("active").equals("1");
            int roleId = Integer.parseInt(request.getParameter("role"));

            // Tạo đối tượng User mới để update
            Users u = new Users();
            u.setId(id);
            u.setDisplayname(name);
            u.setPhone(phone);
            u.setAddress(address);
            u.setGender(gender);
            u.setActive(active);
            
            // Tạo đối tượng Role và gán vào User
            Roles r = new Roles();
            r.setId(roleId);
            u.setRoles(r);

            // Gọi DAO
            UserDAO dao = new UserDAO();
            dao.updateUser(u);

            // Update xong -> Quay về trang danh sách (User List)
            response.sendRedirect("user-list");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("user-list");
        }
    }

}
