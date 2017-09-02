<%-- 
    Document   : notification
    Created on : Sep 2, 2017, 10:37:59 AM
    Author     : pomo
--%>

<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="dao.entities.Notification"%>
<%@page import="java.util.ArrayList"%>
<%@page import="persistence.utils.dao.exceptions.DAOFactoryException"%>
<%@page import="dao.NotificationDAO"%>
<%@page import="persistence.utils.dao.factories.DAOFactory"%>
<%@page import="dao.entities.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% 
    User user;
    user = (User)session.getAttribute("user");
    DAOFactory daoFactory;
    NotificationDAO notificationDAO;
    daoFactory = (DAOFactory) application.getAttribute("daoFactory");
    if (daoFactory == null) {
        throw new ServletException("Impossible to get dao factory for storage system");
    }
    try {
        notificationDAO = daoFactory.getDAO(NotificationDAO.class);
    } catch (DAOFactoryException ex) {
        throw new ServletException("Impossible to get dao factory for shop storage system", ex);
    }
    ArrayList<Notification> notifiche = new ArrayList<>();
    if(user != null)
        notifiche = notificationDAO.getByRecipient(user.getUserId());
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
    </head>
    <body>
        <div class="container">
            <jsp:include page="Header.jsp"/>
            <% if(user == null) { %>
            <p class="text-center">Per visualizzare le notifiche <a href="login.jsp">accedi</a>.</p>
            <% } else { %>
            <h1>Notifiche</h1>
            <% if(notifiche.isEmpty()) { %>
            <p class="text-center">Nessuna notifica.</p>
            <% } else { %>
            <ul class="list-group">
            <%
               for(Notification n : notifiche) {
                   SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S"); 
                   Date date = dt.parse(n.getNotificationTime());
            %>
            <li class="list-group-item">
                <a href="<%= n.getLink() %>" target="_blank">
                <fmt:formatDate value = "<%=date%>" /> : <%= n.getNotificationText() %>
                </a>
            </li>
            <%}%>
            </ul>
            <% } %>
            <% } %>
            <jsp:include page="Footer.jsp"/>
        </div>
    </body>
</html>
