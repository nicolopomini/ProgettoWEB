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
<%@page errorPage="/errorpage.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%
    if(request.getParameter("itemid") == null)
        throw new NullPointerException("No item specified");
    int itemid = Integer.parseInt(request.getParameter("itemid"));
    Item item;
    Shop shop;
    ArrayList<Picture> immagini;
    ArrayList<ItemReview> commenti;
    ArrayList<Shop> nearby;
    boolean venditore, logged, cancomment, owner;
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
        throw new ServletException("Impossible to get dao factory for item storage system", ex);
    }
    try {
            shopDAO = daoFactory.getDAO(ShopDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shop storage system", ex);
        }
    try {
            pictureDAO = daoFactory.getDAO(PictureDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for picture storage system", ex);
        }
    try {
            itemReviewDAO = daoFactory.getDAO(ItemReviewDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for review storage system", ex);
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
        owner = false;
    } else {
        logged = true;
        cancomment = itemDAO.canComment(itemid, user.getUserId());
        venditore = user.getUserId() == shop.getUserId();
        owner = itemDAO.isOwner(itemid, user.getUserId());
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title><%= item.getName() %></title>
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js" integrity="sha384-b/U6ypiBEHpOf/4+1nzFpr53nxSS+GLCkfwBdFNTxtclqqenISfwAzpKaMNFNmj4" crossorigin="anonymous"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="js/itemJS.js"></script>
        <link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
        <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="Header.jsp"/>
        <div class="container-fluid containerFix">
              <div class="modal show in" id="confirm-modal" tabindex="-1" role="dialog" aria-labelledby="modal-title" aria-hidden="true" style="">
                <div class="modal-dialog" role="document">
                  <div class="modal-content">
                    <div class="modal-header">
                      <h5 class="modal-title" id="modal-title"></h5>
                      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                      </button>
                    </div>
                    <div class="modal-body">
                        <p id="modal-text"></p>
                    </div>
                    <div class="modal-footer">
                      <a href="cart.jsp" id="modal-cart-btn" class="btn btn-warning">Go to cart</a>
                      <button type="button" style="cursor:pointer;" class="btn btn-success" data-dismiss="modal">Ok</button>
                    </div>
                  </div>
                </div>
              </div>
            <div class="row">
                <div class="col-12 col-xl-6">
                    <h1><%= item.getName() %></h1>
                    <ul class="list-group">
                        <li class="list-group-item">
                            Prezzo: <fmt:formatNumber value="<%= item.getPrice() %>" type="currency" currencySymbol="€"/>
                        </li>
                        <li class="list-group-item">
                            <%=item.getDescription()%>
                        </li>
                        <li class="list-group-item">
                            Venduto da <a href="shop.jsp?shopid=<%= shop.getShopId() %>" target="_blank"><%= shop.getName() %></a>: <a href="#map">Vedi sulla mappa</a>
                        </li>
                    </ul>
                    <div class="d-flex justify-content-center">
                        <span class="btn btn-success" style="cursor:pointer; margin: 20px;" onclick="addToCart('<%=item.getItemId()%>','<%=item.getName()%>')">Aggiungi al carrello</span>
                        <% if(owner) { %>
                        <span class="btn btn-success" style="cursor:pointer; margin: 20px;" data-toggle="modal" data-target="#modificaitem">Modifica Item</span>
                        <% } %>
                    </div>
                    <div id="itemimages" class="row justify-content-center">
                        <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
                        <ol class="carousel-indicators">
                        <%  int tmp = 0;
                            for(Picture p : immagini) {%>
                        <%--<img src="${pageContext.request.contextPath}/<%=p.getPath()%>" class="img-responsive" alt="Responsive image">--%>
                            <li data-target="#carouselExampleIndicators" data-slide-to="<%=tmp%>" class="active"></li>
                            <% tmp++; }%>
                            </ol>
                            <div class="carousel-inner">
                            <% for(int i = 0;i<immagini.size();i++) {%>
                              <div class="carousel-item <%if(i==0){%>active<%}%>">
                                <img class="d-block defaultImage w-100" src="<%=immagini.get(i).getPath()%>" alt="Beautiful image">
                              </div>
                            <%}%>
                            </div>
                            <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
                              <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                              <span class="sr-only">Previous</span>
                            </a>
                            <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
                              <span class="carousel-control-next-icon" aria-hidden="true"></span>
                              <span class="sr-only">Next</span>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-xl-6">
                    <div>
                        <h3>Dove puoi trovare il prodotto</h3>
                        <div><select class="form-control" id="locationSelect" visibility: hidden"></select></div>
                        <div id="map" class="embed-responsive embed-responsive-16by9"></div>
                        <div id="venditori"></div>
                    </div>
                    <div id="comments-wrapper">
                    <center>
                        <br/>
                        <% if(commenti.isEmpty()) { %>
                        <h5 style="text-align: center">Nessuna recensione</h5>
                        <%}%>
                    </center>
                    <% if(!commenti.isEmpty()) { %>
                        <div class=" col col-xs-12" >
                            <div id="comments">
                                <h5 id="avg-title">Valutazione media degli utenti: <%=media%>/5</h5>
                                <div class="progress">
                                    <div id="progress" class="progress-bar" role="progressbar" style="width: <%=progress%>%" aria-valuenow="<%=progress%>" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                                <div id="commenti">
                                    <!--Per ogni commento:-->
                                    <% for(ItemReview r : commenti) {
                                        SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S"); 
                                        Date date = dt.parse(r.getReviewTime());                         
                                    %>
                                    <fmt:formatDate value = "<%=date%>" /> : <%= r.getScore() + "/5" %>
                                    <ul class="list-group" id="<%= r.getItemReviewId() %>">
                                        <li class="list-group-item"><b><%= r.getAuthorName() + " " + r.getAuthorSurname() %></b>: <%=r.getReviewText()%></li>
                                        <%if(r.getReply() != null) {%>
                                        <li class="list-group-item"><b>Venditore</b>: <%=r.getReply()%></li>
                                        <%} else if(!venditore) {%>
                                        <form id="form-reply" class="form-inline" method="POST">
                                            <div class="form-group">
                                              <input type="text" class="form-control" placeholder="Rispondi al commento" name="replycomment" id="replycomment-<%=r.getItemReviewId()%>" required>
                                            </div>
                                            <span class="btn btn-sm btn-success" style="cursor:pointer;" onclick="addReply('<%=r.getItemReviewId()%>','<%=item.getItemId()%>')">Invia</span>
                                        </form>
                                        <%}%>
                                    </ul>
                                    <%}%>
                                </div>
                            </div>
                            <% if(cancomment) { %>
                            <form class="form-inline" method="POST" id="addcomment">
                                <div class="form-group">
                                    <input type="text" class="form-control" placeholder="Inserisci un commento" name="newcomment" id="comment-text" required>
                                  Voto:
                                    <select class="form-control" name="score" id="item-score">
                                      <% for(int i = 1; i <= 5; i++) { %>
                                      <option value="<%=i%>"><%=i%></option>
                                      <%}%>
                                  </select>
                                </div>
                                  <span class="btn btn-sm btn-success" style="cursor:pointer;" onclick="addComment('<%=item.getItemId()%>','<%=item.getName()%>', '<%= venditore %>')">Invia</span>
                              </form>
                            <% } else { %>
                            <p>Per lasciare un commento devi aver aquistato in questo negozio.</p>
                            <% } %>
                        </div>
                <%}else if(cancomment) {%>
                    <h4>Inserisci un commento</h4>
                    <form method="POST" id="addcomment">
                        <div class="form-group">
                            <input type="text" class="form-control" placeholder="Inserisci un commento" name="newcomment" id="comment-text" required>
                            Voto:
                            <select class="form-control" name="score" id="item-score">
                            <% for(int i = 1; i <= 5; i++) { %>
                            <option value="<%=i%>"><%=i%></option>
                            <%}%>
                            </select>
                        </div>
                            <span class="btn btn-sm btn-success" style="cursor:pointer;" onclick="addComment('<%=item.getItemId()%>','<%=item.getName()%>', '<%= venditore %>')">Invia</span>
                    </form>
                <%}%>
                    </div>
                </div>
                <% if(owner) { 
                    ArrayList<String> categorie = itemDAO.getAllCategories();
                %>
                <!--Modal-->
                <div class="modal fade" id="modificaitem" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                      <div class="modal-content">
                        <div class="modal-header">
                          <h5 class="modal-title" id="exampleModalLongTitle">Modifica Item</h5>
                          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                          </button>
                        </div>
                        <div class="modal-body">
                            <form method="POST" enctype="multipart/form-data" name="edit-item">
                                <div class="form-group">
                                    <label for="name">Nome Item</label>
                                    <input type="text" class="form-control" id="name" placeholder="<%= item.getName() %>" name="name">
                                </div>
                                <div class="form-group">
                                    <label for="categoria">Categoria</label>
                                    <select class="form-control" id="categoria" name="categoria">
                                        <% 
                                            for(String c : categorie) {%>
                                            <option value="<%=c%>"><%=c%></option>        
                                        <%  } %>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="descrizione">Descrizione</label>
                                    <textarea class="form-control" id="descrizione" name="descrizione" rows="3" max="1000"></textarea>
                                </div>
                                <div class="form-group">
                                    <label for="prezzo">Prezzo</label>
                                    <input type="number" step="0.01" class="form-control" name="prezzo" id="prezzo">
                                </div>
                                    <input type="hidden" name="id" value="<%= item.getItemId() %>">
                                <div class="form-group">
                                <label for="image">Inserisci immagini</label>
                                <div id='immaginiitem'>
                                <input type="file" id="image" name="image1" class="form-control-file">
                                </div>
                                <p class="help-block">Inserisci delle immagini per l'oggetto. <a onclick="addPhoto()" href='#'>Aggiungi un'altra foto</a></p>
                            </div>
                            <button type="submit" class="btn btn-default" id="edit-item-submit" onclick="edititem()">Modifica</button>
                            <button type='reset' class="btn btn-default">Reset</button>
                            </form>
                        </div>
                      </div>
                    </div>
                    </div>
                <!--End modal-->
                <script type="text/javascript">
                    var count = 1;
                    function addPhoto() {
                        var content = document.getElementById("immaginiitem").innerHTML;
                        count++;
                        content+='<input type="file" id="image" name="image' + count + '" class="form-control-file">';
                        document.getElementById("immaginiitem").innerHTML = content;
                    }
                </script>
                <% } %>
            </div>
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
        <script src="js/editItem.js"></script>
        <jsp:include page="Footer.jsp"/>
    </body>
</html>
