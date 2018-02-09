var actionChoose = null;

$(document).ready(function () {
    var btnadd = '<a id="{0}" style="width : 26px; height: 26px;  background-repeat: no-repeat" data-role="button" class="k-button" role="button" aria-disabled="false" tabindex="0" onclick="{1}"><span class="asf-button-text">...</span></a>';

    var btndelete = '<a id="{0}" style="width : 26px; height: 26px;  background-image: url(/Content/Images/icon-delete-24x24.png); background-repeat: no-repeat" data-role="button" class="k-button" role="button" aria-disabled="false" tabindex="0" onclick="{1}"><span class="asf-button-text"></span></a>';

    $("#FromInventoryName").after(kendo.format(btndelete, "btnDeleteFromInventoryID", "btnDeleteFromInventoryID_Click()"));
    $("#FromInventoryName").after(kendo.format(btnadd, "btnFromInventoryID", "btnFromInventoryID_Click()"));
    $("#FromInventoryName").css("width", "82%");
    $("#FromInventoryName").attr("disabled", "disabled");


    $("#ToInventoryName").after(kendo.format(btndelete, "btnDeleteToInventoryID", "btnDeleteToInventoryID_Click()"));
    $("#ToInventoryName").after(kendo.format(btnadd, "btnToInventoryID", "btnToInventoryID_Click()"));
    $("#ToInventoryName").css("width", "82%");
    $("#ToInventoryName").attr("disabled", "disabled");

    $("#FromSalesManName").after(kendo.format(btndelete, "btnDeleteFromEmployeeID", "btnDeleteFromEmployeeID_Click()"));
    $("#FromSalesManName").after(kendo.format(btnadd, "btnFromEmployeeID", "btnFromEmployeeID_Click()"));
    $("#FromSalesManName").css("width", "82%");
    $("#FromSalesManName").attr("disabled", "disabled");


    $("#ToSalesManName").after(kendo.format(btndelete, "btnDeleteToEmployeeID", "btnDeleteToEmployeeID_Click()"));
    $("#ToSalesManName").after(kendo.format(btnadd, "btnToEmployeeID", "btnToEmployeeID_Click()"));
    $("#ToSalesManName").css("width", "82%");
    $("#ToSalesManName").attr("disabled", "disabled");
})


function btnFromEmployeeID_Click() {
    var urlChooseInventoryID = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseInventoryID, {});
    actionChoose = 1;
}

function btnToEmployeeID_Click() {
    var urlChooseInventoryID = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseInventoryID, {});
    actionChoose = 2;
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
    $("#FromInventoryName").val("");
    $("#FromInventoryID").val("");
}
function btnDeleteToInventoryID_Click() {
    $("#ToInventoryName").val("");
    $("#ToInventoryID").val("");
}

function btnDeleteFromEmployeeID_Click() {
    $("#FromSalesManName").val("");
    $("#FromSalesManID").val("");
}
function btnDeleteToEmployeeID_Click() {
    $("#ToSalesManName").val("");
    $("#ToSalesManID").val("");
}


function receiveResult(result) {
    if (actionChoose == 1) {
        $("#FromSalesManName").val(result["EmployeeName"]);
        $("#FromSalesManID").val(result["EmployeeID"]);
    }
    if (actionChoose == 2) {
        $("#ToSalesManName").val(result["EmployeeName"]);
        $("#ToSalesManID").val(result["EmployeeID"]);
    }
    if (actionChoose == 3) {
        $("#FromInventoryID").val(result["InventoryID"]);
        $("#FromInventoryName").val(result["InventoryName"]);
    }
    if (actionChoose == 4) {
        $("#ToInventoryID").val(result["InventoryID"]);
        $("#ToInventoryName").val(result["InventoryName"]);
    }
}
