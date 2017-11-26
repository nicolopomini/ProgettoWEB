package servlets;

import dao.ItemDAO;
import dao.PictureDAO;
import dao.PurchaseDAO;
import dao.entities.*;
import persistence.utils.dao.exceptions.DAOException;
import persistence.utils.dao.exceptions.DAOFactoryException;
import persistence.utils.dao.factories.DAOFactory;
import utils.MultipartHandler;
import utils.StringUtils;

import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.swing.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;

/**
 * Created by Michele on 09/08/2017.
 */

@WebServlet(name = "Checkout", urlPatterns = {"/Checkout"})
public class Checkout extends HttpServlet {
    private PurchaseDAO purchaseDAO;
    private ItemDAO itemDAO;
    @Override
    public void init() throws ServletException {
        super.init();
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for storage system");
        }
        try {
            purchaseDAO = daoFactory.getDAO(PurchaseDAO.class);
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
        HttpSession session = request.getSession();

        String type = request.getParameter("type");
        User user = (User)session.getAttribute("user");
        if(type != null) {
            if (type.equals("cod")) {

            } else if (type.equals("card")) {

            }
        }
        HashMap<Integer, Integer> cart;
        HashMap<Item, Integer> items = new HashMap<>();
        ArrayList<Item> items_array = new ArrayList<>();
        try {
            cart = (HashMap<Integer, Integer>) request.getSession().getAttribute("cart");
            if (cart != null && !cart.isEmpty()) {
                for (Integer i : cart.keySet()) {
                    Purchase p = new Purchase();
                    p.setItemId(i);
                    p.setQuantity(cart.get(i));
                    p.setPurchaseTime(new Timestamp(new Date().getTime()).toString());
                    p.setUserId(user.getUserId());
                    purchaseDAO.add(p);
                }
            }
            else { throw new ServletException("The cart is probably empty");}
        } catch (DAOException e){
            throw new ServletException("An unexpected error occured");
        }
        String contextPath = getServletContext().getContextPath();
        if(!contextPath.endsWith("/"))
            contextPath += "/";
        contextPath += "index.jsp";
        response.sendRedirect(response.encodeRedirectURL(contextPath));


        /*Shop shop = (Shop)session.getAttribute("shop");
        double prezzo = -1.0;
        ArrayList<String> images = new ArrayList<>();
        String encoding = request.getCharacterEncoding();
        if(encoding == null)
            encoding = "UTF-8";
        Collection<Part> requestObjects = request.getParts();
        for(Part p : requestObjects) {
            if(p.getSize() > 0) {
                if(p.getName().startsWith("image"))
                    images.add(MultipartHandler.processImage(p,getServletContext().getRealPath("/")));
                else if(p.getName().equals("name"))
                    name = StringUtils.checkInputString(MultipartHandler.getStringValue(p, encoding));
                else if(p.getName().equals("descrizione"))
                    descrizione = StringUtils.checkInputString(MultipartHandler.getStringValue(p, encoding));
                else if(p.getName().equals("prezzo"))
                    prezzo = Double.parseDouble(MultipartHandler.getStringValue(p, encoding));
                else if(p.getName().equals("categoria"));

            }
        }
        Item item = new Item();
        item.setCategory(categoria);
        item.setDescription(descrizione);
        item.setItemId(null);
        item.setName(name);
        item.setPrice(prezzo);
        item.setShopId(shop.getShopId());
        try {
            item = itemDAO.add(item);
        } catch (DAOException ex) {
            throw new ServletException("Impossible to add the item");
        }
        for(String s : images) {
            Picture p = new Picture();
            p.setItemId(item.getItemId());
            p.setPath(s);
            p.setPictureId(null);
            try {
                pictureDAO.add(p);
            } catch (DAOException ex) {
                throw new ServletException("Impossible to add the picture");
            }
        }*/
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
