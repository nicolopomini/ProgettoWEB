<%-- 
    Document   : Registration
    Created on : 5-lug-2017, 15.46.04
    Author     : Marco
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    boolean venditore, logged;
    String name = "Prova";
%>
<%
    if(session.getAttribute("logged") == null)
    {
        logged = false;
        session.setAttribute("logged", logged);
        venditore = false;
        session.setAttribute("venditore", venditore);
    }
    else
    {
        logged = (boolean)session.getAttribute("logged");
        venditore = (boolean)session.getAttribute("venditore");
    }
%>  
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Registration Page</title>
        <link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
        <link href="css/bootstrap-theme.min.css" type="text/css" rel="stylesheet">
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
                        <% if(venditore) { %>
                        <li><a href="#">Modifica negozio</a></li>
                        <% } %>
                        <% if(logged) { %>
                        <li><a href="#">Esci</a></li>
                        <% }else {%>
                        <li><a href="#">Login</a></li>
                        <li><a href="#">Registrati</a></li>
                        <% } %>
                    </ul>
                  </div><!-- /.navbar-collapse -->
                </div><!-- /.container-fluid -->
            </nav>
                    
            <div class="form-group row">
                <label for="example-text-input" class="col-2 col-form-label">Text</label>
                <div class="col-10">
                    <input class="form-control" type="text" value="Artisanal kale" id="example-text-input">
                </div>
            </div>
                    
            <footer class="footer">
                <center>
                    <p class="text-muted">Footer content</p>
                </center>
            </footer>
        </div>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </body>
</html>
