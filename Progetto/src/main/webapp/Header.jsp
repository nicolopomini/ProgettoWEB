<%-- 
    Document   : Header
    Created on : 25-Aug-2017, 10:59:02
    Author     : Dva
--%>

<%@page import="dao.ComplaintDAO"%>
<%@page import="persistence.utils.dao.exceptions.DAOFactoryException"%>
<%@page import="dao.NotificationDAO"%>
<%@page import="persistence.utils.dao.factories.DAOFactory"%>
<%@page import="dao.entities.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    DAOFactory daoFactory;
    NotificationDAO notificationDAO;
    ComplaintDAO complaintDAO;
    daoFactory = (DAOFactory) application.getAttribute("daoFactory");
    if (daoFactory == null) {
        throw new ServletException("Impossible to get dao factory for storage system");
    }
    try {
            notificationDAO = daoFactory.getDAO(NotificationDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for notification storage system", ex);
        }
    try {
            complaintDAO = daoFactory.getDAO(ComplaintDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for complaint storage system", ex);
        }
    boolean logged = false;
    String type = "";
    User sessionUser = (User)session.getAttribute("user");
    int unread = 0;
    int complaints = 0;
    if(sessionUser != null)
    {
        logged = true;
        type = sessionUser.getType();
        unread = notificationDAO.getUnreadCount(sessionUser.getUserId());
        complaints = complaintDAO.getUnread();
    }
%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <a class="navbar-brand" href="./">Home</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarText" aria-controls="navbarText" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="collapse navbar-collapse" id="navbarText">
    <ul class="navbar-nav ml-auto" id="voci_menu">
        <li class="nav-item">
            <a class="nav-link" href="cart.jsp">Carrello</a>
        </li>
        <% if(logged) { %>
            <% if(type.equals("admin")) { %>
            <li class="nav-item"><a class="nav-link" href="notifications.jsp">Notifiche<% if(unread > 0 || complaints > 0) { %> <span class="badge"><%=unread + complaints%></span> <% } %></a></li>
            <% } else { %>
            <li class="nav-item"><a class="nav-link" href="notifications.jsp">Notifiche<% if(unread > 0) { %> <span class="badge"><%=unread%></span> <% } %></a></li>
            <% } %>
            <li class="nav-item"><a class="nav-link" href="userpage.jsp"><%=sessionUser.getName() + " " + sessionUser.getSurname()%></a></li>
            <li class="nav-item"><a class="nav-link" href="Logout">Esci</a></li>
        <% }else {%>
            <li class="nav-item"><a class="nav-link" href="login.jsp">Login</a></li>
            <li class="nav-item"><a class="nav-link" href="Registration.jsp">Registrati</a></li>
        <% } %>
    </ul>
  </div>
</nav>