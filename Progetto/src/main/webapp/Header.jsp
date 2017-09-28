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
<div class="container">
<nav class="navbar navbar-default">
        <div class="container-fluid">
          <!-- Brand and toggle get grouped for better mobile display -->
          <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
              <span class="sr-only">Toggle navigation</span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="./">Home</a>
          </div>

          <!-- Collect the nav links, forms, and other content for toggling -->
          <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav navbar-right" id="voci_menu">
                <% if(logged) { %>
                    <% if(type.equals("admin")) { %>
                    <li><a href="notifications.jsp">Notifiche<% if(unread > 0 || complaints > 0) { %> <span class="badge"><%=unread + complaints%></span> <% } %></a></li>
                    <% } else { %>
                    <li><a href="notifications.jsp">Notifiche<% if(unread > 0) { %> <span class="badge"><%=unread%></span> <% } %></a></li>
                    <li><a href="cart.jsp">Carrello</a></li>
                    <% } %>
                    <li><a href="userpage.jsp"><%=sessionUser.getName() + " " + sessionUser.getSurname()%></a></li>
                <li><a href="Logout">Esci</a></li>
                <% }else {%>
                <li><a href="login.jsp">Login</a></li>
                <li><a href="Registration.jsp">Registrati</a></li>
                <% } %>
            </ul>
          </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>