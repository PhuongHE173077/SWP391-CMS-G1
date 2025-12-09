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
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(name = "AddUser", urlPatterns = {"/AddUser"})
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

    private boolean isValidPassword(String password) {
        if (password == null || password.length() < 6) {
            return false;
        }

        boolean hasUpperCase = false;
        boolean hasDigit = false;

        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) {
                hasUpperCase = true;
            }
            if (Character.isDigit(c)) {
                hasDigit = true;
            }
            // Nếu đã tìm thấy cả chữ hoa và số thì return true 
            if (hasUpperCase && hasDigit) {
                return true;
            }
        }

        return hasUpperCase && hasDigit;
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

        // Validate required fields
        if (displayname == null || displayname.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()
                || confirmPassword == null || confirmPassword.trim().isEmpty()
                || roleIdParam == null || roleIdParam.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ các trường bắt buộc.");
            loadRoles(request);
            request.getRequestDispatcher("admin/user/addUser.jsp").forward(request, response);
            return;
        }

        // Validate password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu và xác nhận mật khẩu không khớp.");
            loadRoles(request);
            request.getRequestDispatcher("admin/user/addUser.jsp").forward(request, response);
            return;
        }

        // Validate password strength: >= 6 ký tự, có chữ hoa và số
        if (!isValidPassword(password)) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ hoa và số.");
            loadRoles(request);
            request.getRequestDispatcher("admin/user/addUser.jsp").forward(request, response);
            return;
        }

        // Validate email exists
        String emailTrimmed = email.trim();
        if (userDAO.checkEmailExists(emailTrimmed)) {
            request.setAttribute("error", "Email này đã tồn tại trong hệ thống.");
            loadRoles(request);
            request.getRequestDispatcher("admin/user/addUser.jsp").forward(request, response);
            return;
        }

        // Validate phone exists (if phone is provided)
        String phoneTrimmed = phone != null ? phone.trim() : null;
        if (phoneTrimmed != null && !phoneTrimmed.isEmpty()) {
            if (userDAO.checkPhoneExists(phoneTrimmed)) {
                request.setAttribute("error", "Số điện thoại này đã tồn tại trong hệ thống.");
                loadRoles(request);
                request.getRequestDispatcher("admin/user/addUser.jsp").forward(request, response);
                return;
            }
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
            user.setEmail(emailTrimmed);
            String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
            user.setPassword(hashed);

            user.setPhone(phoneTrimmed);
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
