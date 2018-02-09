var GridKPIF1070= null;
var urldeleteKPIF1070 = null;
var isSaveCopy = false;

$(document).ready(function () {
    urldeleteKPIF1070 = $('#DeleteKPIF1070').val();
    GridKPIF1070 = $("#GridKPIT10701").data("kendoGrid");
    $("#BtnDelete").unbind();
    $("#BtnDelete").kendoButton({
        "click": CustomDelete_Click
    });

    var saveCopy = ASOFT.helper.getLanguageString("KPIF1070.SaveCopy", "KPIF1070", "KPI");

    var btnSaveCopy = '<li><a class="k-button k-button-icontext asf-button" id="BtnSaveCopy" style="" data-role="button" role="button" aria-disabled="false" tabindex="0" onclick="btnSaveCopy_Click()"><span class="asf-button-text">' + saveCopy + '</span></a></li>';

    $(".asf-toolbar").append(btnSaveCopy);
});


function btnSaveCopy_Click() {
    var records = ASOFT.asoftGrid.selectedRecords(GridKPIF1070);
    if (records.length == 0) return;
    if (records.length > 1) {
        ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('00ML000126'));
        return;
    };
    isSaveCopy = true;
    ASOFT.asoftPopup.showIframe("/PopupMasterDetail/Index/KPI/KPIF1071?PK=" + records[0]["APK"] + "&Table=KPIT10701&key=APK", {});
}

function CustomDelete_Click() {
    var args = [];
    var key = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GridKPIF1070);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        valuepk = records[i]["EvaluationSetID"];
        args.push(valuepk);
    }
    key.push(tablecontent, "EvaluationSetID");
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldeleteKPIF1070, key, args, deleteSuccess);
    });
}

