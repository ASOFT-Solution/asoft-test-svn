$(document).ready(function () {
    var OrtherInfo = "<fieldset id='OOR'><legend><label>" + $("#GroupTitle1").val() + "</label></legend></fieldset>";
    var tableOO = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO'> </table> </div> </div>";
    var tableOO1 = "<div class='asf-form-container'> <div class='form-content'> <table class='asf-table-view' id='TableOO1'> </table> </div> </div>";
    var filter = "<fieldset id='OORfilter'><legend><label>" + $("#GroupTitle2").val() + "</label></legend></fieldset>";
    var divcost = "<div id ='cost' style ='margin-top:10px;'></div>"
    var divsale = "<div id ='sale' style ='margin-top:10px;'></div>"
    $("#FormReportFilter").prepend(filter);
    $("#FormReportFilter").prepend(OrtherInfo);
    $("#OOR").prepend(tableOO);
    $("#OORfilter").append($("#PeriodFilter1"));
    $("#OORfilter").append($("#PeriodFilter2"));
    
    $("#OORfilter").prepend(tableOO1);
    $("#TableOO").append($(".ReportID"));
    $("#TableOO").append($(".ReportName"));
    $("#TableOO").append($(".ReportTitle"));


    $("#ReportTitle").val(parent.returnReport()[2]);
    $("#ReportTitle").attr("readonly", "readonly");

    //$("#btnExport").css('display', 'none');
    $("#btnPrintBD").css('display', 'none');

    $("#ToPeriodFilter").data("kendoComboBox").select(0);
    var combo = $("#FromPeriodFilter").data("kendoComboBox");
    combo.select(combo.dataSource._data.length - 1);
  
    $("#btnPrint").unbind();
    $("#btnPrint").kendoButton({
        "click": print_Click
    });

    $("#btnExport").unbind();
    $("#btnExport").kendoButton({
        "click": export_Click
    });

    // replace tr, td to div

    $("#FormReportFilter").prepend(divcost);
    $("#FormReportFilter").prepend(divsale);
    $("#OORfilter").append($("#cost"));
    $("#OORfilter").append($("#sale"));
    $("#cost").append($(".IsCostOfSale"));
    $("#sale").append($(".IsSaleReceipt"));
})

function print_Click() {
    isPrint = true;

    $("#FromTranMonth").val($("#FromPeriodFilter").val().split('/')[0]);
    $("#FromTranYear").val($("#FromPeriodFilter").val().split('/')[1]);

    $("#ToTranMonth").val($("#ToPeriodFilter").val().split('/')[0]);
    $("#ToTranYear").val($("#ToPeriodFilter").val().split('/')[1]);

    var data = getData();
    var url = URLDoPrintorExport;
    ASOFT.helper.postTypeJson(url, data, ExportSuccess);
}

function export_Click() {
    isPrint = false;

    $("#FromTranMonth").val($("#FromPeriodFilter").val().split('/')[0]);
    $("#FromTranYear").val($("#FromPeriodFilter").val().split('/')[1]);

    $("#ToTranMonth").val($("#ToPeriodFilter").val().split('/')[0]);
    $("#ToTranYear").val($("#ToPeriodFilter").val().split('/')[1]);
    var data = getData();
    var url = URLDoPrintorExport;
    ASOFT.helper.postTypeJson(url, data, ExportSuccess);
}

function CustomerCheck() {
    var Check = false;
    ASOFT.form.clearMessageBox($('#sysScreenID').val())
    if ($('#IsDate').val() == 0 && $('#FromPeriodFilter').val() == '' && $('#ToPeriodFilter').val() == '') {
        ASOFT.form.displayMessageBox('#FormReportFilter', [ASOFT.helper.getMessage('BIFML000001')], null);
        Check = true;
    }
    return Check;
}