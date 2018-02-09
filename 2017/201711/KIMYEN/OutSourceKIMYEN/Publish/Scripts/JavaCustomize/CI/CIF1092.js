$(document).ready(function () {
    $("#GR_LichSu").remove();
    $("#GR_DinhKem").remove();
});

function DeleteViewNoDetail(pk) {
    pk = $(".S").text() + "," + $(".DivisionID").text() + "," + $(".STypeID").text() + "," + $(".TypeID").text();
    return pk;
}