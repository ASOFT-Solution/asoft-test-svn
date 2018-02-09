$(document).ready(function () {
    $("#CSMF1011").prepend("<table id = 'csmf1011' style = 'width:100%'></table>");
    //$("#csmf1011").append($(".ReasonDenyID"), $(".Description"), $(".Notes"), $(".IsCommon"), $(".Disabled"));

    $("#csmf1011").append($(".ReasonDenyID"), $(".Description"), $(".Notes"), "<tr id='common'></tr>");
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
        $("#ReasonDenyID").attr("ReadOnly", true);
        $("#IsCommon").attr("ReadOnly", true);
    };

})