/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import dao.NotificationDAO;
import dao.ShopDAO;
import dao.ShopReviewDAO;
import dao.entities.Notification;
import dao.entities.Shop;
import dao.entities.ShopReview;
import dao.entities.User;
import java.io.IOException;
import java.io.PrintWriter;
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
@WebServlet(name = "ShopComment", urlPatterns = {"/ShopComment"})
public class ShopComment extends HttpServlet {
    private ShopDAO shopDAO;
    private ShopReviewDAO shopReviewDAO;
    private NotificationDAO notificationDAO;

    @Override
    public void init() throws ServletException {
        super.init(); 
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for storage system");
        }
        try {
            shopDAO = daoFactory.getDAO(ShopDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shop storage system", ex);
        }
        try {
            shopReviewDAO = daoFactory.getDAO(ShopReviewDAO.class);
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
        response.setContentType("application/json");
        HttpSession session = request.getSession();
        User user = (User)session.getAttribute("user");
        int shopId = Integer.parseInt(request.getParameter("shopid"));
        PrintWriter out = response.getWriter();
        String comment = StringUtils.checkInputString(request.getParameter("newcomment"));
        int score = Integer.parseInt(request.getParameter("score"));
        try {
            Shop shop = shopDAO.getByPrimaryKey(shopId);
            ShopReview review = new ShopReview();
            review.setReply(null);
            review.setShopReviewId(null);
            review.setReviewText(comment);
            review.setScore(score);
            review.setReviewTime(new Timestamp(new Date().getTime()).toString());
            review.setShopId(shop.getShopId());
            review.setUserId(user.getUserId());
            review.setAuthorName(user.getName());
            review.setAuthorSurname(user.getSurname());
            review = shopReviewDAO.add(review);
            Notification notification = new Notification();
            notification.setAuthor(review.getUserId());
            notification.setRecipient(shop.getUserId());
            notification.setType(Notification.NEWCOMMENTSHOP);
            notification.setNotificationTime(new Timestamp(new Date().getTime()).toString());
            notification.setNotificationText("");
            notification.setLink("./shop.jsp?shopid=" + shop.getShopId() + "#" + review.getShopReviewId());
            notification.setSeen(false);
            notificationDAO.add(notification);
            double avgScore = shopReviewDAO.getAverageScoreByShopId(shopId);
            int avg = (int)(avgScore * 10);
            String JSONReturn = "{\"avgScore\": \"" + avgScore + "\", \"avg\": \"" + avg + "\", " + review.toString() + "}";
            out.println(JSONReturn);
        } catch (DAOException ex) {
            throw new ServletException("Error during insering the shop review",ex);
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
