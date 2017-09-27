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
    User sessionUser = (User)session.getAttribute("user");
    if(sessionUser != null)
    {
        logged = true;
        if(sessionUser.getType().equals("seller"))
        {
            venditore = true;
        }
    }
    String activationCode = "";
    boolean validCode = true;
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
            toUpdate = user.getUserByVerificationCode(activationCode);
            if(toUpdate.getUserId() != null)
            {
                toUpdate.setVerificationCode("1");
                user.update(toUpdate);
                session.setAttribute("user", toUpdate);
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
        <title>Account activation</title>
    </head>
    <body>
        <div class="container">
            <jsp:include page="Header.jsp"/>
            <%
                if(validCode)
                {
            %>
            <div class="row">
                <div class="col-xs-12">
                    <label>Your account has been activated</label>
                    <p>You will now be able to access your customer area and buy our products</p>
                    <p id="redirectTimer"></p>
                    <script>
                        function timedRedirect(timeLeft)
                        {
                            document.getElementById("redirectTimer").innerHTML = "An automatic redirect to the home page will happen in " + timeLeft;
                            if(timeLeft > 0)
                            {
                                setTimeout(function() {timedRedirect(timeLeft-1)},1000);
                            }
                            else
                            {
                                window.location.replace("index.jsp");
                            }
                        }
                        timedRedirect(8);
                    </script>
                </div>
            </div>
            <% } else { %>
            <div class="row">
                <div class="col-xs-12">
                    <label>Something went wrong</label>
                </div>
            </div>
            <% } %>
            <jsp:include page="Footer.jsp"/>
        </div>
    </body>
</html>
