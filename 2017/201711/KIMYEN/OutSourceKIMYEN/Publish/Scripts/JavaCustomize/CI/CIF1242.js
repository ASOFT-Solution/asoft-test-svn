$(document).ready(function () {
    $("#GR_LichSu").remove();
    $("#GR_DinhKem").remove();

    var btnAddCIF1184 = '<li><a class="asfbtn-item-32  k-button k-button-icon" id="BtnAddNew1" style="" data-role="button" role="button" aria-disabled="false" tabindex="0" onclick="AddCIF1244()"><span class="k-sprite asf-icon asf-icon-32 asf-i-add-32"></span></a>'
    $("#viewdetail").find(".asf-toolbar").prepend(btnAddCIF1184);
});

function DeleteViewMasterDetail(pk) {
    pk = $(".PromoteID").text();
    return pk;
}


function getPromoteID() {
    return $(".PromoteID").text();
}

function getDivisionID() {
    return $(".DivisionID").text();
}


function CustomRead() {
    var ct = [];
    ct.push($(".PromoteID").text());
    return ct;
}


function CustomDeleteDetail(records) {
    var args = [];
    for (var i = 0; i < records.length; i++) {
        var valuepk = records[i]["InventoryID"] + "," + records[i]["PromoteID"];
        args.push(valuepk);
    }
    return args;
}

function AddCIF1244() {
    var GridDetail = $('#GridAT1328').data('kendoGrid');
    var records = ASOFT.asoftGrid.selectedRecords(GridDetail);
    if (records.length == 0) return;
    if (records.length > 1) {
        ASOFT.dialog.messageDialog("Chỉ được chọn một mặt hàng");
        return;
    }
    var URL = "/PopupMasterDetail/Index/CI/CIF1244?PK=" + records[0]["VoucherID"] + "&key=VoucherID&Table=AT1328&DivisionID=" + $(".DivisionID").text();
    ASOFT.asoftPopup.showIframe(URL, {});
}

function PrintClick() {
    ASOFT.helper.postTypeJson("/CI/CIF1240/DoPrintOrExportCIF1242?PromoteID=" + $(".PromoteID").text(), {}, ExportSuccess);
}

function ExportSuccess(result) {
    if (result) {
        var urlPrint = '/CI/CIF1240/ReportViewer';
        var urlExcel = '/CI/CIF1240/ExportReport';
        var urlPost = !isMobile ? urlPrint : urlExcel;
        var options = !isMobile ? '&viewer=pdf&actionPrint=2' : '&actionPrint=2';
        // Tạo path full
        var fullPath = urlPost + "?id=" + result.apk + options;

        // Getfile hay in báo cáo
        if (!isMobile)
            window.open(fullPath, "_blank");
        else {
            window.location = fullPath;
        }
    }
}
