<%-- 
    Document   : shop
    Created on : Jun 28, 2017, 11:10:22 AM
    Author     : pomo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    boolean venditore = false, logged = false, cancomment = true;
    String name = "Prova";
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title><%= name %></title>
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
            <!-- Fine menu -->
            
            
            <!-- Contenuto pagina -->
            <div class="row">
                <div class="col-md-8">
                    <center>
                    <h1><%= name %></h1>
                    <img src="img/big.jpg" class="img-responsive" alt="Responsive image">
                    </center>
                    <br/>
                    <div id="info">
                        <p>Website: <a href="www.google.com">sito</a></p>
                    </div>
                    <div id="map">
                        <center>
                            <h3>Dove trovarci</h3>
                            <div class="embed-responsive embed-responsive-16by9">
                              <iframe class="embed-responsive-item" src="//www.google.com/maps/embed/v1/place?q=Piazza+Venezia+38122+Trento&key=AIzaSyAOzJPvYZ2Mq5oCbxK5v1R1HBRy5KyfRUM"></iframe>
                            </div>
                        </center>
                    </div>
                    <br/>
                    <br/>
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
                    <form class="form-inline" method="POST" action="">
                        <div class="form-group">
                          <input type="text" class="form-control" id="exampleInputName2" placeholder="Inserisci un commento" name="newcomment">
                        </div>
                        <button type="submit" class="btn btn-default">Invia</button>
                      </form>
                    <% } %>
                </div>
            </div>
            <!--Fine contenuto-->
            <!--Footer-->
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
