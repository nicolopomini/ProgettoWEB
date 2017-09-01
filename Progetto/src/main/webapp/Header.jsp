<%-- 
    Document   : Header
    Created on : 25-Aug-2017, 10:59:02
    Author     : Dva
--%>

<%@page import="dao.entities.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    boolean logged = false;
    String type = "";
    User sessionUser = (User)session.getAttribute("user");
    if(sessionUser != null)
    {
        logged = true;
        type = sessionUser.getType();
                
    }
%>
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
                    <% if(type.equals("seller")) { %>
                    <li><a href="#">Notifiche</a></li>
                    <% } %>
                    <% if(type.equals("admin")) { %>
                    <li><a href="#">Notifiche</a></li>
                    <% } %>
                    <%
                        if(type.equals("admin"))
                        {
                            %>
                            <li><a href="UserPage.jsp"><%=sessionUser.getName() + " " + sessionUser.getSurname()%></a></li>
                            <%
                        }
                        else
                        {
                            %>
                            <li><a href="cart.jsp">Cart</a></li>
                            <li class="dropdown">
                                <a class="dropdown-toggle" data-toggle="dropdown" href="#"><%=sessionUser.getName() + " " + sessionUser.getSurname()%>
                                    <span class="caret"></span>
                                </a>
                                <ul class="dropdown-menu">
                                    <li><a href="UserPage.jsp">Profile</a></li>
                                    <li><a href="#">Complaint</a></li>
                                    <%
                                        if(type.equals("seller"))
                                        {
                                    %>
                                        <li><a href="#">My shop</a></li>
                                    <%
                                        }
                                    %>
                                </ul>
                            </li>
                            <%
                        } 
                    %>

                <li><a href="Logout">Esci</a></li>
                <% }else {%>
                <li><a href="login.jsp">Login</a></li>
                <li><a href="Registration.jsp">Registrati</a></li>
                <% } %>
            </ul>
          </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>