var dateFrom;
var dateTo;

$(document).ready(function () {
    var GroupReport = "<fieldset id='OOR' style = 'margin-top:20px; margin-bottom:10px;'><legend><label>Báo cáo</label></legend></fieldset>";
    var GroupFilter = "<fieldset id='OORFilter' style = 'margin-top:10px; margin-bottom:10px;'><legend><label>Thời gian</label></legend></fieldset>";
    var table = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='Table'> </table> </div> </div>";
    var tableOO = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO'> </table> </div> </div>";
    var tableOO1 = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO1'> </table> </div> </div>";
    var DivTag = "<div class='asf-filter-main' id='{0}'></div>";
    var DivTagblock = "<div class='block-{0}'> <div class='asf-filter-label'></div><div class='asf-filter-input'></div></div>";
    var DivTagblock1 = "<div class='block-{0}'> <div class='asf-filter-input'></div></div>";

    $(".ReportName").css('display', 'none');

    $("#FormReportFilter").prepend(GroupFilter);
    $("#FormReportFilter").prepend(GroupReport);
    $("#FormReportFilter").prepend(table);
    $("#Table").append($(".DivisionID"));    
    $("#OORFilter").append($("#PeriodFilter1"));
    $("#OORFilter").append($("#PeriodFilter2"));    
    $("#OOR").append(kendo.format(DivTag, 'DPeriod'));
    $("#OOR").append(tableOO);
    $("#TableOO").append($(".ReportTitle"));
    $("#OOR").append(kendo.format(DivTag, 'DOther'));
    $('#DPeriod').append(kendo.format(DivTagblock, "left"));
    $('#DPeriod .block-left .asf-filter-label').append($(".ReportID").children()[0]);
    $('#DPeriod .block-left .asf-filter-input').append($(".ReportID").children()[0]);
    $('#DPeriod').append(kendo.format(DivTagblock1, "right"));
    $('#DPeriod .block-right .asf-filter-input').append($(".ReportName").children()[1]);
    $('#DPeriod .block-right .asf-filter-input').css('width', '100%');
    $('#DPeriod .block-right .asf-filter-input .asf-td-field').css('width', '50%');

    $('.ReportTitle .asf-td-caption').css('width', '19%');
    $("#FormReportFilter").prepend($("#FormReportFilter").children()[3]);

    var cboReportCode = $("#ReportID").data("kendoComboBox");
    if (cboReportCode) {
        cboReportCode.select(0);
        var data = cboReportCode.dataItem();
        $("#ReportName").val(data.ReportName1);
        $("#ReportTitle").val(data.ReportTitle);
        cboReportCode.bind('change', function () {
            var data = cboReportCode.dataItem();
            $("#ReportName").val(data.ReportName1);
            $("#ReportTitle").val(data.ReportTitle);
        });
    }

    var cboCurrencyID = $("#CurrencyID").data("kendoComboBox");
    if (cboCurrencyID) {
        cboCurrencyID.value(ASOFTEnvironment.CurrencyID);
    }

    dateFrom = $("#FromDate").data("kendoDatePicker");
    dateTo = $("#ToDate").data("kendoDatePicker");
    dateFrom.bind('change', date_change);
    dateTo.bind('change', date_change);
    date_change(null);
});

function date_change(e) {
    $("#FromDate1").val(kendo.toString(dateFrom.value(), 'yyyy-MM-dd'));
    $("#ToDate1").val(kendo.toString(dateTo.value(), 'yyyy-MM-dd'));
}