/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.RoleDAO;
import model.RolePermission;
import model.RouterGroup;
import model.Roles;
import utils.RouterDefault;

/**
 *
 * @author admin
 */
@WebServlet(name = "EditRole", urlPatterns = { "/EditRole" })
public class EditRole extends HttpServlet {

    private RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("ViewRole");
            return;
        }

        try {
            int roleId = Integer.parseInt(idParam);
            Roles role = roleDAO.getRoleById(roleId);
            if (role == null) {
                response.sendRedirect("ViewRole");
                return;
            }

            
            List<RolePermission> currentPermissions = roleDAO.getPermissionsByRoleId(roleId);
            Set<String> currentRouters = new HashSet<>();
            for (RolePermission perm : currentPermissions) {
                currentRouters.add(perm.getRouter());
            }

           
            List<RouterGroup> routerGroups = RouterDefault.getRouterGroups();

            request.setAttribute("role", role);
            request.setAttribute("routerGroups", routerGroups);
            request.setAttribute("currentRouters", currentRouters);
            request.getRequestDispatcher("/admin/role/RoleEdit.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("ViewRole");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String statusParam = request.getParameter("status");
        String[] selectedRouters = request.getParameterValues("permissions");

        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("ViewRole");
            return;
        }

        try {
            int roleId = Integer.parseInt(idParam);
            Roles role = roleDAO.getRoleById(roleId);
            if (role == null) {
                response.sendRedirect("ViewRole");
                return;
            }

            
            role.setName(name);
            role.setDescription(description);
            role.setStatus("on".equals(statusParam) || "true".equals(statusParam));
            roleDAO.updateRole(role);

            
            List<String> routers = new ArrayList<>();
            if (selectedRouters != null) {
                for (String router : selectedRouters) {
                    routers.add(router);
                }
            }
            roleDAO.updateRolePermissions(roleId, routers);

            response.sendRedirect("RoleDetail?id=" + roleId);

        } catch (NumberFormatException e) {
            response.sendRedirect("ViewRole");
        }
    }

    @Override
    public String getServletInfo() {
        return "Edit Role Servlet";
    }

}
