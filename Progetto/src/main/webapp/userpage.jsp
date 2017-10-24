<%-- 
    Document   : UserPage
    Created on : 25-Aug-2017, 10:22:31
    Author     : Dva
--%>

<%@page import="dao.ItemDAO"%>
<%@page import="dao.entities.Item"%>
<%@page import="dao.PurchaseDAO"%>
<%@page import="dao.entities.Purchase"%>
<%@page import="utils.StringUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="dao.entities.Complaint"%>
<%@page import="dao.entities.Shop"%>
<%@page import="java.util.ArrayList"%>
<%@page import="persistence.utils.dao.exceptions.DAOFactoryException"%>
<%@page import="dao.ShopDAO"%>
<%@page import="dao.ComplaintDAO"%>
<%@page import="dao.UserDAO"%>
<%@page import="persistence.utils.dao.factories.DAOFactory"%>
<%@page import="dao.entities.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    boolean logged, venditore;
    logged = venditore = false;
    User sessionUser = (User)session.getAttribute("user");
    if(sessionUser != null)
    {
        logged = true;
        if(sessionUser.getType().equals("seller"))
        {
            venditore = true;
        }
    }
    DAOFactory daoFactory;
    UserDAO userDAO;
    ComplaintDAO complaintDAO;
    ShopDAO shopDAO;
    PurchaseDAO purchaseDAO;
    ItemDAO itemDAO;
    daoFactory = (DAOFactory) application.getAttribute("daoFactory");
    if (daoFactory == null) {
        throw new ServletException("Impossible to get dao factory for storage system");
    }
    try {
        complaintDAO = daoFactory.getDAO(ComplaintDAO.class);
    } catch (DAOFactoryException ex) {
        throw new ServletException("Impossible to get dao factory for complaint storage system", ex);
    }
    try {
        userDAO = daoFactory.getDAO(UserDAO.class);
    } catch (DAOFactoryException ex) {
        throw new ServletException("Impossible to get dao factory for user storage system", ex);
    }
    try {
        shopDAO = daoFactory.getDAO(ShopDAO.class);
    } catch (DAOFactoryException ex) {
        throw new ServletException("Impossible to get dao factory for shop storage system", ex);
    }
    try {
        purchaseDAO = daoFactory.getDAO(PurchaseDAO.class);
    } catch (DAOFactoryException ex) {
        throw new ServletException("Impossible to get dao factory for purchase storage system", ex);
    }
    try {
        itemDAO = daoFactory.getDAO(ItemDAO.class);
    } catch (DAOFactoryException ex) {
        throw new ServletException("Impossible to get dao factory for item storage system", ex);
    }
    ArrayList<Shop> shops = new ArrayList<>();
    ArrayList<Complaint> complaints = new ArrayList<>();
    ArrayList<Purchase> purchases = new ArrayList<>();
    if(logged) {
        complaints = complaintDAO.getComplaintByAuthor(sessionUser.getUserId());
        purchases = purchaseDAO.getByUserId(sessionUser.getUserId());
        if(venditore) 
            shops = shopDAO.getShopsByOwner(sessionUser.getUserId());
    }
    Cookie[] cookies = request.getCookies();
    Cookie coo = null;
    for(Cookie cookie : cookies)
        if(cookie.getName().equals("user_message"))
            coo = cookie;
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>
            <% if(logged) { %>
            <%= sessionUser.getName() + " " + sessionUser.getSurname() %>
            <% } else { %>
            Pagina utente
            <% } %>
        </title>
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js" integrity="sha384-b/U6ypiBEHpOf/4+1nzFpr53nxSS+GLCkfwBdFNTxtclqqenISfwAzpKaMNFNmj4" crossorigin="anonymous"></script>
        <script src="js/bootstrap.min.js"></script>
        <link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
        <link href="css/bootstrap-theme.min.css" type="text/css" rel="stylesheet">
        <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
        <script>
            function validate() {
                var np = document.forms["update-profile"]["newpassword"].value;
                var rep = document.forms["update-profile"]["repeatpassword"].value;
                var old = document.forms["update-profile"]["oldpassword"].value;
                var message = document.getElementById("messaggio-errore").innerHTML;
                if((old !== null && old !== "") || (rep !== null && rep !== "") || (np !== null && np !== "")) {
                    if(np === null || np === "" || rep === null || rep === "") {
                        message += "Inserisci una nuova password e ripetila."
                        document.getElementById("messaggio-errore").innerHTML = message;
                        return false;
                    } else if(np !== rep){
                        message += "Password ripetuta non corretta."
                        document.getElementById("messaggio-errore").innerHTML = message;
                        return false;
                    }
                    return true;
                }
                return true;
            }
        </script>
    </head>
    <body>
        <div class="container">
            <jsp:include page="Header.jsp"/>
            <% if(coo != null) { %>
            <div class="alert <% if(coo.getValue().equals("error")) { %> alert-danger <% }else{ %> alert-info <% } %> alert-dismissable fade in" role="alert">
                <button type="button" class="close" data-dismiss="alert" aria-label="close">
                    <span aria-hidden="true">x</span>
                </button>
                <%if(coo.getValue().equals("ok")) {%>
                Profilo utente aggiornato.
                <%} else if(coo.getValue().equals("error")) {%>
                Errore nell'aggiornamento dell'utente
                <%}%>
            </div>
            <% } %>
            <% if(sessionUser == null) { %>
            <h1 style="text-align: center">Accesso negato</h1>
            <p class="text-center">Per visualizzare il tuo profilo <a href="login.jsp">accedi</a>.</p>
            <% }else { %>
                <div id="profilo">
                    <h2><%= sessionUser.getName() + " " + sessionUser.getSurname() %></h2>
                    <form name="update-profile" method="post" action="UpdateUser" onsubmit="return validate()">
                        <div class="form-group">
                            <label for="inidirizzo">Modifica indirizzo</label>
                            <input type="text" class="form-control" id="indirizzo" placeholder="<%= sessionUser.getAddress() %>" name="indirizzo">
                        </div>
                        <div class="form-group">
                            <label for="email">Modifica email</label>
                            <input type="email" class="form-control" id="email" placeholder="<%= sessionUser.getEmail() %>" name="email">
                        </div>
                        <h4>Modifica password:</h4>
                        <div class="form-group">
                            <label for="oldpassword">Vecchia password</label>
                            <input type="password" class="form-control" id="oldpassword" placeholder="Vecchia password" name="oldpassword">
                        </div>
                        <div class="form-group">
                            <label for="newpassword">Nuova password</label>
                            <input type="password" class="form-control" id="newpassword" placeholder="Nuova password" name="newpassword">
                        </div>
                        <div class="form-group">
                            <label for="repeatpassword">Ripeti password</label>
                            <input type="password" class="form-control" id="repeatpassword" placeholder="Ripeti password" name="repeatpassword">
                            <p class="help-block" id="messaggio-errore" style="color: red"></p>
                        </div>
                        <button type="submit" class="btn btn-default">Modifica</button>
                    </form>
                </div>
                <div id="anomalie">
                    <% if(!purchases.isEmpty()) { %>
                    <h2>Segnalazione anomalie</h2>
                    <button type="button" class="btn btn-primary btn-lg" data-toggle="modal" data-target="#anomalia">
                        Segnala anomalia
                    </button>
                    <% } %>
                    <% if(!complaints.isEmpty()) { %>
                        <p>Le tue anomalie:</p>
                        <ul>
                        <% for(Complaint c : complaints) { 
                            SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S"); 
                            String date = StringUtils.printDate(dt.parse(c.getComplaintTime()));
                        %>
                        <li>
                            <a role="button" data-toggle="modal" data-target="#<%= c.getComplaintId() %>">
                            <ul class="list-inline">
                                <li><%= date %></li>
                                <li><%= c.getPurchaseId() %></li>
                                <li><%= c.getStatus() %></li>
                            </ul>
                            </a>
                        </li>
                        <% } %>
                        </ul>
                    <% } %>
                </div>
                <% if(venditore) { %>
                <div id="shops">
                    <h2>Negozi</h2>
                    <% if(shops.isEmpty()) { %>
                    <p>Nessun negozio</p>
                    <% } else {%>
                    <table class="table">
                        <tbody>
                            <% for(Shop s : shops) { %>
                            <tr>
                                <td><b><%= s.getName() %></b></td>
                                <td><%= s.getAddress() %></td>
                                <td><a href="shop.jsp?shopid=<%= s.getShopId() %>"><img src="${pageContext.request.contextPath}/<%=s.getImagePath()%>" alt="<%= s.getName() %>" class="img-rounded" height="100" width="177"></a></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <% } %>
                </div>
                <% } %>
          <!--Modals-->
          <%for(Complaint c : complaints) {  
                    SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S"); 
                    String date = StringUtils.printDate(dt.parse(c.getComplaintTime()));
                    Purchase purchase = purchaseDAO.getByPrimaryKey(c.getPurchaseId()); 
                    String purDate = StringUtils.printDate(dt.parse(purchase.getPurchaseTime()));
          %>
          <div class="modal fade" id="<%= c.getComplaintId() %>" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog" role="document">
              <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="readComplaint(<%=c.getComplaintId()%>)"><span aria-hidden="true">&times;</span></button>
                  <h4 class="modal-title" id="myModalLabel">Info anomalia <%= c.getComplaintId() %></h4>
                </div>
                <div class="modal-body">
                    <ul>
                        <li><b>Data</b>: <%=date%></li>
                        <li><b>Stato</b>: <%= c.getStatus() %></li>
                        <li><b>Messaggio</b>: <%= c.getComplaintText() %></li>
                        <li><b>Risposta</b>:
                            <% if(c.getReply() == null ||  c.getReply().equals("")) { %>
                            Nessuna risposta.
                            <% }else { %>
                            <%= c.getReply() %>
                            <% } %>
                        </li>
                    </ul>
                    <h4>Info acquisto</h4>
                    <ul>
                        <li><a href="item.jsp?itemid=<%=purchase.getItemId()%>" target="_blank"><b>ID Prodotto</b>: <%= purchase.getItemId() %></a></li>
                        <li><b>Quantità</b>: <%= purchase.getQuantity() %></li>
                        <li><b>Data</b>: <%= purDate %></li>
                    </ul>
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
              </div>
            </div>
            </div>
            <% } %>
            <!--Modal segnalazione-->
            <div class="modal fade" id="anomalia" tabindex="-1" role="dialog" aria-labelledby="anomaliaLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                  <div class="modal-content">
                    <div class="modal-header">
                      <h5 class="modal-title" id="anomaliaLabel">Segnala anomalia</h5>
                      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                      </button>
                    </div>
                    <div class="modal-body">
                        <form action="InsertComplaint" method="POST">
                            <div class="form-group">
                            <label for="selectPurchase">Seleziona acquisto</label>
                            <select class="form-control" id="selectPurchase" name="purchaseid">
                              <% for(Purchase p : purchases) { 
                                Item item = itemDAO.getByPrimaryKey(p.getItemId());
                              %>
                              <option value="<%= p.getPurchaseId() %>"><b><%= item.getName() %></b> acquistato il <%= StringUtils.printDate(new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S").parse(p.getPurchaseTime())) %> <% if(p.getQuantity()>1) { %>, X<%=p.getQuantity()%> <%}%></option>
                              <% } %>
                            </select>
                            </div>
                            <div class="form-group">
                                <label for="testoComplaint">Messaggio</label>
                                <textarea class="form-control" id="testoComplaint" rows="3" max="1000" name="testo" required></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary">Segnala</button>
                        </form>
                    </div>
                  </div>
                </div>
              </div>
            <% } %>
            <jsp:include page="Footer.jsp"/>
        </div>
    </body>
</html>
