var actionChoose = null;

$(document).ready(function () {
    var btnadd = '<a id="{0}" style="width : 26px; height: 26px;  background-repeat: no-repeat" data-role="button" class="k-button" role="button" aria-disabled="false" tabindex="0" onclick="{1}"><span class="asf-button-text">...</span></a>';

    var btndelete = '<a id="{0}" style="width : 26px; height: 26px;  background-image: url(/Content/Images/icon-delete-24x24.png); background-repeat: no-repeat" data-role="button" class="k-button" role="button" aria-disabled="false" tabindex="0" onclick="{1}"><span class="asf-button-text"></span></a>';

    $("#FromInventoryID").after(kendo.format(btndelete, "btnDeleteFromInventoryID", "btnDeleteFromInventoryID_Click()"));
    $("#FromInventoryID").after(kendo.format(btnadd, "btnFromInventoryID", "btnFromInventoryID_Click()"));
    $("#FromInventoryID").css("width", "82%");
    $("#FromInventoryID").attr("readonly", "readonly");


    $("#ToInventoryID").after(kendo.format(btndelete, "btnDeleteToInventoryID", "btnDeleteToInventoryID_Click()"));
    $("#ToInventoryID").after(kendo.format(btnadd, "btnToInventoryID", "btnToInventoryID_Click()"));
    $("#ToInventoryID").css("width", "82%");
    $("#ToInventoryID").attr("readonly", "readonly");


    $("#FromMemberID").after(kendo.format(btndelete, "btnDeleteFromMemberID", "btnDeleteFromMemberID_Click()"));
    $("#FromMemberID").after(kendo.format(btnadd, "btnFromMemberID", "btnFromMemberID_Click()"));
    $("#FromMemberID").css("width", "82%");
    $("#FromMemberID").attr("readonly", "readonly");


    $("#ToMemberID").after(kendo.format(btndelete, "btnDeleteToMemberID", "btnDeleteToMemberID_Click()"));
    $("#ToMemberID").after(kendo.format(btnadd, "btnToMemberID", "btnToMemberID_Click()"));
    $("#ToMemberID").css("width", "82%");
    $("#ToMemberID").attr("readonly", "readonly");
})

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

function btnFromMemberID_Click() {
    var urlChooseInventoryID = "/PopupSelectData/Index/POS/POSF00761?DivisionIDList=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseInventoryID, {});
    actionChoose = 1;
}

function btnToMemberID_Click() {
    var urlChooseInventoryID = "/PopupSelectData/Index/POS/POSF00761?DivisionIDList=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseInventoryID, {});
    actionChoose = 2;
}


function btnDeleteFromMemberID_Click() {
    $("#FromMemberID").val("");
}
function btnDeleteToMemberID_Click() {
    $("#ToMemberID").val("");
}

function receiveResult(result) {
    if (actionChoose == 1) {
        $("#FromMemberID").val(result["MemberID"]);
    }
    if (actionChoose == 2) {
        $("#ToMemberID").val(result["MemberID"]);
    }
    if (actionChoose == 3) {
        $("#FromInventoryID").val(result["InventoryID"]);
    }
    if (actionChoose == 4) {
        $("#ToInventoryID").val(result["InventoryID"]);
    }
}
