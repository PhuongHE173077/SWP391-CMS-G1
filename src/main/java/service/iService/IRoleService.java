/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.iService;

import java.util.List;
import model.RolePermission;
import model.Roles;

/**
 *
 * @author admin
 */
public interface IRoleService {

    List<Roles> getListRoleses();

    Roles getRoleById(int id);

    List<RolePermission> getPermissionsByRoleId(int roleId);
}
