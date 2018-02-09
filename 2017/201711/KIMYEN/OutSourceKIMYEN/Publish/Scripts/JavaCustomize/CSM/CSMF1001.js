$(document).ready(function () {
    $("#CSMF1001").prepend("<table id = 'csmf1001' style = 'width:100%'></table>");
    //$("#csmf1001").append($(".StatusErrorID"), $(".StatusErrorName"), $(".Notes"), $(".IsCommon"), $(".Disabled"));

    $("#csmf1001").append($(".FirmID"), $(".StatusErrorID"), $(".StatusErrorName"), $(".Notes"), "<tr id='common'></tr>");
    var isUpdate = $("#isUpdate").val();
    if (isUpdate == "True") {
        $("#common").append("<td class='asf-td-field'>" + $("#IsCommon").parent().html() + "</td>",
            "<td class='asf-td-field' >" + $("#Disabled").parent().html() + "</td>");
    }
    else {
        $("#common").append("<td></td>","<td class='asf-td-field'>" + $("#IsCommon").parent().html() + "</td>",
            "<td class='asf-td-field' hidden >" + $("#Disabled").parent().html() + "</td>");
    }
    $(".IsCommon").remove();
    $(".Disabled").remove();

    if($("#isUpdate").val()=="True")
    {
        $("#StatusErrorID").attr("ReadOnly", true);
        $("#IsCommon").attr("disabled", "disabled");
    };
})