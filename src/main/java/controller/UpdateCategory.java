/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CategoryDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.DeviceCategory;

/**
 *
 * @author Dell
 */
@WebServlet(name = "UpdateCategory", urlPatterns = {"/UpdateCategory"})
public class UpdateCategory extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UpdateCategory</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateCategory at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id_raw = request.getParameter("id");

        try {
            int id = Integer.parseInt(id_raw);

            CategoryDAO dao = new CategoryDAO();
            DeviceCategory category = dao.getCategoryById(id);

            if (category == null) {
                request.setAttribute("error", "Danh mục không tồn tại!");
                request.getRequestDispatcher("ViewListCategory").forward(request, response);
                return;
            }

            request.setAttribute("category", category);
            request.getRequestDispatcher("manager/UpdateCategory.jsp").forward(request, response);

        } catch (Exception e) {
            response.sendRedirect("ViewListCategory");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // ⭐ Lấy id đúng từ form, không dùng session
        int id = Integer.parseInt(request.getParameter("id"));

        String name = request.getParameter("name");

        CategoryDAO dao = new CategoryDAO();
        boolean success = dao.updateCategory(id, name);

        if (success) {
            session.setAttribute("success", "Cập nhật danh mục thành công!");
        } else {
            session.setAttribute("error", "Cập nhật thất bại!");
        }

        response.sendRedirect("ViewListCategory");

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
