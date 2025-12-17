package controller;

import dal.SubDeviceDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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
            HttpSession session = request.getSession();

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
                    session.setAttribute("success", "Xóa Sub Device thành công");
                    response.sendRedirect("ViewRemainingSubDevices?deviceId=" + deviceIdParam);
                } else {
                    session.setAttribute("error", "Có lỗi xảy ra khi xóa Sub Device");
                    response.sendRedirect("ViewRemainingSubDevices?deviceId=" + deviceIdParam);
                }
            } else {
                response.sendRedirect("ViewListDevice");
            }

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            String deviceIdParam = request.getParameter("deviceId");
            if (deviceIdParam != null && !deviceIdParam.trim().isEmpty()) {
                session.setAttribute("error", "ID không hợp lệ");
                response.sendRedirect("ViewRemainingSubDevices?deviceId=" + deviceIdParam);
            } else {
                response.sendRedirect("ViewListDevice");
            }
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            String deviceIdParam = request.getParameter("deviceId");
            if (deviceIdParam != null && !deviceIdParam.trim().isEmpty()) {
                session.setAttribute("error", "Có lỗi xảy ra");
                response.sendRedirect("ViewRemainingSubDevices?deviceId=" + deviceIdParam);
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

