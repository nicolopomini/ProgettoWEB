<%-- 
    Document   : login
    Created on : 1-ago-2017, 16.52.28
    Author     : Marco
--%>

<%@page import="utils.MailUtils"%>
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
    Boolean active = true;
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
                                        active = false;
                                        MailUtils.sendActivationEmail(toSearch);
                                    }
                                    else
                                    {
                                        session.setAttribute("user", toSearch);
                                        response.sendRedirect("/Progetto/login.jsp");
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
        <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
    </head>
    <body>
        <div class="container">
            <jsp:include page="Header.jsp"/>
            <div class="row">
                <%
                    if(!logged)
                    {
                        if(active)
                        {
                %>
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
                            <div class="col-xs-6">
                                <button type="submit" class="btn btn-default">Login</button>
                            </div>
                            <div class="col-xs-6">
                                <span onclick="goBack()" style="float:right;" class="btn btn-danger">Cancel</a>
                            </div>
                        </div>
                    </div>
                </form>
                <%
                        }
                        else
                        {
                %>
                <div class="col-xs-12">
                    <label>Your account needs to be activated first!</label>
                    <p class="redText">WARNING: To start using your account you will need to activate it. An activation email has been sent to the address "<%=email%>", click on the button contained in the email to activate your account</p>
                </div>
                <%
                        }
                    }
                    else
                    {
                %>
                <div class="col-xs-12">
                    <label>Effettua il logout per accedere a questa pagina</label>
                </div>
                <%
                    }
                %>
            </div>
            <jsp:include page="Footer.jsp"/>
        </div>
        <script src="js/registrationJS.js"></script>
    </body>
</html>
