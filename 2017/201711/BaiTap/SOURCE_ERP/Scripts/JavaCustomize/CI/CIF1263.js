$(document).ready(function () {
    //$(".line_left").remove();
    $(".grid_6").addClass("form-content");
    $(".grid_6").removeClass();

    if ($("#isUpdate").val() == "False") {
        $("#PromoteID").val(parent.getPromoteID());
        $("#DivisionID").val(parent.getDivisionID());
    }
});

function CustomerCheck() {
    var FromValues = parseFloat($("#FromValues").val());
    var ToValues = parseFloat($("#ToValues").val());

    if (FromValues > ToValues) {
        var msg = ASOFT.helper.getMessage("CFML000186");
        ASOFT.form.displayError("#CIF1263", msg);
        return true;
    }
    return false;
}