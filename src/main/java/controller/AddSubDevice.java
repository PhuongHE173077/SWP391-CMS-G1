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
import model.SubDevice;

@WebServlet(name = "AddSubDevice", urlPatterns = {"/AddSubDevice"})
public class AddSubDevice extends HttpServlet {

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
            String deviceIdParam = request.getParameter("deviceId");
            if (deviceIdParam == null || deviceIdParam.trim().isEmpty()) {
                response.sendRedirect("ViewListDevice");
                return;
            }

            int deviceId = Integer.parseInt(deviceIdParam);
            Device device = deviceDAO.getDeviceById(deviceId);

            if (device == null) {
                response.sendRedirect("ViewListDevice");
                return;
            }

            request.setAttribute("device", device);
            request.getRequestDispatcher("manager/device/addSubDevice.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("ViewListDevice");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ViewListDevice");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String deviceIdParam = request.getParameter("deviceId");
        String seriId = request.getParameter("seriId");

        // Validate required fields
        if (deviceIdParam == null || deviceIdParam.trim().isEmpty()
                || seriId == null || seriId.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin.");
            try {
                int deviceId = Integer.parseInt(deviceIdParam);
                Device device = deviceDAO.getDeviceById(deviceId);
                if (device != null) {
                    request.setAttribute("device", device);
                }
            } catch (Exception e) {
                // Ignore
            }
            request.getRequestDispatcher("manager/device/addSubDevice.jsp").forward(request, response);
            return;
        }

        try {
            int deviceId = Integer.parseInt(deviceIdParam);
            String seriIdTrimmed = seriId.trim();

            // Kiểm tra device có tồn tại không
            Device device = deviceDAO.getDeviceById(deviceId);
            if (device == null) {
                request.setAttribute("error", "Thiết bị không tồn tại.");
                response.sendRedirect("ViewListDevice");
                return;
            }

            // Kiểm tra seri_id đã tồn tại chưa (trong tất cả sub_device, kể cả đã xóa)
            if (subDeviceDAO.checkSeriIdExists(seriIdTrimmed)) {
                request.setAttribute("error", "Số seri này đã tồn tại trong hệ thống.");
                request.setAttribute("device", device);
                request.setAttribute("seriId", seriIdTrimmed);
                request.getRequestDispatcher("manager/device/addSubDevice.jsp").forward(request, response);
                return;
            }

            // Tạo SubDevice object
            SubDevice subDevice = new SubDevice();
            subDevice.setSeriId(seriIdTrimmed);
            subDevice.setDevice(device);
            subDevice.setIsDelete(false); // Mặc định là còn lại

            // Insert vào database
            boolean success = subDeviceDAO.insertSubDevice(subDevice);

            if (success) {
                // Redirect về danh sách sub device với thông báo thành công
                response.sendRedirect("ViewRemainingSubDevices?deviceId=" + deviceId + "&success=Thêm Sub Device thành công");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi thêm Sub Device.");
                request.setAttribute("device", device);
                request.setAttribute("seriId", seriIdTrimmed);
                request.getRequestDispatcher("manager/device/addSubDevice.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID thiết bị không hợp lệ.");
            response.sendRedirect("ViewListDevice");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            try {
                int deviceId = Integer.parseInt(deviceIdParam);
                Device device = deviceDAO.getDeviceById(deviceId);
                if (device != null) {
                    request.setAttribute("device", device);
                }
            } catch (Exception ex) {
                // Ignore
            }
            request.getRequestDispatcher("manager/device/addSubDevice.jsp").forward(request, response);
        }
    }
}

