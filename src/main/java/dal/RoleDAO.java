/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Roles;

/**
 *
 * @author admin
 */
public class RoleDAO extends DBContext {

    public List<Roles> getAllRoleses() {
        List<Roles> roleses = new ArrayList<>();
        String query = "SELECT * FROM roles";
        try (PreparedStatement ps = connection.prepareStatement(query);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Roles role = new Roles();
                role.setId(rs.getInt("id"));
                role.setName(rs.getString("name"));
                roleses.add(role);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return roleses;
    }

}
