var GridPAT20001 = null;
var isExportUser = false;   

$(document).ready(function () {
    GridPAT20001 = $("#GridPAT20001").data("kendoGrid");
    var urlPrint = "/PA/PAF2000";
    ASOFT.partialView.Load(urlPrint, "#contentMaster", 1);

    $("#BtnDelete").unbind();
    $("#BtnDelete").kendoButton({
        "click": CustomDelete_Click
    });
})


function CustomDelete_Click() {
    var args = [];
    var key = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GridPAT20001);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        valuepk = records[i]["APK"];
        args.push(valuepk);
    }
    key.push(tablecontent, "APK");
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1($('#DeletePAF2000').val(), key, args, deleteSuccess);
    });
}


function PrintClick(e) {
    var dialog = $("#PrintPopup").data("kendoWindow");
    $("#Print").show();
    dialog.wrapper.css({ top: e.sender.wrapper.offset().top + 30, left: e.sender.wrapper.offset().left });
    isExportUser = false;
    isPrint = true;

    dialog.open();
}


function ExportClick(e) {
    var dialog = $("#PrintPopup").data("kendoWindow");
    $("#Print").show();
    dialog.wrapper.css({ top: e.sender.wrapper.offset().top + 30, left: e.sender.wrapper.offset().left });
    isExportUser = true;
    isPrint = false;

    dialog.open();
}


function print1_Click() {
    var URLDoPrintorExport = '/ContentMaster/DoPrintOrExport?id=' + screen + '&area=' + $("#Module" + $("#sysScreenID").val()).val();
    var dataFilter = getDataPrintExport();
    var url = URLDoPrintorExport;
    ASOFT.helper.postTypeJson(url, dataFilter, ExportSuccess);
}

function print2_Click() {
    var records = ASOFT.asoftGrid.selectedRecords(GridPAT20001, 'FormFilter');
    if (records.length == 0) return;

    for (var i = 0; i < records.length; i++) {
        var URLDoPrintorExport = '/PA/PAF2000/DoPrintOrExport?APK=' + records[i].APK;
        ASOFT.helper.postTypeJson(URLDoPrintorExport, {}, ExportSuccessPrint2);
    }
}

function ExportSuccessPrint2(result) {
    if (result) {
        var urlPrint = '/PA/PAF2000/ReportViewer';
        var urlExcel = '/PA/PAF2000/ExportReport';
        var urlPost = isExportUser ? urlExcel : (!isMobile ? urlPrint : urlExcel);
        var options = isExportUser ? '' : (!isMobile ? '&viewer=pdf' : '&viewer=pdf&mobile=mobile');
        // Tạo path full
        var fullPath = urlPost + "?id=" + result.apk + options;

        // Getfile hay in báo cáo
        if (!isMobile && !isExportUser)
            window.open(fullPath, "_blank");
        else {
            window.location = fullPath;
        }
    }
}