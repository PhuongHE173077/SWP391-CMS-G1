
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Users;

public class UserDAO extends DBContext{

    PreparedStatement ps = null;
    ResultSet rs = null;

    public List<Users> getAllUser() {
        List<Users> listUser = new ArrayList<>();
        String query = "SELECT * FROM Users";
        try {
            
            ps = connection.prepareStatement(query);
            rs = ps.executeQuery();
            while (rs.next()) {
                listUser.add(new Users(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getString(4),
                        rs.getString(5),
                        rs.getBoolean(6),
                        rs.getInt(7),
                        rs.getString(8),                       
                        rs.getBoolean(9)));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listUser;
    }
  
    public Users login(String user, String password) {
        String query = "select * from Users\n"
                + "where email = ?\n"
                + "and password = ?";
        try {
            
            ps = connection.prepareStatement(query);
            ps.setString(1, user);
            ps.setString(2, password);
            rs = ps.executeQuery();
            while (rs.next()) {
                return new Users(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getString(4),
                        rs.getString(5),
                        rs.getBoolean(6),
                        rs.getInt(7),
                        rs.getString(8),                       
                        rs.getBoolean(9));

            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
        
    public static void main(String[] args) {
        UserDAO u = new UserDAO();
        System.out.println(u.login("vana@example.com", "hashedpass1"));
    }
}
