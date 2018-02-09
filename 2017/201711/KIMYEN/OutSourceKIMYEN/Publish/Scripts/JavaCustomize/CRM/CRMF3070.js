$(document).ready(function () {
    var url = "/Partial/FromAccountID/CRM/CRMF3060";
    ASOFT.partialView.Load(url, ".DivisionID", 0);

    setTimeout(function () {
        url = "/Partial/ToAccountID/CRM/CRMF3060";
        ASOFT.partialView.Load(url, ".FromAccountIDPartial", 0);
    }, 50)

    var btnadd = '<a id="{0}" style="width : 26px; height: 26px; background-repeat: no-repeat" data-role="button" class="k-button" role="button" aria-disabled="false" tabindex="0" onclick="{1}"><span class="asf-button-text">...</span></a>';

    var btndelete = '<a id="{0}" style="width : 26px; height: 26px; background-image: url(/Content/Images/icon-delete-24x24.png); background-repeat: no-repeat" data-role="button" class="k-button" role="button" aria-disabled="false" tabindex="0" onclick="{1}"><span class="asf-button-text"></span></a>';

    $("#FromInventoryID").after(kendo.format(btndelete, "btnDeleteFromInventoryID", "btnDeleteFromInventoryID_Click()"));
    $("#FromInventoryID").after(kendo.format(btnadd, "btnFromInventoryID", "btnFromInventoryID_Click()"));
    $("#FromInventoryID").css("width", "82%");
    $("#FromInventoryID").attr("readonly", "readonly");


    $("#ToInventoryID").after(kendo.format(btndelete, "btnDeleteToInventoryID", "btnDeleteToInventoryID_Click()"));
    $("#ToInventoryID").after(kendo.format(btnadd, "btnToInventoryID", "btnToInventoryID_Click()"));
    $("#ToInventoryID").css("width", "82%");
    $("#ToInventoryID").attr("readonly", "readonly");

    $("#FromDate").attr("data-val-required", "The field is required.");
    $("#ToDate").attr("data-val-required", "The field is required.");
})

function CustomerCheck() {
    return ASOFT.form.checkRequired("FormReportFilter");
}


function btnFromInventoryID_Click() {
    var urlChooseInventoryID = "/PopupSelectData/Index/00/CMNF9001?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseInventoryID, {});
    actionChoose = 3;
}

function btnToInventoryID_Click() {
    var urlChooseInventoryID = "/PopupSelectData/Index/00/CMNF9001?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseInventoryID, {});
    actionChoose = 4;
}

function btnDeleteFromInventoryID_Click() {
    $("#FromInventoryID").val("");
}
function btnDeleteToInventoryID_Click() {
    $("#ToInventoryID").val("");
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
    if (actionChoose == 2) {
        $("#ToAccountID").val(result["AccountID"]);
        $("#ToAccountName").val(result["AccountName"]);
    }
    if (actionChoose == 3)
    {
        $("#FromInventoryID").val(result["InventoryID"]);
    }
    if (actionChoose == 4)
    {
        $("#ToInventoryID").val(result["InventoryID"]);
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
