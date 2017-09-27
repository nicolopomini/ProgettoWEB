<%-- 
    Document   : passwordRecovery
    Created on : 19-Sep-2017, 11:51:17
    Author     : Dva
--%>

<%@page import="utils.BCrypt"%>
<%@page import="utils.MailUtils"%>
<%@page import="java.math.BigInteger"%>
<%@page import="java.security.SecureRandom"%>
<%@page import="persistence.utils.dao.exceptions.DAOException"%>
<%@page import="persistence.utils.dao.exceptions.DAOFactoryException"%>
<%@page import="persistence.utils.dao.factories.DAOFactory"%>
<%@page import="dao.UserDAO"%>
<%@page import="utils.StringUtils"%>
<%@page import="dao.entities.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    int hasEmail, hasToken, hasPassword;
    hasEmail = hasToken = hasPassword = -1;
    String email = "";
    String token = "";
    String password = "";
    User sessionUser = (User)session.getAttribute("user");
    DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
    if (daoFactory == null) 
    {
        throw new ServletException("Impossible to get dao factory for storage system");
    }
    if(sessionUser != null)
    {
        response.sendRedirect("index.jsp");
    }
    if(request.getParameter("Email") != null)
    {
        email = request.getParameter("Email");
        String emailRegex = "[^a-zA-Z0-9-_@.]";
        if(StringUtils.isValidString(email,emailRegex) && !StringUtils.isEmpty(email))
        {
            UserDAO user;
            User toSearch = null;
            try 
            {
                user = daoFactory.getDAO(UserDAO.class);
                toSearch = user.getUserByEmail(email);
            } 
            catch (DAOFactoryException ex) 
            {
                throw new ServletException("Impossible to get dao factory for user activation", ex);
            } 
            catch (DAOException ex) 
            {
                throw new ServletException("Impossible to get dao factory for user activation", ex);
            }
            if(toSearch.getUserId() != null)
            {
                hasEmail = 1;
                SecureRandom random = new SecureRandom();
                String newToken = new BigInteger(130, random).toString(32);
                toSearch.setToken(newToken);
                user.update(toSearch);
                MailUtils.sendPasswordResetEmail(toSearch);
            }
        }
        else
        {
            hasEmail = 0;
        }
    }
    else
    if(request.getParameter("Token") != null)
    {
        token = request.getParameter("Token");
        String tokenRegex = "[^a-zA-Z0-9]";
        if(StringUtils.isValidString(token,tokenRegex) && !StringUtils.isEmpty(token))
        {
            UserDAO user;
            User toUpdate = null;
            try 
            {
                user = daoFactory.getDAO(UserDAO.class);
                toUpdate = user.getUserByToken(token);
            } 
            catch (DAOFactoryException ex) 
            {
                throw new ServletException("Impossible to get dao factory for user activation", ex);
            }
            catch (DAOException ex)
            {
                throw new ServletException("Impossible to get dao factory for user activation", ex);
            }
            if(toUpdate.getUserId() != null)
            {
                hasToken = 1;
                if(request.getParameter("Password") != null)
                {
                    password = request.getParameter("Password");
                    String passwordRegex = "[^a-zA-Z0-9-_]";
                    if(StringUtils.isValidString(password,passwordRegex) && !StringUtils.isEmpty(password))
                    {
                        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));
                        toUpdate.setPassword(hashedPassword);
                        toUpdate.setToken("");
                        user.update(toUpdate);
                        hasPassword = 1;
                    }
                    else
                    {
                        hasPassword = 0;
                    }
                }
            }
            else
            {
                hasToken = 0;
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
        <link href="css/LoginTheme.css" type="text/css" rel="stylesheet">
        <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
        <title>Password Recovery</title>
    </head>
    <body>
        <div class="container">
            <jsp:include page="Header.jsp"/>
            <div class="row">
                <%
                    if(hasEmail == 1)
                    {
                        %>
                        <div class="col-xs-12">
                            <p>Una email contenente un codice per eseguire il reset della password è stata inviata all'indirizzo "<%=email%>"</p>
                        </div>
                        <%
                    }
                    else if(hasToken != 1)
                    {
                        if(hasToken == 0)
                        {
                            %>
                            <div class="col-xs-12">
                                <p class="redText">The inserted token is not valid.</p>
                            </div>
                            <%
                        }
                        %>
                        <form method="post" action="<%=request.getRequestURL()%>" class="form-horizontal">
                            <div class="col-xs-12 marginBottomFix">
                                <label class="col-xs-12">Insert the email you registered with</label>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4">
                                <div class="form-group col-xs-12">
                                    <%
                                        if(hasEmail == 0)
                                        {
                                            %>
                                            <label class="col-xs-12 redText">The Email you typed contains invalid characters</label>
                                            <%
                                        }
                                    %>
                                    <div class="col-xs-12">
                                        <input class="form-control" type="email" name="Email">
                                    </div>
                                </div>
                                <div class="form-group col-xs-12"> 
                                    <div class="col-xs-6">
                                        <button type="submit" class="btn btn-default">Reset</button>
                                    </div>
                                </div>
                            </div>
                        </form>
                        <%
                    }
                    else if(hasPassword != 1)
                    {
                        %>
                        <form method="post" action="<%=request.getRequestURL()%>" class="form-horizontal">
                            <div class="col-xs-12 marginBottomFix">
                                <label class="col-xs-12">Insert your new password</label>
                            </div>
                            <div class="col-xs-12 col-sm-6 col-md-4">
                                <div class="form-group col-xs-12">
                                    <%
                                        if(hasPassword == 0)
                                        {
                                            %>
                                            <label class="col-xs-12 redText">The Password you typed contains invalid characters</label>
                                            <%
                                        }
                                    %>
                                    <div class="col-xs-12">
                                        <input class="form-control" type="password" name="Password">
                                    </div>
                                    <div class="col-xs-12">
                                        <input class="form-control" type="hidden" name="Token" value="<%=token%>">
                                    </div>
                                </div>
                                <div class="form-group col-xs-12"> 
                                    <div class="col-xs-6">
                                        <button type="submit" class="btn btn-default">Reset</button>
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
                            <p>La password è stata resettata con successo.</p>
                        </div>
                        <%
                    }
                %>
            </div>
            <jsp:include page="Footer.jsp"/>
        </div>
    </body>
</html>

