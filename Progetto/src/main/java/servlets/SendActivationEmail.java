/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import dao.UserDAO;
import dao.entities.User;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import persistence.utils.dao.exceptions.DAOException;
import persistence.utils.dao.exceptions.DAOFactoryException;
import persistence.utils.dao.factories.DAOFactory;
import utils.MailUtils;
import utils.StringUtils;

/**
 *
 * @author Dva
 */
public class SendActivationEmail extends HttpServlet {

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
            throws ServletException, IOException 
    {
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
            throws ServletException, IOException 
    {
        String contextPath = getServletContext().getContextPath();
        if(!contextPath.endsWith("/"))
            contextPath += "/";
        contextPath += "index.jsp";
        response.sendRedirect(response.encodeRedirectURL(contextPath));
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
            throws ServletException, IOException 
    {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String emailRegex = "[^a-zA-Z0-9-_@.]";
        String email = request.getParameter("Email");
        if(!StringUtils.isEmpty(email))
        {
            if(StringUtils.isValidString(email, emailRegex))
            {
                UserDAO user;
                User toActivate = null;
                DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
                if (daoFactory == null) 
                {
                    throw new ServletException("Impossible to get dao factory for storage system");
                }
                try 
                {
                    user = daoFactory.getDAO(UserDAO.class);
                    toActivate = user.getUserByEmail(email);
                } 
                catch (DAOFactoryException ex) 
                {
                    throw new ServletException("Impossible to get dao factory for user activation", ex);
                } 
                catch (DAOException ex) 
                {
                    throw new ServletException("Impossible to get dao factory for user activation", ex);
                }
                if(toActivate.getUserId() != null)
                {
                    if(!toActivate.getVerificationCode().equals("1"))
                    {
                        MailUtils.sendActivationEmail(toActivate);
                        out.print("sent");
                    }
                }
                else
                {
                    out.print("");
                }
            }
            else
            {
                out.print("");
            }
        }
        else
        {
            out.print("");
        }
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
