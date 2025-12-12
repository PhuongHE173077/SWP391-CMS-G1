package controller;

import dal.DeviceDAO;
import dal.SubDeviceDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Device;

@WebServlet(name = "ViewDetailDevice", urlPatterns = {"/ViewDetailDevice"})
public class ViewDetailDevice extends HttpServlet {

    private DeviceDAO deviceDAO;
    private SubDeviceDAO subDeviceDAO;

    @Override
    public void init() throws ServletException {
        deviceDAO = new DeviceDAO();
        subDeviceDAO = new SubDeviceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendRedirect("ViewListDevice");
                return;
            }

            int deviceId = Integer.parseInt(idParam);
            Device device = deviceDAO.getDeviceById(deviceId);

            if (device == null) {
                response.sendRedirect("ViewListDevice");
                return;
            }

            // Đếm số lượng sub device còn lại
            int remainingCount = subDeviceDAO.countRemainingSubDevicesByDeviceId(deviceId);

            request.setAttribute("device", device);
            request.setAttribute("remainingCount", remainingCount);
            request.getRequestDispatcher("manager/device/device-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("ViewListDevice");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ViewListDevice");
        }
    }
}

