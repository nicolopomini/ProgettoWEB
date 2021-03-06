/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import dao.ComplaintDAO;
import dao.NotificationDAO;
import dao.PurchaseDAO;
import dao.entities.Complaint;
import dao.entities.Notification;
import dao.entities.User;
import java.io.IOException;
import java.rmi.ServerException;
import java.sql.Timestamp;
import java.util.Date;
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
@WebServlet(name = "UpdateComplaint", urlPatterns = {"/UpdateComplaint"})
public class UpdateComplaint extends HttpServlet {
    private NotificationDAO notificationDAO;
    private ComplaintDAO complaintDAO;
    private PurchaseDAO purchaseDAO;
    
    @Override
    public void init() throws ServletException {
        super.init(); 
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for storage system");
        }
        try {
            notificationDAO = daoFactory.getDAO(NotificationDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for notification storage system", ex);
        }
        try {
            complaintDAO = daoFactory.getDAO(ComplaintDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for complaint storage system", ex);
        }
        try {
            purchaseDAO = daoFactory.getDAO(PurchaseDAO.class);
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
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User)session.getAttribute("user");
        int complaintId = Integer.parseInt(request.getParameter("complaintid"));
        String reply = request.getParameter("risposta");
        String reject = request.getParameter("reject");
        boolean addNotification = false;
        try {
            Complaint complaint = complaintDAO.getByPrimaryKey(complaintId);
            Notification notification = new Notification();
            complaint.setStatus(Complaint.STATUS_SEEN);
            if(reply != null && !reply.equals("")) {
                complaint.setReply(reply);
                notification.setNotificationText(reply);
                addNotification = true;
            } else
                notification.setNotificationText("");
            if(reject != null && reject.equals("on")) {
                complaint.setStatus(Complaint.STATUS_REJECTED);
                
                addNotification = true;
                notification.setNotificationText(notification.getNotificationText() + "<br/>L'anomalia è stata respinta.");
            }
            if(addNotification) {
                notification.setAuthor(user.getUserId());
                notification.setLink("#");
                notification.setSeen(false);
                notification.setRecipient(purchaseDAO.getByPrimaryKey(complaint.getPurchaseId()).getUserId());
                notification.setNotificationTime(new Timestamp(new Date().getTime()).toString());
                notification.setType(Notification.REPLYCOMPLAINT);
                notificationDAO.add(notification);
            }
            complaintDAO.update(complaint);
        } catch (DAOException ex) {
            throw new ServerException("Impossible to update the complaint", ex);
        }
        String contextPath = getServletContext().getContextPath();
        if(!contextPath.endsWith("/"))
            contextPath += "/";
        contextPath += "notifications.jsp";
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
