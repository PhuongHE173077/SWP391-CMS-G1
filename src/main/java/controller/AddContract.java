/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.BufferedReader;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import dal.ContractDAO;
import model.Users;

/**
 *
 * @author admin
 */
@WebServlet(name = "AddContract", urlPatterns = { "/AddContract" })
public class AddContract extends HttpServlet {

    private ContractDAO contractDAO = new ContractDAO();
    private Gson gson = new Gson();

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("manager/contract/AddContract.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        JsonObject jsonResponse = new JsonObject();

        try {

            BufferedReader reader = request.getReader();
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            JsonObject jsonRequest = JsonParser.parseString(sb.toString()).getAsJsonObject();

            int userId = jsonRequest.get("userId").getAsInt();
            String content = jsonRequest.get("content").getAsString();
            JsonArray subDevicesArray = jsonRequest.getAsJsonArray("subDevices");

            HttpSession session = request.getSession();
            Users currentUser = (Users) session.getAttribute("user");

            if (currentUser == null) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng đăng nhập để tạo hợp đồng");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            if (subDevicesArray == null || subDevicesArray.size() == 0) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng chọn ít nhất một thiết bị");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            int contractId = contractDAO.addContract(userId, currentUser.getId(), content);

            if (contractId == -1) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Lỗi khi tạo hợp đồng");
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }

            boolean allItemsAdded = true;
            for (int i = 0; i < subDevicesArray.size(); i++) {
                JsonObject subDeviceObj = subDevicesArray.get(i).getAsJsonObject();

                int subDeviceId = subDeviceObj.get("id").getAsInt();

                int maintenanceTime = 12;

                // Lấy maintenance time từ device nếu có
                if (subDeviceObj.has("device") && subDeviceObj.get("device").isJsonObject()) {

                    JsonObject deviceObj = subDeviceObj.getAsJsonObject("device");

                    if (deviceObj.has("maintenanceTime") && !deviceObj.get("maintenanceTime").isJsonNull()) {
                        try {

                            maintenanceTime = Integer.parseInt(deviceObj.get("maintenanceTime").getAsString());

                        } catch (NumberFormatException e) {
                            maintenanceTime = 12;
                        }
                    }
                }

                boolean added = contractDAO.addContractItem(contractId, subDeviceId, maintenanceTime);

                if (added) {
                    contractDAO.updateSubDeviceIsDelete(subDeviceId, true);
                } else {
                    allItemsAdded = false;
                }
            }

            if (allItemsAdded) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Tạo hợp đồng thành công");
                jsonResponse.addProperty("contractId", contractId);
            } else {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Tạo hợp đồng thành công nhưng một số thiết bị không được thêm");
                jsonResponse.addProperty("contractId", contractId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi hệ thống: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(jsonResponse));
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
