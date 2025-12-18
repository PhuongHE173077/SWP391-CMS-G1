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
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.util.List;
import model.Device;
import model.DeviceCategory;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "AddDevice", urlPatterns = {"/AddDevice"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class AddDevice extends HttpServlet {

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
            out.println("<title>Servlet AddDevice</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddDevice at " + request.getContextPath() + "</h1>");
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
        CategoryDAO cate = new CategoryDAO();
        List<DeviceCategory> deviceCategoryList = cate.getAllCategory();
        request.setAttribute("deviceCategory", deviceCategoryList);
        request.getRequestDispatcher("manager/device/AddDevice.jsp").forward(request, response);

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
        
        String name = request.getParameter("name");
        String maintenance_time = request.getParameter("maintenance_time");
        String description = request.getParameter("description");
        String categoryId = request.getParameter("category_id");

        String message = "";
        boolean success = false;

        // Validate required fields
        if (name == null || name.trim().isEmpty()
                || categoryId == null || categoryId.trim().isEmpty()
                || maintenance_time == null || maintenance_time.trim().isEmpty()) {
            message = "Vui lòng nhập đầy đủ thông tin bắt buộc";
            success = false;
        } else {
            try {
                int categoryID = Integer.parseInt(categoryId);

                // Xử lý upload ảnh
                String imagePath = null;
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
                                imagePath = "uploads/device/" + fileName;
                            } else {
                                message = "File không phải là ảnh. Vui lòng chọn file ảnh hợp lệ.";
                                success = false;
                                CategoryDAO cate = new CategoryDAO();
                                List<DeviceCategory> deviceCategoryList = cate.getAllCategory();
                                request.setAttribute("deviceCategory", deviceCategoryList);
                                request.setAttribute("message", message);
                                request.setAttribute("success", success);
                                request.getRequestDispatcher("/manager/device/AddDevice.jsp").forward(request, response);
                                return;
                            }
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    // Nếu upload ảnh lỗi nhưng không bắt buộc, vẫn tiếp tục
                }

                Device d = new Device();
                d.setName(name.trim());
                d.setImage(imagePath); // Có thể null nếu không upload ảnh
                d.setDescription(description != null ? description.trim() : null);
                d.setMaintenanceTime(maintenance_time.trim());

                DeviceCategory dc = new DeviceCategory();
                dc.setId(categoryID);
                d.setCategory(dc);

                new DeviceDAO().insertDevice(d);

                message = "Thêm thiết bị thành công!";
                success = true;

            } catch (NumberFormatException e) {
                message = "ID danh mục không hợp lệ";
                success = false;
            } catch (Exception e) {
                e.printStackTrace();
                message = "Có lỗi xảy ra khi xử lý dữ liệu: " + e.getMessage();
                success = false;
            }
        }

        CategoryDAO cate = new CategoryDAO();
        List<DeviceCategory> deviceCategoryList = cate.getAllCategory();
        request.setAttribute("deviceCategory", deviceCategoryList);
        request.setAttribute("message", message);
        request.setAttribute("success", success);
        request.getRequestDispatcher("/manager/device/AddDevice.jsp")
                .forward(request, response);

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
