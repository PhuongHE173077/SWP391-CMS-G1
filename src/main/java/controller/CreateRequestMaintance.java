package controller;

import dal.MaintenanceRequestDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.ContractItem;
import model.MaintanceRequest;
import model.Users;
import utils.MaintenanceStatus;

@WebServlet(name = "CreateRequestMaintance", urlPatterns = {"/CreateRequestMaintance"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class CreateRequestMaintance extends HttpServlet {

    private MaintenanceRequestDAO maintenanceRequestDAO;

    @Override
    public void init() throws ServletException {
        maintenanceRequestDAO = new MaintenanceRequestDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Kiểm tra đăng nhập
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Lấy contractItemId từ param (user click từ danh sách hợp đồng)
            String contractItemIdStr = request.getParameter("contractItemId");
            if (contractItemIdStr == null || contractItemIdStr.trim().isEmpty()) {
                if (session != null) {
                    session.setAttribute("error", "Thiếu thông tin thiết bị trong hợp đồng!");
                }
                response.sendRedirect("customer/ViewListContact");
                return;
            }

            int contractItemId = Integer.parseInt(contractItemIdStr);

            // Lấy contract item theo id
            ContractItem contractItem = maintenanceRequestDAO.getContractItemById(contractItemId);
            if (contractItem == null) {
                if (session != null) {
                    session.setAttribute("error", "Thiết bị trong hợp đồng không tồn tại!");
                }
                response.sendRedirect("customer/ViewListContact");
                return;
            }

            // Đảm bảo contract item thuộc về user hiện tại
            if (contractItem.getContract() == null
                    || contractItem.getContract().getUser() == null
                    || contractItem.getContract().getUser().getId() != user.getId()) {
                if (session != null) {
                    session.setAttribute("error", "Bạn không có quyền tạo yêu cầu bảo trì cho thiết bị này!");
                }
                response.sendRedirect("customer/ViewListContact");
                return;
            }

            // Truyền contractItem sang JSP để hiển thị cố định
            request.setAttribute("contractItem", contractItem);
            request.getRequestDispatcher("customer/maintenance/CreateRequestMaintance.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            if (session != null) {
                session.setAttribute("error", "Có lỗi xảy ra khi tải trang: " + e.getMessage());
            }
            response.sendRedirect("HomePage.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Kiểm tra đăng nhập
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            request.setCharacterEncoding("UTF-8");
            
            // Lấy tham số từ form
            String title = request.getParameter("title");
            String contractItemIdStr = request.getParameter("contractItemId");
            String content = request.getParameter("content");

            // Validation
            if (title == null || title.trim().isEmpty()) {
                session.setAttribute("error", "Vui lòng nhập tiêu đề yêu cầu!");
                response.sendRedirect("CreateRequestMaintance?contractItemId=" + contractItemIdStr);
                return;
            }

            if (contractItemIdStr == null || contractItemIdStr.trim().isEmpty()) {
                session.setAttribute("error", "Vui lòng chọn thiết bị!");
                response.sendRedirect("customer/ViewListContact");
                return;
            }

            if (content == null || content.trim().isEmpty() || content.trim().length() < 10) {
                session.setAttribute("error", "Nội dung yêu cầu phải có ít nhất 10 ký tự!");
                response.sendRedirect("CreateRequestMaintance?contractItemId=" + contractItemIdStr);
                return;
            }

            int contractItemId = Integer.parseInt(contractItemIdStr);

            // Kiểm tra contract item có thuộc về user không
            ContractItem contractItem = maintenanceRequestDAO.getContractItemById(contractItemId);
            if (contractItem == null) {
                session.setAttribute("error", "Thiết bị không tồn tại!");
                response.sendRedirect("customer/ViewListContact");
                return;
            }

            // Kiểm tra contract item có thuộc về user hiện tại không
            if (contractItem.getContract().getUser().getId() != user.getId()) {
                session.setAttribute("error", "Bạn không có quyền tạo yêu cầu bảo trì cho thiết bị này!");
                response.sendRedirect("customer/ViewListContact");
                return;
            }

            // Xử lý upload ảnh
            String imagePath = null;
            try {
                Part filePart = request.getPart("image");
                if (filePart != null && filePart.getSize() > 0) {
                    String originalFileName = getFileName(filePart);
                    if (originalFileName != null && !originalFileName.trim().isEmpty()) {                      
                        String sanitizedFileName = originalFileName.replaceAll("[^a-zA-Z0-9._-]", "_");
                        String fileName = System.currentTimeMillis() + "_" + sanitizedFileName;
                        String uploadPath = getServletContext().getRealPath("/uploads/maintenance");
                        java.io.File uploadDir = new java.io.File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdirs();
                        }
                        String fullPath = uploadPath + java.io.File.separator + fileName;
                        filePart.write(fullPath);
                        imagePath = "uploads/maintenance/" + fileName;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Tạo maintenance request
            MaintanceRequest maintenanceRequest = new MaintanceRequest();
            maintenanceRequest.setTitle(title.trim());
            maintenanceRequest.setContent(content.trim());
            maintenanceRequest.setUser(user);
            maintenanceRequest.setStatus(MaintenanceStatus.PENDING); // Mặc định là chưa xử lý
            maintenanceRequest.setImage(imagePath); // Set imagePath (có thể null nếu không upload)
            maintenanceRequest.setContractItem(contractItem);

            // Insert vào database
            boolean success = maintenanceRequestDAO.insertMaintenanceRequest(maintenanceRequest);

            if (success) {
                session.setAttribute("msg", "Tạo yêu cầu bảo trì thành công! Chúng tôi sẽ liên hệ với bạn sớm nhất có thể.");
                response.sendRedirect("customer/ViewListContact");
            } else {
                session.setAttribute("error", "Có lỗi xảy ra khi tạo yêu cầu bảo trì. Vui lòng thử lại!");
                response.sendRedirect("CreateRequestMaintance?contractItemId=" + contractItemIdStr);
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("error", "ID thiết bị không hợp lệ!");
            response.sendRedirect("customer/ViewListContact");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect("customer/ViewListContact");
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
}

