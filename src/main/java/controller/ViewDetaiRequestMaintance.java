/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.ReplyMaintenanceRequestDAO;
import dal.MaintenanceRequestDAO;
import java.util.List;
import model.MaintanceRequest;
import model.ReplyMaintanceRequest;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "ViewDetaiRequestMaintance", urlPatterns = {"/ViewDetaiRequestMaintance"})
public class ViewDetaiRequestMaintance extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
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
            out.println("<title>Servlet ViewDetaiRequestMaintance</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ViewDetaiRequestMaintance at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");

        ReplyMaintenanceRequestDAO rmr = new ReplyMaintenanceRequestDAO();
        List<ReplyMaintanceRequest> replyMaintanceRequest = rmr.getAllReplyMaintanceRequest(id);
        request.setAttribute("replyMaintanceRequest", replyMaintanceRequest);

        MaintenanceRequestDAO mr = new MaintenanceRequestDAO();
        MaintanceRequest maintanceRequest = mr.getMaintanceRequestById(id);
        request.setAttribute("maintanceRequest", maintanceRequest);

        request.getRequestDispatcher("manager/replyMaintenanceRequest.jsp").forward(request, response);

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String id = request.getParameter("id");

        ReplyMaintenanceRequestDAO rmr = new ReplyMaintenanceRequestDAO();
        ReplyMaintanceRequest reply = new ReplyMaintanceRequest();
        reply.setContent(content);
        reply.setTitle(title);
        MaintanceRequest m = new MaintanceRequest();
        int strId = Integer.parseInt(id);
        m.setId(strId);
        reply.setMaintanceRequest(m);
        rmr.insertReplyMaintenanceRequest(reply);
        response.sendRedirect("ViewDetaiRequestMaintance?id=" + id);
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
