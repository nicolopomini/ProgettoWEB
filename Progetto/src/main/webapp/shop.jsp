<%-- 
    Document   : shop
    Created on : Jun 28, 2017, 11:10:22 AM
    Author     : pomo
--%>

<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="dao.entities.User"%>
<%@page import="dao.ShopReviewDAO"%>
<%@page import="dao.entities.ShopReview"%>
<%@page import="java.util.ArrayList"%>
<%@page import="persistence.utils.dao.exceptions.DAOFactoryException"%>
<%@page import="dao.ShopDAO"%>
<%@page import="persistence.utils.dao.factories.DAOFactory"%>
<%@page import="dao.entities.Shop"%>
<%@ page errorPage="/errorpage.jsp" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if(request.getParameter("shopid") == null)
        throw new NullPointerException("No shop specified");
    int shopid = Integer.parseInt(request.getParameter("shopid"));
    boolean venditore, logged, cancomment;
    Shop shop;
    User user;
    double valutation;
    int progress;
    ArrayList<ShopReview> reviews;
    String location;
    DAOFactory daoFactory;
    ShopDAO shopDAO;
    ShopReviewDAO shopReviewDAO;
    daoFactory = (DAOFactory) application.getAttribute("daoFactory");
    if (daoFactory == null) {
        throw new ServletException("Impossible to get dao factory for storage system");
    }
    try {
            shopDAO = daoFactory.getDAO(ShopDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shop storage system", ex);
        }
    try {
            shopReviewDAO = daoFactory.getDAO(ShopReviewDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shop storage system", ex);
        }
    shop = shopDAO.getByPrimaryKey(shopid);
    if(shop == null)
        throw new NullPointerException("Shop doesn't exist");
    valutation = shopReviewDAO.getAverageScoreByShopId(shopid);
    progress = (int)(valutation * 10);
    location = shop.getAddress().replace(' ', '+');
    reviews = shopReviewDAO.getByShopId(shopid);
    user = (User)session.getAttribute("user");
    session.setAttribute("shop", shop);
    if(user == null) {  //non è loggato
        logged = false;
        venditore = false;
        cancomment = false;
    }
    else {
        logged = true;
        venditore = user.getUserId() == shop.getUserId();
        cancomment = shopDAO.canComment(shop.getShopId(), user.getUserId());
    }
    Cookie[] cookies = request.getCookies();
    Cookie c = null;
    for(Cookie cookie : cookies)
        if(cookie.getName().equals("shop_message"))
            c = cookie;
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title><%= shop.getName() %></title>
        <link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
        <link href="css/bootstrap-theme.min.css" type="text/css" rel="stylesheet">
        <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
    </head>
    <body onload="addButton()">
        <div class="container">
            <!-- Menu -->
            <jsp:include page="Header.jsp"/>
            <!-- Fine menu -->
            <% if(c != null) { %>
            <div class="alert alert-info alert-dismissable fade in" role="alert">
                <button type="button" class="close" data-dismiss="alert" aria-label="close">
                    <span aria-hidden="true">x</span>
                </button>
                <%if(c.getValue().equals("updated")) {%>
                Negozio aggiornato.
                <%} else if(c.getValue().equals("insered")) {%>
                Commento inserito.
                <%} else if(c.getValue().equals("replied")) {%>
                Risposto al commento.
                <%}%>
            </div>
            <% c.setMaxAge(0); %>
            <% } %>
            
            <!-- Contenuto pagina -->
            <div class="row">
                <% if(!reviews.isEmpty()) { %>
                <div class="col-md-8">
                <% } %>
                    <center>
                    <h1><%= shop.getName() %></h1>
                    <img src="${pageContext.request.contextPath}/<%=shop.getImagePath()%>" class="img-responsive" alt="Responsive image">
                    </center>
                    <br/>
                    <div id="info">
                        <ul class="list-group">
                            <li class="list-group-item">Website: <a href="<%= shop.getWebsite() %>" target="_blank"><%= shop.getWebsite() %></a></li>
                            <li class="list-group-item">Orari del negozio: <%=shop.getOpeningHours()%></li>
                        </ul>
                        <br/>
                        <% if(reviews.isEmpty()) { %>
                        <h5 style="text-align: center">Nessuna recensione</h5>
                        <%}%>
                    </div>
                    <div id="map">
                        <center>
                            <h3>Dove trovarci</h3>
                            <div class="embed-responsive embed-responsive-16by9">
                              <iframe class="embed-responsive-item" src="//www.google.com/maps/embed/v1/place?q=<%=location%>&key=AIzaSyAOzJPvYZ2Mq5oCbxK5v1R1HBRy5KyfRUM"></iframe>
                            </div>
                        </center>
                    </div>
                    <br/>
                    <br/>
                <% if(!reviews.isEmpty()) { %>
                </div>
                <div class="col-md-4" id="comments">
                <% } else if(cancomment) { %>
                <h4>Inserisci un commento</h4>
                <form method="POST" action="ShopComment">
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
                <% } %>
                    <% if(!reviews.isEmpty()) { %>
                    <h5>Valutazione media degli utenti: <%=valutation%>/5</h5>
                    <div class="progress">
                        <div class="progress-bar progress-bar-warning" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 60%;">
                          <span class="sr-only"><%=progress%></span>
                        </div>
                      </div>
                    <div class="commenti">
                        <!--Per ogni commento:-->
                        <% for(ShopReview s : reviews) { 
                        SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S"); 
                        Date date = dt.parse(s.getReviewTime());
                        %>
                        <ul class="list-group">
                            <fmt:formatDate value = "<%=date%>" /> : <%for(int i = 0; i < s.getScore(); i++) {%><span class="glyphicon glyphicon-star" aria-hidden="true"></span> <%}%>
                            <li class="list-group-item"><b><%= s.getAuthorName() + " " + s.getAuthorSurname() %></b>: <%=s.getReviewText()%></li>
                            <% if(s.getReply() != null) { %>
                            <li class="list-group-item"><b>Venditore</b>: <%=s.getReply()%></li>
                            <% } else if(venditore) { %>
                            <form class="form-inline" method="POST" action="ShopCommentReply">
                                <input type="hidden" name="reviewid" value="<%=s.getShopReviewId()%>">
                                <div class="form-group">
                                  <input type="text" class="form-control" placeholder="Rispondi al commento" name="replycomment" required>
                                </div>
                                <button type="submit" class="btn btn-default">Invia</button>
                              </form>
                            <% } %>
                        </ul>
                        <% } %>
                    </div>
                    <% if(cancomment) { %>
                    <form class="form-inline" method="POST" action="ShopComment">
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
                    <% } %>
                <% if(!reviews.isEmpty()) { %>
                </div>
                <% } %>
            </div>
            <!--Fine contenuto-->
            <% if(venditore) { %>
            <!--Modal modifica shop-->
            <div class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" id="modificanegozio">
              <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">Modifica il tuo negozio</h4>
                    </div>
                    <div class="modal-body">
                        <form action="ModifyShop" method="POST" enctype="multipart/form-data">
                            <div class="form-group">
                                <label for="newname">Nome del negozio</label>
                                <input type="text" class="form-control" name="newname" id="newname" placeholder="<%=shop.getName()%>">
                            </div>
                            <div class="form-group">
                                <label for="website">Website</label>
                                <input type="text" class="form-control" name="website" id="website" placeholder="<%=shop.getWebsite()%>">
                            </div>
                            <div class="form-group">
                                <label for="address">Indirizzo</label>
                                <input type="text" class="form-control" name="address" id="address" placeholder="<%=shop.getAddress()%>">
                            </div>
                            <div class="form-group">
                                <label for="orari">Orari</label>
                                <input type="text" class="form-control" name="orari" id="orari" placeholder="<%=shop.getOpeningHours()%>">
                            </div>
                            <div class="form-group">
                                <label for="image">Immagine negozio</label>
                                <input type="file" id="image" name="image">
                                <p class="help-block">Inserisci un immagine che rappresenti il tuo negozio</p>
                            </div>
                            <button type="submit" class="btn btn-default">Modifica</button>
                        </form>
                    </div>
                </div>
              </div>
            </div>
            <!--End modal-->
            <!--Inserisci nuovo item-->
            <div class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" id="inserisciitem">
              <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">Inserisci nuovo item</h4>
                    </div>
                    <div class="modal-body">
                        <form action="InsertItem" method="POST" enctype="multipart/form-data">
                            <div class="form-group">
                                <label for="name">Nome dell'item</label>
                                <input type="text" class="form-control" name="name" id="name" placeholder="Nome item" required>
                            </div>
                            <div class="form-group">
                                <label for="descrizione">Descrizione</label>
                                <textarea class="form-control" rows="3" name="descrizione" id="descrizione" placeholder="Descrizione" maxlength="500" required></textarea>
                            </div>
                            <div class="form-group">
                                <label for="prezzo">Prezzo</label>
                                <input type="number" step="0.01" class="form-control" name="prezzo" id="prezzo" required>
                            </div>
                            <div class="form-group">
                                <label for="categoria">Categoria</label>
                                <select class="form-control" id='categoria' name="categoria">
                                    <option value='electronics'>Elettronica</option>
                                    <option value='books'>Libri</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="image">Inserisci immagini</label>
                                <div id='immaginiitem'>
                                <input type="file" id="image" name="image1">
                                </div>
                                <p class="help-block">Inserisci delle immagini per l'oggetto. <a onclick="addPhoto()" href='#'>Aggiungi un'altra foto</a></p>
                            </div>
                            <button type="submit" class="btn btn-default">Aggiungi</button>
                            <button type='reset' class="btn btn-default">Reset</button>
                        </form>
                    </div>
                </div>
              </div>
            </div>
            <!--End modal-->
            <!--Fine nuovo item-->
            <% } %>
            <!--Footer-->
            <jsp:include page="Footer.jsp"/>
        <script type="text/javascript">
            var count = 1;
            function addPhoto() {
                var content = document.getElementById("immaginiitem").innerHTML;
                count++;
                content+='<input type="file" id="image" name="image' + count + '">';
                document.getElementById("immaginiitem").innerHTML = content;
            }
        </script>
        <% if(venditore) { %>
        <script type="text/javascript">
            function addButton() {
                var menu = document.getElementById("voci_menu").innerHTML;
                menu += '<li><a role="button" data-toggle="modal" data-target="#modificanegozio">Modifica negozio</a></li>';
                menu += '<li><a role="button" data-toggle="modal" data-target="#inserisciitem">Aggiungi item</a></li>';
                document.getElementById("voci_menu").innerHTML = menu;
            }
        </script>
        <% } %>
        </div>
    </body>
</html>
