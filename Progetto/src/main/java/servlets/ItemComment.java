/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import dao.ItemReviewDAO;
import dao.NotificationDAO;
import dao.entities.Item;
import dao.entities.ItemReview;
import dao.entities.Notification;
import dao.entities.User;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;
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
import utils.StringUtils;

/**
 *
 * @author pomo
 */
@WebServlet(name = "ItemComment", urlPatterns = {"/ItemComment"})
public class ItemComment extends HttpServlet {
    private ItemReviewDAO itemReviewDAO;
    private NotificationDAO notificationDAO;

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
        Item item = (Item)session.getAttribute("item");
        String comment = StringUtils.checkInputString(request.getParameter("newcomment"));
        int score = Integer.parseInt(request.getParameter("score"));
        ItemReview review = new ItemReview();
        review.setItemId(item.getItemId());
        review.setItemReviewId(null);
        review.setReply(null);
        review.setReviewText(comment);
        review.setReviewTime(new Timestamp(new Date().getTime()).toString());
        review.setScore(score);
        review.setUserId(user.getUserId());
        Notification notification = new Notification();
        notification.setAuthor(user.getUserId());
        notification.setType(Notification.NEWCOMMENTITEM);
        notification.setNotificationTime(new Timestamp(new Date().getTime()).toString());
        notification.setNotificationText("");
        notification.setLink("./item.jsp?itemid= " + item.getItemId() + "#commenti");
        notification.setSeen(false);
        try {
            notification.setRecipient(itemReviewDAO.getItemSeller(item.getItemId()));
            itemReviewDAO.add(review);
            notificationDAO.add(notification);
        } catch (DAOException ex) {
            throw new ServletException("Impossible to add the item review", ex);
        }
        Cookie c = new Cookie("item_message","insered");
        c.setMaxAge(1);
        response.addCookie(c);
        String contextPath = getServletContext().getContextPath();
        if(!contextPath.endsWith("/"))
            contextPath += "/";
        contextPath += "item.jsp?itemid=" + item.getItemId();
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
