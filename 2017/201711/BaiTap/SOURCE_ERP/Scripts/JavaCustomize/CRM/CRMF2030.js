var GridCRMF2030 = null;
var urldeleteCRMF2030 = null;

$(document).ready(function () {
    urldeleteCRMF2030 = $('#DeleteCRMF2030').val();
    GridCRMF2030 = $("#GridCRMT20301").data("kendoGrid");
    $("#BtnDelete").unbind();
    $("#BtnDelete").kendoButton({
        "click": CustomDelete_Click
    });
});

function CustomDelete_Click() {
    var args = [];
    var key = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GridCRMF2030);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        valuepk = records[i]["LeadID"];
        args.push(valuepk);
    }
    key.push(tablecontent, pk);
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldeleteCRMF2030, key, args, deleteSuccess);
    });
}