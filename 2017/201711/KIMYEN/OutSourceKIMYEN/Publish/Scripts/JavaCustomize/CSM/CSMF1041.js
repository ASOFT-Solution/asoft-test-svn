$(document).ready(function () {
    $("#CSMF1041").prepend("<table id = 'csmf1041' style = 'width:100%'></table>");
    //$("#csmf1041").append($(".DesProductID"),$(".Description") ,$(".ModelID"), $(".IsCommon"), $(".Disabled"));

    $("#csmf1041").append($(".DesProductID"), $(".Description"), $(".ModelID"), "<tr id='common'></tr>");
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
        $("#DesProductID").attr("ReadOnly", true);
    };

})