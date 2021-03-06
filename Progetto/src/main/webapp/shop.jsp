<%-- 
    Document   : shop
    Created on : Jun 28, 2017, 11:10:22 AM
    Author     : pomo
--%>

<%@page import="dao.ItemDAO"%>
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
<%@ page import="dao.entities.Item" %>
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
    ItemDAO itemDAO;
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
            throw new ServletException("Impossible to get dao factory for review storage system", ex);
        }
    try {
        itemDAO = daoFactory.getDAO(ItemDAO.class);
    } catch (DAOFactoryException ex) {
        throw new ServletException("Impossible to get dao factory for item storage system", ex);
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

    ArrayList<Item> soldItems = itemDAO.findItemsByShop(shopid);

%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title><%= shop.getName() %></title>
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js" integrity="sha384-b/U6ypiBEHpOf/4+1nzFpr53nxSS+GLCkfwBdFNTxtclqqenISfwAzpKaMNFNmj4" crossorigin="anonymous"></script>
        <script src="js/bootstrap.min.js"></script>
        <link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
        <link href="css/bootstrap-theme.min.css" type="text/css" rel="stylesheet">
        <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="Header.jsp"/>
        <div class="container-fluid containerFix">
            <!-- Contenuto pagina -->
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
                      <button type="button" style="cursor:pointer;" class="btn btn-success" data-dismiss="modal" id="modal-btn">Ok</button>
                    </div>
                  </div>
                </div>
              </div>
            <div class="row">
                <div class="col-12 col-xl-6">
                    <center>
                    <h1><%= shop.getName() %></h1>
                    <img src="${pageContext.request.contextPath}/<%=shop.getImagePath()%>" class="img-fluid" alt="Responsive image">
                    </center>
                    <br/>
                    <div id="info">
                        <ul class="list-group">
                            <li class="list-group-item">Website: <a href="http://<%= shop.getWebsite() %>" target="_blank"><%= shop.getWebsite() %></a></li>
                            <li class="list-group-item">Orari del negozio: <%=shop.getOpeningHours()%></li>
                        </ul>
                    </div>
                    <center>
                        <br/>
                        <% if(venditore) { %> 
                            <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#modificanegozio">Modifica Negozio</button>
                            <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#inserisciitem">Aggiungi Item</button>
                        <% } %>
                        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#visualizzaitem">Visualizza Item</button>
                    </center>
                    <br/>
                </div>
                <div class="col-12 col-xl-6">
                    <div id="map">
                        <center>
                            <h3>Dove trovarci</h3>
                            <div class="embed-responsive embed-responsive-16by9">
                              <iframe class="embed-responsive-item" src="https://www.google.com/maps/embed/v1/place?q=<%=location%>&key=AIzaSyAOzJPvYZ2Mq5oCbxK5v1R1HBRy5KyfRUM"></iframe>
                            </div>
                        </center>
                    </div>
                    <div id="comments-wrapper">
                    <center>
                        <br/>
                        <% if(reviews.isEmpty()) { %>
                        <h5 style="text-align: center">Nessuna recensione</h5>
                        <%}%>
                    </center>
                    <% if(!reviews.isEmpty()) { %>
                    <div class=" col col-xs-12" >
                        <div id="comments">
                            <h5 id="avg-title">Valutazione media degli utenti: <%=valutation%>/5</h5>
                            <div class="progress">
                                <div id="progress" class="progress-bar" role="progressbar" style="width: <%=progress%>%" aria-valuenow="<%=progress%>" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                            <div class="commenti" id="commenti">
                                <!--Per ogni commento:-->
                                <% for(ShopReview s : reviews) { 
                                SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S"); 
                                Date date = dt.parse(s.getReviewTime());
                                %>
                                <fmt:formatDate value = "<%=date%>" /> : <%= s.getScore() + "/5" %>
                                <ul class="list-group" id="<%= s.getShopReviewId() %>">
                                    <li class="list-group-item"><b><%= s.getAuthorName() + " " + s.getAuthorSurname() %></b>: <%=s.getReviewText()%></li>
                                    <%if(s.getReply() != null) {%>
                                    <li class="list-group-item"><b>Venditore</b>: <%=s.getReply()%></li>
                                    <%} else if(venditore) {%>
                                    <form id="form-reply-<%=s.getShopReviewId()%>" class="form-inline" method="POST">
                                        <div class="form-group">
                                          <input type="text" class="form-control" placeholder="Rispondi al commento" name="replycomment" id="replycomment-<%=s.getShopReviewId()%>" required>
                                        </div>
                                        <span class="btn btn-sm btn-success" style="cursor:pointer;" onclick="addReply('<%=s.getShopReviewId()%>','<%=shop.getShopId()%>')">Invia</span>
                                    </form>
                                    <%}%>
                                </ul>
                                <%}%>
                            </div>
                        </div>
                    </div>
                    <% if(cancomment) { %>
                    <form class="form-inline" method="POST" id="addcomment">
                                <div class="form-group">
                                    <input type="text" class="form-control" placeholder="Inserisci un commento" name="newcomment" id="comment-text" required>
                                  Voto:
                                    <select class="form-control" name="score" id="shop-score">
                                      <% for(int i = 1; i <= 5; i++) { %>
                                      <option value="<%=i%>"><%=i%></option>
                                      <%}%>
                                  </select>
                                </div>
                                  <span class="btn btn-sm btn-success" style="cursor:pointer;" onclick="addComment('<%=shop.getShopId()%>','<%=shop.getName()%>', '<%= venditore %>')">Invia</span>
                              </form>
                    <% } else { %>
                    <p>Per lasciare un commento devi aver aquistato in questo negozio.</p>
                    <% } %>
                <% }else if(cancomment) {%>
                    <h4>Inserisci un commento</h4>
                    <form method="POST" id="addcomment">
                        <div class="form-group">
                            <input type="text" class="form-control" placeholder="Inserisci un commento" name="newcomment" id="comment-text" required>
                            Voto:
                            <select class="form-control" name="score" id="shop-score">
                            <% for(int i = 1; i <= 5; i++) { %>
                            <option value="<%=i%>"><%=i%></option>
                            <%}%>
                            </select>
                        </div>
                            <span class="btn btn-sm btn-success" style="cursor:pointer;" onclick="addComment('<%=shop.getShopId()%>','<%=shop.getName()%>', '<%= venditore %>')">Invia</span>
                    </form>
                <%}%>
                </div>
                </div>
            </div>
            <!--Fine contenuto-->
            <!--visualizza tutti gli item-->
            <div class="modal fade" id="visualizzaitem" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title">Visualizza Oggetti Venduti</h4>
                        </div>
                        <div class="modal-body">
                            <ul>
                                <%
                                    if(soldItems.size() == 0){
                                        %>
                                        Non stai vendendo ancora nessun oggetto
                                    <%
                                    }else{
                                        for (Item item:soldItems) {
                                            System.out.println(item.getItemId());
                                            %>
                                            <li><a href="item.jsp?itemid=<%=item.getItemId()%>"><%=item.getName()%></a></li>
                                    <%
                                        }
                                    }
                                %>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            <!--End modal-->
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
                        <form method="POST" enctype="multipart/form-data" name="form-modify-shop">
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
                                <label for="image">Immagine negozio (dim. max 2MB)</label>
                                <input type="file" id="image" name="image">
                                <p class="help-block">Inserisci un immagine che rappresenti il tuo negozio</p>
                            </div>
                            <button type="submit" class="btn btn-default" id="modifyshopbutton">Modifica</button>
                        </form>
                    </div>
                </div>
              </div>
            </div>
            <!--End modal-->
            <%
                ArrayList<String> categorie = itemDAO.getAllCategories();
            %>
            <!--Inserisci nuovo item-->
            <div class="modal fade" id="inserisciitem" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
              <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">Inserisci nuovo item</h4>
                    </div>
                    <div class="modal-body">
                        <form name="form-new-item" method="POST" enctype="multipart/form-data">
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
                                    <% 
                                            for(String cat : categorie) {%>
                                            <option value="<%=cat%>"><%=cat%></option>        
                                        <%  } %>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="image">Inserisci immagini (dim. max 2MB)</label>
                                <div id='immaginiitem'>
                                <input type="file" id="image" name="image1">
                                </div>
                                <p class="help-block">Inserisci delle immagini per l'oggetto. <a onclick="addPhoto()" href='#'>Aggiungi un'altra foto</a></p>
                            </div>
                            <button type="submit" class="btn btn-default" id="form-new-item-btn">Aggiungi</button>
                            <button type='reset' class="btn btn-default">Reset</button>
                        </form>
                    </div>
                </div>
              </div>
            </div>
            <!--End modal-->
            <!--Fine nuovo item-->
            <script type="text/javascript">
            var count = 1;
            function addPhoto() {
                var content = document.getElementById("immaginiitem").innerHTML;
                count++;
                content+='<input type="file" id="image" name="image' + count + '">';
                document.getElementById("immaginiitem").innerHTML = content;
            }
        </script>
        <script src="js/shopJS.js"></script>
            <% } %>
        </div>
        <jsp:include page="Footer.jsp"/>
    </body>
</html>
