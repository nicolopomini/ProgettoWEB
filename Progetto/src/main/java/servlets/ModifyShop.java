/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import Utility.MultipartHandler;
import java.io.File;
import java.io.IOException;
import java.util.Collection;
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
        /*
        Input tramite post:
        newname
        website
        address (bisogna modificare anche le coordinate)
        orari
        image
        */
        String encoding = request.getCharacterEncoding();
        if(encoding == null)
            encoding = "UTF-8";
        String name = null, website = null, address = null, orari = null, image = null;
        Collection<Part> requestObjects = request.getParts();
        for(Part p : requestObjects) {
            if(p.getName().equals("image")) //file
                image = MultipartHandler.processImage(p);
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
        System.out.println(name);
        System.out.println(website);
        System.out.println(address);
        System.out.println(orari);
        System.out.println(image);
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
