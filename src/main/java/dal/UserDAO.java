package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Roles;
import model.Users;
import org.mindrot.jbcrypt.BCrypt;

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
        try {
            int roleId = rs.getInt("role_id");
            if (!rs.wasNull()) {
                Roles role = new Roles();
                role.setId(roleId);
                try {
                    role.setName(rs.getString("role_name"));
                } catch (SQLException ignore) {
                }
                user.setRoles(role);
            }
        } catch (SQLException ignore) {
        }
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

    public List<Users> searchUsers(String keyword, String roleId, String status, String gender, int pageIndex,
            int pageSize, String sortBy, String sortOrder) {
        List<Users> list = new ArrayList<>();
        // số lượng User trên 1 page
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
        // 1
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND u.displayname LIKE ? ";
        }

        // Nếu có chọn Role (Khác rỗng)
        // 2
        if (roleId != null && !roleId.isEmpty()) {
            sql += " AND u.role_id = ? ";
        }

        // Nếu có chọn Status
        // 3
        if (status != null && !status.isEmpty()) {
            sql += " AND u.active = ? ";
        }

        // Nếu có chọn Gender
        // 4
        if (gender != null && !gender.isEmpty()) {
            sql += " AND u.gender = ? ";
        }
        // default khi hiện list là order by user Id
        String listSort = " ORDER BY u.id DESC";

        if (sortBy != null && !sortBy.isEmpty()) {
            String orderBy = (sortOrder != null && sortOrder.equalsIgnoreCase("ASC")) ? "ASC" : "DESC";

            switch (sortBy) {
                case "fullname":
                    listSort = " ORDER BY u.displayname " + orderBy;
                    break;
                case "email":
                    listSort = " ORDER BY u.email " + orderBy;
                    break;
                case "id":
                    listSort = " ORDER BY u.id " + orderBy;
                    break;
                case "createdAt": // Đã sửa từ 'created_at' để khớp với biến JSP
                    listSort = " ORDER BY u.created_at " + orderBy;
                    break;
                default:
                    listSort = " ORDER BY u.id DESC"; // Mặc định
                    break;
            }
        }
        sql += listSort;
        sql += " LIMIT ? OFFSET ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            int index = 1;

            // ? của search Keyword
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
            }
            if (roleId != null && !roleId.isEmpty()) {
                ps.setInt(index++, Integer.parseInt(roleId));
            }
            // ? của status, Nếu status="1" -> set true (Active), ngược lại set false
            // (Inactive)
            if (status != null && !status.isEmpty()) {
                ps.setBoolean(index++, status.equals("1"));
            }
            if (gender != null && !gender.isEmpty()) {
                // Giải thích: Nếu gender="1" -> set true (Male), ngược lại set false (Female)
                ps.setBoolean(index++, gender.equals("1"));
            }
            // ? của pageSize, lấy 3 người/ 1 page
            ps.setInt(index++, pageSize);
            // ? của offset, Bỏ qua offset người
            ps.setInt(index++, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Roles role = new Roles();
                role.setId(rs.getInt("role_id"));
                role.setName(rs.getString("role_name"));
                Users user = new Users();
                user.setId(rs.getInt("id"));
                user.setDisplayname(rs.getString("displayname"));
                user.setCreatedAt(rs.getObject("created_at", java.time.OffsetDateTime.class));
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
            System.out.println("Error when get User List: " + e.getMessage());
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
        try {
            // 1️⃣ Lấy mật khẩu hiện tại (đang hash trong DB)
            String sql = "SELECT password FROM _user WHERE id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                return false; // Không tìm thấy user
            }

            String hashedPassword = rs.getString("password");

            if (!BCrypt.checkpw(oldPassword, hashedPassword)) {
                return false;
            }

            String newHashed = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));

            String updateSql = "UPDATE _user SET password = ? WHERE id = ?";
            PreparedStatement ps2 = connection.prepareStatement(updateSql);
            ps2.setString(1, newHashed);
            ps2.setInt(2, userId);

            return ps2.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean checkEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM _user WHERE email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean checkPhoneExists(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false; // Phone là optional, nếu null hoặc empty thì không cần check
        }
        String sql = "SELECT COUNT(*) FROM _user WHERE phone = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, phone.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Users getUserByEmail(String email) {
        String sql = "SELECT u.*, r.name as role_name "
                + "FROM _user u "
                + "INNER JOIN roles r ON u.role_id = r.id "
                + "WHERE u.email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updatePassword(String email, String newPass) {
        String sql = "UPDATE _user SET password=? WHERE email=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, newPass);
            st.setString(2, email);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Users> searchUsersByKeyword(String keyword) {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT u.*, r.name as role_name "
                + "FROM _user u "
                + "INNER JOIN roles r ON u.role_id = r.id "
                + "WHERE (u.email LIKE ? OR u.displayname LIKE ? OR u.phone LIKE ?) "
                + "AND u.active = 1 "
                + "LIMIT 10";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);

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
            System.out.println("Error searching users: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public List<Users> searchUsersByPhone(String keyword, int pageSize) {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT u.*, r.name as role_name "
                + "FROM _user u "
                + "INNER JOIN roles r ON u.role_id = r.id "
                + "WHERE ( u.phone LIKE ?) "
                + "AND u.active = 1 AND u.role_id != 1 "
                + "LIMIT ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setInt(2, pageSize);

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
            System.out.println("Error searching users: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public List<Users> getAllManagerSaleStaff() {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT u.*, r.name AS role_name "
                + "FROM _user u "
                + "INNER JOIN roles r ON u.role_id = r.id "
                + "WHERE u.role_id IN (2, 3) AND u.active = 1";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Users u = new Users();
                u.setId(rs.getInt("id"));
                u.setDisplayname(rs.getString("displayname"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setAddress(rs.getString("address"));
                u.setActive(rs.getBoolean("active"));

                Roles r = new Roles();
                r.setId(rs.getInt("role_id"));
                r.setName(rs.getString("role_name"));
                u.setRoles(r);
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Hàm lấy danh sách tất cả Customer để đổ vào Dropdown Filter
    public List<Users> getAllCustomers() {
        List<Users> list = new ArrayList<>();
        // role_id = 4 là Customer (dựa theo dữ liệu insert roles của bạn)
        String sql = "SELECT * FROM _user WHERE role_id = 4";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Users u = new Users();
                u.setId(rs.getInt("id"));
                u.setDisplayname(rs.getString("displayname"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setAddress(rs.getString("address"));
                u.setActive(rs.getBoolean("active"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Integer> getExistingGenders() {
        List<Integer> list = new ArrayList<>();
        // Query lấy các giá trị 0 hoặc 1 đang có trong bảng
        String sql = "SELECT DISTINCT gender FROM _user WHERE gender IS NOT NULL ORDER BY gender DESC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                // Lấy thẳng giá trị boolean, convert sang int (1 hoặc 0)
                int genderId = rs.getBoolean("gender") ? 1 : 0;
                list.add(genderId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
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
