/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.RoleDAO;
import dal.RolePermissionDAO;
import model.RolePermission;
import model.Roles;
import model.RouterGroup;
import utils.RouterDefault;

/**
 *
 * @author admin
 */
@WebServlet(name = "viewRolePermission", urlPatterns = { "/role-permission" })
public class ViewRolePermission extends HttpServlet {

    private RoleDAO roleDAO = new RoleDAO();
    private RolePermissionDAO rolePermissionDAO = new RolePermissionDAO();

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Roles> listRoles = roleDAO.getAllRoleses();
        List<RouterGroup> routerGroups = RouterDefault.getRouterGroups();
        List<RouterGroup> routerGroupsForCus = RouterDefault.getRouterGroupsForCus();
        List<RolePermission> rolePermissions = rolePermissionDAO.getRolePermission();

        request.setAttribute("listRoles", listRoles);
        request.setAttribute("routerGroups", routerGroups);
        request.setAttribute("routerGroupsForCus", routerGroupsForCus);
        request.setAttribute("rolePermissions", rolePermissions);

        request.getRequestDispatcher("admin/role/listRolePermission.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
