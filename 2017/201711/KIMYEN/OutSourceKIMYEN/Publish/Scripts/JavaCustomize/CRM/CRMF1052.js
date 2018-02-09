
$(document).ready(function () {
    $("#GR_LichSu").remove();
    $("#GR_DinhKem").remove();
    $("#BtnDeleteDetail").unbind();
    $("#BtnDeleteDetail").kendoButton({
        "click": customDelete_Click
    });
});

function customDelete_Click() {
    var args = [],
        list = [],
        requestID = $(".CauseID").text();
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