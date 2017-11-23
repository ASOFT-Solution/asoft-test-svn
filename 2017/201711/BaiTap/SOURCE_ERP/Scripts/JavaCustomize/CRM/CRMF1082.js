﻿
$(document).ready(function () {
    $("#GR_LichSu").remove();
    $("#GR_DinhKem").remove();
    $("#BtnDelete").unbind();
    $("#BtnDeleteDetail").kendoButton({
        "click": customDelete_Click
    });

    $(".content-label").css({
        "width": "40%"
    });
});

function customDelete_Click() {
    var args = [],
        list = [],
        requestID = $(".NextActionID").text();
    ASOFT.form.clearMessageBox();
    pk = pk + "," + $(".DivisionID").text();

    if (typeof DeleteViewMasterDetail2 === "function") {
        pk = DeleteViewMasterDetail2(pk);
    }
    args.push(pk);
    list.push(table, key);
    args.push(requestID);
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldel, list, args, deleteSuccess);
    });

}