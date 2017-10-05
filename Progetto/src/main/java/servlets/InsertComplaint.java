/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import dao.ComplaintDAO;
import dao.PurchaseDAO;
import dao.UserDAO;
import dao.entities.Complaint;
import dao.entities.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import persistence.utils.dao.exceptions.DAOException;
import persistence.utils.dao.exceptions.DAOFactoryException;
import persistence.utils.dao.factories.DAOFactory;

/**
 *
 * @author pomo
 */
@WebServlet(name = "InsertComplaint", urlPatterns = {"/InsertComplaint"})
public class InsertComplaint extends HttpServlet {

    private ComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        super.init(); 
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for storage system");
        }
        try {
        complaintDAO = daoFactory.getDAO(ComplaintDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for complaint storage system", ex);
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
        int purID = Integer.parseInt(request.getParameter("purchaseid"));
        String text = request.getParameter("testo");
        Complaint c = new Complaint();
        c.setComplaintText(text);
        c.setPurchaseId(purID);
        c.setStatus(Complaint.STATUS_NEW);
        c.setComplaintTime(new Timestamp(new Date().getTime()).toString());
        try {
            complaintDAO.add(c);
        } catch (DAOException ex) {
            throw new ServletException("Error during creating a new complaint",ex);
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
