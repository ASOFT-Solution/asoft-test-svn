var GridKPIT20101 = null;

$(document).ready(function () {
    GridKPIT20101 = $("#GridKPIT20101").data("kendoGrid");

    $("#BtnDelete").unbind();
    $("#BtnDelete").kendoButton({
        "click": CustomDelete_Click
    });
})

function CustomDelete_Click() {
    var args = [];
    var key = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GridKPIT20101);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        valuepk = records[i]["APK"];
        args.push(valuepk);
    }
    key.push(tablecontent, "APK");
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1($('#DeleteKPIF2010').val(), key, args, deleteSuccess);
    });
}
