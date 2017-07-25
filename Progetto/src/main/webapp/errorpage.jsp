<%-- 
    Document   : errorpage
    Created on : Jul 25, 2017, 1:41:49 PM
    Author     : pomo
--%>

<%@page import="dao.entities.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8" isErrorPage="true"%>
<%
    boolean logged;
    User user = null;
    if(session.getAttribute("user") == null) 
        logged = false;
    else {
        logged = true;
        user = (User)session.getAttribute("user");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Errore</title>
        <link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
        <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
    </head>
    <body>
        <div class="container">
            <!-- Menu -->
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
                <a class="navbar-brand" href="#">Home</a>
              </div>

              <!-- Collect the nav links, forms, and other content for toggling -->
              <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav navbar-right">
                    <li><a href="cart.jsp">Carrello</a></li>
                  <% if(logged) { %>
                  <li><a href="#"><%= user.getName() + " " + user.getSurname() %></a></li>
                  <li><a href="#">Esci</a></li>
                  <% }else {%>
                  <li><a href="#">Login</a></li>
                  <li><a href="#">Registrati</a></li>
                  <% } %>
                </ul>
              </div><!-- /.navbar-collapse -->
            </div><!-- /.container-fluid -->
          </nav>
            <!-- Fine menu -->
            <div class="starter-template">
                <h1>Errore</h1>
                <p class="lead">L'elemento richiesto non esiste o non è disponibile. Assicurati di aver cercato quello che effettivamente desideravi cercare.</p>
              </div>
            <footer class="footer">
                  <p class="text-muted">Footer content</p>
            </footer>
            <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
            <script src="js/bootstrap.min.js"></script>
        </div>
    </body>
</html>
