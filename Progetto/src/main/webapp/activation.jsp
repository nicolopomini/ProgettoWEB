<%-- 
    Document   : activation
    Created on : 31-lug-2017, 14.01.32
    Author     : Marco
--%>

<%@page import="dao.entities.User"%>
<%@page import="persistence.utils.dao.exceptions.DAOFactoryException"%>
<%@page import="dao.UserDAO"%>
<%@page import="persistence.utils.dao.factories.DAOFactory"%>
<%@page import="utils.StringUtils"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    boolean logged, venditore;
    logged = venditore = false;
    String activationCode = "";
    boolean validCode = true;
    
    if(request.getMethod().equals("POST"))
    {
        if(request.getParameter("ActivationCode") != null)
        {
            activationCode = request.getParameter("ActivationCode");
            String activationCodeRegex = "[^a-zA-Z0-9]";
            if(StringUtils.isValidString(activationCode,activationCodeRegex) && !StringUtils.isEmpty(activationCode))
            {
                UserDAO user;
                User toUpdate;
                DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
                if (daoFactory == null) 
                {
                    throw new ServletException("Impossible to get dao factory for storage system");
                }
                try 
                {
                    user = daoFactory.getDAO(UserDAO.class);
                } 
                catch (DAOFactoryException ex) 
                {
                    throw new ServletException("Impossible to get dao factory for user activation", ex);
                }
                toUpdate = user.getUserByActivationCode(activationCode);
                if(toUpdate.getUserId() != null)
                {
                    toUpdate.setVerificationCode("1");
                    user.update(toUpdate);
                }
                else
                {
                    validCode = false;
                }
            }
            else
            {
                validCode = false;
            }
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
        <link href="css/bootstrap-theme.min.css" type="text/css" rel="stylesheet">
        <title>Account activation</title>
    </head>
    <body>
        <div class="container">
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
            <%
                if(validCode)
                {
            %>
            <div class="row">
                <div class="col-xs-12">
                    <label>Your account has been activated</label>
                    <p>You will now be able to access your customer area and buy our products</p>
                </div>
            </div>
            <% } else { %>
            <div class="row">
                <div class="col-xs-12">
                    <label>Something went wrong</label>
                </div>
            </div>
            <% } %>
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
