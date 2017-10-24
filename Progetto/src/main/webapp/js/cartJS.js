/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function addRemoveItem(action,id)
{
    var xhttp;
    var table;
    table = document.getElementById("cartDiv");
    xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200)
        {
            table.innerHTML = this.responseText;
        }
    };
    xhttp.open("POST", "CartManager", true);
    xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhttp.send("Action="+action+"&Id="+id);
}

