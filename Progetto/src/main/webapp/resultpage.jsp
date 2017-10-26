<%-- 
    Document   : resultpage
    Created on : Oct 25, 2017, 11:07:51 AM
    Author     : root
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
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <!-- Bootstrap libraries -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>
        <!-- Datatable libraries -->
        <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.15/css/dataTables.bootstrap.min.css"/>
        <script type="text/javascript" src="https://cdn.datatables.net/1.10.15/js/jquery.dataTables.min.js"></script>
        <script type="text/javascript" src="https://cdn.datatables.net/1.10.15/js/dataTables.bootstrap.min.js"></script>
        <!-- Jquery UI Autocomplete libraries -->
        <script type="text/javascript" src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
        <link rel="stylesheet" type="text/css" href="https://code.jquery.com/ui/1.12.1/themes/dark-hive/jquery-ui.css"/>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js" integrity="sha256-VazP97ZCwtekAsvgPBSUwPFKdrwD3unUfSGVYrahUqU=" crossorigin="anonymous"></script>
        
        <title>Home</title>
        <script type="text/javascript">
            $(document).ready(function($) {
                $( function() {
                    $( "#SearchQuery" ).autocomplete({
                        source : function(request, response) {
                            $.ajax({
                                url : "AutoCompleteServlet",
                                type : "GET",
                                data : {
                                    query:$("#SearchQuery").val(),
                                    category:$("#Categoria").val(),
                                    shop:$("#Negozio").val(),
                                    rating:$("#Recensione").val(),
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
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-4">
                    <form class="form" action="#" method="GET">
                        <div class="form-group">
                            <br>
                            <input type="search" class="form-control" name="SearchQuery" id="SearchQuery" placeholder="Scrivi il nome di un prodotto...">
                            <br>
                            <button class="btn btn-dark btn-sm" type="button" data-toggle="collapse" data-target="#AdvanceSearch" aria-expanded="false" aria-controls="AdvanceSearch">Ricerca Avanzata</button>
                        </div>
                        <div class="collapse" id="AdvanceSearch">
                            <div class="card card-body">
                                
                                <div class="form-group row">
                                    <label for="Negozio" class="col-xl-3 col-form-label">Negozio</label>
                                    <div class="col-xl-9">
                                        <input type="search" class="form-control" id="Negozio" nome="Negozio" placeholder="Scrivi il nome del negozio...">
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
                                        <input type="number" class="form-control" id="Recensione" nome="Recensione" min="0" max="5">
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label class="col-xl-6 col-form-label" for="minPrice">Prezzo minimo:</label>
                                    <div class="col-xl-6">
                                        <input type="number" class="form-control" id="minPrice" nome="minPrice">
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label class="col-xl-6 col-form-label" for="maxPrice">Prezzo massimo:</label>
                                    <div class="col-xl-6">
                                        <input type="number" class="form-control" id="maxPrice" nome="maxPrice">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-4"></div>
                                    <div class="col-4">
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
                                <!-- <th>Prodotto</th><th>Descrizione</th><th>Negozio</th><th>Prezzo</th><th style="display:none;">Regione</th><th>Recensioni</th> -->
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                String name=request.getParameter("SearchQuery");
                                String category=request.getParameter("Categoria");
                                String shop=request.getParameter("Negozio");
                                String minPrice=request.getParameter("minPrice");
                                String maxPrice=request.getParameter("maxPrice");
                                String rating=request.getParameter("Recensione");
                                System.err.println("------");
                                System.err.println(name);
                                System.err.println(category);
                                System.err.println(shop);
                                System.err.println(minPrice);
                                System.err.println(maxPrice);
                                System.err.println(rating);
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <jsp:include page="Footer.jsp"/>
    </body>
</html>