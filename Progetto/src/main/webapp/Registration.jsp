<%-- 
    Document   : Registration
    Created on : 5-lug-2017, 15.46.04
    Author     : Marco
--%>

<%@page import="utils.MailUtils"%>
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
    User sessionUser = (User)session.getAttribute("user");
    if(sessionUser != null)
    {
        logged = true;
        if(sessionUser.getType().equals("seller"))
        {
            venditore = true;
        }
    }
    boolean validData = true;
    String tmpEmail, tmpPassword, tmpName, tmpSurname, tmpAddress;
    tmpEmail = tmpPassword = tmpName = tmpSurname = tmpAddress = "";
    User toInsert = new User();
    
    String previousPage = "home.jsp";
    if(request.getHeader("Referer") != null)
    {
        previousPage = request.getHeader("Referer");
    }

    if(!logged)
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
                if(!StringUtils.isValidString(tmpPassword,passwordRegex) || StringUtils.isEmpty(tmpPassword) || tmpPassword.length() < 8)
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
                User toSearch;
                toInsert.setUserId(null);
                toInsert.setEmail(tmpEmail);
                String hashedPassword = BCrypt.hashpw(tmpPassword, BCrypt.gensalt(12));
                toInsert.setPassword(hashedPassword);
                toInsert.setName(tmpName);
                toInsert.setSurname(tmpSurname);
                toInsert.setAddress(tmpAddress);
                toInsert.setType("registered");
                toInsert.setToken("");
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
                    toSearch = user.getUserByEmail(tmpEmail);
                } 
                catch (DAOFactoryException ex) 
                {
                    throw new ServletException("Impossible to get dao factory for registration", ex);
                }
                if(toSearch.getUserId() == null)
                {
                    user.add(toInsert);
                }
                else
                {
                    validData = false;
                }
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
            <!-- Menu -->
            <div class="row">
                <div class="col-12">
                    <h1>Registrazione</h1>
                    <% if(!logged) 
                    {
                        if(request.getMethod().equals("POST"))
                        {
                            if(validData)
                            {
                    %>
                    <label>Registrazione effettuata con successo</label>
                    <p class="redText">ATTENZIONE: Per cominciare ad usare il tuo account devi prima attivarlo. Una email di conferma è stata inviata all'indirizzo "<%=tmpEmail%>", clicca sul bottone contenuto nella email per attivare il tuo account.</p>
                    <script>
                        function sendActivationEmail(email)
                        {
                            var xhttp;
                            var label;
                            label = document.getElementById("emailSent");
                            xhttp = new XMLHttpRequest();
                            xhttp.onreadystatechange = function () {
                                if (this.readyState == 4 && this.status == 200)
                                {
                                    if(this.responseText == "sent")
                                    {
                                        label.setAttribute("style","display:block");
                                    }
                                }
                            };
                            xhttp.open("POST", "SendActivationEmail", true);
                            xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                            var toSend = encodeURIComponent(email);
                            xhttp.send("Email="+toSend);
                        }
                        sendActivationEmail("<%=tmpEmail%>");
                    </script>
                    <%      }
                            else
                            {
                    %>
                    <label>Oops, qualcosa è andato storto</label>
                    <%
                            }
                        }
                        else
                        {
                    %>
                    <form id="registerForm" method="post" action="<%=request.getRequestURL() %>" class="form-horizontal">
                        <div class="marginBottomFix">
                            <h6>Compila il form e clicca "Registrati" per creare un account</h6>
                        </div>
                        <div class="col-12 col-sm-7 col-lg-4 leftPaddingZero">
                            <div class="form-group">
                                <div class="alert alert-danger collapse" id="EmailError"></div>
                                <label for="Email">Email</label>
                                <input oninput="isUniqueEmail()" class="form-control" type="email" name="Email" id="Email">
                            </div>
                            <div class="form-group">
                                <div class="alert alert-danger collapse" id="PasswordError"></div>
                                <label for="Password">Password</label>
                                <input class="form-control" type="password" name="Password" id="Password">
                            </div>
                            <div class="form-group">
                                <div class="alert alert-danger collapse" id="NameError"></div>
                                <label for="Name">Nome</label>
                                <input class="form-control" type="text" name="Name" id="Name">
                            </div>
                            <div class="form-group">
                                <div class="alert alert-danger collapse" id="SurnameError"></div>
                                <label for="Surname">Cognome</label>
                                <input class="form-control" type="text" name="Surname" id="Surname">
                            </div>
                            <div class="form-group">
                                <div class="alert alert-danger collapse" id="AddressError"></div>
                                <label for="Address">Indirizzo</label>
                                <input class="form-control" type="text" name="Address" id="Address">
                            </div>
                            <div class="form-group"> 
                                <span onclick="registerAttempt()" class="btn btn-success">Registrati</span>
                                <span onclick="goBack()" style="float:right;" class="btn btn-danger">Annulla</span>
                            </div>
                        </div>
                    </form>
            <%      }
                } 
                else 
                {
            %>
                <label>Effettua il logout per accedere a questa pagina</label>
            <%  } %>
                </div>
            </div>
        </div>
        <jsp:include page="Footer.jsp"/>
        <script src="js/registrationJS.js"></script>
    </body>
</html>
