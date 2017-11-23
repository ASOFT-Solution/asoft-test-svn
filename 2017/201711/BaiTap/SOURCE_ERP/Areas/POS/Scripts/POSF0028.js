//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     06/06/2014      Thai Son        Tạo mới
//####################################################################

var rowNumber1 = 0;
var rowNumber2 = 0;
var posGrid = null;

$(document).ready(function () {
    posGrid = $("#POSF0028Grid1").data("kendoGrid");



    posGrid.bind('dataBound', initGridLinkEvent);
    function initGridLinkEvent() {
        ASOFT.helper.initAutoClearMessageBox([], "POSF0028Grid1");
        //LOG($(gridLinkSelector));
        $('#POSF0028Grid1 .asf-grid-link').on('click', function (e) {
            //LOG(e); 
            var data = {},
                apk = posGrid.dataItem(posGrid.select()).APK,
                url = ("/POS/POSF0027/POSF0029" + '?id={0}').format(apk);
                ASOFT.asoftPopup.showIframe(url, data);
        });
    }
});


function popupClose(event) {
    parent.popupClose();
}
/**
* Xử lý sự kiện click vào nút lưu
*/
function POSF0025Save(event) {
}

function btnClose_Click(event) {

}

function sendDataFilter() {
    var data = {};
    data.APK = $('#APK').val();
    return data;
}

function showPopup(id) {
    var voucherNo = $('#VoucherNo').val();
    var url = '/POS/POSF0024/POSP0028?InventoryID={0}&VoucherNo={1}'.format(id, voucherNo);
    ASOFT.asoftPopup.showIframe(url);
    return false;
}

/**
* Gen rowNumber
*/
function renderNumber1(data) {
    return ++rowNumber1;
}
function renderNumber2(data) {
    return ++rowNumber2;
}
function popupClose(event) {
    ASOFT.asoftPopup.hideIframe();
}

function refreshGrid(event) {
    rowNumber1 = 0;
    posGrid.dataSource.page(0);
}


function btnClose_Click() {
    //parent.popupClose();    
    window.history.back();
}


function btnEditMaster_Click() {
    var url = "/POS/POSF0027/POSF00282?id=" + $("#APK").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(url, {});
}

function btnDeleteMaster_Click() {
    var args = [];
    args.push($("#APK").val());
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson("/POS/POSF0027/Delete", args, deleteSuccess1);
    });
}

function btnPrintMaster_Click() {
    ASOFT.helper.postTypeJson("/POS/POSF0016/DoPrintOrExport", { apkMaster: $("#APK").val() }, ExportSuccess);
}

function ExportSuccess(result) {
    if (result) {
        var urlPrint = '/POS/POSF0016/ReportViewer';
        var options = '&viewer=pdf';
        // Tạo path full
        var fullPath = urlPrint + "?id=" + result.apk + options;

        // Getfile hay in báo cáo
        window.open(fullPath, "_blank");
    }
}


function deleteSuccess1(result) {
    ASOFT.helper.showErrorSeverOption(1, result, "mtf1042-viewmastercontent", function () {
        window.location.href = $("#UrlContent").val();
    }, null, null, true, false, "mtf1042-viewmastercontent");
}

function btnAddDetail_Click() {
    var url = "/POS/POSF0027/POSF0029";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(url, {});
}

function btnDeleteDetail_Click() {
    var args = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(posGrid);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        args.push(records[i]["APK"]);
    }
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson("/POS/POSF0027/DeleteDetail", args, deleteSuccess);
    });
}

function deleteSuccess(result) {
    if (posGrid) {
        rowNumber1 = 0;
        posGrid.dataSource.page(0); // Refresh grid 
    }
}


function returnDivisionID() {
    return $("#DivisionID").val();
}

function getDataInsert() {
    var data = {};
    data.DivisionID = $("#DivisionID").val();
    data.ShopID = $("#ShopID").val();
    data.VoucherID = $("#VoucherID").val();
    data.APKMaster = $("#APK").val();
    return data;
}