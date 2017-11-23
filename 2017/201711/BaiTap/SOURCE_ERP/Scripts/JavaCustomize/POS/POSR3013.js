var actionChoose = null;

$(document).ready(function () {
    var btnadd = '<a id="{0}" style="width : 26px; height: 26px;  background-repeat: no-repeat" data-role="button" class="k-button" role="button" aria-disabled="false" tabindex="0" onclick="{1}"><span class="asf-button-text">...</span></a>';

    var btndelete = '<a id="{0}" style="width : 26px; height: 26px;  background-image: url(/Content/Images/icon-delete-24x24.png); background-repeat: no-repeat" data-role="button" class="k-button" role="button" aria-disabled="false" tabindex="0" onclick="{1}"><span class="asf-button-text"></span></a>';

    $("#FromEmployeeID").after(kendo.format(btndelete, "btnDeleteFromEmployeeID", "btnDeleteFromEmployeeID_Click()"));
    $("#FromEmployeeID").after(kendo.format(btnadd, "btnFromEmployeeID", "btnFromEmployeeID_Click()"));
    $("#FromEmployeeID").css("width", "82%");
    $("#FromEmployeeID").attr("readonly", "readonly");


    $("#ToEmployeeID").after(kendo.format(btndelete, "btnDeleteToEmployeeID", "btnDeleteToEmployeeID_Click()"));
    $("#ToEmployeeID").after(kendo.format(btnadd, "btnToEmployeeID", "btnToEmployeeID_Click()"));
    $("#ToEmployeeID").css("width", "82%");
    $("#ToEmployeeID").attr("readonly", "readonly");
})

function btnFromEmployeeID_Click() {
    var urlChooseEmployeeID = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseEmployeeID, {});
    actionChoose = 3;
}

function btnToEmployeeID_Click() {
    var urlChooseEmployeeID = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseEmployeeID, {});
    actionChoose = 4;
}

function btnDeleteFromEmployeeID_Click() {
    $("#FromEmployeeID").val("");
}
function btnDeleteToEmployeeID_Click() {
    $("#ToEmployeeID").val("");
}


function receiveResult(result) {
    if (actionChoose == 3) {
        $("#FromEmployeeID").val(result["EmployeeID"]);
    }
    if (actionChoose == 4) {
        $("#ToEmployeeID").val(result["EmployeeID"]);
    }
}
