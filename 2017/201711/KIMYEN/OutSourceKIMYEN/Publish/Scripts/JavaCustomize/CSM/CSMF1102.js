
$(document).ready(function () {
    getFirmID();
    getFirmName();
});

function getFirmID() {
    firmID = $(".FirmID").text();
    return firmID;
}
function getFirmName() {
    firmName = $(".FirmName").text();
    return firmName;
}
