/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.serviceImpl;

import dal.RoleDAO;
import java.util.ArrayList;
import java.util.List;
import model.Roles;
import service.iService.IRoleService;

/**
 *
 * @author admin
 */
public class RoleServiceImpl implements IRoleService {
    private RoleDAO roleRespone;

    public RoleServiceImpl() {
        this.roleRespone = new RoleDAO();
    }

    @Override
    public List<Roles> getListRoleses() {
        return roleRespone.getAllRoleses();
    }

}
