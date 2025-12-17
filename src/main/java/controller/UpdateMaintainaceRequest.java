/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import dal.MaintenanceRequestDAO;
import model.MaintanceRequest;
import model.Users;
import utils.MaintenanceStatus;

/**
 *
 * @author admin
 */
@WebServlet(name = "UpdateMaintainaceRequest", urlPatterns = {"/UpdateMaintainaceRequest"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class UpdateMaintainaceRequest extends HttpServlet {

    private MaintenanceRequestDAO maintenanceDAO;

    @Override
    public void init() throws ServletException {
        maintenanceDAO = new MaintenanceRequestDAO();
    }

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
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("customer-maintenance");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            MaintanceRequest maintenanceRequest = maintenanceDAO.getMaintenanceRequestById(id);

            if (maintenanceRequest == null) {
                request.setAttribute("error", "Maintenance request not found");
                response.sendRedirect("customer-maintenance");
                return;
            }

            // Kiểm tra quyền: chỉ cho phép user sở hữu request được update
            if (maintenanceRequest.getUser().getId() != currentUser.getId()) {
                request.setAttribute("error", "You don't have permission to update this request");
                response.sendRedirect("customer-maintenance");
                return;
            }

            // Chỉ cho phép update khi status là PENDING
            if (maintenanceRequest.getStatus() != MaintenanceStatus.PENDING) {
                request.setAttribute("error", "Only PENDING requests can be updated");
                response.sendRedirect("customer-maintenance");
                return;
            }

            request.setAttribute("maintenanceRequest", maintenanceRequest);
            request.getRequestDispatcher("customer/maintenance/update-mantenance.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("customer-maintenance");
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
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        String idParam = request.getParameter("id");
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("customer-maintenance");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            MaintanceRequest existingRequest = maintenanceDAO.getMaintenanceRequestById(id);

            if (existingRequest == null) {
                session.setAttribute("error", "Maintenance request not found");
                response.sendRedirect("customer-maintenance");
                return;
            }

            // Kiểm tra quyền
            if (existingRequest.getUser().getId() != currentUser.getId()) {
                session.setAttribute("error", "You don't have permission to update this request");
                response.sendRedirect("customer-maintenance");
                return;
            }

            // Chỉ cho phép update khi status là PENDING
            if (existingRequest.getStatus() != MaintenanceStatus.PENDING) {
                session.setAttribute("error", "Only PENDING requests can be updated");
                response.sendRedirect("customer-maintenance");
                return;
            }

            // Xử lý upload image
            String imagePath = existingRequest.getImage(); // Giữ ảnh cũ nếu không upload mới
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + getFileName(filePart);
                String uploadPath = getServletContext().getRealPath("/uploads/maintenance");
                java.io.File uploadDir = new java.io.File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                filePart.write(uploadPath + java.io.File.separator + fileName);
                imagePath = "uploads/maintenance/" + fileName;
            }

            // Update request
            existingRequest.setTitle(title);
            existingRequest.setContent(content);
            existingRequest.setImage(imagePath);

            boolean success = maintenanceDAO.updateMaintenanceRequest(existingRequest);

            if (success) {
                session.setAttribute("msg", "Maintenance request updated successfully!");
            } else {
                session.setAttribute("error", "Failed to update maintenance request");
            }

            response.sendRedirect("customer-maintenance");

        } catch (NumberFormatException e) {
            response.sendRedirect("customer-maintenance");
        }
    }

    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String token : contentDisposition.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
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
