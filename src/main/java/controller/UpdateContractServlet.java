package controller;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import dal.ContractDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Contract;
import model.ContractItem;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.OffsetDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;

@WebServlet(name = "UpdateContractServlet", urlPatterns = { "/update-contract" })
public class UpdateContractServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idRaw = request.getParameter("id");
            if (idRaw == null) {
                response.sendRedirect("contract-list");
                return;
            }
            int contractId = Integer.parseInt(idRaw);

            ContractDAO contractDAO = new ContractDAO();
            Contract contract = contractDAO.getContractWithCreatedAt(contractId);

            if (contract == null) {
                response.sendRedirect("contract-list");
                return;
            }

            // Kiểm tra điều kiện 6 ngày
            boolean canEdit = false;
            if (contract.getCreatedAt() != null) {
                OffsetDateTime now = OffsetDateTime.now();
                long daysBetween = ChronoUnit.DAYS.between(contract.getCreatedAt(), now);
                canEdit = daysBetween <= 6;
            }

            // Lấy danh sách contract items
            List<ContractItem> contractItems = contractDAO.getAllItemsByContractId(contractId);

            request.setAttribute("contract", contract);
            request.setAttribute("contractItems", contractItems);
            request.setAttribute("canEdit", canEdit);

            request.getRequestDispatcher("manager/contract/update-contract.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("contract-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject result = new JsonObject();

        try {
            // Đọc JSON từ request body
            BufferedReader reader = request.getReader();
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            JsonObject jsonData = JsonParser.parseString(sb.toString()).getAsJsonObject();

            int contractId = jsonData.get("contractId").getAsInt();
            JsonArray addedDevices = jsonData.getAsJsonArray("addedDevices");
            JsonArray removedItemIds = jsonData.getAsJsonArray("removedItemIds");

            ContractDAO contractDAO = new ContractDAO();

            // Kiểm tra contract tồn tại và điều kiện 6 ngày
            Contract contract = contractDAO.getContractWithCreatedAt(contractId);
            if (contract == null) {
                result.addProperty("success", false);
                result.addProperty("message", "Hợp đồng không tồn tại");
                out.print(result.toString());
                return;
            }

            // Kiểm tra điều kiện 6 ngày
            if (contract.getCreatedAt() != null) {
                OffsetDateTime now = OffsetDateTime.now();
                long daysBetween = ChronoUnit.DAYS.between(contract.getCreatedAt(), now);
                if (daysBetween > 6) {
                    result.addProperty("success", false);
                    result.addProperty("message", "Hợp đồng đã quá 6 ngày, không thể chỉnh sửa sản phẩm");
                    out.print(result.toString());
                    return;
                }
            }

            // Xóa các contract items đã bị remove
            if (removedItemIds != null) {
                for (int i = 0; i < removedItemIds.size(); i++) {
                    int itemId = removedItemIds.get(i).getAsInt();
                    contractDAO.deleteContractItem(itemId);
                }
            }

            // Thêm các sub devices mới
            if (addedDevices != null) {
                for (int i = 0; i < addedDevices.size(); i++) {
                    JsonObject deviceObj = addedDevices.get(i).getAsJsonObject();
                    int subDeviceId = deviceObj.get("id").getAsInt();
                    int maintenanceTime = 0;

                    if (deviceObj.has("maintenanceTime") && !deviceObj.get("maintenanceTime").isJsonNull()) {
                        try {
                            maintenanceTime = deviceObj.get("maintenanceTime").getAsInt();
                        } catch (Exception e) {
                            maintenanceTime = 0;
                        }
                    }

                    boolean added = contractDAO.addContractItem(contractId, subDeviceId, maintenanceTime);
                    if (added) {
                        contractDAO.updateSubDeviceIsDelete(subDeviceId, true);
                    }
                }
            }

            result.addProperty("success", true);
            result.addProperty("message", "Cập nhật hợp đồng thành công");

        } catch (Exception e) {
            e.printStackTrace();
            result.addProperty("success", false);
            result.addProperty("message", "Có lỗi xảy ra: " + e.getMessage());
        }

        out.print(result.toString());
    }
}
