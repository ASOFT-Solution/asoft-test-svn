$(document).ready(function () {
    $("#btnExport").remove();
    $("#btnPrint").unbind();
    $("#btnPrint").kendoButton({
        "click": custom_Html,
    });

    $($($(".AllDivisionID")[0]).find('.asf-td-caption')).append($($(".AllDivisionID")[0]).find('.asf-td-field'));
    $($($(".AllDivisionID")[1]).find('.asf-td-caption')).append($($(".AllDivisionID")[1]).find('.asf-td-field'));
    $(".DivisionID").find('.asf-td-caption').text('');
    $($($(".AllDivisionID")[1])).append($(".DivisionID").find('.asf-td-field'));
    $("#AllDivisionID").trigger("click");
    $("#DivisionID").data("kendoDropDownList").enable(false);

    $(".AllDivisionID input[type='radio']").change(function () {
        if ($(this).val() == 0) {
            $("#DivisionID").data("kendoDropDownList").enable(true);
        }
        else {
            $("#DivisionID").data("kendoDropDownList").enable(false);
        }
    })
})


function custom_Html() {
    var data = ASOFT.helper.dataFormToJSON("FormReportFilter");
    var para = "";
    if (data["AllDivisionID"] == "0") {
        para = para + "DivisionID=" + data["DivisionID"];
    }
    para = para + "&IsDate=" + data["rdoFilter"];
    para = para + "&IsDivisionID=" + data["AllDivisionID"];
    if (data["rdoFilter"] == "1") {
        para = para + "&FromDateJQ=" + data["FromDatePeriodControl"];
        para = para + "&ToDateJQ=" + data["ToDatePeriodControl"];
    }
    else {
        para = para + "&PeriodIDList=" + data["CheckListPeriodControl"];
    }
    window.open("/CRM/CRMR3010/CRMR30111?" + para, '_blank');
}