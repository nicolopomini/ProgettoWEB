<%-- 
    Document   : index
    Created on : 18-ago-2017, 14.04.52
    Author     : blast
--%>

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
    String query=request.getParameter("inputSearch");
    String category=request.getParameter("category");
    String shopName=request.getParameter("shopName");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
        <link href="css/bootstrap-theme.min.css" type="text/css" rel="stylesheet">
        <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
       
        
        <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/css/bootstrap.min.css"/>
        <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.15/css/dataTables.bootstrap.min.css"/>

        
        <script type="text/javascript" src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <script type="text/javascript" src="https://cdn.datatables.net/1.10.15/js/jquery.dataTables.min.js"></script>
        <script type="text/javascript" src="https://cdn.datatables.net/1.10.15/js/dataTables.bootstrap.min.js"></script>
        
        <title>Home</title>
        <script type="text/javascript">
            $(document).ready(function($) {
                $(".table-row").click(function() {
                    window.document.location = $(this).data("href");
                });
                $.fn.dataTable.ext.search.push(
                    function( settings, data, dataIndex ) {
                        var min = parseInt( $('#minPrice').val(), 10 );
                        var max = parseInt( $('#maxPrice').val(), 10 );
                        var inputReview=parseFloat( $('#inputReview').val(), 10 );
                        var price = parseFloat( data[3] ) || 0;
                        var review = parseFloat( data[5] ) || 0;

                        if ( ( ( isNaN( min ) && isNaN( max ) ) ||
                             ( isNaN( min ) && price <= max ) ||
                             ( min <= price   && isNaN( max ) ) ||
                             ( min <= price   && price <= max ) ) &&
                              ( (isNaN( inputReview ) || isNaN( review )) || review>=inputReview ) )
                        {
                            return true;
                        }
                        return false;
                    }
                );
                $('#minPrice, #maxPrice, #inputReview').keyup( function() {
                    var table=$('#resultTable').DataTable();
                    table.draw();
                } );
            });
        </script>
    </head>
    <body>
        <div class="container">
            <jsp:include page="Header.jsp"/>
            
            <div class="container-fluid">
                <div class="row">

                    <div class="col-md-2">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="list-group stacked">
                                    
                                    <li class="list-group-item dropdown">
                                        <a href="#" data-toggle="dropdown" class="dropdown-toggle">Categorie<strong class="caret"></strong></a>
                                        <ul class="dropdown-menu">
                                            <%
                                                ArrayList<Item>allitems=new ArrayList<>(itemDatabase.getAll());
                                                TreeSet<String>categories=new TreeSet<>();
                                                Iterator<Item>itrCat=allitems.iterator();
                                                while(itrCat.hasNext()) {
                                                        Item elem = itrCat.next();
                                                        categories.add(elem.getCategory());
                                                    }
                                                Iterator<String>strItr=categories.iterator();
                                                while (strItr.hasNext()) {
                                                        String elem = strItr.next();
                                                        String red=(shopName!=null)?"?category="+elem+"&shopName="+shopName:"?category="+elem;
                                                        out.write("<a href='index.jsp"+red+"' class='list-group-item'>"+elem+"</a>");
                                                    }
                                            %>
                                        </ul>
                                    </li>
                                    <div class="list-group-item">
                                        <h5 class="list-group-item-heading">Negozio</h5>
                                        <form role="form" action="index.jsp<%
                                            if(category!=null){
                                                out.write("?category="+category);
                                            }
                                            %>" method="GET">
                                            <input type="search" class="form-control" name="shopName"/>
                                        </form>
                                    </div>
                                    <li class="list-group-item">
                                        <a href="#searchFilters" data-toggle="collapse" >Filtri di ricerca</a>
                                    </li>
                                </div>
                            </div>
                        </div>
                    </div>


                    <div class="col-md-10">
                        
                        <div class="row">
                            <form class="form-horizontal" role="form" action="index.jsp<%
                                            if(category!=null){
                                                out.write("?category="+category);
                                            }
                                            if(category!=null&&shopName!=null){
                                                 out.write("&shopName="+shopName);
                                            }else if(shopName!=null){
                                                out.write("?shopName="+shopName);
                                            }
                                        
                                        %>" method="POST">
                                <div class="col-md-2">
                                    <button type="submit" class="btn btn-default">Cerca nel negozio</button>
                                </div>
                                <div class="col-md-10">
                                    <input type="search" class="form-control" name="inputSearch" />
                                </div>
                            </form>
                        </div>
                        <br>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="container-fluid">
                                    <%
                                        
                                        if(query!=null||category!=null||shopName!=null){
                                            
                                            ArrayList<Item>items=new ArrayList<>(itemDatabase.getAll());
                                            ArrayList<Item>queryItems=new ArrayList<>();
                                            
                                            if(items!=null){
                                                Iterator<Item>itr=items.iterator();
                                                if(shopName!=null){
                                                    itr=items.iterator();
                                                    while (itr.hasNext()) {
                                                        Item alpha=itr.next();
                                                        String name=shopDatabase.getByPrimaryKey(alpha.getShopId()).getName();
                                                        if(!name.toLowerCase().contains(shopName.toLowerCase()))
                                                            itr.remove();
                                                    }
                                                }
                                                if(category!=null){
                                                    itr=items.iterator();
                                                    while (itr.hasNext()) {
                                                        Item alpha=itr.next();
                                                        if (!alpha.getCategory().equalsIgnoreCase(category))
                                                            itr.remove();
                                                    }
                                                }
                                                if(query!=null){
                                                    while (itr.hasNext()) {
                                                        Item alpha=itr.next();
                                                        if(alpha.getName().toLowerCase().contains(query.toLowerCase())){
                                                            queryItems.add(alpha);
                                                            itr.remove();
                                                        }
                                                    }
                                                    itr=items.iterator();
                                                    while (itr.hasNext()) {
                                                        Item alpha=itr.next();
                                                        if(alpha.getDescription().toLowerCase().contains(query.toLowerCase())){
                                                            queryItems.add(alpha);
                                                            itr.remove();
                                                        }
                                                    }
                                                }else{
                                                    queryItems=items;
                                                }
                                                
                                            }else{
                                                %> vuoto <%
                                            }

                                            if(!queryItems.isEmpty()){
                                            %>
                                            <div class="row">
                                                <table class="table collapse" id="searchFilters">
                                                    <tbody>
                                                        <tr>
                                                            <td>Prezzo minimo:</td>
                                                            <td><input type="text" id="minPrice" name="minPrice"></td>
                                                            <td>Prezzo massimo:</td>
                                                            <td><input type="text" id="maxPrice" name="maxPrice"></td>
                                                            <td>Recensione</td>
                                                            <td><input type="text" id="inputReview" name="inputReview"></td>
                                                        </tr>
                                                    </tbody>
                                                 </table>
                                            </div>
                                            <table class="table" id="resultTable">
                                                <thead>
                                                    <tr>
                                                        <th>Prodotto</th><th>Descrizione</th><th>Negozio</th><th>Prezzo</th><th style="display:none;">Regione</th><th style="display:none;">Recensione</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                            <%
                                            for(Item i:queryItems){
                                                String name=i.getName();
                                                String description=i.getDescription();
                                                String shop=(shopDatabase.getByPrimaryKey(i.getShopId())).getName();
                                                String price=i.getPrice().toString();
                                                String itemPage="item.jsp?itemid="+i.getItemId();
                                                String strReview=reviewDatabase.getAverageScoreByItemId(i.getItemId()).toString();
                                                //String region=shopDatabase.getByPrimaryKey(i.getShopId()).getAddress();
                                                //REGIONI DA FARE
                                            %>
                                                <tr class="table-row" data-href="<% out.write(itemPage); %>">
                                                    <td><% out.write(name); %> </td><td><% out.write(description); %></td><td><% out.write(shop); %></td><td><% out.write(price); %></td><td style="display:none;"><!-- REGIONE --></td><td style="display:none;"><% out.write(strReview); %></td>
                                                </tr>
                                                    <%--
                                                    <tr class="active">
                                                    </tr>
                                                    <tr class="success">
                                                    </tr>
                                                    <tr class="warning">
                                                    </tr>
                                                    <tr class="danger">
                                                    </tr>
                                                    --%>
                                            <%
                                            }
                                            %>
                                                    </tbody>
                                                </table>
                                                <%
                                            }else{
                                            %> Nessun prodotto trovato <%
                                            }
                                        }else{
                                        %> Nessuna ricerca effettuata <%
                                        }
                                    %>
                                    <script>
                                        $(document).ready(function() {
                                            $('#resultTable').DataTable( {
                                                "language": {
                                                    "url": "//cdn.datatables.net/plug-ins/1.10.15/i18n/Italian.json"
                                                },
                                                "bSort": false
                                            });
                                        });
                                    </script>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>                                      
            </div>
            
            <jsp:include page="Footer.jsp"/>
        </div>
    </body>
</html>