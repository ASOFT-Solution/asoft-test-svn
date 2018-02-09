var actionChoose = null;

$(document).ready(function () {
    var btnadd = '<a id="{0}" style="width : 26px; height: 26px;  background-repeat: no-repeat" data-role="button" class="k-button" role="button" aria-disabled="false" tabindex="0" onclick="{1}"><span class="asf-button-text">...</span></a>';

    var btndelete = '<a id="{0}" style="width : 26px; height: 26px;  background-image: url(/Content/Images/icon-delete-24x24.png); background-repeat: no-repeat" data-role="button" class="k-button" role="button" aria-disabled="false" tabindex="0" onclick="{1}"><span class="asf-button-text"></span></a>';

    $("#FromMemberID").after(kendo.format(btndelete, "btnDeleteFromMemberID", "btnDeleteFromMemberID_Click()"));
    $("#FromMemberID").after(kendo.format(btnadd, "btnFromMemberID", "btnFromMemberID_Click()"));
    $("#FromMemberID").css("width", "82%");
    $("#FromMemberID").attr("readonly", "readonly");


    $("#ToMemberID").after(kendo.format(btndelete, "btnDeleteToMemberID", "btnDeleteToMemberID_Click()"));
    $("#ToMemberID").after(kendo.format(btnadd, "btnToMemberID", "btnToMemberID_Click()"));
    $("#ToMemberID").css("width", "82%");
    $("#ToMemberID").attr("readonly", "readonly");
})

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
}
