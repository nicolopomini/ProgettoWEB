/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function addToCart(id,name)
{
    var xhttp;
    var modal;
    modal = document.getElementById("confirmModal");
    xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200)
        {
            if(this.responseText == "added")
            {
                $('#modal-text').text("Item '"+name+"' has been added to the cart");
                $('#modal-title').text("Item added");
                $('#modal-cart-btn').show();
                $('#confirm-modal').modal({show: true});
            }
        }
    };
    xhttp.open("POST", "AddToCart", true);
    xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhttp.send("itemid="+id);
}

function addComment(id,name)
{
    var xhttp;
    var modal;
    var commentDiv;
    var commentText;
    var itemScore;
    modal = document.getElementById("confirmModal");
    commentDiv = document.getElementById("comments");
    commentText = document.getElementById("comment-text");
    itemScore = document.getElementById("item-score");
    xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200)
        {
            if(this.responseText != "")
            {
                $('#modal-text').text("Your comment for the item'"+name+"' has been added succesfully");
                $('#modal-title').text("Comment added");
                $('#modal-cart-btn').hide();
                $('#confirm-modal').modal({show: true});
            }
        }
    };
    xhttp.open("POST", "ItemComment", true);
    xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhttp.send("itemid="+id+"&itemscore="+itemScore.options[itemScore.selectedIndex].value+"&newcomment="+commentText.value);
}