package controller;

import dal.RoleDAO;
import dal.UserDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Roles;
import model.Users;

@WebServlet(name = "EditUser", urlPatterns = { "/edit" })
public class EditUser extends HttpServlet {

    private UserDAO userDAO;
    private RoleDAO roleDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        roleDAO = new RoleDAO();
    }

    private void loadRoles(HttpServletRequest request) {
        List<Roles> roleList = roleDAO.getAllRoleses();
        request.setAttribute("roleList", roleList);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idRaw = request.getParameter("id");
        try {
            int id = Integer.parseInt(idRaw);
            Users user = userDAO.getUserById(id);
            if (user == null) {
                response.sendRedirect("user-list");
                return;
            }

            loadRoles(request);
            request.setAttribute("user", user);
            request.getRequestDispatcher("admin/user/user-edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("user-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String idRaw = request.getParameter("id");
        String displayname = request.getParameter("displayname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String genderParam = request.getParameter("gender");
        String activeParam = request.getParameter("active");
        String roleIdParam = request.getParameter("roleId");

        try {
            int id = Integer.parseInt(idRaw);

            if (displayname == null || displayname.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || roleIdParam == null || roleIdParam.trim().isEmpty()) {

                request.setAttribute("error", "Vui lòng nhập đầy đủ các trường bắt buộc.");
                Users user = userDAO.getUserById(id);
                loadRoles(request);
                request.setAttribute("user", user);
                request.getRequestDispatcher("admin/user/user-edit.jsp").forward(request, response);
                return;
            }

            int roleId = Integer.parseInt(roleIdParam);
            boolean gender = "true".equals(genderParam);
            boolean active = activeParam != null && "true".equals(activeParam);

            Roles role = roleDAO.getRoleById(roleId);
            if (role == null) {
                request.setAttribute("error", "Vai trò không tồn tại.");
                Users user = userDAO.getUserById(id);
                loadRoles(request);
                request.setAttribute("user", user);
                request.getRequestDispatcher("admin/user/user-edit.jsp").forward(request, response);
                return;
            }

            Users existingUser = userDAO.getUserById(id);
            if (existingUser == null) {
                response.sendRedirect("user-list");
                return;
            }

            existingUser.setDisplayname(displayname.trim());
            existingUser.setEmail(email.trim());
            existingUser.setPhone(phone != null ? phone.trim() : null);
            existingUser.setAddress(address != null ? address.trim() : null);
            existingUser.setGender(gender);
            existingUser.setActive(active);
            existingUser.setRoles(role);

            boolean success = userDAO.updateUser(existingUser);

            loadRoles(request);
            request.setAttribute("user", existingUser);
            if (success) {
                request.setAttribute("success", "Cập nhật người dùng thành công.");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật người dùng.");
            }
            request.getRequestDispatcher("admin/user/user-edit.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("user-list");
        }
    }

    @Override
    public String getServletInfo() {
        return "Edit user information";
    }
}


