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

            // Lấy user hiện tại để so sánh
            Users existingUser = userDAO.getUserById(id);
            if (existingUser == null) {
                response.sendRedirect("user-list");
                return;
            }

            // Validate required fields
            if (displayname == null || displayname.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || roleIdParam == null || roleIdParam.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ các trường bắt buộc.");
                loadRoles(request);
                request.setAttribute("user", existingUser);
                request.getRequestDispatcher("admin/user/user-edit.jsp").forward(request, response);
                return;
            }

            String displaynameTrimmed = displayname.trim();
            String emailTrimmed = email.trim();
            String phoneTrimmed = phone != null ? phone.trim() : null;
            String addressTrimmed = address != null ? address.trim() : null;

            // Validate displayname length
            if (displaynameTrimmed.length() < 2) {
                request.setAttribute("error", "Họ và tên phải có ít nhất 2 ký tự.");
                loadRoles(request);
                request.setAttribute("user", existingUser);
                request.getRequestDispatcher("admin/user/user-edit.jsp").forward(request, response);
                return;
            }
            if (displaynameTrimmed.length() > 100) {
                request.setAttribute("error", "Họ và tên không được vượt quá 100 ký tự.");
                loadRoles(request);
                request.setAttribute("user", existingUser);
                request.getRequestDispatcher("admin/user/user-edit.jsp").forward(request, response);
                return;
            }
            // Validate displayname không chứa ký tự đặc biệt nguy hiểm
            if (displaynameTrimmed.contains("<") || displaynameTrimmed.contains(">")) {
                request.setAttribute("error", "Họ và tên không được chứa ký tự < hoặc >.");
                loadRoles(request);
                request.setAttribute("user", existingUser);
                request.getRequestDispatcher("admin/user/user-edit.jsp").forward(request, response);
                return;
            }

            // Validate email format
            String emailPattern = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
            if (!emailTrimmed.matches(emailPattern)) {
                request.setAttribute("error", "Email không hợp lệ.");
                loadRoles(request);
                request.setAttribute("user", existingUser);
                request.getRequestDispatcher("admin/user/user-edit.jsp").forward(request, response);
                return;
            }
            if (emailTrimmed.length() > 100) {
                request.setAttribute("error", "Email không được vượt quá 100 ký tự.");
                loadRoles(request);
                request.setAttribute("user", existingUser);
                request.getRequestDispatcher("admin/user/user-edit.jsp").forward(request, response);
                return;
            }

            // Validate email duplicate (trừ user hiện tại)
            String currentEmail = existingUser.getEmail();
            if (!emailTrimmed.equalsIgnoreCase(currentEmail != null ? currentEmail.trim() : "")) {
                if (userDAO.checkEmailExists(emailTrimmed)) {
                    request.setAttribute("error", "Email này đã được sử dụng bởi người dùng khác.");
                    loadRoles(request);
                    request.setAttribute("user", existingUser);
                    request.getRequestDispatcher("admin/user/user-edit.jsp").forward(request, response);
                    return;
                }
            }

            // Validate phone format (nếu có)
            if (phoneTrimmed != null && !phoneTrimmed.isEmpty()) {
                String phonePattern = "^[0-9]{10,11}$";
                if (!phoneTrimmed.matches(phonePattern)) {
                    request.setAttribute("error", "Số điện thoại phải có 10-11 chữ số.");
                    loadRoles(request);
                    request.setAttribute("user", existingUser);
                    request.getRequestDispatcher("admin/user/user-edit.jsp").forward(request, response);
                    return;
                }

                // Validate phone duplicate (trừ user hiện tại)
                String currentPhone = existingUser.getPhone();
                String currentPhoneTrimmed = currentPhone != null ? currentPhone.trim() : "";
                if (!phoneTrimmed.equals(currentPhoneTrimmed)) {
                    if (userDAO.checkPhoneExists(phoneTrimmed)) {
                        request.setAttribute("error", "Số điện thoại này đã được sử dụng bởi người dùng khác.");
                        loadRoles(request);
                        request.setAttribute("user", existingUser);
                        request.getRequestDispatcher("admin/user/user-edit.jsp").forward(request, response);
                        return;
                    }
                }
            }

            // Validate address length
            if (addressTrimmed != null && addressTrimmed.length() > 500) {
                request.setAttribute("error", "Địa chỉ không được vượt quá 500 ký tự.");
                loadRoles(request);
                request.setAttribute("user", existingUser);
                request.getRequestDispatcher("admin/user/user-edit.jsp").forward(request, response);
                return;
            }

            // Validate roleId
            int roleId;
            try {
                roleId = Integer.parseInt(roleIdParam);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID vai trò không hợp lệ.");
                loadRoles(request);
                request.setAttribute("user", existingUser);
                request.getRequestDispatcher("admin/user/user-edit.jsp").forward(request, response);
                return;
            }

            Roles role = roleDAO.getRoleById(roleId);
            if (role == null) {
                request.setAttribute("error", "Vai trò không tồn tại.");
                loadRoles(request);
                request.setAttribute("user", existingUser);
                request.getRequestDispatcher("admin/user/user-edit.jsp").forward(request, response);
                return;
            }

            // Parse gender và active
            boolean gender = "true".equals(genderParam);
            boolean active = activeParam != null && "true".equals(activeParam);

            // Update user
            existingUser.setDisplayname(displaynameTrimmed);
            existingUser.setEmail(emailTrimmed);
            existingUser.setPhone(phoneTrimmed);
            existingUser.setAddress(addressTrimmed);
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


