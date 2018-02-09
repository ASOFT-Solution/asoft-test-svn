var GridPAF1020 = null;
var urldeletePAF1020 = null;

$(document).ready(function () {
    urldeletePAF1020 = $('#DeletePAF1020').val();
    GridPAF1020 = $("#GridPAT10201").data("kendoGrid");
    $("#BtnDelete").unbind();
    $("#BtnDelete").kendoButton({
        "click": CustomDelete_Click
    });
});

function CustomDelete_Click() {
    var args = [];
    var key = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GridPAF1020);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        valuepk = records[i]["EvaluationKitID"];
        args.push(valuepk);
    }
    key.push(tablecontent, "EvaluationKitID");
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldeletePAF1020, key, args, deleteSuccess);
    });
}

