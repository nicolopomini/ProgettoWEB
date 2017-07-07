<%-- 
    Document   : item
    Created on : Jul 7, 2017, 9:24:30 PM
    Author     : pomo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%! 
String itemname = "Item", shopname= "Shop";
int shop = 1;
double price = 2.34;
boolean logged = true, cancomment = true;
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title><%= itemname %></title>
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
                  <% if(logged) { %>
                  <li><a href="#">Nome e Cognome</a></li>
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
            <div class="row">
                <div class="col-md-8">
                    <center>
                        <h1><%= itemname %></h1>
                    </center>
                    <p>Prezzo: <fmt:formatNumber value="<%= price %>" type="currency"/></p>
                    <h4>Aggiungi al carrello</h4>
                    <p>Venduto da <a href="shop.jsp?shopid=<%= shop %>"><%= shopname %></a></p>
                    <center>
                        <img src="img/big.jpg" class="img-responsive" alt="Responsive image">
                        <img src="img/1.JPG" alt="..." class="img-rounded">
                        <img src="img/4.jpg" alt="..." class="img-rounded">
                    </center>
                </div>
                <div class="col-md-4" id="comments">
                    <h5>Valutazione media degli utenti: 3.0/5</h5>
                    <div class="progress">
                        <div class="progress-bar progress-bar-warning" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 60%;">
                          <span class="sr-only">60</span>
                        </div>
                      </div>
                    <div class="commenti">
                        <!--Per ogni commento:-->
                        <ul class="list-group">
                            <li class="list-group-item"><b>Nome Utente</b>: commento</li>
                            <li class="list-group-item"><b>Venditore</b>: risposta commento</li>
                        </ul>
                        <ul class="list-group">
                            <li class="list-group-item"><b>Nome Utente</b>: commento 2 senza rispodta feobe vdovmelbprv!</li>
                        </ul>
                    </div>
                    <% if(cancomment) { %>
                    <form class="form-inline" method="POST" action="ItemComment">
                        <div class="form-group">
                          <input type="text" class="form-control" id="exampleInputName2" placeholder="Inserisci un commento" name="newcomment">
                        </div>
                        <button type="submit" class="btn btn-default">Invia</button>
                      </form>
                    <% } else { %>
                    <p>Per lasciare un commento devi aver aquistato questo oggetto.</p>
                    <% } %>
                </div>
            </div>
        </div>
    </body>
</html>
