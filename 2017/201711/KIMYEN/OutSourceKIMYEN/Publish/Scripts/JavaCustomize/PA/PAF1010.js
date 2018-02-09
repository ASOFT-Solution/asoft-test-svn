var GridPAF1010 = null;
var urldeletePAF1010 = null;

$(document).ready(function () {
    urldeletePAF1010 = $('#DeletePAF1010').val();
    GridPAF1010 = $("#GridPAT10101").data("kendoGrid");
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
    var records = ASOFT.asoftGrid.selectedRecords(GridPAF1010);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        valuepk = records[i]["AppraisalID"];
        args.push(valuepk);
    }
    key.push(tablecontent, "AppraisalID");
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldeletePAF1010, key, args, deleteSuccess);
    });
}

//function CustomEnable_Click() {
//    var args = [];
//    var key = [];
//    ASOFT.form.clearMessageBox();
//    var records = ASOFT.asoftGrid.selectedRecords(GridKPIF1050);
//    if (records.length == 0) return;
//    for (var i = 0; i < records.length; i++) {
//        args.push(records[i]["TargetsID"]);
//    }

//    key.push(tablecontent, "TargetsID");
//    ASOFT.helper.postTypeJson1(urlenable, key, args, disable_enableSuccess);
//}

//function CustomDisable_Click() {
//    var args = [];
//    var key = [];
//    ASOFT.form.clearMessageBox();
//    var records = ASOFT.asoftGrid.selectedRecords(GridKPIF1050);
//    if (records.length == 0) return;
//    for (var i = 0; i < records.length; i++) {
//        args.push(records[i]["TargetsID"]);
//    }

//    key.push(tablecontent, "TargetsID");
//    ASOFT.helper.postTypeJson1(urldisable, key, args, disable_enableSuccess);
//}