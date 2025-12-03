package controller;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.RolePermission;
import model.Roles;
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

            // Tạo danh sách permission với tên hiển thị từ RouterDefault
            List<Map<String, String>> permissionList = new ArrayList<>();
            for (RolePermission permission : permissions) {
                Map<String, String> permMap = new HashMap<>();
                permMap.put("router", permission.getRouter());
                permMap.put("name", RouterDefault.getRouterNameByPath(permission.getRouter()));
                permMap.put("groupName", RouterDefault.getGroupNameByRouterPath(permission.getRouter()));
                permissionList.add(permMap);
            }

            request.setAttribute("role", role);
            request.setAttribute("permissionList", permissionList);
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
