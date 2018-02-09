$(document).ready(function () {
    $("#GR_LichSu").remove();
    $("#GR_DinhKem").remove();

    $("#BtnPrint").unbind();
    $("#BtnPrint").kendoButton({
        "click": CustomPrint_Click
    });

    var btnAddCIF1184 = '<li><a class="asfbtn-item-32  k-button k-button-icon" id="BtnAddNew1" style="" data-role="button" role="button" aria-disabled="false" tabindex="0" onclick="AddCIF1184()"><span class="k-sprite asf-icon asf-icon-32 asf-i-add-32"></span></a>'
    $("#viewdetail").find(".asf-toolbar").prepend(btnAddCIF1184);
});

function DeleteViewMasterDetail(pk) {
    pk = $(".KITID").text();
    return pk;
}

function getKIDID() {
    return $(".KITID").text();
}

function getDivisionID() {
    return $(".DivisionID").text();
}


function CustomDeleteDetail(records) {
    var args = [];
    for (var i = 0; i < records.length; i++) {
        var valuepk = records[i]["InventoryID"] + ",";
        valuepk = valuepk + records[i]["KITID"];
        args.push(valuepk);
    }
    return args;
}

function AddCIF1184() {
    var GridDetail = $('#GridAT1324').data('kendoGrid');
    var records = ASOFT.asoftGrid.selectedRecords(GridDetail);
    if (records.length == 0) return;
    if (records.length > 1) {
        ASOFT.dialog.messageDialog("Chỉ được chọn một mặt hàng");
        return;
    }
    var URL = "/PopupMasterDetail/Index/CI/CIF1184?PK=" + $(".KITID").text() + "&key=KITID&DivisionID=" + $(".DivisionID").text() + "&InventoryID=" + records[0].InventoryID;
    ASOFT.asoftPopup.showIframe(URL, {});
}

function CustomPrint_Click() {
    var data = [];
    data.push($(".KITID").text());
    ASOFT.helper.postTypeJson("/CI/CIF1180/DoPrintOrExport", data, ExportSuccess);
}

function ExportSuccess(result) {
    if (result) {
        var urlPrint = '/CI/CIF1180/ReportViewer';
        var options = '&viewer=pdf&actionPrint=2';
        // Tạo path full
        var fullPath = urlPrint + "?id=" + result.apk + options;

        // Getfile hay in báo cáo
        window.open(fullPath, "_blank");
    }
}
