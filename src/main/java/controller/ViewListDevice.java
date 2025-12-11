/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CategoryDAO;
import dal.DeviceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Device;
import model.DeviceCategory;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "ViewListDevice", urlPatterns = {"/ViewListDevice"})
public class ViewListDevice extends HttpServlet {

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
            out.println("<title>Servlet ViewListDevice</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ViewListDevice at " + request.getContextPath() + "</h1>");
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
        DeviceDAO dev = new DeviceDAO();

        String indexPage = request.getParameter("page");
        int PageSize = 7;
        int Page = 1;

        if (indexPage != null && !indexPage.isEmpty()) {
            try {
                Page = Integer.parseInt(indexPage);
            } catch (NumberFormatException e) {
            }
        }

        int count = dev.getTotalAccount();
        int maxPage = count / PageSize;
        if (count % PageSize != 0) {
            maxPage++;
        }

        CategoryDAO cate = new CategoryDAO();
        List<DeviceCategory> dc = cate.getAllCategory();
        request.setAttribute("deviceCategory", dc);
        
        
        List<Device> devicePart = dev.pagingDevice(Page, PageSize);
        request.setAttribute("devices", devicePart);
        request.setAttribute("crPage", Page);
        request.setAttribute("maxp", maxPage);
        request.getRequestDispatcher("manager/device/listDevice.jsp").forward(request, response);
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
