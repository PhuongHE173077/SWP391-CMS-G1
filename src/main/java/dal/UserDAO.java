
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
