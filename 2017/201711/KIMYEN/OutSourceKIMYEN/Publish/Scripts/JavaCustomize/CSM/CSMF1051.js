$(document).ready(function () {
    $("#CSMF1051").prepend("<table id = 'csmf1051' style = 'width:100%'></table>");
    //$("#csmf1051").append($(".VMIID"), $(".Description"), $(".Notes"), $(".IsCommon"), $(".Disabled"));

    $("#csmf1051").append($(".FirmID"), $(".VMIID"), $(".Description"), $(".Notes"), "<tr id='common'></tr>");
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
    if ($("#isUpdate").val() == "True") {
        $("#VMIID").attr("ReadOnly", true);
    };
})  