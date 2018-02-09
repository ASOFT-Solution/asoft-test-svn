var GridKPIF1050= null;
var urldeleteKPIF1050 = null;

$(document).ready(function () {
    urldeleteKPIF1050 = $('#DeleteKPIF1050').val();
    GridKPIF1050 = $("#GridKPIT10501").data("kendoGrid");
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
    var records = ASOFT.asoftGrid.selectedRecords(GridKPIF1050);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        valuepk = records[i]["TargetsID"];
        args.push(valuepk);
    }
    key.push(tablecontent, "TargetsID");
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldeleteKPIF1050, key, args, deleteSuccess);
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