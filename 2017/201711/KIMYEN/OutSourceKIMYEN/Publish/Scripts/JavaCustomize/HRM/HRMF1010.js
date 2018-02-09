$(document).ready(function () {
    var btnDelete = $("#BtnDelete").data("kendoButton") || $("#BtnDelete");
    if (btnDelete)
        btnDelete.unbind("click").bind("click", customerDelete_Click);
});

function customerDelete_Click() {
    var key = [],
        $urldeleteCRMF1040 = $("#DeleteHRMF1010").val(),
        $gridCRMF1040 = $("#GridHRMT1010").data("kendoGrid"),
        records = ASOFT.asoftGrid.selectedRecords($gridCRMF1040);

    ASOFT.form.clearMessageBox();
    if (records.length == 0) return false;
    var args = $.map(records, function (record) {
        //if (record.InterviewTypeID && record.DutyID) {
            return record.DutyID + ',' + record.InterviewTypeID;
        //}
    });

    key.push(tablecontent, pk);
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1($urldeleteCRMF1040, key, args, deleteSuccess);
    });
    return false;
}