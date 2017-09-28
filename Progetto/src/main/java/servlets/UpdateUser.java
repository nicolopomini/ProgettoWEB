/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import dao.UserDAO;
import dao.entities.User;
import java.io.IOException;
import java.rmi.ServerException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import persistence.utils.dao.exceptions.DAOException;
import persistence.utils.dao.exceptions.DAOFactoryException;
import persistence.utils.dao.factories.DAOFactory;
import utils.BCrypt;

/**
 *
 * @author pomo
 */
@WebServlet(name = "UpdateUser", urlPatterns = {"/UpdateUser"})
public class UpdateUser extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init(); 
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for storage system");
        }
        try {
        userDAO = daoFactory.getDAO(UserDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shop storage system", ex);
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
        HttpSession session = request.getSession();
        User user = (User)session.getAttribute("user");
        String address, email, oldpassword, newpassword, repeatpassword;
        address = request.getParameter("indirizzo");
        email = request.getParameter("email");
        oldpassword = request.getParameter("oldpassword");
        newpassword = request.getParameter("newpassword");
        repeatpassword = request.getParameter("repeatpassword");
        boolean error = false;
        Cookie c;
        if((oldpassword != null && !oldpassword.equals("")) || (newpassword != null && !newpassword.equals("")) || (repeatpassword != null && !repeatpassword.equals(""))) { //cambio password
            if(oldpassword != null && newpassword != null && repeatpassword != null) {
                if(BCrypt.checkpw(oldpassword, user.getPassword()) && newpassword.equals(repeatpassword)) 
                    user.setPassword(BCrypt.hashpw(newpassword, BCrypt.gensalt(12)));
                else
                    error = true;
            }
            else    //almeno un campo è vuoto
                error = true;
        }
        if(!error) {
            if(address != null && !address.equals(""))
                user.setAddress(address);
            if(email != null && !email.equals(""))
                user.setEmail(email);
            try {
                userDAO.update(user);
                session.setAttribute("user", user);
                c = new Cookie("user_message","ok");
            } catch (DAOException ex) {
                throw new ServerException("Error updating user",ex);
            }
        } else {
            c = new Cookie("user_message","error");
        }
        c.setMaxAge(1);
        response.addCookie(c);
        String contextPath = getServletContext().getContextPath();
        if(!contextPath.endsWith("/"))
            contextPath += "/";
        contextPath += "userpage.jsp";
        response.sendRedirect(response.encodeRedirectURL(contextPath));
        
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
