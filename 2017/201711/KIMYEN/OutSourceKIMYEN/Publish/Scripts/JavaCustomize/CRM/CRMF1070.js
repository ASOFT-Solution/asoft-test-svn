var GridCRMF1070 = null;
var urldeleteCRMF1070 = null;

$(document).ready(function () {
    urldeleteCRMF1070 = $('#DeleteCRMF1070').val();
    GridCRMF1070 = $("#GridCRMT10701").data("kendoGrid");
    $("#BtnDelete").unbind();
    $("#BtnDelete").kendoButton({
        "click": CustomDelete_Click
    });
});

function CustomDelete_Click() {
    var args = [];
    var key = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GridCRMF1070);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        valuepk = records[i]["BusinessLinesID"];
        args.push(valuepk);
    }
    key.push(tablecontent, pk);
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldeleteCRMF1070, key, args, deleteSuccess);
    });
}