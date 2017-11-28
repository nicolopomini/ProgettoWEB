/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import dao.ItemDAO;
import dao.UserDAO;
import dao.entities.Item;
import dao.entities.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import persistence.utils.dao.exceptions.DAOException;
import persistence.utils.dao.exceptions.DAOFactoryException;
import persistence.utils.dao.factories.DAOFactory;
import utils.StringUtils;

/**
 *
 * @author Dva
 */
public class CartManager extends HttpServlet {

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
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        String action = request.getParameter("Action");
        String itemId = request.getParameter("Id");
        HashMap<Integer,Integer> cart = (HashMap<Integer,Integer>) request.getSession().getAttribute("cart");
        ItemDAO itemDAO;
        double totalprice = 0;

        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) 
        {
            throw new ServletException("Impossible to get dao factory for storage system");
        }
        try 
        {
            itemDAO = daoFactory.getDAO(ItemDAO.class);
        } 
        catch (DAOFactoryException ex) 
        {
            throw new ServletException("Impossible to get dao factory for shop storage system", ex);
        }
        if(!StringUtils.isEmpty(action) && !StringUtils.isEmpty(itemId))
        {
            if(cart.containsKey(Integer.parseInt(itemId)))
            {

                int toChange = cart.get(Integer.parseInt(itemId));
                if(action.equals("0"))
                {
                    toChange--;
                }
                else if(action.equals("1"))
                {
                    toChange++;
                }
                if(toChange != 0)
                {
                    cart.replace(Integer.parseInt(itemId), toChange);
                }
                else
                {
                    cart.remove(Integer.parseInt(itemId));
                }
                request.getSession().setAttribute("cart", cart);
                if(cart == null || cart.isEmpty())
                {
                    out.print("<h2 style=\"text-align: center\">Il carrello è vuoto</h2>");
                }
                else
                {
                    HashMap<Item,Integer> items = new HashMap<>();
                    try 
                    {
                        for (Integer i : cart.keySet())
                        {
                            Item item;
                            item = itemDAO.getByPrimaryKey(i);
                            items.put(item,cart.get(i));
                            totalprice += item.getPrice() * cart.get(i);
                        } 
                    }
                    catch (DAOException ex) 
                    {
                        Logger.getLogger(CartManager.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    out.print("<h1>Carrello</h1>"
                            + "<table class=\"table\" style=\"table-layout: fixed;\">"
                            + "<thead>"
                            + "<th><strong>Totale</strong></th>"
                            + "<th></th>"
                            + "<th class=\"text-right\"><strong>€ " + Math.round(totalprice * 100.0)/100.0 + "</strong></th>"
                            + "</thead>"
                            + "<tbody>");
                    for(Item current : items.keySet())
                    {
                        out.print("<tr>"
                                + "<td><p style=\"word-wrap: break-word;\"><a href=\"item.jsp?itemid=" + current.getItemId()+"\">" + current.getName() + "</a></p></td>"
                                + "<td class=\"text-right\">€ " + current.getPrice() + "</td>"
                                + "<td class=\"text-right\"><span class=\"btn-group btn-group-sm\"><button onclick=\"addRemoveItem(0,"+current.getItemId()+")\" class=\"btn btn-xs btn-danger\">-</button><button class=\"btn btn-xs btn-outline-dark\" disabled>"+items.get(current)+"</button><button onclick=\"addRemoveItem(1,"+current.getItemId()+")\" class=\"btn btn-xs btn-danger\">+</button></span></td>"
                                + "</tr>");
                    }
                    out.print("</tbody>"
                            + "</table>"
                            + "<form action=\"/Payment.jsp\" method=\"POST\" class=\"form-inline\">" +
                                    "<input class=\"btn btn-default btn-success\" type=\"submit\" value=\"Procedi al pagamento\">" +
                              "</form>");
                }
            }
        }
        else
        {
            out.print("");
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
