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
import dao.entities.User;
import java.io.IOException;
import java.io.PrintWriter;
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
        response.setContentType("application/json");
        int itemId = Integer.parseInt(request.getParameter("itemid"));
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        User user = (User)session.getAttribute("user");
        Item toComment = null;
        double avgScore;
        int avg;
        try {
            toComment = itemDAO.getByPrimaryKey(itemId);
            String comment = StringUtils.checkInputString(request.getParameter("newcomment"));
            int score = Integer.parseInt(request.getParameter("itemscore"));
            ItemReview review = new ItemReview();
            review.setItemId(toComment.getItemId());
            review.setItemReviewId(null);
            review.setReply(null);
            review.setReviewText(comment);
            review.setReviewTime(new Timestamp(new Date().getTime()).toString());
            review.setScore(score);
            review.setUserId(user.getUserId());
            review.setAuthorName(user.getName());
            review.setAuthorSurname(user.getSurname());
            Notification notification = new Notification();
            notification.setAuthor(user.getUserId());
            notification.setType(Notification.NEWCOMMENTITEM);
            notification.setNotificationTime(new Timestamp(new Date().getTime()).toString());
            notification.setNotificationText("");
            notification.setLink("./item.jsp?itemid= " + toComment.getItemId() + "#commenti");
            notification.setSeen(false);
            notification.setRecipient(itemReviewDAO.getItemSeller(toComment.getItemId()));
            itemReviewDAO.add(review);
            notificationDAO.add(notification);
            avgScore = itemReviewDAO.getAverageScoreByItemId(itemId);
            avg = (int)(avgScore * 10);
            String JSONReturn = "{\"avgScore\": \"" + avgScore + "\", \"avg\": \"" + avg + "\", " + review.toString() + "}";
            out.println(JSONReturn);
        } catch (DAOException ex) {
            throw new ServletException("Impossible to add the item review", ex);
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
