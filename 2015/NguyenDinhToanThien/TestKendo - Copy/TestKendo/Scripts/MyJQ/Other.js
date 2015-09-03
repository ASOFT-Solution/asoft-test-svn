

$(document).ready(function () {
    //Xu ly khi nhan button them se mo popup
    $("#them").bind("click", function () {
        $("#window").data("kendoWindow").open();
        $("#window").data("kendoWindow").focus;
    });
});