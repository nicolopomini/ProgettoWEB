var modifyShop = document.forms.namedItem("form-modify-shop");
var newItem = document.forms.namedItem("form-new-item");

modifyShop.addEventListener('submit', function(ev) {
    $("#modifyshopbutton").prop("disabled", true);
    var data = new FormData(modifyShop);
    var req = new XMLHttpRequest();
    req.open("POST", "ModifyShop", true);
    req.onload = function(event) {
      if (req.status == 200) {
          if(this.responseText == "OK") {
                location.reload();
          }
      }
      else {
          $("#modifyshopbutton").prop("disabled", false);
      }
  };

  req.send(data);
  ev.preventDefault();
}, false);

newItem.addEventListener('submit', function(ev) {
    $("#form-new-item-btn").prop("disabled", true);
    var data = new FormData(newItem);
    var req = new XMLHttpRequest();
    req.open("POST", "InsertItem", true);
    req.onload = function(event) {
      if (req.status == 200) {
          if(this.responseText == "OK") {
                newItem.reset();
                $('#inserisciitem').modal('hide')
                $('#modal-text').text("Nuovo item inserito con successo");
                $('#modal-title').text("Operazione eseguita");
                $('#confirm-modal').modal({show: true});
          }
      }
      else {
          $("#form-new-item-btn").prop("disabled", false);
      }
  };

  req.send(data);
  ev.preventDefault();
}, false);

