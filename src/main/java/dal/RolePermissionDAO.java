/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.RolePermission;
import model.Roles;

/**
 *
 * @author admin
 */
public class RolePermissionDAO extends DBContext {

    public List<RolePermission> getRolePermission() {
        List<RolePermission> rolePermissions = new ArrayList<>();
        String query = "SELECT rl.id, rl.router, r.id as roleId, r.description, r.name, r.status FROM role_permission as rl JOIN roles as r ON rl.role_id = r.id";
        try (PreparedStatement ps = connection.prepareStatement(query);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                RolePermission rp = new RolePermission();
                rp.setId(rs.getInt("id"));
                rp.setRouter(rs.getString("router"));

                Roles role = new Roles();
                role.setId(rs.getInt("roleId"));
                role.setName(rs.getString("name"));
                role.setDescription(rs.getString("description"));
                role.setStatus(rs.getBoolean("status"));
                rp.setRoles(role);

                rolePermissions.add(rp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rolePermissions;
    }

    public void deleteAllRolePermissions() {
        String query = "DELETE FROM role_permission";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void addRolePermission(int roleId, String router) {
        String query = "INSERT INTO role_permission (role_id, router) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, roleId);
            ps.setString(2, router);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
