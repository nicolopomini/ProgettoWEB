<%-- 
    Document   : notifications
    Created on : Sep 12, 2017, 10:02:22 AM
    Author     : pomo
--%>

<%@page import="utils.StringUtils"%>
<%@page import="dao.entities.Purchase"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="dao.entities.Complaint"%>
<%@page import="dao.entities.Notification"%>
<%@page import="java.util.ArrayList"%>
<%@page import="persistence.utils.dao.exceptions.DAOFactoryException"%>
<%@page import="dao.PurchaseDAO"%>
<%@page import="dao.ComplaintDAO"%>
<%@page import="dao.NotificationDAO"%>
<%@page import="persistence.utils.dao.factories.DAOFactory"%>
<%@page import="dao.entities.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% 
    User user;
    user = (User)session.getAttribute("user");
    DAOFactory daoFactory;
    NotificationDAO notificationDAO;
    ComplaintDAO complaintDAO;
    PurchaseDAO purchaseDAO;
    daoFactory = (DAOFactory) application.getAttribute("daoFactory");
    if (daoFactory == null) {
        throw new ServletException("Impossible to get dao factory for storage system");
    }
    try {
        notificationDAO = daoFactory.getDAO(NotificationDAO.class);
    } catch (DAOFactoryException ex) {
        throw new ServletException("Impossible to get dao factory for shop storage system", ex);
    }
    try {
        complaintDAO = daoFactory.getDAO(ComplaintDAO.class);
    } catch (DAOFactoryException ex) {
        throw new ServletException("Impossible to get dao factory for shop storage system", ex);
    }
    try {
        purchaseDAO = daoFactory.getDAO(PurchaseDAO.class);
    } catch (DAOFactoryException ex) {
        throw new ServletException("Impossible to get dao factory for shop storage system", ex);
    }
    ArrayList<Notification> notifiche = new ArrayList<>();
    ArrayList<Complaint> complaints = new ArrayList<>();
    //notifiche = notificationDAO.getByRecipient(0);
    //complaints = (ArrayList)complaintDAO.getAll();
    if(user != null) {
        notifiche = notificationDAO.getByRecipient(user.getUserId());
        if(user.getType().equals(User.ADMIN))
            complaints = (ArrayList)complaintDAO.getAll();
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Notifiche</title>
        <link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
        <link href="css/bootstrap-theme.min.css" type="text/css" rel="stylesheet">
        <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
        <script>
            function readNotifications(userId) {
                var xhttp = new XMLHttpRequest();
                xhttp.open("POST", "ReadNotifications", true);
                xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                xhttp.send("userid="+userId);
            }
            function readComplaint(complaintId) {
                var xhttp = new XMLHttpRequest();
                xhttp.open("POST", "ReadComplaint", true);
                xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                xhttp.send("complaintid="+complaintId);
            }
        </script>
        <style>
            .daleggere {
                background-color: #f5f5f5;
            }
        </style>
    </head>
    <body>
        <jsp:include page="Header.jsp"/>
        <% if(user == null) {  %>
            <h1 style="text-align: center">Accesso negato</h1>
            <p class="text-center">Per visualizzare le notifiche <a href="login.jsp">accedi</a>.</p>
        <% }else { %>
        <% if(user.getType().equals(User.ADMIN)) {  %>
                <!--Complaint-->
                <h1 style="text-align: center">Anomalie</h1>
                <% if(complaints.isEmpty()) { %>
                    <p class="text-center">Nessuna anomalia.</p>
                <% } else { %>
                <ul>
                        <%
                            for(Complaint c : complaints) {
                                SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S"); 
                                String date = StringUtils.printDate(dt.parse(c.getComplaintTime()));
                        %>
                        <li class="list-group-item" style="text-align: center">
                            <a role="button" data-toggle="modal" data-target="#<%= c.getComplaintId() %>">
                            <ul class="list-inline">
                                <li><%=date%></li>
                                <li><%= c.getPurchaseId() %></li>
                                <li><%= c.getStatus() %></li>
                            </ul>
                            </a>
                        </li>
                        <% } %>
                </ul>
                <% } %>
                <!--End complaint-->
            <% } %>
            <!--Notifiche-->
            <h1 style="text-align: center">Notifiche</h1>
            <% if(notifiche.isEmpty()) { %>
                <p class="text-center">Nessuna notifica.</p>
            <% } else { %>
            <ul>
                <%
               for(Notification n : notifiche) {
                   SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S"); 
                   String date = StringUtils.printDate(dt.parse(n.getNotificationTime()));
                   String textType = "";
                   if(n.getType().equals(Notification.NEWCOMMENTITEM))
                      textType = "Nuovo commento su un item da ";
                   else if(n.getType().equals(Notification.REPLYCOMMENTITEM) || n.getType().equals(Notification.REPLYCOMMENTSHOP))
                      textType = "Il tuo commento è stato risposto da ";
                   else if(n.getType().equals(Notification.NEWCOMMENTSHOP))
                      textType = "Nuovo commento su un negozio da ";
                   else if(n.getType().equals(Notification.REPLYCOMPLAINT))
                      textType = "Risposta alla segnalazione di anomalia.";
            %>
            <li class="list-group-item <%if(!n.getSeen()){%> daleggere <%}%>" style="text-align: center">
                <a href="<%= n.getLink() %>" target="_blank">
                    <ul class="list-inline">
                        <li><%=date%></li>
                        <li><%= textType %>
                        <% if(!n.getType().equals(Notification.REPLYCOMPLAINT)) { %>
                        <%= n.getAuthorName() + " " + n.getAuthorSurname() %>
                        </li>
                        <% } %>
                    </ul>
                </a>
            </li>
            <%}%>
            </ul>
            <script>readNotifications(<%= user.getUserId() %>);</script>
            <% } %>

            <% if(user.getType().equals(User.ADMIN)) { 
                for(Complaint c : complaints) {  
                    SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S"); 
                    String date = StringUtils.printDate(dt.parse(c.getComplaintTime()));
                    Purchase purchase = purchaseDAO.getByPrimaryKey(c.getPurchaseId());
                    String purDate = StringUtils.printDate(dt.parse(purchase.getPurchaseTime()));
            %>
            <div class="modal fade" id="<%= c.getComplaintId() %>" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog" role="document">
              <div class="modal-content">
                  <form action="UpdateComplaint" method="POST">
                      <input type="hidden" name="complaintid" value="<%= c.getComplaintId() %>">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="readComplaint(<%=c.getComplaintId()%>)"><span aria-hidden="true">&times;</span></button>
                  <h4 class="modal-title" id="myModalLabel">Gestione anomalia <%= c.getComplaintId() %></h4>
                </div>
                <div class="modal-body">
                    <ul>
                        <li><b>Data</b>: <%=date%></li>
                        <li><b>Stato</b>: <%= c.getStatus() %></li>
                        <li><b>Messaggio</b>: <%= c.getComplaintText() %></li>
                    </ul>
                    <h4>Info acquisto</h4>
                    <ul>
                        <li><b>Utente</b>: <%= purchase.getUserId() %></li>
                        <li><a href="item.jsp?itemid=<%=purchase.getItemId()%>" target="_blank"><b>ID Prodotto</b>: <%= purchase.getItemId() %></a></li>
                        <li><b>Quantità</b>: <%= purchase.getQuantity() %></li>
                        <li><b>Data</b>: <%= purDate %></li>
                    </ul>
                    <h4>Gestisci anomalia</h4>
                    <div class="form-group">
                        <label for="Risposta">Risposta</label>
                        <textarea class="form-control" rows="3" name="risposta" id="risposta" <% if(c.getReply() != null && !c.getReply().equals("")) { %> placeholder="<%= c.getReply() %>" <%} else {%> placeholder="Risposta" <% } %> maxlength="1000"></textarea>
                    </div>
                    <div class="checkbox">
                        <label>
                            <input type="checkbox" name="reject" <% if(c.getStatus().equals(Complaint.STATUS_REJECTED)) { %> checked <% } %> > Rigetta
                        </label>
                    </div>
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-default" data-dismiss="modal" onclick="readComplaint(<%=c.getComplaintId()%>)">Close</button>
                  <button type="submit" class="btn btn-primary">Salva</button>
                </div>
                  </form>
              </div>
            </div>
            </div>
            <% }
            } %>
            <!--End notifiche-->
        <% } %>
        <jsp:include page="Footer.jsp"/>
    </body>
</html>
