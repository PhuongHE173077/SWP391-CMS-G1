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
                role.setDescription(rs.getString("description"));
                role.setStatus(rs.getBoolean("status"));
                roleses.add(role);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return roleses;
    }

    public Roles getRoleById(int id) {
        String query = "SELECT * FROM roles WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Roles role = new Roles();
                    role.setId(rs.getInt("id"));
                    role.setName(rs.getString("name"));
                    role.setDescription(rs.getString("description"));
                    role.setStatus(rs.getBoolean("status"));
                    return role;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<RolePermission> getPermissionsByRoleId(int roleId) {
        List<RolePermission> permissions = new ArrayList<>();
        String query = "SELECT * FROM role_permission WHERE role_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, roleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RolePermission permission = new RolePermission();
                    permission.setId(rs.getInt("id"));
                    permission.setRouter(rs.getString("router"));
                    permissions.add(permission);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return permissions;
    }
// active/deactive role
    public void changeRoleStatus(int id, int status) {
        String query = "UPDATE roles SET status = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean updateRole(Roles role) {
        String query = "UPDATE roles SET name = ?, description = ?, status = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, role.getName());
            ps.setString(2, role.getDescription());
            ps.setBoolean(3, role.isStatus());
            ps.setInt(4, role.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void deletePermissionsByRoleId(int roleId) {
        String query = "DELETE FROM role_permission WHERE role_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, roleId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void addPermission(int roleId, String router) {
        String query = "INSERT INTO role_permission (role_id, router) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, roleId);
            ps.setString(2, router);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateRolePermissions(int roleId, List<String> routers) {
        deletePermissionsByRoleId(roleId);
        for (String router : routers) {
            addPermission(roleId, router);
        }
    }
    public static void main(String[] args) {
        RoleDAO dao = new RoleDAO();
        List<Roles> roles = dao.getAllRoleses();
        for(Roles role: roles){
            System.out.println(role);
        }
    }
}
