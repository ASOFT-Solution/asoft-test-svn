
$(document).ready(function () {
    var listLB = $($(".Address").parent()).find("td")[0];
    $(listLB).css("background-color", "#000000");
    $(listLB).css("color", "#fff");

    setTimeout(function () {
            
        $("#BtnDelete").unbind();

        $("#BtnDelete").kendoButton({
            "click": CustomBtnDeleteMaster_Click,
        });

        $("#BtnDeleteDetail").unbind();

        $("#BtnDeleteDetail").kendoButton({
            "click": CustomBtnDeleteDetail_Click,
        });

    }, 500);
});

function CustomBtnDeleteMaster_Click() {
    var urldeleteMaster = "/CRM/CRMF2020/DeleteMaster?ScreenID=CRMF2022";
    var ListData = new Array();
    var item = new Object();
    item.VoucherNo = $(".VoucherNo")[0].innerHTML;
    item.DivisionID = $("#DivisionID").val();
    item.VoucherID = $("#PK").val();
    ListData.push(item);

    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson(urldeleteMaster, ListData, deleteSuccess);
    });
};

function CustomBtnDeleteDetail_Click() {
    var urldeleteDetail = "/CRM/CRMF2022/DeleteDetail?DivisionID=" + $("#DivisionID").val();
    var GirdDetail = $("#Grid" + tbchild).data("kendoGrid");
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GirdDetail);
    if (records.length == 0) return;

    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson(urldeleteDetail, records, CustomDeleteDetailSuccess);
    });
};

function CustomDeleteDetailSuccess(result) {
    var formfilter = "mtf1042-viewmastercontent";
    ASOFT.helper.showErrorSeverOption(1, result, formfilter, function () {
        //Chuyển hướng hoặc refresh data
        refreshGrid(tbchild);
    }, function () { refreshGrid(tbchild); }, function () { refreshGrid(tbchild); }, true, false, formfilter);
};



function PrintClick() {

    var URLDoPrintorExport = "/CRMF2020/DoPrintOrExport";

    var dataRP = {};
    dataRP["VoucherID"] = $("#PK").val();
    ASOFT.helper.postTypeJson(URLDoPrintorExport, dataRP, ExportSuccess);
}

function ExportSuccess(result) {
    if (result) {
        var urlPrint = '/CRM/CRMF2020/ReportViewer';
        var options = '&viewer=pdf';
        // Tạo path full
        var fullPath = urlPrint + "?id=" + result.apk + options;

        // Getfile hay in báo cáo
        window.open(fullPath, "_blank");
    }
}
