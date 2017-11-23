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
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js" integrity="sha384-b/U6ypiBEHpOf/4+1nzFpr53nxSS+GLCkfwBdFNTxtclqqenISfwAzpKaMNFNmj4" crossorigin="anonymous"></script>
        <link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
        <script src="js/bootstrap.min.js"></script>
        <link href="css/LoginTheme.css" type="text/css" rel="stylesheet">
        <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
        <title>Password Recovery</title>
    </head>
    <body>
        <jsp:include page="Header.jsp"/>
        <div class="container-fluid containerFix">
            <div class="row">
                <div class="col-12">
                <h1>Password recovery</h1>
                    <%
                        if(hasEmail == 1)
                        {
                            %>
                                <p>Una email contenente un codice per eseguire il reset della password è stata inviata all'indirizzo "<%=email%>"</p>
                            <%
                        }
                        else if(hasToken != 1)
                        {
                            if(hasToken == 0)
                            {
                                %>
                                    <p class="redText">The inserted token is not valid.</p>
                                <%
                            }
                            %>
                            <form method="post" action="<%=request.getRequestURL()%>" class="form-horizontal">
                                <label>Inserisci la email con la quale ti sei registrato</label>
                                <div class="col-12 col-sm-7 col-lg-4 leftPaddingZero">
                                    <div class="form-group">
                                        <%
                                            if(hasEmail == 0)
                                            {
                                                %>
                                                <label class="redText">La email inserita contiene caratteri invalidi</label>
                                                <%
                                            }
                                        %>
                                        <input class="form-control" type="email" name="Email">
                                    </div>
                                    <div class="form-group"> 
                                        <button type="submit" class="btn btn-success">Reset</button>
                                    </div>
                                </div>
                            </form>
                            <%
                        }
                        else if(hasPassword != 1)
                        {
                            %>
                            <form method="post" action="<%=request.getRequestURL()%>" class="form-horizontal">
                                <label>Inserisci la tua nuova password</label>
                                <div class="col-12 col-sm-7 col-lg-4 leftPaddingZero">
                                    <div class="form-group">
                                        <%
                                            if(hasPassword == 0)
                                            {
                                                %>
                                                <label class="redText">La password inserita contiene caratteri invalidi</label>
                                                <%
                                            }
                                        %>
                                        <input class="form-control" type="password" name="Password">
                                        <input class="form-control" type="hidden" name="Token" value="<%=token%>">
                                    </div>
                                    <div class="form-group"> 
                                        <button type="submit" class="btn btn-success">Reset</button>
                                    </div>
                                </div>
                            </form>
                            <%
                        }
                        else
                        {
                            %>
                            <p class="greenText">La password è stata resettata con successo.</p>
                            <%
                        }
                    %>
                </div>
            </div>
        </div>
        <jsp:include page="Footer.jsp"/>
    </body>
</html>

