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

@WebServlet(name = "AddUser", urlPatterns = { "/AddUser" })
public class AddUser extends HttpServlet {

    private UserDAO userDAO;
    private RoleDAO roleDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        roleDAO = new RoleDAO();
    }

    private void loadRoles(HttpServletRequest request) {
        List<Roles> listRoles = roleDAO.getAllRoleses();
        request.setAttribute("listRoles", listRoles);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        loadRoles(request);
        request.getRequestDispatcher("admin/user/addUser.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String displayname = request.getParameter("displayname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String genderParam = request.getParameter("gender");
        String activeParam = request.getParameter("active");
        String roleIdParam = request.getParameter("roleId");

        //Validate
        if (displayname == null || displayname.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()
                || confirmPassword == null || !password.equals(confirmPassword)
                || roleIdParam == null || roleIdParam.trim().isEmpty()) {

            if (confirmPassword == null || !password.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu và xác nhận mật khẩu không khớp.");
            } else {
                request.setAttribute("error", "Vui lòng nhập đầy đủ các trường bắt buộc.");
            }

            loadRoles(request);
            request.getRequestDispatcher("admin/user/addUser.jsp").forward(request, response);
            return;
        }

        try {
            int roleId = Integer.parseInt(roleIdParam);
            boolean gender = "true".equals(genderParam); 
            boolean active = activeParam == null ? false : "true".equals(activeParam);

            Roles role = roleDAO.getRoleById(roleId);
            if (role == null) {
                request.setAttribute("error", "Vai trò không tồn tại.");
                loadRoles(request);
                request.getRequestDispatcher("admin/user/addUser.jsp").forward(request, response);
                return;
            }

            Users user = new Users();
            user.setDisplayname(displayname.trim());
            user.setEmail(email.trim());
            user.setPassword(password.trim()); 
            user.setPhone(phone != null ? phone.trim() : null);
            user.setAddress(address != null ? address.trim() : null);
            user.setGender(gender);
            user.setActive(active);
            user.setRoles(role);

            boolean success = userDAO.insertUser(user);

            loadRoles(request);
            if (success) {
                request.setAttribute("success", "Thêm người dùng thành công.");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi lưu người dùng.");
            }
            request.getRequestDispatcher("admin/user/addUser.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID vai trò không hợp lệ.");
            loadRoles(request);
            request.getRequestDispatcher("admin/user/addUser.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}


