/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import dao.ComplaintDAO;
import dao.ItemDAO;
import dao.ItemReviewDAO;
import dao.NotificationDAO;
import dao.PictureDAO;
import dao.PurchaseDAO;
import dao.ShopDAO;
import dao.ShopReviewDAO;
import dao.UserDAO;
import dao.entities.Complaint;
import dao.entities.Item;
import dao.entities.ItemReview;
import dao.entities.Notification;
import dao.entities.Picture;
import dao.entities.Purchase;
import dao.entities.Shop;
import dao.entities.ShopReview;
import dao.entities.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import persistence.utils.dao.exceptions.DAOException;
import persistence.utils.dao.exceptions.DAOFactoryException;
import persistence.utils.dao.factories.DAOFactory;

/**
 *
 * @author Marco
 */
public class DebugServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
    private ComplaintDAO complaintDAO;
    private ItemDAO itemDAO;
    private ItemReviewDAO itemReviewDAO;
    private NotificationDAO notificationDAO;
    private PictureDAO pictureDAO;
    private PurchaseDAO purchaseDAO;
    private ShopDAO shopDAO;
    private ShopReviewDAO shopReviewDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for storage system");
        }
        try {
            complaintDAO = daoFactory.getDAO(ComplaintDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for camplaint storage system", ex);
        }
        
        try {
            itemDAO = daoFactory.getDAO(ItemDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for item storage system", ex);
        }
        
        try {
            itemReviewDAO = daoFactory.getDAO(ItemReviewDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for itemReview storage system", ex);
        }
        
        try {
            notificationDAO = daoFactory.getDAO(NotificationDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for notification storage system", ex);
        }
        
        try {
            pictureDAO = daoFactory.getDAO(PictureDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for picture storage system", ex);
        }
        
        try {
            purchaseDAO = daoFactory.getDAO(PurchaseDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for purchase storage system", ex);
        }
        
        try {
            shopDAO = daoFactory.getDAO(ShopDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shop storage system", ex);
        }
        
        try {
            shopReviewDAO = daoFactory.getDAO(ShopReviewDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shopReview storage system", ex);
        }
        
        try {
            userDAO = daoFactory.getDAO(UserDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for user storage system", ex);
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            try {
                out.print("Test:<br><br>");
                
                testUser(out);
                testShop(out);
                testItem(out);
                testPicture(out);
                testNotification(out);
                testPurchase(out);
                testComplaint(out);
                testItemReview(out);
                testShopReview(out);
                
                out.print("Test completed");
            } catch (DAOException ex) {
                Logger.getLogger(DebugServlet.class.getName()).log(Level.SEVERE, null, ex);
                out.println("<br>" + ex);
            }
        }
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
    
    private void testUser(PrintWriter out) throws DAOException
    {
        User u = new User();
        
        u.setName("asdf");
        u.setAddress("asdf");
        u.setEmail(UUID.randomUUID().toString());
        u.setPassword("asdf");
        u.setSurname("asdf");
        u.setType("admin");
        u.setVerificationCode("1");
        u.setToken("asdf");
        
        userDAO.add(u);
        
        u.setEmail(UUID.randomUUID().toString());
        userDAO.add(u);
        
        out.print(userDAO.getByPrimaryKey(1) + "<br>");
        
        u.setSurname("asdfasdgasg");
        userDAO.update(u);
        
        for(User user : userDAO.getAll())
        {
            out.print(user + "<br>");
        }
        
        userDAO.removeByPrimaryKey(userDAO.getCount());
        
        out.print("<br>");
    }
    
    private void testShop(PrintWriter out) throws DAOException
    {
        Shop s = new Shop();
        
        s.setAddress("asdf");
        s.setImagePath("asdf");
        s.setLat(0d);
        s.setLon(0d);
        s.setName("asdf");
        s.setOpeningHours("asdf");
        s.setUserId(1);
        s.setWebsite("asdf");
        
        shopDAO.add(s);
        
        s.setName("qwer");
        shopDAO.add(s);
        
        out.print(shopDAO.getByPrimaryKey(1) + "<br>");
        
        s.setOpeningHours("qwer");
        shopDAO.update(s);
        
        for(Shop shop : shopDAO.getAll())
        {
            out.print(shop + "<br>");
        }
        
        shopDAO.removeByPrimaryKey(shopDAO.getCount());
        
        out.print("Can comment " + shopDAO.canComment(1, 1) + "<br>");
        
        out.print("<br>");
    }
    
    private void testItem(PrintWriter out) throws DAOException
    {
        Item i = new Item();
        
        i.setCategory("home");
        i.setDescription("asdf");
        i.setName("asdf");
        i.setPrice(1d);
        i.setShopId(1);
        
        itemDAO.add(i);
        
        i.setName("qwer");
        itemDAO.add(i);
        
        out.print(itemDAO.getByPrimaryKey(1) + "<br>");
        
        i.setDescription("qwer");
        itemDAO.update(i);
        
        for(Item item : itemDAO.getAll())
        {
            out.print(item + "<br>");
        }
        
        itemDAO.removeByPrimaryKey(itemDAO.getCount());
        
        out.print("Can comment " + itemDAO.canComment(1, 1) + "<br>");
        out.print("Nearby " + itemDAO.getItemNearby(i).size() + "<br>");
        out.print("GetItemsByNameFilterByCategoryShop " + itemDAO.getItemsByNameFilterByCategoryShop("asdf", "home", null).toString() + "<br>");
        out.print("Categories " + itemDAO.getAllCategories().toString() + "<br>");
        
        out.print("<br>");
    }
    
    private void testPicture(PrintWriter out) throws DAOException
    {
        Picture p = new Picture();
        
        p.setPath("asdf");
        p.setItemId(1);
        
        pictureDAO.add(p);
        
        p.setPath("qwer");
        pictureDAO.add(p);
        
        out.print(pictureDAO.getByPrimaryKey(1) + "<br>");
        
        p.setPath("asdfasdgasg");
        pictureDAO.update(p);
        
        for(Picture picture : pictureDAO.getAll())
        {
            out.print(picture + "<br>");
        }
        
        pictureDAO.removeByPrimaryKey(pictureDAO.getCount());
        
        out.print("By item " + pictureDAO.getByItemId(1) + "<br>");
        
        out.print("<br>");
    }
    
    private void testNotification(PrintWriter out) throws DAOException
    {
        Notification n = new Notification();
        
        n.setNotificationText("asdf");
        n.setSeen(false);
        n.setAuthor(1);
        
        notificationDAO.add(n);
        
        n.setNotificationText("qwer");
        notificationDAO.add(n);
        
        out.print(notificationDAO.getByPrimaryKey(1) + "<br>");
        
        n.setNotificationText("asdfasdgasg");
        notificationDAO.update(n);
        
        for(Notification notification : notificationDAO.getAll())
        {
            out.print(notification + "<br>");
        }
        
        notificationDAO.removeByPrimaryKey(notificationDAO.getCount());
        
        out.print("<br>");
    }
    
    private void testPurchase(PrintWriter out) throws DAOException
    {
        Purchase p = new Purchase();
        
        p.setItemId(1);
        p.setPurchaseTime("1975-01-01 00:00:01");
        p.setQuantity(5);
        p.setUserId(1);
        
        purchaseDAO.add(p);
        
        p.setQuantity(2);
        purchaseDAO.add(p);
        
        out.print(purchaseDAO.getByPrimaryKey(1) + "<br>");
        
        p.setQuantity(4);
        purchaseDAO.update(p);
        
        for(Purchase purchase : purchaseDAO.getAll())
        {
            out.print(purchase + "<br>");
        }
        
        purchaseDAO.removeByPrimaryKey(purchaseDAO.getCount());
        
        out.print("<br>");
    }
    
    private void testComplaint(PrintWriter out) throws DAOException
    {
        Complaint c = new Complaint();
        
        c.setComplaintText("asdf");
        c.setComplaintTime("1975-01-01 00:00:01");
        c.setPurchaseId(1);
        c.setReply("qwer");
        c.setStatus("new");
        
        complaintDAO.add(c);
        
        c.setComplaintText("qwer");
        complaintDAO.add(c);
        
        out.print(complaintDAO.getByPrimaryKey(1) + "<br>");
        
        c.setComplaintText("qwer");
        complaintDAO.update(c);
        
        for(Complaint complaint : complaintDAO.getAll())
        {
            out.print(complaint + "<br>");
        }
        
        complaintDAO.removeByPrimaryKey(complaintDAO.getCount());
        
        out.print("<br>");
    }
    
    private void testItemReview(PrintWriter out) throws DAOException
    {
        ItemReview ir = new ItemReview();
        
        ir.setItemId(1);
        ir.setReply("asdf");
        ir.setReviewText("asdf");
        ir.setReviewTime("1975-01-01 00:00:01");
        ir.setUserId(1);
        ir.setScore(5);
        
        itemReviewDAO.add(ir);
        
        ir.setReviewText("qwer");
        itemReviewDAO.add(ir);
        
        out.print(itemReviewDAO.getByPrimaryKey(1) + "<br>");
        
        ir.setReviewText("qwer");
        itemReviewDAO.update(ir);
        
        for(ItemReview itemReview : itemReviewDAO.getAll())
        {
            out.print(itemReview + "<br>");
        }
        
        itemReviewDAO.removeByPrimaryKey(itemReviewDAO.getCount());
        
        out.print("Average " + itemReviewDAO.getAverageScoreByItemId(1) + "<br>");
        out.print("By item " + itemReviewDAO.getByItemId(1).size() + "<br>");
        
        out.print("<br>");
    }
    
    private void testShopReview(PrintWriter out) throws DAOException
    {
        ShopReview sr = new ShopReview();
        
        sr.setShopId(1);
        sr.setReply("asdf");
        sr.setReviewText("asdf");
        sr.setReviewTime("1975-01-01 00:00:01");
        sr.setUserId(1);
        sr.setScore(5);
        
        shopReviewDAO.add(sr);
        
        sr.setReviewText("qwer");
        shopReviewDAO.add(sr);
        
        out.print(shopReviewDAO.getByPrimaryKey(1) + "<br>");
        
        sr.setReviewText("qwer");
        shopReviewDAO.update(sr);
        
        for(ShopReview shopReview : shopReviewDAO.getAll())
        {
            out.print(shopReview + "<br>");
        }
        
        shopReviewDAO.removeByPrimaryKey(shopReviewDAO.getCount());
        
        out.print("Average " + shopReviewDAO.getAverageScoreByShopId(1) + "<br>");
        out.print("By shop " + shopReviewDAO.getByShopId(1).size() + "<br>");
        
        out.print("<br>");
    }
}
