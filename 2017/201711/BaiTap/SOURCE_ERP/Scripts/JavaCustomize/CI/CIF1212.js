$(document).ready(function () {
    $("#GR_LichSu").remove();
    $("#GR_DinhKem").remove();
});

function DeleteViewNoDetail(pk) {
    pk = pk + "," + $(".DivisionID").text() + "," + $(".CountryID").text();
    return pk;
}