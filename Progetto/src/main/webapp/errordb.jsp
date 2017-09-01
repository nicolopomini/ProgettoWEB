<%-- 
    Document   : errordb
    Created on : Jul 24, 2017, 3:25:32 PM
    Author     : pomo
--%>

<%@page import="dao.entities.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8" isErrorPage="true"%>
<%
    boolean logged;
    User user = null;
    if(session.getAttribute("user") == null) 
        logged = false;
    else {
        logged = true;
        user = (User)session.getAttribute("user");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Errore</title>
        <link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
        <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
        <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
    </head>
    <body>
        <div class="container">
            <!-- Menu -->
            <jsp:include page="Header.jsp"/>
            <!-- Fine menu -->
            <div class="starter-template">
                <h1>Errore</h1>
                <p class="lead">Si è verificato un errore nel collegamento con il database</p>
              </div>
            <jsp:include page="Footer.jsp"/>
        </div>
    </body>
</html>
