/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import dao.NotificationDAO;
import dao.ShopReviewDAO;
import dao.entities.Notification;
import dao.entities.Shop;
import dao.entities.ShopReview;
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
import utils.StringUtils;

/**
 *
 * @author pomo
 */
@WebServlet(name = "ShopCommentReply", urlPatterns = {"/ShopCommentReply"})
public class ShopCommentReply extends HttpServlet {
    private ShopReviewDAO shopReview;
    private NotificationDAO notificationDAO;

    @Override
    public void init() throws ServletException {
        super.init(); 
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for storage system");
        }
        try {
            shopReview = daoFactory.getDAO(ShopReviewDAO.class);
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
        Shop shop = (Shop)session.getAttribute("shop");
        int reviewid = Integer.parseInt(request.getParameter("reviewid"));
        try {
            ShopReview review = shopReview.getByPrimaryKey(reviewid);
            String reply = StringUtils.checkInputString(request.getParameter("replycomment"));
            review.setReply(reply);
            shopReview.update(review);
            Notification notification = new Notification();
            notification.setAuthor(shop.getUserId());
            notification.setRecipient(review.getUserId());
            notification.setType(Notification.REPLYCOMMENTSHOP);
            notification.setNotificationTime(new Timestamp(new Date().getTime()).toString());
            notification.setNotificationText("");
            notification.setLink("./item.jsp?itemid= " + shop.getShopId() + "#commenti");
            notification.setSeen(false);
            notificationDAO.add(notification);
        } catch (DAOException ex) {
            throw new ServerException("Impossible to reply the review", ex);
        }
        String contextPath = getServletContext().getContextPath();
        if(!contextPath.endsWith("/"))
            contextPath += "/";
        contextPath += "shop.jsp?shopid=" + shop.getShopId() + "&message=replied";
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
