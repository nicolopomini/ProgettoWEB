<%--
  Created by IntelliJ IDEA.
  User: Michele
  Date: 25/11/2017
  Time: 16:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.entities.User" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="dao.entities.Item" %>
<%@ page import="dao.ItemDAO" %>
<%@ page import="persistence.utils.dao.factories.DAOFactory" %>
<%@ page import="persistence.utils.dao.exceptions.DAOFactoryException" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%
    User sessionUser = (User)session.getAttribute("user");
    boolean logged = (sessionUser != null);
    HashMap<Integer,Integer> cart = (HashMap<Integer,Integer>) session.getAttribute("cart");
    session.setAttribute("checkout", cart);
    double totalprice = (double)session.getAttribute("totalprice");
    ItemDAO itemDAO;

    DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
    if (daoFactory == null) {
        throw new ServletException("Impossible to get dao factory for storage system");
    }
    try {
        itemDAO = daoFactory.getDAO(ItemDAO.class);
    } catch (DAOFactoryException ex) {
        throw new ServletException("Impossible to get dao factory for item storage system", ex);
    }

    String CCN, name, expDate, type;
    type = request.getParameter("type");
    CCN = request.getParameter("cardno");
    name = request.getParameter("owner");
    expDate = request.getParameter("exp-month") + "/" + request.getParameter("exp-year");
    if(!logged){
        response.sendRedirect("/login.jsp");
    }
    else if (type==null || cart == null || cart.isEmpty()){
        response.sendRedirect("/cart.jsp");
    }
%>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Order summary</title>
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js" integrity="sha384-b/U6ypiBEHpOf/4+1nzFpr53nxSS+GLCkfwBdFNTxtclqqenISfwAzpKaMNFNmj4" crossorigin="anonymous"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="js/shopJS.js"></script>
        <link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
        <link href="css/bootstrap-theme.min.css" type="text/css" rel="stylesheet">
        <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
    </head>
    <body>
        <script type="text/javascript">
            function sendForm(){
                document.getElementById("CVV").value = <%=request.getAttribute("CVV")%>;
                document.getElementById("confirmForm").submit();
            }
        </script>
        <jsp:include page="Header.jsp"/>
        <div class="container-fluid containerFix">
            <h1>Riepilogo Ordine</h1>
            <br/>
            <form id="confirmForm" method="post" action="Checkout">
                <input type="hidden" id="CVV" name="CVV">
                <input type="hidden" name="type" value="<%= type%>">
                <% if(type.equals("card")){%> 
                <label>Tipo di pagamento: <b>Carta di Credito</b></label><br/>
                <label>Numero carta: <b><%= CCN%></b></label><input type="hidden" name="cardno" value="<%= CCN%>"> <br/>
                <label>Proprietario: <b><%= name%></b></label><input type="hidden" name="owner" value="<%= name%>"> <br/>
                <label>Scadenza <b><%= expDate%></b></label><input type="hidden" name="expDate" value="<%= expDate%>"><br/>
                <% }else{%>
                <label>Tipo di pagamento: <b>Contrassegno</b></label><br/>
                <% }%>
                <table class="table" style="table-layout: fixed;">
                    <thead>
                            <th><strong>Totale</strong></th>
                            <th></th>
                            <th class="text-right"><strong><fmt:formatNumber value="${totalprice}" type="currency" currencySymbol="€"/></strong></th>
                        </thead>
                        <tbody>
                <%
                    for (Integer i : cart.keySet()) {
                %>
                    <tr>
                        <%Item item = itemDAO.getByPrimaryKey(i); %>
                        <td><label><%=item.getName()%></label></td>
                        <td><label><%=item.getPrice()+" $"%></label></td>
                        <td><label><%=cart.get(i)%></label></td>
                    </tr>
                <%
                    }
                %>
                        </tbody>
                </table>
                <button class="btn btn-success" type = "button" onclick="sendForm()">Conferma</button>
                <a href="cart.jsp">
                    <button class="btn btn-warning" type = "button">Torna al carrello</button>
                </a>
            </form>
        </div>
        <!--Footer-->
        <jsp:include page="Footer.jsp"/>
    </body>
</html>
