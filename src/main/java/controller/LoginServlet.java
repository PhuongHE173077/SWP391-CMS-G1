package controller;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="LoginServlet", urlPatterns={"/Login"})
public class LoginServlet extends HttpServlet {
   
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

    HttpSession session = request.getSession(false);

    // Nếu đã login → vào trang Home
    if (session != null && session.getAttribute("user") != null) {
        response.sendRedirect("HomePage.jsp");
    } else {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}

@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String username = request.getParameter("email");
    String password = request.getParameter("password");

    UserDAO udao = new UserDAO();
    Users a = udao.getUserByEmail(username);

    if (a == null) {
        request.setAttribute("mess", "User does not exist");
        request.getRequestDispatcher("login.jsp").forward(request, response);
        return;
    }

    boolean match = BCrypt.checkpw(password, a.getPassword());
    if (!match) {
        request.setAttribute("mess", "Wrong password");
        request.getRequestDispatcher("login.jsp").forward(request, response);
        return;
    }
    
     if (!a.isActive()) {
        request.setAttribute("messdie", "Account is inactive");
        request.getRequestDispatcher("login.jsp").forward(request, response);
        return;
    }

    // Đăng nhập thành công
    HttpSession session = request.getSession(true);
    session.setAttribute("user", a);

    // Redirect vào servlet Home
    response.sendRedirect("/ViewRole");
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