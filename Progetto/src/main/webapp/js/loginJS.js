/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


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
            else
                alert("Errore, qualcosa è andato storto");
        }
        else
            alert("Errore, qualcosa è andato storto");
    };
    xhttp.open("POST", "SendActivationEmail", true);
    xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    var toSend = encodeURIComponent(email);
    xhttp.send("Email="+toSend);
}