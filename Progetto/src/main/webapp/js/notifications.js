function readNotifications(userId) {
    var xhttp = new XMLHttpRequest();
    xhttp.open("POST", "ReadNotifications", true);
    xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhttp.send("userid="+userId);
}
function readComplaint(complaintId) {
    var xhttp = new XMLHttpRequest();
    xhttp.open("POST", "ReadComplaint", true);
    xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xhttp.send("complaintid="+complaintId);
}
function showmodal(complaintid) {
    $('#' + complaintid).modal({show: true});
}