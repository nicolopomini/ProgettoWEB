<%--
  User: Michele
  Date: 02/08/2017
  Time: 11:31
--%>
<%@page import="java.util.HashMap"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="dao.entities.User"%>
<%
    User sessionUser = (User)session.getAttribute("user");
    boolean logged = (sessionUser != null);
    HashMap<Integer,Integer> cart = (HashMap<Integer,Integer>) session.getAttribute("cart");

%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Payment method</title>
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js" integrity="sha384-b/U6ypiBEHpOf/4+1nzFpr53nxSS+GLCkfwBdFNTxtclqqenISfwAzpKaMNFNmj4" crossorigin="anonymous"></script>
        <script src="js/bootstrap.min.js"></script>
        <link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
        <link href="css/bootstrap-theme.min.css" type="text/css" rel="stylesheet">
        <link href="css/stickyfooter.css" type="text/css" rel="stylesheet">
    </head>
    <body>
        <script type="text/javascript">
            function showDiv(radioselect) {
                if(radioselect == "Card"){
                    document.getElementById("Card").setAttribute("class","form-group");
                    document.getElementById("Card").focus();
                }else{
                    document.getElementById("Card").setAttribute("class","form-group collapse");
                }
            }

            function detectCardType(number) {
                var re = {
                    electron: /^(4026|417500|4405|4508|4844|4913|4917)\d+$/,
                    maestro: /^(5018|5020|5038|5612|5893|6304|6759|6761|6762|6763|0604|6390)\d+$/,
                    dankort: /^(5019)\d+$/,
                    visa: /^4[0-9]{12}(?:[0-9]{3})?$/,
                    mastercard: /^5[1-5][0-9]{14}$/,
                    amex: /^3[47][0-9]{13}$/,
                    diners: /^3(?:0[0-5]|[68][0-9])[0-9]{11}$/,
                    discover: /^6(?:011|5[0-9]{2})[0-9]{12}$/,
                    jcb: /^(?:2131|1800|35\d{3})\d{11}$/
                }
                number = number.replace(/\s+/g, '')
                for(var key in re) {
                    if(re[key].test(number)) {
                        return key
                    }
                }
                return "credit"
            }

            function updateImage(){
                document.getElementById("cardimg").src = "resources/icons/" + detectCardType(document.getElementById("cardno").value) +".png";
            }

            function checkCC(s) {
                var i, n, c, r, t, card;
                s = s.replace(/\s+/g, '');
                r = "";
                for (i = 0; i < s.length; i++) {
                    c = parseInt(s.charAt(i), 10);
                    if (c >= 0 && c <= 9)
                        r = c + r;
                    else if(!c==" ")
                        return false;
                }

                if (r.length <= 1)
                    return false;

                t = "";
                for (i = 0; i < r.length; i++) {
                    c = parseInt(r.charAt(i), 10);
                    if (i % 2 != 0)
                        c *= 2;
                    t = t + c;
                }

                n = 0;
                for (i = 0; i < t.length; i++) {
                    c = parseInt(t.charAt(i), 10);
                    n = n + c;
                }

                return (n != 0 && n % 10 == 0);
            }

            function checkAndSend(){
                card = document.getElementById('cardno').value.replace(/\s+/g, '');
                toggleVisibility("error",false);
                if(!document.getElementById("typeCOD").checked)
                {
                    if(document.getElementById("owner").value==""){
                        toggleVisibility("error",true);
                        document.getElementById('error').innerHTML = "Owner cannot be empty";
                    }else if(document.getElementById("CVV").value==""){
                        toggleVisibility("error",true);
                        document.getElementById('error').innerHTML = "CVV cannot be empty";
                    }else if(checkCC(card)){
                        document.getElementById("form-payment").submit();
                    } else{
                        toggleVisibility("error",true);
                        document.getElementById('error').innerHTML = "Invalid Credit Card Number";
                    }
                }
                else
                {
                    document.getElementById("form-payment").submit();
                }
                //document.write(detectCardType(card));
            }
            
            function toggleVisibility(id, visible){
                var elem = document.getElementById(id);
                if(visible){
                    document.getElementById(id).setAttribute("class","alert alert-danger");
                }else{
                   document.getElementById(id).setAttribute("class","alert alert-danger collapse");
                 
                }
            }
        </script>
        <!-- Menu -->
        <jsp:include page="Header.jsp"/>
        <div class="container-fluid containerFix">
                    <% if(!logged)
                            response.sendRedirect("/login.jsp");
                        if(cart == null || cart.isEmpty()) { //carrello vuoto%>
                    <h2 style="text-align: center">Il carrello è vuoto</h2>
                    <% } else { //carrello pieno%>
                    <div class="row">
                    <div class="col-12 col-sm-10 col-lg-8 leftPaddingZero">
                    <h1>Seleziona il metodo di pagamento:</h1>
                        <br/>
                    <form action="OrderSummary.jsp" id="form-payment" name="payment-info" method="post">
                            <div class="form-check form-check-inline">
                                <label class="form-check-label" for="typeCOD">
                                    <input class="form-check-input" type="radio" id="typeCOD" name="type" value="cod" onClick="showDiv('');">
                                    C.O.D.
                                    <img src="resources/icons/money.png" height="22">
                                </label>
                                
                            </div>
                            <div class="form-check form-check-inline">
                                <label class="form-check-label" for="typeCC">
                                    <input class="form-check-input" type="radio" id="typeCC" name="type" value="card" onClick="showDiv('Card');">
                                    Credit Card
                                    <img src="resources/icons/credit.png" height="22">  
                                </label>
                            </div>
                        <br/>
                                <div id="Card" class="collapse">
                                    <div class="form-group">
                                        
                                        <div class="alert alert-danger collapse" id="error" ></div>
                                            <label for="cardno">Card Number:</label>
                                        <div class="form-row">
                                            <div class="col-10">
                                                <input class="form-control" type="text" oninput="updateImage()" name="cardno" id="cardno">
                                            </div>
                                            <div class="col">
                                                <img id="cardimg" src="resources/icons/credit.png">
                                            </div>
                                                
                                        </div>
                                    </div>
                                    <label for="owner">Owner Name:</label>
                                    <input class="form-control" type="text"  id="owner" name="owner"><br/>
                                    <label>Expiration Date:</label>
                                    
                                    <div class="form-group form-row">
                                        <div class="col">
                                            <select class="form-control" name="exp-month">
                                                <option value="01">01</option>
                                                <option value="02">02</option>
                                                <option value="03">03</option>
                                                <option value="04">04</option>
                                                <option value="05">05</option>
                                                <option value="06">06</option>
                                                <option value="07">07</option>
                                                <option value="08">08</option>
                                                <option value="09">09</option>
                                                <option value="10">10</option>
                                                <option value="11">11</option>
                                                <option value="12">12</option>
                                            </select>
                                        </div>
                                        <div class="col">
                                            <select class="form-control" name="exp-year">
                                                <option value="17">2017</option>
                                                <option value="18">2018</option>
                                                <option value="19">2019</option>
                                                <option value="20">2020</option>
                                                <option value="21">2021</option>
                                                <option value="22">2022</option>
                                                <option value="23">2023</option>
                                                <option value="24">2024</option>
                                                <option value="25">2025</option>
                                                <option value="26">2026</option>`
                                                <option value="27">2027</option>
                                                <option value="28">2028</option>
                                                <option value="29">2029</option>
                                                <option value="30">2030</option>
                                            </select>
                                        </div>
                                    </div>
                                    <label>Security Code:</label> <input class="form-control" type="text" maxlength="4" id="CVV"  name="CVV">
                                </div>
                        <br/><br/>
                        <button class="btn btn-success" type="button" onclick="checkAndSend()" name="submit">Conferma</button>
                    </form>
                    </div>
                    </div>
                    
                        <% } %>
        </div>
        <!--Footer-->
        <jsp:include page="Footer.jsp"/>
    </body>
</html>