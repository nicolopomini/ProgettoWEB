<%-- 
    Document   : errorpage
    Created on : Jul 25, 2017, 1:41:49 PM
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
                <p class="lead">L'elemento richiesto non esiste o non è disponibile. Assicurati di aver cercato quello che effettivamente desideravi cercare.</p>
              </div>
            <jsp:include page="Footer.jsp"/>
        </div>
    </body>
</html>
