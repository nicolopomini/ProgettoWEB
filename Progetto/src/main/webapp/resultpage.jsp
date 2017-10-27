<%-- 
    Document   : resultpage
    Created on : Oct 25, 2017, 11:07:51 AM
    Author     : root
--%>
<%@page import="dao.entities.Shop"%>
<%@page import="dao.ItemReviewDAO"%>
<%@page import="dao.entities.ItemReview"%>
<%@page import="java.util.TreeSet"%>
<%@page import="java.util.Set"%>
<%@page import="dao.ShopDAO"%>
<%@page import="java.util.Iterator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.util.List"%>
<%@page import="persistence.utils.dao.exceptions.DAOFactoryException"%>
<%@page import="persistence.utils.dao.factories.DAOFactory"%>
<%@page import="dao.ItemDAO"%>
<%@page import="dao.entities.Item"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    ItemDAO itemDatabase;
    ShopDAO shopDatabase;
    ItemReviewDAO reviewDatabase;
    DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
    if(daoFactory!=null){
        try{
            itemDatabase=daoFactory.getDAO(ItemDAO.class);
        }catch(DAOFactoryException ex){
            throw new ServletException("Impossible to get dao factory for item storage system", ex);
        }
        try {
            shopDatabase = daoFactory.getDAO(ShopDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for shop storage system", ex);
        }
        try {
            reviewDatabase = daoFactory.getDAO(ItemReviewDAO.class);
        } catch (DAOFactoryException ex) {
            throw new ServletException("Impossible to get dao factory for itemReview storage system", ex);
        }
    }else{
        throw new ServletException("Impossible to get dao factory for storage system");
    }
    
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
       <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
       
        <!-- Jquery library -->
        <script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        
        <!-- Bootstrap libraries -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>
        
        <!-- Jquery UI Autocomplete libraries -->
        <script type="text/javascript" src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
        <link rel="stylesheet" type="text/css" href="https://code.jquery.com/ui/1.12.1/themes/dark-hive/jquery-ui.css"/>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js" integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU=" crossorigin="anonymous"></script>
        
        <!-- Datatable libraries -->
        
        <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.16/css/dataTables.bootstrap4.css"/>

        <script type="text/javascript" src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="https://cdn.datatables.net/1.10.16/js/dataTables.bootstrap4.js"></script>
        
        <title>Home</title>
        <script type="text/javascript">
            $(document).ready(function($) {
                
                $(".table-row").click(function() {
                    window.document.location = $(this).data("href");
                });
                $( function() {
                    $( "#SearchQuery" ).autocomplete({
                        source : function(request, response) {
                            $.ajax({
                                url : "AutoCompleteServlet",
                                type : "GET",
                                data : {
                                    Query:$("#SearchQuery").val(),
                                    Categoria:$("#Categoria").val(),
                                    Negozio:$("#Negozio").val(),
                                    Recensione:$("#Recensione").val(),
                                    minPrice:$("#minPrice").val(),
                                    maxPrice:$("#maxPrice").val()
                                },
                                dataType : "json",
                                success : function(data) {
                                    response(data);
                                }
                            });
                        }
                    });
                });
            });
        </script>
    </head>
    <body>
        <jsp:include page="Header.jsp"/>
        <div class="container-fluid containerFix">
            <div class="row">
                <div class="col-md-4">
                    <form class="form" action="resultpage.jsp" method="GET">
                        <input type="submit" style="display: none" />
                        <div class="form-group">
                            <br>
                            <input type="search" class="form-control" name="SearchQuery" id="SearchQuery" placeholder="Scrivi il nome di un prodotto...">
                            <br>
                            <button class="btn btn-dark btn-sm" type="submit" form="form" data-toggle="collapse" aria-expanded="false">Ricerca</button>
                            <button class="btn btn-dark btn-sm" type="button" data-toggle="collapse" data-target="#AdvanceSearch" aria-expanded="false" aria-controls="AdvanceSearch">Ricerca Avanzata</button>
                        </div>
                        <div class="collapse" id="AdvanceSearch">
                            <div class="card card-body">
                                
                                <div class="form-group row">
                                    <label for="Negozio" class="col-xl-3 col-form-label">Negozio</label>
                                    <div class="col-xl-9">
                                        <input type="text" class="form-control" id="Negozio" name="Negozio" placeholder="Scrivi il nome del negozio...">
                                    </div>
                                </div>

                                <div class="form-group row">
                                    <label class="col-xl-4 col-form-label" for="Categoria">Categoria</label>
                                    <div class="col-xl-8">
                                        <select class="form-control" id="Categoria" name="Categoria">
                                            <option value=''></option>
                                            <%
                                                String head="<option value='";
                                                String middle="'>";
                                                String tail="</option>";
                                                ArrayList<String> categories=itemDatabase.getAllCategories();
                                                for(String c:categories){
                                                    out.write(head+c+middle+c+tail);
                                                }
                                            %>
                                        </select>
                                    </div>
                                </div>


                                <div class="form-group row">
                                    <label class="col-xl-6 col-form-label" for="Recesione">Valutazione</label>
                                    <div class="col-xl-6">
                                        <input name="Recensione" type="number" class="form-control" id="Recensione" min="0" max="5">
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label class="col-xl-6 col-form-label" for="minPrice">Prezzo minimo:</label>
                                    <div class="col-xl-6">
                                        <input name="minPrice" type="number" class="form-control" id="minPrice">
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label class="col-xl-6 col-form-label" for="maxPrice">Prezzo massimo:</label>
                                    <div class="col-xl-6">
                                        <input name="maxPrice" type="number" class="form-control" id="maxPrice">
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label class="col-xl-6 col-form-label" for="geo">Ricerca geografica:</label>
                                    <div class="col-xl-6">
                                        <input name="geo" type="search" class="form-control" id="geo" placeholder="Inserisci un luogo">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-4"></div>
                                    <div class="col-4">
                                        <input type="submit" value="Ricerca">
                                        <input type="reset">
                                    </div>
                                    <div class="col-4"></div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="col-md-8">
                    <table class="table" id="resultTable">
                        <thead>
                            <tr>
                                <th>Prodotto</th><th>Descrizione</th><th>Negozio</th><th>Prezzo</th><th>Recensioni</th><th style="display:none;">Regione</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                String strName=request.getParameter("SearchQuery");
                                String name=(strName.equals(""))?null:strName;
                                
                                String strCategory=request.getParameter("Categoria");
                                String category=(strCategory.equals(""))?null:strCategory;
                                
                                String strShop=request.getParameter("Negozio");
                                String shop=(strShop.equals(""))?null:strShop;
                                
                                String strMinPrice=request.getParameter("minPrice");
                                Integer minPrice=(strMinPrice.equals(""))?null:Integer.getInteger(strMinPrice);
                                
                                String strMaxPrice=request.getParameter("maxPrice");
                                Integer maxPrice=(strMaxPrice.equals(""))?null:Integer.getInteger(strMaxPrice);
                                
                                String strMinAvgScore=request.getParameter("Recensione");
                                Integer minAvgScore=(strMinAvgScore.equals(""))?null:Integer.getInteger(strMinAvgScore);
                                
                                String strGeo = request.getParameter("geo");
                                String geo = (strGeo.equals(""))?null:strGeo;
                                
                                System.err.println("------");
                                System.err.println(name);
                                System.err.println(category);
                                System.err.println(shop);
                                System.err.println(minPrice);
                                System.err.println(maxPrice);
                                System.err.println(minAvgScore);
                                
                                ArrayList<Item>items=itemDatabase.findItems(name, category, shop, minPrice, maxPrice, minAvgScore, geo);
                                for (Item i:items) {
                                    String itemName=i.getName();
                                    String itemDescription=i.getDescription();
                                    
                                    Shop itemShop=shopDatabase.getByPrimaryKey(i.getShopId());
                                    String itemShopName=itemShop.getName();
                                    
                                    String itemPage="item.jsp?itemid="+i.getItemId();
                                    String price=i.getPrice().toString()+"€";
                                    String itemReview=reviewDatabase.getAverageScoreByItemId(i.getItemId()).toString()+"/5";
                                    %>
                                    <tr style="cursor: pointer;" class="table-row" data-href="<% out.write(itemPage); %>">
                                        <td><% out.write(itemName); %> </td><td><% out.write(itemDescription); %></td><td><% out.write(itemShopName); %></td><td><% out.write(price); %></td><td style="display:none;"><!-- REGIONE --></td><td><% out.write(itemReview); %></td>
                                    </tr>
                                    <%
                                    }
                            %>
                        </tbody>
                    </table>
                    <script>
                        $(document).ready(function() {
                            $('#resultTable').DataTable( {
                                "language": {
                                    "url": "//cdn.datatables.net/plug-ins/1.10.15/i18n/Italian.json"
                                },
                                "bSort": false,
                                searching: false
                            });
                        });
                    </script>
                </div>
            </div>
        </div>
        <jsp:include page="Footer.jsp"/>
    </body>
</html>