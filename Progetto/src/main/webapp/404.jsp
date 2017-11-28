<%-- 
    Document   : 404
    Created on : Nov 28, 2017, 4:54:58 PM
    Author     : pomo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>404 Pagina non trovata</title>
        <link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
        <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
        <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="Header.jsp"/>
        <div class="container">
            <!-- Fine menu -->
            <div class="starter-template">
                <h1>Errore 404</h1>
                <p class="lead">La pagina richiesta è inesistente.</p>
              </div>
        </div>
        <jsp:include page="Footer.jsp"/>
    </body>
</html>
