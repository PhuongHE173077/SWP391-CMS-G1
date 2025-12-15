/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CategoryDAO;
import dal.DeviceDAO;
import java.io.IOException;
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
@WebServlet(name = "ViewDeletedDevices", urlPatterns = {"/ViewDeletedDevices"})
public class ViewDeletedDevices extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String categoryIdStr = request.getParameter("category_id");
        int selectedCategoryId = 0;

        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try {
                selectedCategoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException ignored) {
            }
        }

        String textSearch = request.getParameter("textSearch");
        if (textSearch == null) {
            textSearch = ""; 
        }

        String indexPage = request.getParameter("page");
        int PageSize = 7;
        int Page = 1;

        if (indexPage != null && !indexPage.isEmpty()) {
            try {
                Page = Integer.parseInt(indexPage);
            } catch (NumberFormatException ignored) {
            }
        }

        DeviceDAO devDao = new DeviceDAO();

        int count = devDao.getTotalDeletedDevices(selectedCategoryId, textSearch);

        int maxPage = count/PageSize;
        if(count % PageSize != 0){
            ++maxPage;
        }
        

        if (Page > maxPage && maxPage > 0) {
            Page = maxPage;
        }
        if (Page < 1 && maxPage > 0) {
            Page = 1;
        }

        List<Device> devicePart = devDao.getDeletedDevicesWithPaging(Page, PageSize, selectedCategoryId, textSearch);

        CategoryDAO cateDao = new CategoryDAO();
        List<DeviceCategory> dc = cateDao.getAllCategory();

        request.setAttribute("deviceCategory", dc);
        request.setAttribute("devices", devicePart);

        request.setAttribute("crPage", Page);
        request.setAttribute("maxp", maxPage);
        request.setAttribute("selectedCategoryId", selectedCategoryId);
        request.setAttribute("currentSearchText", textSearch);

        request.getRequestDispatcher("manager/device/deleted-device-list.jsp").forward(request, response);
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


