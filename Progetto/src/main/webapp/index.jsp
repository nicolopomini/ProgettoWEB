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
            
        </script>
    </head>
    <body>
        <div class="container">
            <div class="row">
                <div class="col">
                    <jsp:include page="Header.jsp"/>
                </div>
            </div>
            <div class="row">
                <div class="col">
                    <form class="form">
                        <div class="form-group">
                            <br>
                            <input type="search" class="form-control" name="SearchQuery" id="SearchQuery" placeholder="Scrivi il nome di un prodotto...">
                            <br>
                            <button class="btn btn-dark btn-sm" type="button" data-toggle="collapse" data-target="#AdvanceSearch" aria-expanded="false" aria-controls="AdvanceSearch">Ricerca Avanzata</button>
                        </div>
                        <div class="collapse" id="AdvanceSearch">
                            <div class="card card-body">
                                <div class="row">
                                    <div class="col-lg-4">
                                        <div class="form-group row">
                                            <label for="query" class="col-sm-3 col-form-label">Negzio</label>
                                            <div class="col-sm-9">
                                                <input type="search" class="form-control" id="Categoria" nome="Negozio" placeholder="Scrivi il nome del negozio...">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-4">
                                        <div class="form-group row">
                                            <label class="col-sm-4 col-form-label" for="query">Categoria</label>
                                            <div class="col-sm-8">
                                                <select class="form-control">
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
                                    </div>
                                    <div class="col-lg-4">
                                        <div class="form-group row">
                                            <label class="col-sm-6 col-form-label" for="rating">Valutazione</label>
                                            <div class="col-sm-6">
                                                <input type="number" class="form-control" id="Recensione" nome="Recensione" min="0" max="5">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>