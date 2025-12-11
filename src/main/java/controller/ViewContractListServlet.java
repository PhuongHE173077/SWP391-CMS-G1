/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.*;
import model.*;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="ViewContractListServlet", urlPatterns={"/contract-list"})
public class ViewContractListServlet extends HttpServlet {
    String URL_CONTRACT_DIRECTION = "manager/contract-list.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        UserDAO dao = new UserDAO();
        List<Users> lstSaleStaff = dao.getAllSaleStaff();
        request.setAttribute("lstSaleStaff", lstSaleStaff);
        request.getRequestDispatcher(URL_CONTRACT_DIRECTION).forward(request, response);
    } 

  

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
