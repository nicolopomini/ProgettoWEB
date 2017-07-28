<%-- 
    Document   : Registration
    Created on : 5-lug-2017, 15.46.04
    Author     : Marco
--%>


<%@page import="java.security.SecureRandom"%>
<%@page import="java.math.BigInteger"%>
<%@page import="utils.BCrypt"%>
<%@page import="persistence.utils.dao.exceptions.DAOFactoryException"%>
<%@page import="dao.UserDAO"%>
<%@page import="dao.entities.User"%>
<%@page import="utils.StringUtils"%>
<%@page import="persistence.utils.dao.factories.DAOFactory"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    boolean logged, venditore;
    logged = venditore = false;
    boolean validData = true;
    String tmpEmail, tmpPassword, tmpName, tmpSurname, tmpAddress;
    User toInsert = new User();
    
    session.setAttribute("user",null);
    if(session.getAttribute("user") == null)
    {
        if(request.getMethod().equals("POST"))
        {
            if(request.getParameter("Email") != null)
            {
                tmpEmail = request.getParameter("Email");
                String emailRegex = "[^a-zA-Z0-9-_@.]";
                if(!StringUtils.isValidString(tmpEmail,emailRegex) || StringUtils.isEmpty(tmpEmail))
                {
                    validData = false;
                }
            }
            else
            {
                throw new NullPointerException("Oops, You got on this page the wrong way");
            }
            
            if(request.getParameter("Password") != null)
            {
                tmpPassword = request.getParameter("Password");
                String passwordRegex = "[^a-zA-Z0-9-_]";
                if(!StringUtils.isValidString(tmpPassword,passwordRegex) || StringUtils.isEmpty(tmpPassword))
                {
                    validData = false;
                }
            }
            else
            {
                throw new NullPointerException("Oops, You got on this page the wrong way");
            }
            
            if(request.getParameter("Name") != null)
            {
                tmpName = request.getParameter("Name");
                String nameRegex = "[^a-zA-Z ]";
                if(!StringUtils.isValidString(tmpName,nameRegex) || StringUtils.isEmpty(tmpName))
                {
                    validData = false;
                }
            }
            else
            {
                throw new NullPointerException("Oops, You got on this page the wrong way");
            }
            
            if(request.getParameter("Surname") != null)
            {
                tmpSurname = request.getParameter("Surname");
                String surnameRegex = "[^a-zA-Z ]";
                if(!StringUtils.isValidString(tmpSurname,surnameRegex) || StringUtils.isEmpty(tmpSurname))
                {
                    validData = false;
                }
            }
            else
            {
                throw new NullPointerException("Oops, You got on this page the wrong way");
            }
            
            if(request.getParameter("Address") != null)
            {
                tmpAddress = request.getParameter("Address");
                String addressRegex = "[^a-zA-Z0-9, ]";
                if(!StringUtils.isValidString(tmpAddress,addressRegex) || StringUtils.isEmpty(tmpAddress))
                {
                    validData = false;
                }
            }
            else
            {
                throw new NullPointerException("Oops, You got on this page the wrong way");
            }
            
            if(validData)
            {
                toInsert.setUserId(null);
                toInsert.setEmail(tmpEmail);
                String hashedPassword = BCrypt.hashpw(tmpPassword, BCrypt.gensalt(12));
                toInsert.setPassword(hashedPassword);
                toInsert.setName(tmpName);
                toInsert.setSurname(tmpSurname);
                toInsert.setAddress(tmpAddress);
                toInsert.setType("registered");
                SecureRandom random = new SecureRandom();
                String verificationCode = new BigInteger(130, random).toString(32);
                toInsert.setVerificationCode(verificationCode);
                UserDAO user;
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
                    throw new ServletException("Impossible to get dao factory for shop storage system", ex);
                }
                user.add(toInsert);
            }
        }
    }
    else
    {
        logged = true;
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
                <% if(!logged) 
                {
                    if(request.getMethod().equals("POST"))
                    {
                        if(validData)
                        {
                %>
                
                <div class="col-xs-12">
                    <label>Registration completed.</label>
                </div>
                
                <%      }
                        else
                        {
                %>
                
                <div class="col-xs-12">
                    <label>Registration failed, please try again.</label>
                </div>
                
                <%      }
                    }
                    else
                    {
                %>
                <form method="post" action="<%=request.getRequestURL() %>" class="form-horizontal">
                    <div class="col-xs-12 marginBottomFix">
                        <label class="col-xs-12">Fill the form and press "Register" to create a new user</label>
                    </div>
                    <div class="col-xs-12 col-sm-6 col-md-4">
                        <div class="form-group col-xs-12">
                            <label for="Email" class="col-xs-12">Email</label>
                            <div class="col-xs-12">
                                <input class="form-control" type="email" name="Email" id="Email">
                            </div>
                        </div>
                        <div class="form-group col-xs-12">
                            <label for="Password" class="col-xs-12">Password</label>
                            <div class="col-xs-12">
                                <input class="form-control" type="password" name="Password" id="Password">
                            </div>
                        </div>
                        <div class="form-group col-xs-12">
                            <label for="example-text-input" class="col-xs-12">Name</label>
                            <div class="col-xs-12">
                                <input class="form-control" type="text" name="Name" id="Name">
                            </div>
                        </div>
                        <div class="form-group col-xs-12">
                            <label for="example-text-input" class="col-xs-12">Surname</label>
                            <div class="col-xs-12">
                                <input class="form-control" type="text" name="Surname" id="Surname">
                            </div>
                        </div>
                        <div class="form-group col-xs-12">
                            <label for="example-text-input" class="col-xs-12">Address</label>
                            <div class="col-xs-12">
                                <input class="form-control" type="text" name="Address" id="Address">
                            </div>
                        </div>
                        <div class="form-group col-xs-12"> 
                            <div class="col-xs-2">
                                <button type="submit" class="btn btn-default">Register</button>
                            </div>
                        </div>
                    </div>
                </form>
            <%      }
                } 
                else 
                {
            %>
            
                <div class="col-xs-12">
                    <label>Effettua il logout per accedere a questa pagina</label>
                </div>
            
            <%  } %>
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
