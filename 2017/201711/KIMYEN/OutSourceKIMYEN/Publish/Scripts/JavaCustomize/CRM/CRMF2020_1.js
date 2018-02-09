
$(document).ready(function (e) {
    var listLB = $(".Address").find("td")[0];
    $(listLB).css("background-color", "#000000");
    $(listLB).css("color", "#fff");

setTimeout(function () {
    $("#ShipDate_CRMF2010").val("");

    var VoucherNo = $("#VoucherNo_CRMF2020").parent().parent();
    $("#VoucherNo_CRMF2020").parent().parent().remove();
    $(".col1 .asf-table-view").append(VoucherNo);

    var SVoucherNo = $("#SVoucherNo_CRMF2020").parent().parent();
    $(".col3 .asf-table-view").append(SVoucherNo);

    var AccountName = $("#AccountName_CRMF2020").parent().parent();
    $("#AccountName_CRMF2020").parent().parent().remove();
    $("#EmployeeName_CRMF2020").parent().parent().before(AccountName);

    //var EmployeeName = $("#EmployeeName_CRMF2020").parent().parent();
    //$("#EmployeeName_CRMF2020").parent().parent().remove();
    //$("#RouteName_CRMF2020").parent().parent().before(EmployeeName);

    

    $("#BtnDelete").unbind();

    $("#BtnDelete").kendoButton({
        "click": CustomBtnDelete_Click,
    });
}, 500);
});

function CustomBtnDelete_Click() {
    var urldelete = "/CRM/CRMF2020/DeleteMaster?ScreenID=CRMF2020";
    GridKendo = $('#GridAT2006').data('kendoGrid');
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
    if (records.length == 0) return;

    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson(urldelete, records, deleteSuccess);
    });
};

function PrintClick() {
    var args = [];
    var listDivisionID = [];
    var CRMF2020Grid = ASOFT.asoftGrid.castName('GridAT2006');
    var records = ASOFT.asoftGrid.selectedRecords(CRMF2020Grid, 'FormFilter');
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        args.push(records[i].VoucherID);
        listDivisionID.push(records[i].DivisionID);
    }

    var URLDoPrintorExport = "/CRMF2020/DoPrintOrExport";

    for (i = 0; i < args.length; i++)
    {
        var dataRP = {};
        dataRP["VoucherID"] = args[i];
        dataRP["DivisionID"] = listDivisionID[i];
        ASOFT.helper.postTypeJson(URLDoPrintorExport, dataRP, ExportSuccess);
    }
}

function ExportSuccess(result) {
    if (result) {
        var urlPrint = '/CRM/CRMF2020/ReportViewer';
        var options = '&viewer=pdf';
        // Tạo path full
        var fullPath = urlPrint + "?id=" + result.apk + options;

        // Getfile hay in báo cáo
        window.open(fullPath, "_blank");
        //window.location = fullPath;
    }
}