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
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.util.List;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "EditDevice", urlPatterns = {"/EditDevice"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
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
            e.printStackTrace();
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
    response.setCharacterEncoding("UTF-8");

    String idDevice = request.getParameter("id");
    String name = request.getParameter("name");
    String category_id = request.getParameter("category_id");
    String maintenance_time = request.getParameter("maintenance_time");
    String description = request.getParameter("description");

    DeviceDAO devDAO = new DeviceDAO();
    Device device = new Device();
    
    request.setAttribute("deviceCategory", new CategoryDAO().getAllCategory());
    
    String message = "";
    boolean success = false;
    
    try {
        if (idDevice == null || idDevice.isEmpty()) {
            throw new NumberFormatException("ID thiết bị không hợp lệ.");
        }
        int id = Integer.parseInt(idDevice);
        
        // Lấy device hiện tại để giữ lại ảnh cũ nếu không upload ảnh mới
        Device existingDevice = devDAO.getDeviceById(id);
        if (existingDevice == null) {
            message = "Không tìm thấy thiết bị.";
            success = false;
            request.setAttribute("device", existingDevice);
            request.setAttribute("message", message);
            request.setAttribute("success", success);
            request.getRequestDispatcher("/manager/device/UpdateDevice.jsp").forward(request, response);
            return;
        }
        
        String imagePath = existingDevice.getImage(); // Giữ lại ảnh cũ mặc định
        
        // Xử lý upload ảnh mới (nếu có)
        try {
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                String originalFileName = getFileName(filePart);
                if (originalFileName != null && !originalFileName.trim().isEmpty()) {
                    // Kiểm tra loại file
                    String contentType = filePart.getContentType();
                    if (contentType != null && contentType.startsWith("image/")) {
                        // Sanitize tên file
                        String sanitizedFileName = originalFileName.replaceAll("[^a-zA-Z0-9._-]", "_");
                        String fileName = System.currentTimeMillis() + "_" + sanitizedFileName;
                        
                        // Tạo thư mục upload nếu chưa tồn tại
                        String uploadPath = getServletContext().getRealPath("/uploads/device");
                        java.io.File uploadDir = new java.io.File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdirs();
                        }
                        
                        // Lưu file
                        String fullPath = uploadPath + java.io.File.separator + fileName;
                        filePart.write(fullPath);
                        imagePath = "uploads/device/" + fileName; // Cập nhật với ảnh mới
                    } else {
                        message = "File không phải là ảnh. Vui lòng chọn file ảnh hợp lệ.";
                        success = false;
                        request.setAttribute("device", existingDevice);
                        request.setAttribute("message", message);
                        request.setAttribute("success", success);
                        request.getRequestDispatcher("/manager/device/UpdateDevice.jsp").forward(request, response);
                        return;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Nếu upload ảnh lỗi, giữ lại ảnh cũ
        }
        
        device.setId(id);      
        device.setDescription(description != null ? description.trim() : null);
        device.setImage(imagePath); // Sử dụng ảnh mới hoặc giữ nguyên ảnh cũ
        device.setName(name != null ? name.trim() : null);
        device.setMaintenanceTime(maintenance_time != null ? maintenance_time.trim() : null);      

        devDAO.editDevice(device, category_id);
        
        message = "Cập nhật thiết bị thành công!";
        success = true;

        device = devDAO.getDeviceById(id);
              
    } catch (NumberFormatException e) {
        message = "Lỗi: ID thiết bị không hợp lệ. Vui lòng kiểm tra lại.";
        success = false;
        Device existingDevice = devDAO.getDeviceById(Integer.parseInt(idDevice));
        request.setAttribute("device", existingDevice);
    } catch (Exception e) {
        e.printStackTrace();
        message = "Có lỗi xảy ra khi cập nhật thiết bị: " + e.getMessage();
        success = false;
        try {
            Device existingDevice = devDAO.getDeviceById(Integer.parseInt(idDevice));
            request.setAttribute("device", existingDevice);
        } catch (Exception ex) {
            // Ignore
        }
    } 
    
    request.setAttribute("device", device);
    request.setAttribute("message", message);
    request.setAttribute("success", success);
    request.getRequestDispatcher("/manager/device/UpdateDevice.jsp").forward(request, response);
}

    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            for (String token : contentDisposition.split(";")) {
                if (token.trim().startsWith("filename")) {
                    return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
        }
        return "";
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
