$(document).ready(function () {
    $("#CSMF1061").prepend("<table id = 'csmf1061' style = 'width:100%'></table>");
    //$("#csmf1061").append($(".ServiceTypeID"), $(".ServiceTypeName"), $(".Notes"), $(".IsCommon"), $(".Disabled"));

    $("#csmf1061").append($(".ServiceTypeID"), $(".ServiceTypeName"), $(".Notes"), "<tr id='common'></tr>");
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
        $("#ServiceTypeID").attr("ReadOnly", true);
    };

})  