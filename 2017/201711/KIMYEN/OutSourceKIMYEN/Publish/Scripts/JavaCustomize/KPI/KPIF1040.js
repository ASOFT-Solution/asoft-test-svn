var GridKPIF1040= null;
var urldeleteKPIF1040 = null;

$(document).ready(function () {
    urldeleteKPIF1040 = $('#DeleteKPIF1040').val();
    GridKPIF1040 = $("#GridKPIT10401").data("kendoGrid");
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
    var records = ASOFT.asoftGrid.selectedRecords(GridKPIF1040);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        valuepk = records[i]["UnitKpiID"];
        args.push(valuepk);
    }
    key.push(tablecontent, "UnitKpiID");
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldeleteKPIF1040, key, args, deleteSuccess);
    });
}

//function CustomEnable_Click() {
//    var args = [];
//    var key = [];
//    ASOFT.form.clearMessageBox();
//    var records = ASOFT.asoftGrid.selectedRecords(GridKPIF1040);
//    if (records.length == 0) return;
//    for (var i = 0; i < records.length; i++) {
//        args.push(records[i]["UnitKpiID"]);
//    }

//    key.push(tablecontent, "UnitKpiID");
//    ASOFT.helper.postTypeJson1(urlenable, key, args, disable_enableSuccess);
//}

//function CustomDisable_Click() {
//    var args = [];
//    var key = [];
//    ASOFT.form.clearMessageBox();
//    var records = ASOFT.asoftGrid.selectedRecords(GridKPIF1040);
//    if (records.length == 0) return;
//    for (var i = 0; i < records.length; i++) {
//        args.push(records[i]["UnitKpiID"]);
//    }

//    key.push(tablecontent, "UnitKpiID");
//    ASOFT.helper.postTypeJson1(urldisable, key, args, disable_enableSuccess);
//}