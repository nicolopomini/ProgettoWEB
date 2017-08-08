<%-- 
    Document   : login
    Created on : 1-ago-2017, 16.52.28
    Author     : Marco
--%>

<%@page import="utils.BCrypt"%>
<%@page import="persistence.utils.dao.exceptions.DAOFactoryException"%>
<%@page import="persistence.utils.dao.factories.DAOFactory"%>
<%@page import="dao.UserDAO"%>
<%@page import="utils.StringUtils"%>
<%@page import="dao.entities.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    boolean logged, venditore;
    logged = venditore = false;
    String email = "";
    String password = "";
    Boolean valid = true;
    User sessionUser = (User)session.getAttribute("user");
    if(sessionUser != null)
    {
        logged = true;
        if(sessionUser.getType().equals("seller"))
        {
            venditore = true;
        }
    }
    else
    {
        if(request.getMethod().equals("POST"))
        {
            if(request.getParameter("Email") != null)
            {
                email = request.getParameter("Email");
                String emailRegex = "[^a-zA-Z0-9-_@.]";
                if(!StringUtils.isEmpty(email) && StringUtils.isValidString(email, emailRegex))
                {
                    if(request.getParameter("Password") != null)
                    {
                        password = request.getParameter("Password");
                        String passwordRegex = "[^a-zA-Z0-9-_]";
                        if(!StringUtils.isEmpty(password) && StringUtils.isValidString(password, passwordRegex))
                        {
                            UserDAO user;
                            User toSearch;
                            DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
                            if (daoFactory == null) 
                            {
                                throw new ServletException("Impossible to get dao factory for storage system");
                            }
                            try 
                            {
                                user = daoFactory.getDAO(UserDAO.class);
                                toSearch = user.getUserByEmail(email);
                            } 
                            catch (DAOFactoryException ex) 
                            {
                                throw new ServletException("Impossible to get dao factory for registration", ex);
                            }
                            if(toSearch.getUserId() != null)
                            {
                                String retreivedPass = toSearch.getPassword();
                                if(BCrypt.checkpw(password, retreivedPass))
                                {
                                    if(!toSearch.getVerificationCode().equals("1"))
                                    {
                                        
                                    }
                                    else
                                    {
                                        
                                        if(request.getParameter("wasPaying") != null)
                                        {
                                            response.sendRedirect("localhost/Progetto/Payment.jsp");
                                        }
                                        else
                                        {
                                            response.sendRedirect("Registration.jsp");
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    email = "";
                }
                valid = false;
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
        <title>Login Page</title>
        <link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
        <link href="css/bootstrap-theme.min.css" type="text/css" rel="stylesheet">
        <link href="css/LoginTheme.css" type="text/css" rel="stylesheet">
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
            <div class="row">
                <form id="registerForm" method="post" action="<%=request.getRequestURL() %>" class="form-horizontal">
                    <div class="col-xs-12 marginBottomFix">
                        <label class="col-xs-12">Fill the form an press the button to login</label>
                        <label class="col-xs-12">You need to be registered in order to login</label>
                        <p class="col-xs-12"><a href="Registration.jsp">Not registered? click here to register</a></p>
                    </div>
                    <div class="col-xs-12 col-sm-6 col-md-4">
                        <div class="form-group col-xs-12">
                            <%
                                if(!valid)
                                {
                                    %>
                                    <label class="col-xs-12 redText">The email and password you typed do not match any user</label>
                                    <%
                                }
                            %>
                            <label for="Email" class="col-xs-12">Email</label>
                            <div class="col-xs-12">
                                <input class="form-control" value="<%=email%>" type="email" name="Email" id="Email">
                            </div>
                        </div>
                        <div class="form-group col-xs-12">
                            <label for="Password" class="col-xs-12">Password</label>
                            <div class="col-xs-12">
                                <input class="form-control" type="password" name="Password" id="Password">
                            </div>
                        </div>
                        <div class="form-group col-xs-12"> 
                            <div class="col-xs-2">
                                <button type="submit" class="btn btn-default">Login</button>
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
