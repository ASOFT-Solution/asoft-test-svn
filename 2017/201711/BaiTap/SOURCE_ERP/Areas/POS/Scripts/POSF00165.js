
$(document).ready(function () {
    setTimeout(function () {
        $(".k-window-actions").html("<button onclick='btnClose_Click()' style='background-color: rgba(0, 0, 0, 0);border:0'><img src='/Areas/POS/Content/images/close.png'></button>");
    }, 500);
});

function GridDataPOSF00165() {
    var data = {};
    data.InventoryID = $("#InventoryID").val();
    return data;
}

function btnClose_Click() {
    ASOFT.asoftPopup.closeOnly();
};