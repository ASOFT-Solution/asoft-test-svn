$(document).ready(function () {

    var url = "/Partial/FromAccountID/CRM/CRMF3010";
    ASOFT.partialView.Load(url, ".DivisionID", 0);

    url = "/Partial/ToAccountID/CRM/CRMF3010";
    ASOFT.partialView.Load(url, ".FromEmployeeID", 1);

    $("#FromDate").attr("data-val-required", "The field is required.");
    $("#ToDate").attr("data-val-required", "The field is required.");
})


function CustomerCheck() {
    return ASOFT.form.checkRequired("FormReportFilter");
}


function btnChooseFromAccount_Click() {
    urlChooseFromAccount = "/PopupSelectData/Index/CRM/CRMF9001?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseFromAccount, {});
    action = 1;
}

function btnChooseToAccount_Click() {
    urlChooseToAccount = "/PopupSelectData/Index/CRM/CRMF9001?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseToAccount, {});
    action = 2;
}

function btnDeleteToAccount_Click() {
    $("#ToAccountID").val("");
    $("#ToAccountName").val("");
}
function btnDeleteFromAccount_Click() {
    $("#FromAccountID").val("");
    $("#FromAccountName").val("");
}


function receiveResult(result) {
    if (action == 1 || action == 0) {
        $("#FromAccountID").val(result["AccountID"]);
        $("#FromAccountName").val(result["AccountName"]);
    }
    if (action == 2) {
        $("#ToAccountID").val(result["AccountID"]);
        $("#ToAccountName").val(result["AccountName"]);
    }
}