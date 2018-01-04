var form = document.forms.namedItem("edit-item");
form.addEventListener('submit', function(ev) {
    $("#edit-item-submit").prop("disabled", true);
    var data = new FormData(form);
    var req = new XMLHttpRequest();
    req.open("POST", "ModifyItem", true);
    req.onload = function(event) {
      if (req.status == 200) {
          if(this.responseText == "OK") {
                location.reload();
          }
          else {
            $('#modal-text').text("Qualcosa è andato storto");
            $('#modal-title').text("Errore");
            $('#modal-cart-btn').hide();
            $('#confirm-modal').modal({show: true});
          }
      }
      else {
          $("#edit-item-submit").prop("disabled", false);
          $('#modal-text').text("Qualcosa è andato storto");
            $('#modal-title').text("Errore");
            $('#modal-cart-btn').hide();
            $('#confirm-modal').modal({show: true});
      }
  };

  req.send(data);
  ev.preventDefault();
}, false);
