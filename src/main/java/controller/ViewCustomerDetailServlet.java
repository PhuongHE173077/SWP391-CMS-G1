package controller;

import dal.ContractDAO;
import dal.MaintenanceRequestDAO;
import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Users;
import java.util.List;
import model.Contract;
import model.ContractItem;

/**
 * Servlet để xem chi tiết khách hàng
 */
@WebServlet(name = "ViewCustomerDetailServlet", urlPatterns = {"/customer-detail"})
public class ViewCustomerDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy userId từ parameter
            String userIdParam = request.getParameter("id");
            if (userIdParam == null || userIdParam.trim().isEmpty()) {
                response.sendRedirect("ViewCustomer");
                return;
            }

            int userId = Integer.parseInt(userIdParam);

            // Lấy thông tin khách hàng
            UserDAO userDAO = new UserDAO();
            Users customer = userDAO.getUserById(userId);

            if (customer == null) {
                request.setAttribute("errorMsg", "Không tìm thấy khách hàng.");
                response.sendRedirect("ViewCustomer");
                return;
            }

            // Lấy danh sách hợp đồng của khách hàng
            ContractDAO contractDAO = new ContractDAO();
            List<Contract> contracts = contractDAO.getListContractByUserId(userId, null, null, null, null, 1, 100);
            
            // Lấy tất cả contract items của khách hàng
            MaintenanceRequestDAO maintenanceDAO = new MaintenanceRequestDAO();
            List<ContractItem> contractItems = maintenanceDAO.getContractItemsByUserId(userId);

            // Set attributes
            request.setAttribute("customer", customer);
            request.setAttribute("contracts", contracts);
            request.setAttribute("contractItems", contractItems);

            // Forward to JSP
            request.getRequestDispatcher("manager/customer/customer-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("ViewCustomer");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ViewCustomer");
        }
    }
}
