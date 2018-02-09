$(document).ready(function () {
    //$(".line_left").remove();
    $(".grid_6").addClass("form-content");
    $(".grid_6").removeClass();
    if ($("#isUpdate").val() == "False") {
        $("#KITID").attr("readonly", true);
        $("#UnitID ").attr("readonly", true);
        $("#InventoryID ").attr("readonly", true);
        $("#KITID").val(parent.getKIDID());
        $("#DivisionID").val(parent.getDivisionID());

        $("#InventoryID").css("width", "90%");
        var btnFrom = '<a id="btSearchFrom" style="border: none !important; z-index:10001; position: absolute; right: 27px; height: 25px; width: 27px;" data-role="button" class="k-button k-button-icontext asf-i-search-24" role="button" aria-disabled="false" tabindex="0" onclick="btnSearchFrom_Click()"></a>';
        $("#InventoryID").after(btnFrom);
        if (parent.getDivisionID() == "@@@")
        {
            $("#IsCommon").val(1);
        }
        else
            $("#IsCommon").val(0);
    }
    else {
        //$("#btnOpenSearch_InventoryID").trigger("click");
        //$("#InventoryID").data("kendoAutoComplete").readonly(true);
    }
    $("#InventoryName").attr("disabled", "disabled");
});

function btnSearchFrom_Click() {
    var urlChoose = "/PopupSelectData/Index/00/CMNF9001?DivisionID=" + $("#EnvironmentDivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

function receiveResult(result) {
    $("#InventoryID").val(result["InventoryID"]);
    $("#UnitID").val(result["UnitID"]);
    //$("#Quantity").val(result["Quantity"]);
    //$("#InventoryName").val(result["InventoryName"]);
}


//function CustomerCheck() {
//    var data = $("#InventoryID").data("kendoAutoComplete").dataSource._data;
//    var value = $("#InventoryID").data("kendoAutoComplete").value();
//    for (i = 0; i < data.length; i++)
//    {
//        if (data[i].InventoryID == value)
//            return false;
//    }
//    var msg = ASOFT.helper.getLabelText("InventoryID", '00ML000064');
//    ASOFT.form.displayError("#CIF1183", msg);
//    $("#InventoryID").addClass('asf-focus-input-error');
//    return true;
//}

function Auto_ChangeDynamic(item) {
    if (item != undefined) {
        $("#UnitID").val(item.InventoryUnitID);
        $("#Quantity").val(item.InventoryQuantity);
    }
}

function clearfieldsCustomer() {
    var data = ASOFT.helper.dataFormToJSON(id);
    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox") {
            if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key.indexOf("listRequired") == -1 && key != "CheckInList" && key != "tableNameEdit" && key != "KITID") {
                if ($("#" + key).data("kendoComboBox") != null) {
                    $("#" + key).data("kendoComboBox").value("");
                }
                if ($("#" + key).data("kendoDropDownList") != null) {
                    $("#" + key).data("kendoDropDownList").value("");
                    $("#" + key).data("kendoDropDownList").text("");
                }
                $("#" + key).val('');
            }
        }
    })
}