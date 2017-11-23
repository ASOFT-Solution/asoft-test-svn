$(document).ready(function () {
    $("#GR_LichSu").remove();
    $("#GR_DinhKem").remove();
    $(".GroupID").parent().hide();

    if ($(".RefDate").html() === undefined)
    {
        var urlEdit = $("#urlEdit").val();
        urlEdit = urlEdit.replace("AT1011", "AT1015");
        $("#urlEdit").val(urlEdit);
    }
});

function DeleteViewNoDetail(pk) {
    pk = $(".AnaTypeID").text() + "," + $(".AnaID").text() + "," + $(".GroupID").text();
    return pk;
}