var actionChoose = null;

$(document).ready(function () {
    $("#CheckListPeriodControl").attr("data-val-required", "The field is required.");
    $("#FromDatePeriodControl").attr("data-val-required", "The field is required.");
    $("#ToDatePeriodControl").attr("data-val-required", "The field is required.");

    var url = "/Partial/FromAccountID/CRM/CRMF3060";
    ASOFT.partialView.Load(url, ".DivisionID", 0);

    setTimeout(function () {
        url = "/Partial/ToAccountID/CRM/CRMF3060";
        ASOFT.partialView.Load(url, ".FromAccountIDPartial", 0);
    }, 50)
})

function CustomerCheck() {
    return ASOFT.form.checkRequired("FormReportFilter");
}

function btnChooseFromAccount_Click() {
    var urlChooseEmployee = "/PopupSelectData/Index/CRM/CRMF9001?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseEmployee, {});
    actionChoose = 1;
}
function btnChooseToAccount_Click() {
    var urlChooseEmployee = "/PopupSelectData/Index/CRM/CRMF9001?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseEmployee, {});
    actionChoose = 2;
}


function receiveResult(result) {
    if (actionChoose == 1) {
        $("#FromAccountID").val(result["AccountID"]);
        $("#FromAccountName").val(result["AccountName"]);
    }
    else {
        $("#ToAccountID").val(result["AccountID"]);
        $("#ToAccountName").val(result["AccountName"]);
    }
}

function btnDeleteToAccount_Click() {
    $("#ToAccountID").val("");
    $("#ToAccountName").val("");
}
function btnDeleteFromAccount_Click() {
    $("#FromAccountID").val("");
    $("#FromAccountName").val("");
}