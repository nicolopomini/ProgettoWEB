/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

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
import javax.servlet.http.Part;

/**
 *
 * @author pomo
 */
@WebServlet(name = "ModifyShop", urlPatterns = {"/ModifyShop"})
public class ModifyShop extends HttpServlet {

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
                        name = MultipartHandler.getStringValue(p, encoding);
                    else if(p.getName().equals("website"))
                        website = MultipartHandler.getStringValue(p, encoding);
                    else if(p.getName().equals("address"))
                        address = MultipartHandler.getStringValue(p, encoding);
                    else if(p.getName().equals("orari"))
                        orari = MultipartHandler.getStringValue(p, encoding);
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
            coordinates.getJsonNumber("lat").doubleValue();
            lat = coordinates.getJsonNumber("lat").doubleValue();
            lng = coordinates.getJsonNumber("lng").doubleValue();
        }
        //query di modifica
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
