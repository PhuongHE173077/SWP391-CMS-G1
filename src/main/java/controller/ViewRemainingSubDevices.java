package controller;

import dal.DeviceDAO;
import dal.SubDeviceDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Device;
import model.SubDevice;

@WebServlet(name = "ViewRemainingSubDevices", urlPatterns = {"/ViewRemainingSubDevices"})
public class ViewRemainingSubDevices extends HttpServlet {

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
            String idParam = request.getParameter("deviceId");
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

            // Lấy parameter search nếu có
            String searchKeyword = request.getParameter("search");
            List<SubDevice> remainingSubDevices;
            
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                // Tìm kiếm theo số seri
                remainingSubDevices = subDeviceDAO.searchRemainingSubDevicesBySeriId(deviceId, searchKeyword.trim());
                request.setAttribute("searchKeyword", searchKeyword.trim());
            } else {
                // Lấy tất cả
                remainingSubDevices = subDeviceDAO.getRemainingSubDevicesByDeviceId(deviceId);
            }

            request.setAttribute("device", device);
            request.setAttribute("remainingSubDevices", remainingSubDevices);
            request.getRequestDispatcher("device/remaining-subdevices.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("ViewListDevice");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ViewListDevice");
        }
    }
}

