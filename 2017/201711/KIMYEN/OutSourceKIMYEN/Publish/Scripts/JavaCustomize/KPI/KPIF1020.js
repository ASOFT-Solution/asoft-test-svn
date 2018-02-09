var GridKPIF1020= null;
var urldeleteKPIF1020 = null;

$(document).ready(function () {
    urldeleteKPIF1020 = $('#DeleteKPIF1020').val();
    GridKPIF1020 = $("#GridKPIT10201").data("kendoGrid");
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
    var records = ASOFT.asoftGrid.selectedRecords(GridKPIF1020);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        valuepk = records[i]["TargetsDictionaryID"];
        args.push(valuepk);
    }
    key.push(tablecontent, "TargetsDictionaryID");
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldeleteKPIF1020, key, args, deleteSuccess);
    });
}

//function CustomEnable_Click() {
//    var args = [];
//    var key = [];
//    ASOFT.form.clearMessageBox();
//    var records = ASOFT.asoftGrid.selectedRecords(GridKPIF1020);
//    if (records.length == 0) return;
//    for (var i = 0; i < records.length; i++) {
//        args.push(records[i]["TargetsDictionaryID"]);
//    }

//    key.push(tablecontent, "TargetsDictionaryID");
//    ASOFT.helper.postTypeJson1(urlenable, key, args, disable_enableSuccess);
//}

//function CustomDisable_Click() {
//    var args = [];
//    var key = [];
//    ASOFT.form.clearMessageBox();
//    var records = ASOFT.asoftGrid.selectedRecords(GridKPIF1020);
//    if (records.length == 0) return;
//    for (var i = 0; i < records.length; i++) {
//        args.push(records[i]["TargetsDictionaryID"]);
//    }

//    key.push(tablecontent, "TargetsDictionaryID");
//    ASOFT.helper.postTypeJson1(urldisable, key, args, disable_enableSuccess);
//}