/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import Utility.MultipartHandler;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Properties;
import javax.servlet.ServletException;
import static javax.servlet.SessionTrackingMode.URL;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 *
 * @author pomo
 */
@WebServlet(name = "InsertItem", urlPatterns = {"/InsertItem"})
public class InsertItem extends HttpServlet {

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
        String name = "", descrizione = "", categoria = "";
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
                    name = MultipartHandler.getStringValue(p, encoding);
                else if(p.getName().equals("descrizione"))
                    descrizione = MultipartHandler.getStringValue(p, encoding);
                else if(p.getName().equals("prezzo"))
                    prezzo = Double.parseDouble(MultipartHandler.getStringValue(p, encoding));
                else if(p.getName().equals("categoria"))
                    categoria = MultipartHandler.getStringValue(p, encoding);
            }
        }
        System.out.println(name);
        System.out.println(descrizione);
        System.out.println(prezzo);
        System.out.println(categoria);
        System.out.println(images);
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
