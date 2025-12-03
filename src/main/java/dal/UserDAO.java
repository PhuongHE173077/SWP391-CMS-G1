package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Roles;
import model.Users;

public class UserDAO extends DBContext {

    private Users mapResultSetToUser(ResultSet rs) throws SQLException {
        Users user = new Users();
        user.setId(rs.getInt("id"));
        user.setDisplayname(rs.getString("displayname"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setPhone(rs.getString("phone"));
        user.setActive(rs.getBoolean("active"));
        user.setAddress(rs.getString("address"));
        user.setGender(rs.getBoolean("gender"));
        // Note: roles cần được load riêng nếu cần
        return user;
    }

    public List<Users> getAllUser() {
        List<Users> listUser = new ArrayList<>();
        String query = "SELECT * FROM _user";
        try (PreparedStatement ps = connection.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                listUser.add(mapResultSetToUser(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listUser;
    }

    public Users login(String email, String password) {
        String query = "SELECT * FROM _user WHERE email = ? AND password = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Users viewProfile(int id) {
        String query = "SELECT * FROM _user WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static void main(String[] args) {
//        UserDAO u = new UserDAO();
//        Users user = u.login("admin@system.com", "123456");
//        if (user != null) {
//            System.out.println("Login success: " + user.getDisplayname());
//        } else {
//            System.out.println("Login failed");
//        }
        UserDAO u = new UserDAO();
        List<Users> list = u.getAllUsersWithRole();
        for (Users us : list) {
            System.out.println(us.getId() + "_Name: " + us.getDisplayname() + "_Role: " + us.getRoles().getName());
        }
    }

    public List<Users> getAllUsersWithRole() {
        List<Users> users = new ArrayList<>();
        String sql = "SELECT u.*, r.name as role_name \n"
                + "                   FROM _user u \n"
                + "                   INNER JOIN role r ON u.role_id = r.id\n"
                + "                   where u.role_id != 1";
        try {
            //câu lệnh để kết nối database
            PreparedStatement ps = connection.prepareStatement(sql);
            //thực thi câu lệnh, lấy kết quả
            ResultSet rs = ps.executeQuery();
            //duyệt qua từng kết quả
            while (rs.next()) {
                Roles role = new Roles();
                role.setId(rs.getInt("role_id"));
                role.setName(rs.getString("role_name"));

                Users user = new Users();
                //Map từng cột
                user.setId(rs.getInt("id"));
                user.setDisplayname(rs.getString("displayname"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setPhone(rs.getString("phone"));
                user.setActive(rs.getBoolean("active"));
                user.setAddress(rs.getString("address"));
                user.setGender(rs.getBoolean("gender"));
                user.setRoles(role);
                users.add(user);
            }
        } catch (SQLException ex) {
            System.out.println("Lỗi lấy danh sách User: " + ex.getMessage());
            ex.printStackTrace();
        }
        return users;
    }

    public List<Users> searchUsers(String keyword, String roleId, String status, String gender) {
        List<Users> list = new ArrayList<>();

        // 1. Câu SQL gốc (Luôn dùng WHERE 1=1 để dễ nối chuỗi)
        // Lưu ý: Vẫn phải JOIN bảng role để lấy tên role
        String sql = "SELECT u.*, r.name as role_name "
                + "FROM _user u "
                + "INNER JOIN role r ON u.role_id = r.id "
                + "WHERE 1=1 and u.role_id != 1";

        // 2. Nếu người dùng có chọn filter nào thì nối thêm câu SQL đó
        // (Dùng dấu ? để lát nữa điền dữ liệu sau - chống hack SQL)
        // Nếu có nhập từ khóa (Search)
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND u.displayname LIKE ? ";
        }

        // Nếu có chọn Role (Khác rỗng)
        if (roleId != null && !roleId.isEmpty()) {
            sql += " AND u.role_id = ? ";
        }

        // Nếu có chọn Status
        if (status != null && !status.isEmpty()) {
            sql += " AND u.active = ? ";
        }

        // Nếu có chọn Gender
        if (gender != null && !gender.isEmpty()) {
            sql += " AND u.gender = ? ";
        }

        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            // 3. Điền giá trị vào các dấu hỏi chấm (?)
            // Ta dùng biến 'index' để đếm thứ tự dấu hỏi
            int index = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword + "%"); // Dấu ? thứ 1
            }
            if (roleId != null && !roleId.isEmpty()) {
                ps.setInt(index++, Integer.parseInt(roleId)); // Dấu ? tiếp theo
            }
            if (status != null && !status.isEmpty()) {
                // Chuyển chuỗi "1"/"0" thành boolean true/false
                ps.setBoolean(index++, status.equals("1"));
            }
            if (gender != null && !gender.isEmpty()) {
                ps.setBoolean(index++, gender.equals("1"));
            }

            // 4. Chạy câu lệnh và lấy kết quả (Giống hệt hàm getAll cũ)
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Roles role = new Roles();
                role.setId(rs.getInt("role_id"));
                role.setName(rs.getString("role_name")); // Nhớ lấy theo alias role_name

                Users user = new Users();
                user.setId(rs.getInt("id"));
                user.setDisplayname(rs.getString("displayname"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setPhone(rs.getString("phone"));
                user.setActive(rs.getBoolean("active"));
                user.setAddress(rs.getString("address"));
                user.setGender(rs.getBoolean("gender"));

                user.setRoles(role);
                list.add(user);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void changeStatus(int id, int status) {
        // status: 1 là Active, 0 là Inactive
        String sql = "UPDATE _user SET active = ? WHERE id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            // Set tham số theo thứ tự dấu ?
            ps.setInt(1, status); // status
            ps.setInt(2, id);     // id

            ps.executeUpdate();   // Chạy lệnh Update

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Users getUserById(int userId) {
        // SQL vẫn phải JOIN bảng role để lấy tên Role
        String sql = "SELECT u.*, r.name as role_name "
                + "FROM _user u "
                + "INNER JOIN role r ON u.role_id = r.id "
                + "WHERE u.id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId); // Điền ID vào dấu hỏi chấm

            ResultSet rs = ps.executeQuery();

            // Dùng if (rs.next()) thay vì while vì ID là duy nhất, chỉ có tối đa 1 kết quả
            if (rs.next()) {
                Roles role = new Roles();
                role.setId(rs.getInt("role_id"));
                role.setName(rs.getString("role_name"));

                Users user = new Users();
                user.setId(rs.getInt("id"));
                user.setDisplayname(rs.getString("displayname"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setPhone(rs.getString("phone"));
                user.setActive(rs.getBoolean("active"));
                user.setAddress(rs.getString("address"));
                user.setGender(rs.getBoolean("gender"));

                user.setRoles(role);
                return user; 
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;  
    }

}
