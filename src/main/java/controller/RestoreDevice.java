package controller;

import dal.DeviceDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "RestoreDevice", urlPatterns = {"/RestoreDevice"})
public class RestoreDevice extends HttpServlet {

    private DeviceDAO deviceDAO;

    @Override
    public void init() throws ServletException {
        deviceDAO = new DeviceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            HttpSession session = request.getSession();
            
            if (idParam == null || idParam.trim().isEmpty()) {
                session.setAttribute("error", "ID thiết bị không hợp lệ.");
                response.sendRedirect("ViewDeletedDevices");
                return;
            }

            int deviceId = Integer.parseInt(idParam);
            boolean success = deviceDAO.restoreDevice(deviceId);

            if (success) {
                session.setAttribute("msg", "Khôi phục thiết bị thành công.");
            } else {
                session.setAttribute("error", "Có lỗi xảy ra khi khôi phục thiết bị.");
            }
            
            response.sendRedirect("ViewDeletedDevices");

        } catch (NumberFormatException e) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "ID thiết bị không hợp lệ.");
            response.sendRedirect("ViewDeletedDevices");
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect("ViewDeletedDevices");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}


