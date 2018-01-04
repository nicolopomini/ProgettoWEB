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

function addComment(id,name, canReply)
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
            if(this.responseText != null)
            {
                var risposta = JSON.parse(this.responseText);
                $('#modal-text').text("Il tuo commento per l'item '"+name+"' è stato aggiunto con successo");
                $('#modal-title').text("Commento aggiunto");
                $('#modal-cart-btn').hide();
                $('#confirm-modal').modal({show: true});
                var avg = risposta.avg;
                var avgScore = risposta.avgScore;
                var review = risposta.ItemReview;
                document.getElementById("addcomment").reset();
                var title = document.getElementById("avg-title");
                if(title == null) { //primo commento
                    var testo = 
                            "<div class=\" col col-xs-12\" ><div id=\"comments\">" +
                                "<h5 id=\"avg-title\">Valutazione media degli utenti: " + avgScore + "/5</h5>" +
                                '<div class="progress">' +
                                    '<div id="progress" class="progress-bar" role="progressbar" style="width: ' + avg + '%" aria-valuenow="' + avg + '" aria-valuemin="0" aria-valuemax="100"></div>'+
                                '</div>' +
                                "<div id=\"commenti\">" +
                                review.reviewTime + ": " + review.score + "/5" +
                                "<ul class=\"list-group\" id=\"" + review.itemReviewId + "\">" +
                                        "<li class=\"list-group-item\"><b>" + review.authorName + " " + review.authorSurname + "</b>: " + review.reviewText + "</li>";
                                        if(canReply == "true") {
                                            testo += 
                                                                '<form id="form-reply" class="form-inline" method="POST">' +
                                                                    '<div class="form-group">' +
                                                                      '<input type="text" class="form-control" placeholder="Rispondi al commento" name="replycomment" id="replycomment-'+ review.itemReviewId +'" required>' +
                                                                    '</div>' +
                                                                    '<span class="btn btn-sm btn-success" style="cursor:pointer;" onclick="addReply(\''+review.itemReviewId+'\',\''+id+'\')">Invia</span>' +
                                                                '</form>';
                                        }
                                testo += "</div>"+
                            "</div>" + 
                            '<form class="form-inline" method="POST" id="addcomment">'+
                                '<div class="form-group">'+
                                    '<input type="text" class="form-control" placeholder="Inserisci un commento" name="newcomment" id="comment-text" required>'+
                                  'Voto:'+
                                    '<select class="form-control" name="score" id="item-score">';
                                      for(var i = 1; i <= 5; i++) { 
                                      testo += '<option value="'+ i +'">'+ i +'</option>'; 
                                    }
                                  testo += '</select>' +
                                '</div>'+
                                  '<span class="btn btn-sm btn-success" style="cursor:pointer;" onclick="addComment(\''+id+'\',\''+name+'\',\''+canReply+'\')">Invia</span>'+
                              '</form>';
                    document.getElementById("comments-wrapper").innerHTML = testo;
                }
                else {
                    title.innerHTML = "Valutazione media degli utenti: " + avgScore + "/5";
                    var indicatore = document.getElementById("progress");
                    indicatore.setAttribute("aria-valuenow", "" + avg);
                    indicatore.setAttribute("style","width: " + avg + "%");
                    var commenti = "";
                    commenti +=
                            review.reviewTime + ": " + review.score + " /5" +
                            "<ul class=\"list-group\" id=\"" + review.itemReviewId + "\">" +
                                            "<li class=\"list-group-item\"><b>" + review.authorName + " " + review.authorSurname + "</b>: " + review.reviewText + "</li>";
                    if(canReply == "true") {
                        commenti += 
                                            '<form id="form-reply" class="form-inline" method="POST">' +
                                                '<div class="form-group">' +
                                                  '<input type="text" class="form-control" placeholder="Rispondi al commento" name="replycomment" id="replycomment-'+ review.itemReviewId +'" required>' +
                                                '</div>' +
                                                '<span class="btn btn-sm btn-success" style="cursor:pointer;" onclick="addReply(\''+review.itemReviewId+'\',\''+id+'\')">Invia</span>' +
                                            '</form>';
                    }
                    commenti += document.getElementById("commenti").innerHTML;
                    document.getElementById("commenti").innerHTML = commenti;
                }
            } else {
                $('#modal-text').text("Qualcosa è andato storto");
                $('#modal-title').text("Errore");
                $('#modal-cart-btn').hide();
                $('#confirm-modal').modal({show: true});
            }
        } else {
            $('#modal-text').text("Qualcosa è andato storto");
            $('#modal-title').text("Errore");
            $('#modal-cart-btn').hide();
            $('#confirm-modal').modal({show: true});
        }
    };
    xhttp.open("POST", "ItemComment", true);
    xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhttp.send("itemid="+id+"&itemscore="+itemScore.options[itemScore.selectedIndex].value+"&newcomment="+commentText.value);
}
function addReply(commentID, itemID) {
    var replycomment = document.getElementById("replycomment-" + commentID).value;
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
            if(this.responseText.startsWith("<li")) {
                $('#modal-text').text("La risposta al commento è stata inserita con successo");
                $('#modal-title').text("Commento risposto");
                $('#modal-cart-btn').hide();
                $('#confirm-modal').modal({show: true});
                //document.getElementById("form-reply").reset();
                document.getElementById(commentID).innerHTML = this.responseText;
            }
        } else {
            $('#modal-text').text("Qualcosa è andato storto");
            $('#modal-title').text("Errore");
            $('#modal-cart-btn').hide();
            $('#confirm-modal').modal({show: true});
        }
    };
    xhttp.open("POST","ItemCommentReply", true);
    xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhttp.send("itemid="+itemID+"&reviewid="+commentID+"&replycomment="+replycomment);
}