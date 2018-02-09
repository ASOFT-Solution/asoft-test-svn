$(document).ready(function () {
    var btnDelete = $("#BtnDelete").data("kendoButton") || $("#BtnDelete");
    if (btnDelete)
        btnDelete.unbind("click").bind("click", customerDelete_Click);
    CheckCanEdit();

    $(".DutyID").parent().css('display', 'none');
});

function CheckCanEdit() {
    var url = new URL(window.location.href);
    var pk = url.searchParams.get("PK");
    $.ajax({
        url: '/HRM/HRMF1010/CheckUpdateData?InterviewTypeID=' + pk + "&DutyID=" + $(".DutyID.content-text").html() + "&Mode=0",
        success: function (result) {
            if (result.CanEdit == 0) {
                $("#BtnEdit").parent().addClass('asf-disabled-li');
            }
        }
    });
}

function customerDelete_Click() {
    var args = [];
    var list = [];
    ASOFT.form.clearMessageBox();
    pk = $(".DutyID.content-text").html() + ',' + $(".InterviewTypeID.content-text").html();
    args.push(pk);
    list.push(table, key);
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldel, list, args, deleteSuccess);
    });
}