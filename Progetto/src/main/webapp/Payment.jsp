<%--
  User: Michele
  Date: 02/08/2017
  Time: 11:31
--%>
<%@page import="java.util.HashMap"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    boolean logged = false;
    HashMap<Integer,Integer> cart = (HashMap<Integer,Integer>) session.getAttribute("cart");


%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Carrello</title>
    <link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
    <link href="css/bootstrap-theme.min.css" type="text/css" rel="stylesheet">
</head>
<body>
<script type="text/javascript">
    function showDiv(radioselect) {
        document.getElementById("COD").style.visibility = 'hidden';
        document.getElementById("Card").style.visibility = 'hidden';
        document.getElementById(radioselect).style.visibility = 'visible';
        document.getElementById(radioselect).focus();
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
        var i, n, c, r, t;
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

    function check(){
        card = '6360000000000000';
        alert(checkCC(card));
        //document.write(detectCardType(card));
    }
</script>
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
                    <% if(logged) { %>
                    <li><a href="#">Nome e Cognome</a></li>
                    <li><a href="#">Esci</a></li>
                    <% }else {%>
                    <li><a href="#">Login</a></li>
                    <li><a href="#">Registrati</a></li>
                    <% } %>
                </ul>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>
<% if(cart == null || cart.isEmpty()) { //carrello vuoto%>
<h2 style="text-align: center">Il carrello è vuoto</h2>
<% } else { //carrello pieno%>
<h1>Seleziona il metodo di pagamento:</h1>
<form action="Checkout" name="payment-info" method="post">
    <input type="radio" name="type" value="cod" onClick="showDiv('COD');">C.O.D.   <img src="resources/icons/money.png" height="22">
    <div id="COD" style="visibility:hidden">
        asdasd
        asdasd
        asdasd
    </div>
    <input type="radio" name="type" value="card" onClick="showDiv('Card');">Credit Card    <img src="resources/icons/credit.png" height="22">
    <div id="Card" style="visibility:hidden">
        Card Number: <input type="text" onchange="updateImage()" name="cardno" id="cardno"> <img id="cardimg" src="resources/icons/credit.png"><br/>
        Owner Name: <input type="text"  name="owner"><br/>
        Expiration Date:
        <select name="expiry-month">
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
        <select name="expiry-year">
            <option value="17">2017</option>
            <option value="18">2018</option>
            <option value="19">2019</option>
            <option value="20">2020</option>
            <option value="21">2021</option>
            <option value="22">2022</option>
            <option value="23">2023</option>
            <option value="13">2024</option>
            <option value="14">2025</option>
            <option value="15">2026</option>`
            <option value="16">2027</option>
            <option value="13">2028</option>
            <option value="14">2029</option>
            <option value="15">2030</option>
        </select></br>
        Security Code: <input type="text" maxlength="4"  name="CVV">
    </div>
    <input type="submit" value="Conferma" name="submit">
</form>
<% } %>
    <!--Footer-->
    <footer class="footer">
        <center>
            <p class="text-muted">Footer content</p>
        </center>
    </footer>
</div>
</body>
</html>