var GridKPIF1060= null;
var urldeleteKPIF1060 = null;

$(document).ready(function () {
    urldeleteKPIF1060 = $('#DeleteKPIF1060').val();
    GridKPIF1060 = $("#GridKPIT10601").data("kendoGrid");
    $("#BtnDelete").unbind();
    $("#BtnDelete").kendoButton({
        "click": CustomDelete_Click
    });

    //$("#BtnShow").unbind();
    //$("#BtnShow").kendoButton({
    //    "click": CustomEnable_Click
    //});

    //$("#BtnHide").unbind();
    //$("#BtnHide").kendoButton({
    //    "click": CustomDisable_Click
    //});
});

function CustomDelete_Click() {
    var args = [];
    var key = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GridKPIF1060);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        valuepk = records[i]["EvaluationPhaseID"];
        args.push(valuepk);
    }
    key.push(tablecontent, "EvaluationPhaseID");
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldeleteKPIF1060, key, args, deleteSuccess);
    });
}

//function CustomEnable_Click() {
//    var args = [];
//    var key = [];
//    ASOFT.form.clearMessageBox();
//    var records = ASOFT.asoftGrid.selectedRecords(GridKPIF1030);
//    if (records.length == 0) return;
//    for (var i = 0; i < records.length; i++) {
//        args.push(records[i]["SourceID"]);
//    }

//    key.push(tablecontent, "SourceID");
//    ASOFT.helper.postTypeJson1(urlenable, key, args, disable_enableSuccess);
//}

//function CustomDisable_Click() {
//    var args = [];
//    var key = [];
//    ASOFT.form.clearMessageBox();
//    var records = ASOFT.asoftGrid.selectedRecords(GridKPIF1030);
//    if (records.length == 0) return;
//    for (var i = 0; i < records.length; i++) {
//        args.push(records[i]["SourceID"]);
//    }

//    key.push(tablecontent, "SourceID");
//    ASOFT.helper.postTypeJson1(urldisable, key, args, disable_enableSuccess);
//}