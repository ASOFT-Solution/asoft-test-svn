$(document).ready(function () {
    //$(".line_left").remove();
    $(".grid_6").addClass("form-content");
    $(".grid_6").removeClass();

    if ($("#isUpdate").val() == "False") {
        $("#PromoteID").val(parent.getPromoteID());
        $("#DivisionID").val(parent.getDivisionID());
        var buttonSearchObjec = '<a id="btnOpenObject" class="btnOpenSearch k-button k-button-icontext asf-i-search-24" style="border-bottom: none !important; z-index:10001; position: absolute; right: 27px; height: 25px;" data-role="button" role="button" aria-disabled="false" onclick="OpenPopup()" tabindex="0">&nbsp;</a>';
        $($(".InventoryID").find('td')[1]).append(buttonSearchObjec);
        $(".InventoryID").find('input').css("width", "85%");
        $("#InventoryID").attr("readonly", "readonly");
    }
    else {
        $("#InventoryName").attr("disabled", "disabled");
        $("#PromoteTypeName").attr("disabled", "disabled");
    } 
});

function OpenPopup() {
    var url = "/PopupSelectData/Index/00/CMNF9001?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(url, {});
}

function receiveResult(result) {
    $("#InventoryID").val(result["InventoryID"]);
}