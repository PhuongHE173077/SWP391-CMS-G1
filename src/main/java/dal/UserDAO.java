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

    public boolean editProfile(int id, Users updatedUser) {
        String sql = "UPDATE _user SET displayname = ?, email = ?, phone = ?, "
                + "address = ?, gender = ? WHERE id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, updatedUser.getDisplayname());
            ps.setString(2, updatedUser.getEmail());
            ps.setString(3, updatedUser.getPhone());
            ps.setString(4, updatedUser.getAddress());
            ps.setBoolean(5, updatedUser.isGender());
            ps.setInt(6, id);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean insertUser(Users user) {
        String sql = "INSERT INTO _user (displayname, email, password, phone, active, address, gender, role_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getDisplayname());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getPhone());
            ps.setBoolean(5, user.isActive());
            ps.setString(6, user.getAddress());
            ps.setBoolean(7, user.isGender());
            ps.setInt(8, user.getRoles().getId());
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Users> searchUsers(String keyword, String roleId, String status, String gender, int pageIndex) {
        List<Users> list = new ArrayList<>();
        // số lượng User trên 1 page
        int pageSize = 5;

        /*
         * Tính toán số lượng records cần phải BỎ QUA trước khi bắt đầu lấy dữ liệu.
         * Trang 1 (pageIndex = 1):
         * Lấy 5 người đầu tiên(1 -> 5)
         * => offset bỏ qua 0 người
         * Công thức: (1 - 1) * 5 = 0.
         * 
         * Trang 2: (pageIndex = 2)
         * Lấy 5 người tiếp theo (6->10)
         * => offset bỏ qua 5 người từ 1->5(vì đã lấy ở pageIndex =1 rồi)
         * Công thức: (2 - 1) * 5 = 5.
         */
        int offset = (pageIndex - 1) * pageSize;
        String sql = "SELECT u.*, r.name as role_name "
                + "FROM _user u "
                + "INNER JOIN roles r ON u.role_id = r.id "
                + "WHERE 1=1 and u.role_id != 1";

        // 2. Nếu user chọn filter nào thì nối thêm câu SQL đó
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
        sql += " LIMIT ? OFFSET ?";

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
            ps.setInt(index++, pageSize); // Lấy 5 người
            ps.setInt(index++, offset); // Bỏ qua offset người

            // 4. Chạy câu lệnh và lấy kết quả (Giống hệt hàm getAll cũ)
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
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
                list.add(user);
            }

        } catch (SQLException e) {
            System.out.println("Lỗi lấy danh sách User: " + e.getMessage());
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
            ps.setInt(2, id); // id

            ps.executeUpdate(); // Chạy lệnh Update

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Users getUserById(int userId) {
        // SQL vẫn phải JOIN bảng role để lấy tên Role
        String sql = "SELECT u.*, r.name as role_name "
                + "FROM _user u "
                + "INNER JOIN roles r ON u.role_id = r.id "
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

    public boolean updateUser(Users user) {
        String sql = "UPDATE _user SET displayname = ?, email = ?, phone = ?, "
                + "address = ?, gender = ?, active = ?, role_id = ? WHERE id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getDisplayname());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getAddress());
            ps.setBoolean(5, user.isGender());
            ps.setBoolean(6, user.isActive());
            ps.setInt(7, user.getRoles().getId());
            ps.setInt(8, user.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // 1. Hàm đếm tổng số kết quả tìm được (Để tính số trang)
    public int countUsers(String keyword, String roleId, String status, String gender) {
        String sql = "SELECT COUNT(*) FROM _user u WHERE 1=1 and u.role_id != 1";

        // Copy y nguyên phần nối chuỗi điều kiện ở hàm search cũ
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND u.displayname LIKE ? ";
        }
        if (roleId != null && !roleId.isEmpty()) {
            sql += " AND u.role_id = ? ";
        }
        if (status != null && !status.isEmpty()) {
            sql += " AND u.active = ? ";
        }
        if (gender != null && !gender.isEmpty()) {
            sql += " AND u.gender = ? ";
        }

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            // Copy y nguyên phần set tham số (index)
            int index = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
            }
            if (roleId != null && !roleId.isEmpty()) {
                ps.setInt(index++, Integer.parseInt(roleId));
            }
            if (status != null && !status.isEmpty()) {
                ps.setBoolean(index++, status.equals("1"));
            }
            if (gender != null && !gender.isEmpty()) {
                ps.setBoolean(index++, gender.equals("1"));
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        String checkSql = "SELECT * FROM _user WHERE id = ? AND password = ?";
        try (PreparedStatement checkPs = connection.prepareStatement(checkSql)) {
            checkPs.setInt(1, userId);
            checkPs.setString(2, oldPassword);

            try (ResultSet rs = checkPs.executeQuery()) {
                if (!rs.next()) {
                    return false;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        String updateSql = "UPDATE _user SET password = ? WHERE id = ?";
        try (PreparedStatement updatePs = connection.prepareStatement(updateSql)) {
            updatePs.setString(1, newPassword);
            updatePs.setInt(2, userId);

            return updatePs.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
    public boolean updateUser(Users user) {
        String sql = "UPDATE _user SET displayname = ?, phone = ?, address = ?, "
                   + "gender = ?, role_id = ?, active = ? WHERE id = ?";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, user.getDisplayname());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getAddress());
            ps.setBoolean(4, user.isGender());
            
            // Lưu ý: user.getRoles().getId() lấy ID của Role
            ps.setInt(5, user.getRoles().getId()); 
            ps.setBoolean(6, user.isActive());
            ps.setInt(7, user.getId());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static void main(String[] args) {
        UserDAO u = new UserDAO();
        Users user = u.login("vana@example.com", "hashedpass1");
        if (user != null) {
            System.out.println("Login success: " + user.getDisplayname());
        } else {
            System.out.println("Login failed");
        }
    }

}
