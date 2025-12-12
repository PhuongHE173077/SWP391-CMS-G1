package controller;

import dal.SubDeviceDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "DeleteSubDevice", urlPatterns = {"/DeleteSubDevice"})
public class DeleteSubDevice extends HttpServlet {

    private SubDeviceDAO subDeviceDAO;

    @Override
    public void init() throws ServletException {
        subDeviceDAO = new SubDeviceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            String deviceIdParam = request.getParameter("deviceId");
            
            if (idParam == null || idParam.trim().isEmpty()) {
                // Redirect về danh sách nếu không có ID
                if (deviceIdParam != null && !deviceIdParam.trim().isEmpty()) {
                    response.sendRedirect("ViewRemainingSubDevices?deviceId=" + deviceIdParam + "&error=Không tìm thấy Sub Device để xóa");
                } else {
                    response.sendRedirect("ViewListDevice");
                }
                return;
            }

            int subDeviceId = Integer.parseInt(idParam);
            boolean success = subDeviceDAO.deleteSubDevice(subDeviceId);

            // Redirect về danh sách với thông báo
            if (deviceIdParam != null && !deviceIdParam.trim().isEmpty()) {
                if (success) {
                    response.sendRedirect("ViewRemainingSubDevices?deviceId=" + deviceIdParam + "&success=Xóa Sub Device thành công");
                } else {
                    response.sendRedirect("ViewRemainingSubDevices?deviceId=" + deviceIdParam + "&error=Có lỗi xảy ra khi xóa Sub Device");
                }
            } else {
                response.sendRedirect("ViewListDevice");
            }

        } catch (NumberFormatException e) {
            String deviceIdParam = request.getParameter("deviceId");
            if (deviceIdParam != null && !deviceIdParam.trim().isEmpty()) {
                response.sendRedirect("ViewRemainingSubDevices?deviceId=" + deviceIdParam + "&error=ID không hợp lệ");
            } else {
                response.sendRedirect("ViewListDevice");
            }
        } catch (Exception e) {
            e.printStackTrace();
            String deviceIdParam = request.getParameter("deviceId");
            if (deviceIdParam != null && !deviceIdParam.trim().isEmpty()) {
                response.sendRedirect("ViewRemainingSubDevices?deviceId=" + deviceIdParam + "&error=Có lỗi xảy ra");
            } else {
                response.sendRedirect("ViewListDevice");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

