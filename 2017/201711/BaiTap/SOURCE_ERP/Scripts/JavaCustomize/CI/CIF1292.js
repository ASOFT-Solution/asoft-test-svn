$(document).ready(function () {
    $("#GR_LichSu").remove();
    $("#GR_DinhKem").remove();
});

function DeleteViewNoDetail(pk) {
    pk = $(".UnitID").text() + "," + $(".DivisionID").text();
    return pk;
}