/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import dao.ItemDAO;
import dao.ItemReviewDAO;
import dao.NotificationDAO;
import dao.entities.Item;
import dao.entities.ItemReview;
import dao.entities.Notification;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import persistence.utils.dao.exceptions.DAOException;
import persistence.utils.dao.exceptions.DAOFactoryException;
import persistence.utils.dao.factories.DAOFactory;
import utils.StringUtils;

/**
 *
 * @author pomo
 */
@WebServlet(name = "ItemCommentReply", urlPatterns = {"/ItemCommentReply"})
public class ItemCommentReply extends HttpServlet {
    private ItemReviewDAO itemReviewDAO;
    private NotificationDAO notificationDAO;
    private ItemDAO itemDAO;

    @Override
    public void init() throws ServletException {
        super.init(); 
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for storage system");
        }
        try {
            itemReviewDAO = daoFactory.getDAO(ItemReviewDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shop storage system", ex);
        }
        try {
            notificationDAO = daoFactory.getDAO(NotificationDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shop storage system", ex);
        }
        try {
            itemDAO = daoFactory.getDAO(ItemDAO.class);
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
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        int itemid = Integer.parseInt(request.getParameter("itemid"));
        int reviewid = Integer.parseInt(request.getParameter("reviewid"));
        try {
            Item item = itemDAO.getByPrimaryKey(itemid);
            ItemReview review = itemReviewDAO.getByPrimaryKey(reviewid);
            review.setReply(StringUtils.checkInputString(request.getParameter("replycomment")));
            itemReviewDAO.update(review);
            Notification notification = new Notification();
            notification.setAuthor(itemReviewDAO.getItemSeller(item.getItemId()));
            notification.setRecipient(review.getUserId());
            notification.setType(Notification.REPLYCOMMENTITEM);
            notification.setNotificationTime(new Timestamp(new Date().getTime()).toString());
            notification.setNotificationText("");
            notification.setLink("./item.jsp?itemid=" + item.getItemId() + "#" + review.getItemReviewId());
            notification.setSeen(false);
            notificationDAO.add(notification);
            String HTMLreturn = "<li class=\"list-group-item\"><b>" + review.getAuthorName() + " " + review.getAuthorSurname() + "</b>: "+ review.getReviewText() + "</li>" +
                    "<li class=\"list-group-item\"><b>Venditore</b>: " + review.getReply() +  "</li>";
            out.println(HTMLreturn);
        } catch (DAOException ex) {
            throw new ServletException("Impossible to reply the review", ex);
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
