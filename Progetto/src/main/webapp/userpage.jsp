<%-- 
    Document   : UserPage
    Created on : 25-Aug-2017, 10:22:31
    Author     : Dva
--%>

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
    ArrayList<Shop> shops = new ArrayList<>();
    ArrayList<Complaint> complaints = new ArrayList<>();
    if(logged) {
        complaints = complaintDAO.getComplaintByAuthor(sessionUser.getUserId());
        if(venditore) 
            shops = shopDAO.getShopsByOwner(sessionUser.getUserId());
    }
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
        <link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
        <link href="css/bootstrap-theme.min.css" type="text/css" rel="stylesheet">
        <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
    </head>
    <body>
        <div class="container">
            <jsp:include page="Header.jsp"/>
            <% if(sessionUser == null) { %>
            <h1 style="text-align: center">Accesso negato</h1>
            <p class="text-center">Per visualizzare il tuo profilo <a href="login.jsp">accedi</a>.</p>
            <% }else { %>
            <div class="container-fluid">
                <div class="row">
                  <div class="col-sm-3 col-md-2 sidebar">
                    <ul class="nav nav-sidebar">
                      <li class="active"><a href="#profilo">Profilo <span class="sr-only">(current)</span></a></li>
                      <li><a href="#anomalie">Segnalazione anomalie</a></li>
                      <% if(venditore) { %>
                      <li><a href="#shops">I miei negozi</a></li>
                      <% } %>
                    </ul>
                  </div>
                <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
                    <div id="profilo">
                        <h2><%= sessionUser.getName() + " " + sessionUser.getSurname() %></h2>
                        <form method="post" action="">
                            <div class="form-group">
                                <label for="inidirizzo">Modifica indirizzo</label>
                                <input type="text" class="form-control" id="indirizzo" placeholder="<%= sessionUser.getAddress() %>" name="indirizzo">
                            </div>
                            <div class="form-group">
                                <label for="email">Modifica email</label>
                                <input type="email" class="form-control" id="email" placeholder="<%= sessionUser.getEmail() %>" name="email">
                            </div>
                            <p>Modifica password:</p><br/>
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
                            </div>
                            <button type="submit" class="btn btn-default">Modifica</button>
                        </form>
                    </div>
                    <div id="anomalie">
                        <h2>Segnalazione anomalie</h2>
                        <button type="button" class="btn btn-primary btn-lg" data-toggle="modal" data-target="#anomalia">
                            Segnala anomalia
                        </button>
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
                </div>
            </div>
          </div>
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
            <% } %>
            <jsp:include page="Footer.jsp"/>
        </div>
    </body>
</html>
