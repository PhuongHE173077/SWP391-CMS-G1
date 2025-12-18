/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.DeviceDAO;
import dal.ContractDAO;
import dal.UserDAO;
import dal.MaintenanceRequestDAO;
import dal.SubDeviceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import model.TopContractUser;
import model.TopDevice;
import model.Contract;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="Dashboard", urlPatterns={"/Dashboard"})
public class DashboardManager extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Dashboard</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Dashboard at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        DeviceDAO dev = new DeviceDAO();
        int totalDevice = dev.getCountAllDevice();
        request.setAttribute("totalDevice", totalDevice);
        
        ContractDAO con = new ContractDAO();
        int totalContract = con.getCountAllContract();
        request.setAttribute("totalContract", totalContract);
        
        // Đếm số yêu cầu bảo hành pending
        MaintenanceRequestDAO maintenanceDAO = new MaintenanceRequestDAO();
        int totalPendingMaintenanceRequests = maintenanceDAO.countPendingMaintenanceRequests();
        request.setAttribute("totalPendingMaintenanceRequests", totalPendingMaintenanceRequests);
        
        UserDAO user = new UserDAO();
        int totalCustomer = user.getCountAllCustomer();
        request.setAttribute("totalCustomer", totalCustomer);
        
        // Đếm số lượng tồn kho (subdevice)
        SubDeviceDAO subDeviceDAO = new SubDeviceDAO();
        int totalInventory = subDeviceDAO.countAllSubDevices();
        request.setAttribute("totalInventory", totalInventory);
        
        // Lấy Top 3 khách hàng mua nhiều nhất (theo số lượng contract_item)
        List<TopContractUser> topContractUser = con.getTopContractUsers();
        request.setAttribute("topContractUser", topContractUser);
        
        // Lấy Top 3 thiết bị bán chạy nhất (theo số lượng seri đã được làm hợp đồng)
        List<TopDevice> topSellingDevices = con.getTopSellingDevices();
        request.setAttribute("topSellingDevices", topSellingDevices);
        
        // Lấy danh sách hợp đồng pending (chưa có contract_item)
        List<Contract> pendingContracts = con.getPendingContracts(10); // Lấy tối đa 10 hợp đồng pending
        request.setAttribute("pendingContracts", pendingContracts);
        
        // Lấy dữ liệu hợp đồng theo từng tháng
        Map<String, Integer> contractsByMonth = con.getContractsByMonth();
        request.setAttribute("contractsByMonth", contractsByMonth);
        
        // Lấy dữ liệu sản phẩm đã bán theo từng tháng
        Map<String, Integer> soldProductsByMonth = con.getSoldProductsByMonth();
        request.setAttribute("soldProductsByMonth", soldProductsByMonth);
        
        request.getRequestDispatcher("manager/dashboardManager.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
