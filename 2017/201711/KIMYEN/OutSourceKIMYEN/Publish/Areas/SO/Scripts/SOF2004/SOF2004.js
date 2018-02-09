
$(document).ready(function () {
    setTimeout(function () {
        $(".k-window-actions").html("<button onclick='btnClose_Click()' style='background-color: rgba(0, 0, 0, 0);border:0'><img src='/Areas/SO/Content/images/close.png'></button>");
    }, 500);
});

function GridDataF2() {
    var data = {};
    data.DivisionID = $("#DivisionID").val()
    data.InventoryID = $("#InventoryID").val()
    return data;
}

function btnClose_Click() {
    ASOFT.asoftPopup.closeOnly();
};