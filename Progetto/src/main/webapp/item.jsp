<%-- 
    Document   : item
    Created on : Jul 7, 2017, 9:24:30 PM
    Author     : pomo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%
String itemname = "Item", shopname= "Shop";
int shop = 1, itemid = 1;
double price = 2.34, lat = 41.8849605, lng = 12.5107732;
String[] negozi = {"via del corso, 282, 00187 Roma","via nazionale, 195, 00184 Roma"};
double[] nearby = {41.8972018,12.4820151,41.8996288,12.4912549};
boolean logged = true, cancomment = true;
String message = request.getParameter("message");
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
                  <li><a href="cart.jsp">Carrello</a></li>
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
            <% if(message != null && message.equals("ok")) { %>
            <div class="alert alert-info alert-dismissable fade in" role="alert">
                <button type="button" class="close" data-dismiss="alert" aria-label="close">
                    <span aria-hidden="true">x</span>
                </button>
                <%=itemname%> aggiunto al carrello
            </div>
            <% } %>
            <div class="row">
                <div class="col-md-8">
                    <center>
                        <h1><%= itemname %></h1>
                    </center>
                    <p>Prezzo: <fmt:formatNumber value="<%= price %>" type="currency"/></p>
                    <form action="AddToCart" method="POST" class="form-inline">
                        <input type="hidden" name="itemid" value="<%=itemid%>">
                        <input class="btn btn-default" type="submit" value="Aggiungi al carrello">
                    </form>
                    <p>Venduto da <a href="shop.jsp?shopid=<%= shop %>" target="_blank"><%= shopname %></a>: <a href="#map">Indirizzo</a></p>
                    <center>
                        <div id="itemimages" >
                        <img src="img/big.jpg" class="img-responsive" alt="Responsive image">
                        <img src="img/1.JPG" class="img-responsive" alt="Responsive image">
                        <img src="img/small.jpg" class="img-responsive" alt="Responsive image">
                        </div>
                        <br/>
                        <div>
                            <h3>Dove puoi trovare il prodotto</h3>
                            <div><select class="form-control" id="locationSelect" visibility: hidden"></select></div>
                            <div id="map" class="embed-responsive embed-responsive-16by9"></div>
                            <div id="venditori"></div>
                        </div>
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
            <!--Footer-->
            <footer class="footer">
                <center>
                  <p class="text-muted">Footer content</p>
                </center>
            </footer>
        </div>
        <!--Script mappa-->
        <script type="text/javascript">
            var map;
            var markers = [];
            var infoWindow;
            var locationSelect;

              function initMap() {
                map = new google.maps.Map(document.getElementById('map'), {
                  center: new google.maps.LatLng(<%= lat %>,<%= lng %>),
                  zoom: 15,
                  mapTypeId: 'roadmap',
                  mapTypeControlOptions: {style: google.maps.MapTypeControlStyle.DROPDOWN_MENU}
                });
                infoWindow = new google.maps.InfoWindow();
                locationSelect = document.getElementById("locationSelect");
                //da riempire
                var locations = [
                    ["Negozio0","Questo negozio",41.8849605,12.5107732],
                    ["Negozio1","via del corso, 282, 00187 Roma",41.8972018,12.4820151],
                    ["Negozio2","via nazionale, 195, 00184 Roma",41.8996288,12.4912549]
                ];
                var bounds = new google.maps.LatLngBounds();
                for(var i = 0; i < locations.length; i++) {
                    var name = locations[i][0];
                    var address = locations[i][1];
                    var latlng = new google.maps.LatLng(
                        parseFloat(locations[i][2]),
                        parseFloat(locations[i][3]));
                    createOption(name,i);
                    createMarker(latlng, name, address);
                    bounds.extend(latlng);
                } 
                map.fitBounds(bounds);
                locationSelect.style.visibility = "visible";
                locationSelect.onchange = function() {
                   var markerNum = locationSelect.options[locationSelect.selectedIndex].value;
                   google.maps.event.trigger(markers[markerNum], 'click');
                };
                google.maps.event.trigger(markers[0], 'click');
              }

             function createMarker(latlng, name, address) {
                var html = "<b>" + name + "</b> <br/>" + address;
                var marker = new google.maps.Marker({
                  map: map,
                  position: latlng
                });
                google.maps.event.addListener(marker, 'click', function() {
                  infoWindow.setContent(html);
                  infoWindow.open(map, marker);
                });
                markers.push(marker);
              }

             function createOption(name, num) {
                var option = document.createElement("option");
                option.value = num;
                option.innerHTML = name;
                locationSelect.appendChild(option);
             }
        </script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAYq_8A3Y0roix5fablhZIDZZ5GemSSUxo&callback=initMap"></script>
    </body>
</html>
