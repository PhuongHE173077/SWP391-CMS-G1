package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dal.RoleDAO;
import dal.UserDAO;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Roles;
import model.Users;
import org.mindrot.jbcrypt.BCrypt;
import utils.SendMail;

@WebServlet(name = "AddCustomer", urlPatterns = {"/AddCustomer"})
public class AddCustomer extends HttpServlet {

    private static final String DEFAULT_PASSWORD = "Cms123456";
    private static final int CUSTOMER_ROLE_ID = 4;

    private UserDAO userDAO;
    private RoleDAO roleDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        roleDAO = new RoleDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        JsonObject jsonResponse = new JsonObject();
        Gson gson = new Gson();

        try (PrintWriter out = response.getWriter()) {
            // Read JSON body
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            JsonObject jsonRequest = gson.fromJson(sb.toString(), JsonObject.class);

            String name = jsonRequest.has("name") ? jsonRequest.get("name").getAsString().trim() : "";
            String phone = jsonRequest.has("phone") ? jsonRequest.get("phone").getAsString().trim() : "";
            String email = jsonRequest.has("email") ? jsonRequest.get("email").getAsString().trim() : "";
            String address = jsonRequest.has("address") ? jsonRequest.get("address").getAsString().trim() : "";

            // Validate required fields
            if (name.isEmpty() || phone.isEmpty() || email.isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng nhập đầy đủ thông tin bắt buộc!");
                out.print(gson.toJson(jsonResponse));
                return;
            }

            // Check email exists
            if (userDAO.checkEmailExists(email)) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Email này đã tồn tại trong hệ thống!");
                out.print(gson.toJson(jsonResponse));
                return;
            }

            // Check phone exists
            if (userDAO.checkPhoneExists(phone)) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Số điện thoại này đã tồn tại trong hệ thống!");
                out.print(gson.toJson(jsonResponse));
                return;
            }

            // Get customer role
            Roles customerRole = roleDAO.getRoleById(CUSTOMER_ROLE_ID);
            if (customerRole == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không tìm thấy vai trò khách hàng!");
                out.print(gson.toJson(jsonResponse));
                return;
            }

            // Create user with default password
            Users user = new Users();
            user.setDisplayname(name);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address.isEmpty() ? null : address);
            user.setGender(true);
            user.setActive(true);
            user.setRoles(customerRole);

            // Hash default password
            String hashedPassword = BCrypt.hashpw(DEFAULT_PASSWORD, BCrypt.gensalt());
            user.setPassword(hashedPassword);

            boolean success = userDAO.insertUser(user);

            if (success) {
                // Send email notification
                new Thread(() -> {
                    try {
                        sendWelcomeEmail(email, name, DEFAULT_PASSWORD);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }).start();

                // Get the newly created user to return
                Users newUser = userDAO.getUserByEmail(email);

                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Tạo tài khoản khách hàng thành công!");

                // Return customer info for auto-select
                JsonObject customerInfo = new JsonObject();
                if (newUser != null) {
                    customerInfo.addProperty("id", newUser.getId());
                    customerInfo.addProperty("name", newUser.getDisplayname());
                    customerInfo.addProperty("phone", newUser.getPhone());
                    customerInfo.addProperty("email", newUser.getEmail());
                }
                jsonResponse.add("customer", customerInfo);

            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Có lỗi xảy ra khi tạo tài khoản!");
            }

            out.print(gson.toJson(jsonResponse));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi hệ thống: " + e.getMessage());
            try (PrintWriter out = response.getWriter()) {
                out.print(new Gson().toJson(jsonResponse));
            }
        }
    }

    private void sendWelcomeEmail(String toEmail, String customerName, String password) {
        try {
            String subject = "Chào mừng bạn đến với CMS - Thông tin tài khoản";
            String content = "Xin chào " + customerName + ",\n\n"
                    + "Tài khoản của bạn đã được tạo thành công trên hệ thống CMS.\n\n"
                    + "Thông tin đăng nhập:\n"
                    + "- Email: " + toEmail + "\n"
                    + "- Mật khẩu: " + password + "\n\n"
                    + "Vui lòng đổi mật khẩu sau khi đăng nhập lần đầu.\n\n"
                    + "Trân trọng,\n"
                    + "Đội ngũ CMS";

            SendMail.send(toEmail, subject, content);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Lỗi khi gửi email chào mừng: " + e.getMessage());
        }
    }

    @Override
    public String getServletInfo() {
        return "Add Customer Servlet";
    }
}
