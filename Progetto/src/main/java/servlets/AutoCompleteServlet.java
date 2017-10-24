/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import com.google.gson.Gson;
import dao.ItemDAO;
import dao.entities.Item;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Iterator;
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
 * @author root
 */
public class AutoCompleteServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            //System.err.println("test"+request.getParameter("inputSearch"));
            ItemDAO db;
            DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
            db=daoFactory.getDAO(ItemDAO.class);
            String query=request.getParameter("inputSearch");
            String category=request.getParameter("category");
            String shop=request.getParameter("shopName");
            System.err.println(query);
            System.err.println(category);
            System.err.println(shop);
            ArrayList<Item>items;
            
            /*items=db.findItems(query, category, shop, 0, 10000, 0, 5, 100);
            ArrayList<String>names=new ArrayList<>();
            
            Iterator<Item>itr=items.iterator();
            while(itr.hasNext()){
                Item i=itr.next();
                names.add(i.getName());
                
            }
            out.print(names);*/
            String[] sv={"PurpleSmart","BlueFast","YellowQuiet","Ponk","Marshmellow","Apul"};
            out.write(new Gson().toJson(sv));
        } catch (DAOFactoryException ex) {
            Logger.getLogger(AutoCompleteServlet.class.getName()).log(Level.SEVERE, null, ex);
        }/* catch (DAOException ex) {
            Logger.getLogger(AutoCompleteServlet.class.getName()).log(Level.SEVERE, null, ex);
        }*/
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
        processRequest(request, response);
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
        processRequest(request, response);
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
