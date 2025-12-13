/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.DeviceDAO;
import dal.CategoryDAO;
import model.Device;
import model.DeviceCategory;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "EditDevice", urlPatterns = {"/EditDevice"})
public class EditDevice extends HttpServlet {

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
            out.println("<title>Servlet EditDevice</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditDevice at " + request.getContextPath() + "</h1>");
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

        String sid = request.getParameter("id");
        DeviceDAO dev = new DeviceDAO();
        try {
            int id = Integer.parseInt(sid);
            Device divice = dev.getDeviceById(id);

            CategoryDAO cate = new CategoryDAO();
            List<DeviceCategory> deviceCategory = cate.getAllCategory();

            request.setAttribute("deviceCategory", deviceCategory);
            request.setAttribute("device", divice);
            request.getRequestDispatcher("manager/device/UpdateDevice.jsp").forward(request, response);
        } catch (NumberFormatException e) {
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
   
    request.setCharacterEncoding("UTF-8"); 

    String idStr = request.getParameter("id");
    String name = request.getParameter("name");
    String category_id = request.getParameter("category_id");
    String image = request.getParameter("image");
    String maintenance_time = request.getParameter("maintenance_time");
    String description = request.getParameter("description");

    DeviceDAO devDAO = new DeviceDAO();
    Device device = new Device();
    
    request.setAttribute("deviceCategory", new CategoryDAO().getAllCategory());
    
    String message = "";
    boolean success = false;
    
    try {
        if (idStr == null || idStr.isEmpty()) {
            throw new NumberFormatException("ID thiết bị không hợp lệ.");
        }
        int id = Integer.parseInt(idStr);
        device.setId(id);
        
        device.setDescription(description);
        device.setImage(image);
        device.setName(name);
        device.setMaintenanceTime(maintenance_time);      

        devDAO.editDevice(device, category_id);
        
        message = "Cập nhật thiết bị thành công!";
        success = true;

        device = devDAO.getDeviceById(id);
              
    } catch (NumberFormatException e) {
        message = "Lỗi: ID thiết bị không hợp lệ. Vui lòng kiểm tra lại.";
        success = false;
        
    } 
    
    request.setAttribute("device", device);
    request.setAttribute("message", message);
    request.setAttribute("success", success);

    request.getRequestDispatcher("/manager/device/UpdateDevice.jsp").forward(request, response);
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
