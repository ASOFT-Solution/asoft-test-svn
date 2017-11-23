var GridCRMF2050 = null;
var urldeleteCRMF2050 = null;

$(document).ready(function () {
    urldeleteCRMF2050 = $('#DeleteCRMF2050').val();
    GridCRMF2050 = $("#GridCRMT20501").data("kendoGrid");
    $("#BtnDelete").unbind();
    $("#BtnDelete").kendoButton({
        "click": CustomDelete_Click
    });
});

function CustomDelete_Click() {
    var args = [];
    var key = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GridCRMF2050);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        valuepk = records[i]["OpportunityID"];
        args.push(valuepk);
    }
    key.push(tablecontent, pk);
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldeleteCRMF2050, key, args, deleteSuccess);
    });
}