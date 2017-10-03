/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function autoCompleteSearchField()
{
    var xhttp;
    var searchBox;
    searchBox = document.getElementById("inputSearch");
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