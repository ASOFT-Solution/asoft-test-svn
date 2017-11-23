var rowChoose = null;
var FORM_ID = "POSF00163";
var posGrid = null;

$(document).ready(function () {
    posGrid = $("#GridInventoryCA").data("kendoGrid");
})

function radio_Click(tag) {
    var row = $(tag).parent().closest('tr');
    rowChoose = posGrid.dataItem(row);
}

function btnChoose_Click() {
    if (rowChoose == null) {
        ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('00ML000066'/*'A00ML000003'*/));
        return;
    }
    window.parent.receiveResult(rowChoose);
    ASOFT.asoftPopup.closeOnly();
}

function btnCancle_Click() {
    ASOFT.asoftPopup.closeOnly();
}


function sendDataSearch() {
    var dataFilter = ASOFT.helper.dataFormToJSON(FORM_ID);
    return dataFilter;
}