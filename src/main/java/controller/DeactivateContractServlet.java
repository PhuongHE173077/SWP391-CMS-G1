/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.ContractDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "DeactivateContractServlet", urlPatterns = {"/deactivate-contract"})
public class DeactivateContractServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1. Lấy dữ liệu ID và Status cần update
            int id = Integer.parseInt(request.getParameter("id"));
            int status = Integer.parseInt(request.getParameter("status"));  

            // 2. Gọi DAO để thực hiện update xuống DB
            ContractDAO dao = new ContractDAO();
            dao.changeContractStatus(id, status);

            // 3. Gửi thông báo thành công qua Session (Flash Message)
            HttpSession session = request.getSession();
            if (status == 1) {
                session.setAttribute("msg", "Deactivated contract successfully!");
            }
            // 4. Lấy lại các tham số Filter/Sort cũ để Redirect về đúng ngữ cảnh
            // (Nếu không làm bước này, sau khi update nó sẽ nhảy về trang 1 và mất hết filter)
            String page = request.getParameter("page");
            String search = request.getParameter("search");
             String sortBy = request.getParameter("sortBy");
            String sortOrder = request.getParameter("sortOrder");

            // Xử lý null (đề phòng)
            if (page == null) {
                page = "1";
            }
            if (search == null) {
                search = "";
            }
            
            if (sortBy == null) {
                sortBy = "id";
            }
            if (sortOrder == null) {
                sortOrder = "ASC";
            }

            // 5. Xây dựng URL Redirect
            // Lưu ý: search phải được Encode để xử lý ký tự đặc biệt hoặc tiếng Việt
            String redirectURL = "contract-list?"
                    + "page=" + page
                    + "&sortBy=" + sortBy
                    + "&sortOrder=" + sortOrder
                    + "&search=" + URLEncoder.encode(search, StandardCharsets.UTF_8);

            // Chuyển hướng
            response.sendRedirect(redirectURL);

        } catch (Exception e) {
            e.printStackTrace();
            // Nếu có lỗi thì gửi thông báo lỗi và quay về trang list mặc định
            request.getSession().setAttribute("error", "Error updating status: " + e.getMessage());
            response.sendRedirect("contract-list");
        }
    }
}
