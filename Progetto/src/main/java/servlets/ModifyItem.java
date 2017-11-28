/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import dao.ItemDAO;
import dao.PictureDAO;
import dao.entities.Item;
import dao.entities.Picture;
import dao.entities.Shop;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import persistence.utils.dao.exceptions.DAOException;
import persistence.utils.dao.exceptions.DAOFactoryException;
import persistence.utils.dao.factories.DAOFactory;
import utils.MultipartHandler;
import utils.StringUtils;

/**
 *
 * @author pomo
 */
@WebServlet(name = "ModifyItem", urlPatterns = {"/ModifyItem"})
public class ModifyItem extends HttpServlet {
    private ItemDAO itemDAO;
    private PictureDAO pictureDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for storage system");
        }
        try {
            itemDAO = daoFactory.getDAO(ItemDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shop storage system", ex);
        }
        try {
            pictureDAO = daoFactory.getDAO(PictureDAO.class);
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
        Shop shop = (Shop)session.getAttribute("shop");
        String name = "", descrizione = "", categoria = "";
        double prezzo = -1.0;
        int id = -1;
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
                else if(p.getName().equals("categoria"))
                    categoria = MultipartHandler.getStringValue(p, encoding);
                else if(p.getName().equals("id"))
                    id = Integer.parseInt(MultipartHandler.getStringValue(p, encoding));
            }
        }
        try {
            Item item = itemDAO.getByPrimaryKey(id);
            if(name != null && !name.equals(""))
                item.setName(name);
            if(categoria != null && !categoria.equals(""))
                item.setCategory(categoria);
            if(descrizione != null && !descrizione.equals(""))
                item.setDescription(descrizione);
            if(prezzo > 0)
                item.setPrice(prezzo);
            itemDAO.update(item);
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
            }
        } catch (DAOException ex) {
            throw new ServletException("Impossible to edit the item");
        }
        response.getWriter().print("OK");
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
