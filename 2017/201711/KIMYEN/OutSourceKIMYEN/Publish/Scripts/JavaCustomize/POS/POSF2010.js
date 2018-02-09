"use strict";

(function ($, _as) {
    const btnDelete = $("#btnDelete").data("kendoButton") || $("#btnDelete");

    if (btnDelete) {
        btnDelete.unbind("click").bind("click", customerDelete_Click);
    }

}($, ASOFT));


function customerDelete_Click() {
    const key = [],

        $urldeleteposf2010 = $("#DeletePOSF2010").val(),

        gridpost2010 = $("#GridPOST2010").data("kendoGrid"),

        records = ASOFT.asoftGrid.selectedRecords(gridpost2010);

    ASOFT.form.clearMessageBox();

    if (records.length == 0) return false;

    var args = $.map(records, function (record) {
        if (typeof record.apk !== "undefined") {
            return record.apk;
        }
    });

    key.push(tablecontent, pk);

    ASOFT.dialog.confirmDialog(asoft.helper.getmessage('00ML000024'), function () {
        asoft.helper.posttypejson1("", key, args, deletesuccess);
    });
    return false;
}

function print_Click() {
    var gridPost2010 = $("#GridPOST2010").data("kendoGrid"),

        records = ASOFT.asoftGrid.selectedRecords(gridPost2010);

    ASOFT.form.clearMessageBox();

    if (records.length == 0) return false;

    var args = $.map(records, function (record) {
        if (typeof record.APK !== "undefined") {
            return record.APK;
        }
    });

    ASOFT.helper.postTypeJson("/POS/POSF2010/PrintReport", args, printSuccess);


}


function printSuccess(result) {
    if (result) {
        var urlPrint = '/POS/POSF2010/ReportViewer';
        var options = !isMobile ? '&viewer=pdf' : '';
        // Tạo path full
        var fullPath = urlPrint + "?id=" + result.apk + options;
        window.open(fullPath, "_blank");
    }
}





$(document).ready(function () {
    var btnPrint = $("#BtnPrint").data("kendoButton");
    if (btnPrint) {
        btnPrint.unbind("click").bind("click", print_Click);
    }

    var trVoucherNo = $("#VoucherNo_POSF2010").parent().parent();
    var trDescription = $("#Description_POSF2010").parent().parent();
    var trMemberName = $("#MemberName_POSF2010").parent().parent();
    var trSaleMan = $(".SaleManID");

    trVoucherNo.insertBefore(trMemberName);
    trDescription.insertBefore(trSaleMan);

});




