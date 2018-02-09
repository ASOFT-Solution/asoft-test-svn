function customerDelete_Click() {
    var key = [],

        $urldeletePAF1000 = $("#DeletePAF1000").val(),

        $gridPAF1000 = $("#GridPAT10001").data("kendoGrid"),

        records = ASOFT.asoftGrid.selectedRecords($gridPAF1000);

    ASOFT.form.clearMessageBox();

    if (records.length == 0) return false;

    var args = $.map(records, function (record) {
        if (typeof record.AppraisalDictionaryID !== "undefined") {
            return record.AppraisalDictionaryID;
        }
    });

    key.push(tablecontent, pk);

    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1($urldeletePAF1000, key, args, deleteSuccess);
    });
    return false;
}


$(document).ready(function () {

    var $btnDelete = $("#BtnDelete").data("kendoButton") || $("#BtnDelete");


    if (typeof $btnDelete !== "undefined")
        $btnDelete.unbind("click").bind("click", customerDelete_Click);
});