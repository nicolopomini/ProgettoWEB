<%-- 
    Document   : passwordRecovery
    Created on : 19-Sep-2017, 11:51:17
    Author     : Dva
--%>

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
    String Password = "";
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
        if(!StringUtils.isValidString(email,emailRegex) || StringUtils.isEmpty(email))
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
            if(toSearch.getUserId() == null)
            {
                hasEmail = 1;
            }
        }
    }
    else
    if(request.getParameter("Token") != null)
    {
        token = request.getParameter("Token");
        String tokenRegex = "[^a-zA-Z0-9]";
        if(!StringUtils.isValidString(token,tokenRegex) || StringUtils.isEmpty(token))
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
            if(toSearch.getUserId() == null)
            {
                hasEmail = 1;
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
        <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
        <title>Password Recovery</title>
    </head>
    <body>
        <div class="container">
            <jsp:include page="Header.jsp"/>
            <div class="row">
                
            </div>
            <jsp:include page="Footer.jsp"/>
        </div>
    </body>
</html>

