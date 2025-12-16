package controller;

import dal.MaintenanceRequestDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ContractItem;
import model.MaintanceRequest;
import model.Users;
import utils.MaintenanceStatus;

@WebServlet(name = "CreateRequestMaintance", urlPatterns = {"/CreateRequestMaintance"})
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
            // Lấy danh sách contract items của user
            List<ContractItem> contractItems = maintenanceRequestDAO.getContractItemsByUserId(user.getId());
            
            request.setAttribute("contractItems", contractItems);
            request.getRequestDispatcher("user/CreateRequestMaintance.jsp").forward(request, response);
            
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
            // Lấy tham số từ form
            String contractItemIdStr = request.getParameter("contractItemId");
            String content = request.getParameter("content");

            // Validation
            if (contractItemIdStr == null || contractItemIdStr.trim().isEmpty()) {
                session.setAttribute("error", "Vui lòng chọn thiết bị!");
                response.sendRedirect("CreateRequestMaintance");
                return;
            }

            if (content == null || content.trim().isEmpty() || content.trim().length() < 10) {
                session.setAttribute("error", "Nội dung yêu cầu phải có ít nhất 10 ký tự!");
                response.sendRedirect("CreateRequestMaintance");
                return;
            }

            int contractItemId = Integer.parseInt(contractItemIdStr);

            // Kiểm tra contract item có thuộc về user không
            ContractItem contractItem = maintenanceRequestDAO.getContractItemById(contractItemId);
            if (contractItem == null) {
                session.setAttribute("error", "Thiết bị không tồn tại!");
                response.sendRedirect("CreateRequestMaintance");
                return;
            }

            // Kiểm tra contract item có thuộc về user hiện tại không
            if (contractItem.getContract().getUser().getId() != user.getId()) {
                session.setAttribute("error", "Bạn không có quyền tạo yêu cầu bảo trì cho thiết bị này!");
                response.sendRedirect("CreateRequestMaintance");
                return;
            }

            // Tạo maintenance request
            MaintanceRequest maintenanceRequest = new MaintanceRequest();
            maintenanceRequest.setContent(content.trim());
            maintenanceRequest.setUser(user);
            maintenanceRequest.setStatus(MaintenanceStatus.PENDING); // Mặc định là chưa xử lý
            maintenanceRequest.setContractItem(contractItem);

            // Insert vào database
            boolean success = maintenanceRequestDAO.insertMaintenanceRequest(maintenanceRequest);

            if (success) {
                session.setAttribute("msg", "Tạo yêu cầu bảo trì thành công! Chúng tôi sẽ liên hệ với bạn sớm nhất có thể.");
                response.sendRedirect("CreateRequestMaintance");
            } else {
                session.setAttribute("error", "Có lỗi xảy ra khi tạo yêu cầu bảo trì. Vui lòng thử lại!");
                response.sendRedirect("CreateRequestMaintance");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("error", "ID thiết bị không hợp lệ!");
            response.sendRedirect("CreateRequestMaintance");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect("CreateRequestMaintance");
        }
    }
}

