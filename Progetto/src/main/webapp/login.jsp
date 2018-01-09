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
    String toRedirect = "";
    Boolean valid = true;
    Boolean active = true;
    User sessionUser = (User)session.getAttribute("user");
    if(request.getParameter("ToRedirect") != null)
    {
        toRedirect = request.getParameter("ToRedirect");
    }
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
                                    }
                                    else
                                    {
                                        session.setAttribute("user", toSearch);
                                        if(!toRedirect.equals(""))
                                        {
                                            response.sendRedirect(toRedirect);
                                        }
                                        else
                                        {
                                            response.sendRedirect("index.jsp");
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
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js" integrity="sha384-b/U6ypiBEHpOf/4+1nzFpr53nxSS+GLCkfwBdFNTxtclqqenISfwAzpKaMNFNmj4" crossorigin="anonymous"></script>
        <link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
        <script src="js/bootstrap.min.js"></script>
        <link href="css/LoginTheme.css" type="text/css" rel="stylesheet">
        <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="Header.jsp"/>
        <div class="container-fluid containerFix">
            <div class="row">
                <div class="col-12">
                    <h1>Login</h1>
                <%
                    if(!logged)
                    {
                        if(active)
                        {
                %>
                <form id="registerForm" method="post" action="<%=request.getRequestURL() %>" class="form-horizontal">
                    <h6>Inserisci il tuo username e la tua password per entrare</h6>
                    <div class="col-12 col-sm-7 col-lg-4 leftPaddingZero">
                        <div class="marginBottomFix">
                            <p><a href="Registration.jsp">Non sei registrato? Clicca qui per registrarti.</a></p>
                        </div>
                        <div class="form-group">
                            <%
                                if(!valid)
                                {
                                    %>
                                    <div class="alert alert-danger">L'email e la password inseriti non corrispondono a nesssun account</div>
                                    <%
                                }
                            %>
                            <label for="Email">Email</label>
                            <input class="form-control" value="<%=email%>" type="email" name="Email" id="Email">
                        </div>
                        <div class="form-group">
                            <label for="Password">Password</label>
                            <input class="form-control" type="password" name="Password" id="Password">
                            <%
                                if(!toRedirect.equals(""))
                                {
                                    %>
                                        <input class="form-control" type="hidden" name="ToRedirect" value="<%=toRedirect%>" id="ToRedirect">
                                    <%
                                }
                                else
                                {
                                    %>
                                        <input class="form-control" type="hidden" name="ToRedirect" id="ToRedirect">
                                        <script>
                                            var input = document.getElementById("ToRedirect");
                                            input.value = document.referrer;
                                        </script>
                                    <%
                                }
                            %>
                        </div>
                        <div class="form-group"> 
                            <div class="marginBottomFix">
                                <a href='passwordRecovery.jsp'>Ho dimenticato la mia password.</a>
                            </div>
                            <button type="submit" class="btn btn-success">Login</button>
                            <span onclick="goBack()" style="float:right;" class="btn btn-danger">Cancel</span>
                        </div>
                    </div>
                </form>
                <%
                    }
                    else
                    {
                %>
                    <label>Il tuo account deve essere attivato</label>
                    <p class="redText">ATTENZIONE: Per cominciare ad utilizzare il tuo account devi prima attivarlo. Clicca sul bottone qui sotto per reinviare una email di conferma.</p>
                    <button onclick="sendActivationEmail('<%=email%>')" class="btn btn-success marginBottomFix">Send Activation</button>
                    <p class="hiddenText" id="emailSent">Una email di conferma è stata inviata all'indirizzo "<%=email%>".</p>
                <%
                        }
                    }
                    else
                    {
                %>
                    <label>Effettua il logout per accedere a questa pagina</label>
                <%
                    }
                %>
                </div>
            </div>
        </div>
        <jsp:include page="Footer.jsp"/>
        <script src="js/registrationJS.js"></script>
        <script src="js/loginJS.js"></script>
    </body>
</html>
