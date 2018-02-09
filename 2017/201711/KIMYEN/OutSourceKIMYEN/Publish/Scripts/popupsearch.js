var temp = null;
$(document).ready(function () {
    var html = parent.returnHtml();
    for (i = 0; i < html.length; i++) {
        if ($($(html[i]).find(':input[data-role="datepicker"]')).length > 1) {
            if ($(html[i + 1]).find(':input[data-role="dropdownlist"]').length > 0 && $(html[i + 1]).find(':input[type="radio"]').length > 0) {
                $("#Search").prepend($("#PeriodFilter4"));
                temp = 1;
            }
            else {
                $("#Search").prepend($("#PeriodFilter1"));
                temp = 2;
            }
            if ($($(html[i]).find(':input[data-role="datepicker"]')[0]).attr("disabled") != "disabled")
                $("input[name='rdoFilter'][value='1']").trigger("click");

        }
        else {
            if ($(html[i]).find(':input[data-role="dropdownlist"]').length > 0 && $(html[i]).find(':input[type="radio"]').length > 0) {
                $("#Search").prepend($("#PeriodFilter3").show())
                if ($($(html[i]).find(':input[data-role="dropdownlist"]')[0]).attr("disabled") != "disabled") {
                    $("input[name='rdoFilter'][value='0']").trigger("click");
                }
            }
            else {
                if ($(html[i]).find(':input[type="radio"]').length > 0) {
                    $("#Search").prepend($("#PeriodFilter2"));
                    if ($($(html[i]).find(':input[data-role="combobox"]')[0]).attr("disabled") != "disabled") {
                        $("input[name='rdoFilter'][value='0']").trigger("click");
                    }
                }
                else {
                    var clone = $(html[i]).clone();
                    //$(clone.find('td')).removeAttr("colspan");
                    $($(".form-content").find(".asf-table-view")).append(clone.html());
                }
            }
        }
    }

    if (temp == 1) {
        $("#Search").prepend($("#PeriodFilter3"));
        $("#Search").prepend($("#PeriodFilter4"));
    } else if (temp == 2) {
        $("#Search").prepend($("#PeriodFilter2"));
        $("#Search").prepend($("#PeriodFilter1"));
    }
    $("#period1").remove();
    $("#period2").remove();
})

function BtnFilter_Click() {
    var dataSearch = ASOFT.helper.dataFormToJSON("Search");
    if (typeof parent.searchMobile === "function") {
        parent.searchMobile(dataSearch);
    }
}

function BtnClearFilter_Click() {
    var args = $('#Search input');
    $.each(args, function () {

        if ($(this).attr("id") != "undefined" && typeof ($(this).attr("id")) != "undefined") {
            if ($(this).attr("id").indexOf("_input") == -1) {
                if ($(this).attr("id") != "item.TypeCheckBox" && $(this).attr("id").indexOf("_Content_DataType") == -1 && $(this).attr("id").indexOf("_Type_Fields") == -1) {
                    if ($("#" + $(this).attr("id")).data("kendoComboBox") != null) {
                        $("#" + $(this).attr("id")).data("kendoComboBox").value("");
                    }
                    if ($("#" + $(this).attr("id")).data("kendoDropDownList") != null) {
                        $("#" + $(this).attr("id")).data("kendoDropDownList").value("");
                        $("#" + $(this).attr("id")).data("kendoDropDownList").text("");
                    }
                    $("#" + $(this).attr("id")).val('');
                }
            }
        }
    });
}