<%-- 
    Document   : Registration
    Created on : 5-lug-2017, 15.46.04
    Author     : Marco
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    boolean venditore, logged;
    String name = "Prova";
%>
<%
    if(session.getAttribute("logged") == null)
    {
        logged = false;
        session.setAttribute("logged", logged);
        venditore = false;
        session.setAttribute("venditore", venditore);
    }
    else
    {
        logged = (boolean)session.getAttribute("logged");
        venditore = (boolean)session.getAttribute("venditore");
    }
%>  
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Registration Page</title>
        <link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
        <link href="css/bootstrap-theme.min.css" type="text/css" rel="stylesheet">
        <link href="css/LoginTheme.css" type="text/css" rel="stylesheet">
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
                        <% if(venditore) { %>
                        <li><a href="#">Modifica negozio</a></li>
                        <% } %>
                        <% if(logged) { %>
                        <li><a href="#">Esci</a></li>
                        <% }else {%>
                        <li><a href="#">Login</a></li>
                        <li><a href="#">Registrati</a></li>
                        <% } %>
                    </ul>
                  </div><!-- /.navbar-collapse -->
                </div><!-- /.container-fluid -->
            </nav>
            <div class="row">
                <form class="form-horizontal">
                    <div class="col-xs-12 marginBottomFix">
                        <label class="col-xs-12">Fill the form and press "Register" to create a new user</label>
                    </div>
                    <div class="col-xs-12 col-sm-6 col-md-4">
                        <div class="form-group col-xs-12">
                            <label for="Email" class="col-xs-12">Email</label>
                            <div class="col-xs-12">
                                <input class="form-control" type="email" id="Email">
                            </div>
                        </div>
                        <div class="form-group col-xs-12">
                            <label for="Username" class="col-xs-12">Username</label>
                            <div class="col-xs-12">
                                <input class="form-control" type="text" id="Username">
                            </div>
                        </div>
                        <div class="form-group col-xs-12">
                            <label for="Password" class="col-xs-12">Password</label>
                            <div class="col-xs-12">
                                <input class="form-control" type="password" id="Password">
                            </div>
                        </div>
                        <div class="form-group col-xs-12">
                            <label for="example-text-input" class="col-xs-12">Name</label>
                            <div class="col-xs-12">
                                <input class="form-control" type="text" id="Name">
                            </div>
                        </div>
                        <div class="form-group col-xs-12">
                            <label for="example-text-input" class="col-xs-12">Surname</label>
                            <div class="col-xs-12">
                                <input class="form-control" type="text" id="Surname">
                            </div>
                        </div>
                        <div class="form-group col-xs-12"> 
                            <div class="col-xs-2">
                                <button type="submit" class="btn btn-default">Register</button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
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