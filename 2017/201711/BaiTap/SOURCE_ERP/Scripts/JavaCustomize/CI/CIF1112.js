$(document).ready(function () {
    $("#GR_LichSu").remove();
    $("#GR_DinhKem").remove();
});

function DeleteViewNoDetail(pk) {
    pk = pk + "," + $(".DivisionID").text() + "," + $(".PaymentID").text();
    return pk;
}