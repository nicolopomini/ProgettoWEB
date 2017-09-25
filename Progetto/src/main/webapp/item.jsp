<%-- 
    Document   : item
    Created on : Jul 7, 2017, 9:24:30 PM
    Author     : pomo
--%>

<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="dao.entities.User"%>
<%@page import="dao.entities.ItemReview"%>
<%@page import="dao.entities.Picture"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dao.ItemReviewDAO"%>
<%@page import="dao.PictureDAO"%>
<%@page import="dao.ShopDAO"%>
<%@page import="persistence.utils.dao.DAO"%>
<%@page import="persistence.utils.dao.exceptions.DAOFactoryException"%>
<%@page import="dao.ItemDAO"%>
<%@page import="persistence.utils.dao.factories.DAOFactory"%>
<%@page import="dao.entities.Shop"%>
<%@page import="dao.entities.Item"%>
<%@ page errorPage="/errorpage.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%
    if(request.getParameter("itemid") == null)
        throw new NullPointerException("No item specified");
    int itemid = Integer.parseInt(request.getParameter("itemid"));
    Item item;
    Shop shop;
    ArrayList<Picture> immagini;
    ArrayList<ItemReview> commenti;
    ArrayList<Shop> nearby;
    boolean venditore, logged, cancomment;
    User user;
    double media;
    ItemDAO itemDAO;
    ShopDAO shopDAO;
    PictureDAO pictureDAO;
    ItemReviewDAO itemReviewDAO;
    DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
    if (daoFactory == null) {
        throw new ServletException("Impossible to get dao factory for storage system");
    }
    try {
        itemDAO = daoFactory.getDAO(ItemDAO.class);
    } catch (DAOFactoryException ex) {
        throw new ServletException("Impossible to get dao factory for shop storage system", ex);
    }
    try {
            shopDAO = daoFactory.getDAO(ShopDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shop storage system", ex);
        }
    try {
            pictureDAO = daoFactory.getDAO(PictureDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shop storage system", ex);
        }
    try {
            itemReviewDAO = daoFactory.getDAO(ItemReviewDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shop storage system", ex);
        }
    item = itemDAO.getByPrimaryKey(itemid);
    shop = shopDAO.getByPrimaryKey(item.getShopId());
    immagini = pictureDAO.getByItemId(itemid);
    nearby = itemDAO.getItemNearby(item);
    commenti = itemReviewDAO.getByItemId(itemid);
    media = itemReviewDAO.getAverageScoreByItemId(itemid);
    int progress = (int)(media * 10);
    user = (User)session.getAttribute("user");
    if(user == null) {
        logged = false;
        cancomment = false;
        venditore = false;
    } else {
        logged = true;
        cancomment = itemDAO.canComment(itemid, user.getUserId());
        venditore = user.getUserId() == shop.getUserId();
    }
    session.setAttribute("item", item);
    String message = request.getParameter("message");
    Cookie[] cookies = request.getCookies();
    Cookie c = null;
    for(Cookie cookie : cookies) 
        if(cookie.getName().equals("item_message"))
            c = cookie;
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title><%= item.getName() %></title>
        <link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
        <link href="css/bootstrap-theme.min.css" type="text/css" rel="stylesheet">
        <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
    </head>
    <body>
        <div class="container">
            <!-- Menu -->
            <jsp:include page="Header.jsp"/>
            <!-- Fine menu -->
            <% if(c != null) { %>
            <div class="alert alert-info alert-dismissable fade in" role="alert">
                <button type="button" class="close" data-dismiss="alert" aria-label="close">
                    <span aria-hidden="true">x</span>
                </button>
                <%if(c.getValue().equals("ok")) {%>
                <%=item.getName()%> aggiunto al carrello
                <%}else if(c.getValue().equals("insered")) {%>
                Commento inserito.
                <%} else if(c.getValue().equals("replied")) {%>
                Risposto al commento.
                <%}%>
            </div>
            <% } %>
            <div class="row">
                <% if(!commenti.isEmpty()){ %>
                <div class="col-md-8">
                <%}%>
                    <center>
                        <h1><%= item.getName() %></h1>
                    </center>
                    <p>Prezzo: <fmt:formatNumber value="<%= item.getPrice() %>" type="currency"/></p>
                    <form action="AddToCart" method="POST" class="form-inline">
                        <input type="hidden" name="itemid" value="<%=itemid%>">
                        <input class="btn btn-default" type="submit" value="Aggiungi al carrello">
                    </form>
                    <p>Venduto da <a href="shop.jsp?shopid=<%= shop.getShopId() %>" target="_blank"><%= shop.getName() %></a>: <a href="#map">Vedi sulla mappa</a></p>
                    <center>
                        <div id="itemimages" >
                         <% for(Picture p : immagini) {%>
                        <img src="${pageContext.request.contextPath}/<%=p.getPath()%>" class="img-responsive" alt="Responsive image">
                        <br/>
                        <%}%>
                        </div>
                        <br/>
                        <% if(commenti.isEmpty()) { %>
                        <h5 style="text-align: center">Nessuna recensione</h5>
                        <%}%>
                        <br/>
                        <div>
                            <h3>Dove puoi trovare il prodotto</h3>
                            <div><select class="form-control" id="locationSelect" visibility: hidden"></select></div>
                            <div id="map" class="embed-responsive embed-responsive-16by9"></div>
                            <div id="venditori"></div>
                        </div>
                    </center>
                </div>
                <% if(!commenti.isEmpty()) { %>
                <div class="col-md-4" id="comments">
                    <h5>Valutazione media degli utenti: <%=media%>/5</h5>
                    <div class="progress">
                        <div class="progress-bar progress-bar-warning" role="progressbar" aria-valuenow="<%=progress%>" aria-valuemin="0" aria-valuemax="100" style="width: 60%;">
                          <span class="sr-only"><%=progress%></span>
                        </div>
                      </div>
                    <div class="commenti">
                        <!--Per ogni commento:-->
                        <% for(ItemReview r : commenti) {
                            SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S"); 
                            Date date = dt.parse(r.getReviewTime());                         
                        %>
                        <fmt:formatDate value = "<%=date%>" /> : <%for(int i = 0; i < r.getScore(); i++) {%><span class="glyphicon glyphicon-star" aria-hidden="true"></span> <%}%>
                        <ul class="list-group">
                            <li class="list-group-item"><b><%= r.getAuthorName() + " " + r.getAuthorSurname() %></b>: <%=r.getReviewText()%></li>
                            <%if(r.getReply() != null) {%>
                            <li class="list-group-item"><b>Venditore</b>: <%=r.getReply()%></li>
                            <%} else if(venditore) {%>
                            <form class="form-inline" method="POST" action="ItemCommentReply">
                                <input type="hidden" name="reviewid" value="<%=r.getItemReviewId()%>">
                                <div class="form-group">
                                  <input type="text" class="form-control" placeholder="Rispondi al commento" name="replycomment" required>
                                </div>
                                <button type="submit" class="btn btn-default">Invia</button>
                              </form>
                            <%}%>
                        </ul>
                        <%}%>
                    </div>
                    <% if(cancomment) { %>
                    <form class="form-inline" method="POST" action="ItemComment">
                        <div class="form-group">
                            <input type="text" class="form-control" placeholder="Inserisci un commento" name="newcomment" required>
                          Voto:
                            <select class="form-control" name="score">
                              <% for(int i = 1; i <= 5; i++) { %>
                              <option value="<%=i%>"><%=i%></option>
                              <%}%>
                          </select>
                        </div>
                        <button type="submit" class="btn btn-default">Invia</button>
                      </form>
                    <% } else { %>
                    <p>Per lasciare un commento devi aver aquistato in questo negozio.</p>
                    <% } %>
                </div>
            </div>
                <%}else if(cancomment) {%>
                <h4>Inserisci un commento</h4>
                <form method="POST" action="ItemComment">
                        <div class="form-group">
                            <input type="text" class="form-control" placeholder="Inserisci un commento" name="newcomment" required>
                          Voto:
                            <select class="form-control" name="score">
                              <% for(int i = 1; i <= 5; i++) { %>
                              <option value="<%=i%>"><%=i%></option>
                              <%}%>
                          </select>
                        </div>
                        <button type="submit" class="btn btn-default">Invia</button>
                      </form>
                <%}%>
            <!--Footer-->
            <jsp:include page="Footer.jsp"/>
        </div>
        <!--Script mappa-->
        <script type="text/javascript">
            var map;
            var markers = [];
            var infoWindow;
            var locationSelect;

              function initMap() {
                map = new google.maps.Map(document.getElementById('map'), {
                  center: new google.maps.LatLng(<%= shop.getLat() %>,<%= shop.getLon() %>),
                  zoom: 15,
                  mapTypeId: 'roadmap',
                  mapTypeControlOptions: {style: google.maps.MapTypeControlStyle.DROPDOWN_MENU}
                });
                infoWindow = new google.maps.InfoWindow();
                locationSelect = document.getElementById("locationSelect");

                var locations = [
                    ["<%= shop.getName() %>","<%= shop.getAddress() %>",<%= shop.getLat() %>,<%= shop.getLon() %>, <%=shop.getShopId()%>]
                ];
                <% for(Shop s : nearby) { %>
                    locations.push(["<%=s.getName()%>","<%= s.getAddress() %>",<%= s.getLat() %>,<%= s.getLon() %>, <%= s.getShopId() %>]);
                <%}%>
                var bounds = new google.maps.LatLngBounds();
                for(var i = 0; i < locations.length; i++) {
                    var name = locations[i][0];
                    var address = locations[i][1];
                    var latlng = new google.maps.LatLng(
                        parseFloat(locations[i][2]),
                        parseFloat(locations[i][3]));
                    var id = locations[i][4];
                    createOption(name,i);
                    createMarker(latlng, name, address, id);
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

             function createMarker(latlng, name, address, id) {
                var html = "<a href=\"shop.jsp?shopid=" + id + "\" target=\"_blank\"><b>" + name + "</b> <br/>" + address + "</a>";
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
        <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAYq_8A3Y0roix5fablhZIDZZ5GemSSUxo&callback=initMap"></script>
    </body>
</html>
