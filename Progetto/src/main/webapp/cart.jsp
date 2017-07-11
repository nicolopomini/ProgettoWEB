<%-- 
    Document   : cart
    Created on : Jul 11, 2017, 3:13:43 PM
    Author     : pomo
--%>

<%@page import="java.util.HashMap"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    boolean logged = false;
    HashMap<Integer,Integer> cart = (HashMap<Integer,Integer>) session.getAttribute("cart");
    
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Carrello</title>
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
            <% if(cart == null || cart.isEmpty()) { //carrello vuoto%>
            <h2 style="text-align: center">Il carrello è vuoto</h2>
            <% } else { //carrello pieno%>
            <form action="" method="POST" class="form-inline">
                <input type="hidden" name="total" value="32.5">
                <input class="btn btn-default" type="submit" value="Procedi al pagamento">
            </form>
            <table class="table">
                <thead>
                    <th><strong>Totale</strong></th>
                    <th><strong><fmt:formatNumber value="32.5" type="currency"/></strong></th>
                </thead>
                <tbody>
                <c:forEach items="${cart}" var="current">
                    <tr>
                        <td><a href="item.jsp?itemid=<c:out value="${current.key}"/>">Nome oggetto</a></td>
                        <td><fmt:formatNumber value="9.49" type="currency"/></td>
                        <td>x<c:out value="${current.value}"/></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <form action="" method="POST" class="form-inline">
                <input type="hidden" name="total" value="32.5">
                <input class="btn btn-default" type="submit" value="Procedi al pagamento">
            </form>
            <% } %>
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
