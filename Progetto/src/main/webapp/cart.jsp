<%-- 
    Document   : cart
    Created on : Jul 11, 2017, 3:13:43 PM
    Author     : pomo
--%>

<%@page import="java.util.HashMap"%>
<%@ page import="dao.entities.Item" %>
<%@ page import="dao.ItemDAO" %>
<%@ page import="persistence.utils.dao.factories.DAOFactory" %>
<%@ page import="persistence.utils.dao.exceptions.DAOFactoryException" %>
<%@ page import="persistence.utils.dao.factories.jdbc.JDBCDAOFactory" %>
<%@ page import="java.util.ArrayList" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    boolean logged = false;
    ItemDAO itemDAO;
    double totalprice = 0;

    DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
    if (daoFactory == null) {
        throw new ServletException("Impossible to get dao factory for storage system");
    }
    try {
        itemDAO = daoFactory.getDAO(ItemDAO.class);
    } catch (DAOFactoryException ex) {
        throw new ServletException("Impossible to get dao factory for item storage system", ex);
    }

    HashMap<Integer,Integer> cart = (HashMap<Integer,Integer>) session.getAttribute("cart");
    
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Carrello</title>
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js" integrity="sha384-b/U6ypiBEHpOf/4+1nzFpr53nxSS+GLCkfwBdFNTxtclqqenISfwAzpKaMNFNmj4" crossorigin="anonymous"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="js/cartJS.js"></script>
        <link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
        <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="Header.jsp"/>
        <div class="container-fluid containerFix">
            <div class="row">
                <div id="cartDiv" class="col col-xs-12">
                    <%if(cart == null || cart.isEmpty()) 
                    {
                    %>
                    <h2 style="text-align: center">Il carrello è vuoto</h2>
                    <%
                    }
                    else
                    {
                        HashMap<Item,Integer> items = new HashMap<>();
                        ArrayList<Item> items_array = new ArrayList<>();
                        for (Integer i : cart.keySet()){
                            Item item = itemDAO.getByPrimaryKey(i);
                            items_array.add(item);
                            items.put(item,cart.get(i));
                            totalprice += item.getPrice() * cart.get(i);

                            pageContext.setAttribute("totalprice", totalprice);
                            /*for(int j= 0; j< cart.get(i);j++)
                                out.println("ASD PROVA PROVA");
                            */
                        }
                        pageContext.setAttribute("items", items);
                    %>
                    <h1>Carrello</h1>
                    <table class="table" style="table-layout: fixed;">
                        <thead>
                            <th><strong>Totale</strong></th>
                            <th></th>
                            <th class="text-right"><strong><fmt:formatNumber value="${totalprice}" type="currency" currencySymbol="€"/></strong></th>
                        </thead>
                        <tbody>
                        <c:forEach items="${items}" var="current">
                            <tr>
                                <td><p style="word-wrap: break-word;"><a href="item.jsp?itemid=<c:out value="${current.key.itemId}"/>">${current.key.name}</a></p></td>
                                <td class="text-right"><fmt:formatNumber value="${current.key.price}" type="currency" currencySymbol="€"/></td>
                                <td class="text-right"><span class="btn-group btn-group-sm"><button onclick="addRemoveItem(0,${current.key.itemId})" class="btn btn-xs btn-danger">-</button><button class="btn btn-xs btn-outline-dark" disabled><c:out value="${current.value}"/></button><button onclick="addRemoveItem(1,${current.key.itemId})" class="btn btn-xs btn-danger">+</button></span></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                    <form action="/Payment.jsp" method="POST" class="form-inline">
                        <input class="btn btn-default btn-success" type="submit" value="Procedi al pagamento">
                    </form>
                    <% } %>
                </div>
            </div>
        </div>
        <jsp:include page="Footer.jsp"/>
    </body>
</html>
