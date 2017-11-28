/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import dao.ShopDAO;
import dao.entities.Shop;
import utils.MultipartHandler;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.Collection;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonReader;
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
import utils.StringUtils;

/**
 *
 * @author pomo
 */
@WebServlet(name = "ModifyShop", urlPatterns = {"/ModifyShop"})
public class ModifyShop extends HttpServlet {
    private ShopDAO shopDAO;
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
        String name = null, website = null, address = null, orari = null, image = null;
        double lat = 0.0, lng = 0.0;
        String encoding = request.getCharacterEncoding();
        if(encoding == null)
            encoding = "UTF-8";
        Collection<Part> requestObjects = request.getParts();
        for(Part p : requestObjects) {
            if(p.getSize() > 0){ //se il campo non è vuoto lo processo
                if(p.getName().equals("image")) //file
                    image = MultipartHandler.processImage(p,getServletContext().getRealPath("/"));
                else {  //testo
                    if(p.getName().equals("newname"))
                        name = StringUtils.checkInputString(MultipartHandler.getStringValue(p, encoding));
                    else if(p.getName().equals("website"))
                        website = StringUtils.checkInputString(MultipartHandler.getStringValue(p, encoding));
                    else if(p.getName().equals("address"))
                        address = MultipartHandler.getStringValue(p, encoding);
                    else if(p.getName().equals("orari"))
                        orari = StringUtils.checkInputString(MultipartHandler.getStringValue(p, encoding));
                }
            }
        }
        //conversione dell'indirizzo in lat e lng
        if(address != null) {
            address = address.replace(' ', '+');
            URL jsonAddress = new URL("https://maps.googleapis.com/maps/api/geocode/json?address=" + address + "&key=AIzaSyDrBp40H8f9zzcsWA8H-1rWNwjl28cthfg");
            InputStream is = jsonAddress.openStream();
            JsonReader rdr = Json.createReader(is);
            JsonObject results = rdr.readObject().getJsonArray("results").getJsonObject(0);
            address = results.getString("formatted_address");
            JsonObject coordinates = results.getJsonObject("geometry").getJsonObject("location");
            lat = coordinates.getJsonNumber("lat").doubleValue();
            lng = coordinates.getJsonNumber("lng").doubleValue();
        }
        //query di modifica
        if(name != null)
            shop.setName(name);
        if(website != null)
            shop.setWebsite(website);
        if(address != null) {
            shop.setAddress(address);
            shop.setLat(lat);
            shop.setLon(lng);
        }
        if(orari != null)
            shop.setOpeningHours(orari);
        if(image != null)
            shop.setImagePath(image);
        try {
            shopDAO.update(shop);
        } catch (DAOException ex) {
            throw new ServletException("Impossible to update the shop", ex);
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
