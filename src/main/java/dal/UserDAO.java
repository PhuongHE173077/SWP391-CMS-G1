
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
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
        try (PreparedStatement ps = connection.prepareStatement(query);
                ResultSet rs = ps.executeQuery()) {
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
