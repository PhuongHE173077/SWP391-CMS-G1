package controller;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

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
import model.RolePermission;
import model.Roles;
import model.RouterGroup;
import model.Routers;
import service.serviceImpl.RoleServiceImpl;
import utils.RouterDefault;

/**
 *
 * @author admin
 */
@WebServlet(urlPatterns = { "/RoleDetail" })
public class ViewRoleDetail extends HttpServlet {

    private RoleServiceImpl roleService;

    @Override
    public void init() throws ServletException {
        roleService = new RoleServiceImpl();
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
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
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("ViewRole");
            return;
        }

        try {
            int roleId = Integer.parseInt(idParam);
            Roles role = roleService.getRoleById(roleId);

            if (role == null) {
                response.sendRedirect("ViewRole");
                return;
            }

            List<RolePermission> permissions = roleService.getPermissionsByRoleId(roleId);


            Set<String> permittedRouters = new HashSet<>();
            for (RolePermission perm : permissions) {
                permittedRouters.add(perm.getRouter());
            }

            List<RouterGroup> filteredGroups = new ArrayList<>();
            for (RouterGroup group : RouterDefault.getRouterGroups()) {
                List<Routers> matchedRouters = new ArrayList<>();
                for (Routers router : group.getRouterses()) {
                    if (permittedRouters.contains(router.getRouter())) {
                        matchedRouters.add(router);
                    }
                }
                
                if (!matchedRouters.isEmpty()) {
                    RouterGroup filteredGroup = new RouterGroup(group.getId(), group.getName(), matchedRouters);
                    filteredGroups.add(filteredGroup);
                }
            }

            request.setAttribute("role", role);
            request.setAttribute("permissionGroups", filteredGroups);
            request.getRequestDispatcher("admin/role/roleDetail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("ViewRole");
        }
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
