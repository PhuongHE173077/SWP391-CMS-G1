<<<<<<<< HEAD:src/main/java/controller/AddAdvice.java
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
========
>>>>>>>> origin/xuanhieu:src/main/java/controller/LoginServlet.java
package controller;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
<<<<<<<< HEAD:src/main/java/controller/AddAdvice.java
import service.iService.IDeviceService;

/**
 *
 * @author admin
 */

public class AddAdvice extends HttpServlet {
    private final IDeviceService deviceService = null;
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request  servlet request
========
import jakarta.servlet.http.HttpSession;
import model.Users;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="LoginServlet", urlPatterns={"/Login"})
public class LoginServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
>>>>>>>> origin/xuanhieu:src/main/java/controller/LoginServlet.java
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
<<<<<<<< HEAD:src/main/java/controller/AddAdvice.java
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddAdvice</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddAdvice at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
========
        
    } 
>>>>>>>> origin/xuanhieu:src/main/java/controller/LoginServlet.java

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
<<<<<<<< HEAD:src/main/java/controller/AddAdvice.java
            throws ServletException, IOException {
      request.getRequestDispatcher("manager/AddAdvice.jsp").forward(request, response);
    }
========
    throws ServletException, IOException {
        HttpSession session = request.getSession(false);         
    if (session != null && session.getAttribute("acc") != null) {      
        response.sendRedirect("Home"); 
    } else {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}     
    
>>>>>>>> origin/xuanhieu:src/main/java/controller/LoginServlet.java

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
<<<<<<<< HEAD:src/main/java/controller/AddAdvice.java
            throws ServletException, IOException {
        request.getRequestDispatcher("/manager/AddAdvice.jsp").forward(request, response);
========
    throws ServletException, IOException {
         String username = request.getParameter("email");
        String password = request.getParameter("password");
        
        UserDAO udao = new UserDAO();
        Users a = udao.login(username, password);
        if(a==null) {
            request.setAttribute("mess", "User does not exist");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else if(a.isActive()== false){
            request.setAttribute("messdie", "Account die");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }else{
            HttpSession session = request.getSession();
            session.setAttribute("acc", a);
            response.sendRedirect("Home");
        }
>>>>>>>> origin/xuanhieu:src/main/java/controller/LoginServlet.java
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
