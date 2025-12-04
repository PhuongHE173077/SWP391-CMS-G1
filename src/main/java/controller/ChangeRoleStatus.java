package controller;

import dal.RoleDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ChangeRoleStatus", urlPatterns = { "/change-role-status" })
public class ChangeRoleStatus extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idRaw = request.getParameter("id");
            String statusRaw = request.getParameter("status");

            int id = Integer.parseInt(idRaw);
            int status = Integer.parseInt(statusRaw);

            RoleDAO dao = new RoleDAO();
            dao.changeRoleStatus(id, status);

            response.sendRedirect("ViewRole");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ViewRole");
        }
    }
}


