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

            // Lấy parameter search, date filter và page
            String searchKeyword = request.getParameter("search");
            String dateFrom = request.getParameter("dateFrom");
            String dateTo = request.getParameter("dateTo");
            String pageParam = request.getParameter("page");
            
            // Xử lý pagination
            int pageIndex = 1;
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    pageIndex = Integer.parseInt(pageParam);
                    if (pageIndex < 1) {
                        pageIndex = 1;
                    }
                } catch (NumberFormatException e) {
                    pageIndex = 1;
                }
            }
            
            int pageSize = 10; // 10 sản phẩm mỗi trang
            
            // Xử lý filter parameters
            String seriKeyword = (searchKeyword != null && !searchKeyword.trim().isEmpty()) 
                    ? searchKeyword.trim() : null;
            String dateFromFilter = (dateFrom != null && !dateFrom.trim().isEmpty()) 
                    ? dateFrom.trim() : null;
            String dateToFilter = (dateTo != null && !dateTo.trim().isEmpty()) 
                    ? dateTo.trim() : null;
            
            // Đếm tổng số record với filter
            int totalRecords = subDeviceDAO.countRemainingSubDevicesByDeviceId(
                    deviceId, seriKeyword, dateFromFilter, dateToFilter);
            int totalPages = (totalRecords % pageSize == 0) 
                    ? (totalRecords / pageSize) 
                    : (totalRecords / pageSize + 1);
            
            // Đảm bảo pageIndex không vượt quá totalPages
            if (pageIndex > totalPages && totalPages > 0) {
                pageIndex = totalPages;
            }
            
            // Lấy danh sách với phân trang và filter
            List<SubDevice> remainingSubDevices = subDeviceDAO.getRemainingSubDevicesByDeviceIdWithPaging(
                    deviceId, seriKeyword, dateFromFilter, dateToFilter, pageIndex, pageSize);

            request.setAttribute("device", device);
            request.setAttribute("remainingSubDevices", remainingSubDevices);
            request.setAttribute("searchKeyword", seriKeyword);
            request.setAttribute("dateFrom", dateFromFilter);
            request.setAttribute("dateTo", dateToFilter);
            request.setAttribute("currentPage", pageIndex);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);
            request.getRequestDispatcher("device/remaining-subdevices.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("ViewListDevice");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ViewListDevice");
        }
    }
}

