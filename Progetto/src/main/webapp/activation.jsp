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
    boolean validCode = false;
    if(request.getParameter("ActivationCode") != null)
    {
        validCode = true;
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
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js" integrity="sha384-b/U6ypiBEHpOf/4+1nzFpr53nxSS+GLCkfwBdFNTxtclqqenISfwAzpKaMNFNmj4" crossorigin="anonymous"></script>
        <link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
        <script src="js/bootstrap.min.js"></script>
        <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
        <title>Account activation</title>
    </head>
    <body>
        <jsp:include page="Header.jsp"/>
        <div class="container-fluid containerFix">
            <%
                if(validCode)
                {
            %>
            <div class="row">
                <div class="col-12">
                    <h1>Activation</h1>
                    <label class="greenText">Il tuo account è stato attivato con successo</label>
                    <p>Puoi ora acquistare ed accedere alla tua area personale per modificare i tuoi dati</p>
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
                <div class="col-12">
                    <label>Something went wrong</label>
                </div>
            </div>
            <% } %>
        </div>
        <jsp:include page="Footer.jsp"/>
    </body>
</html>
