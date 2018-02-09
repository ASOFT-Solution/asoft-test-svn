$(document).ready(function () {
    $(".grid_6").removeClass();
    $(".grid_6").addClass("form-content");
    $("#InventoryID").attr("readonly", "true");
    $("#UnitID").attr("readonly", "true");

    $("#ActualQuantity").css("width", "80%");
    $("#ActualQuantity").after("<input type='button' onclick='CRMF2023_PlusClick()' value='&plus;' /> <input type='button' onclick='CRMF2023_MinusClick()' value='&minus;' />");

});
function CRMF2023_PlusClick() {
    var Quantity = Number($("#ActualQuantity").val());
    $("#ActualQuantity").val(Quantity + 1);
};

function CRMF2023_MinusClick() {
    var Quantity = Number($("#ActualQuantity").val());
    $("#ActualQuantity").val(Quantity - 1);
};