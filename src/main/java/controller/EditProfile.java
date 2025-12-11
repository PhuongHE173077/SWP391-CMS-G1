package controller;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

@WebServlet(name = "EditProfile", urlPatterns = {"/EditProfile"})
public class EditProfile extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Lấy user đang đăng nhập từ session
        Users user = (Users) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("editprofile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        Users currentUser = (Users) session.getAttribute("user");

        // Nếu chưa đăng nhập
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int id = currentUser.getId(); // Lấy id từ session

        String displayname = request.getParameter("displayname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        boolean gender = "male".equalsIgnoreCase(request.getParameter("gender"));

        // Lấy email và phone hiện tại của user
        String currentEmail = currentUser.getEmail();
        String currentPhone = currentUser.getPhone();

        UserDAO dao = new UserDAO();
        String errorMessage = null;

        // Check email nếu email mới khác email hiện tại
        if (email != null && !email.trim().equalsIgnoreCase(currentEmail != null ? currentEmail.trim(): "")) {
            if (dao.checkEmailExists(email.trim())) {
                errorMessage = "Email này đã được sử dụng bởi người dùng khác!";
            }
        }

        // Check phone nếu phone mới khác phone hiện tại
        if (errorMessage == null && phone != null && !phone.trim().isEmpty()) {
            String currentPhoneTrimmed = currentPhone != null ? currentPhone.trim() : "";
            if (!phone.trim().equals(currentPhoneTrimmed)) {
                if (dao.checkPhoneExists(phone.trim())) {
                    errorMessage = "Số điện thoại này đã được sử dụng bởi người dùng khác!";
                }
            }
        }

        // Nếu có lỗi, trả về form với thông báo lỗi
        if (errorMessage != null) {
            Users updated = new Users();
            updated.setId(id);
            updated.setDisplayname(displayname);
            updated.setEmail(email);
            updated.setPhone(phone);
            updated.setAddress(address);
            updated.setGender(gender);

            request.setAttribute("error", errorMessage);
            request.setAttribute("user", updated);
            request.getRequestDispatcher("editprofile.jsp").forward(request, response);
            return;
        }

        Users updated = new Users();
        updated.setId(id);
        updated.setDisplayname(displayname);
        updated.setEmail(email);
        updated.setPhone(phone);
        updated.setAddress(address);
        updated.setGender(gender);

        boolean success = dao.editProfile(id, updated);

        if (success) {
            // Cập nhật lại session sau khi update profile
            session.setAttribute("user", dao.viewProfile(id));
            response.sendRedirect("ViewProfile");
        } else {
            request.setAttribute("error", "Update failed!");
            request.setAttribute("user", updated);
            request.getRequestDispatcher("editprofile.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Edit profile using session";
    }
}
