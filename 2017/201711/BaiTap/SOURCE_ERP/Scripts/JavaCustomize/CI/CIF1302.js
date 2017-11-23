$(document).ready(function () {
    $("#GR_LichSu").remove();
    $("#GR_DinhKem").remove();
});

function DeleteViewNoDetail(pk) {
    pk =  $(".NormID").text() + "," + $(".DivisionID").text();
    return pk;
}