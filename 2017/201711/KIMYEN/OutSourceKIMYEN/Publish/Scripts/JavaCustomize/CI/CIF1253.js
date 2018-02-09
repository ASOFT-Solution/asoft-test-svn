$(document).ready(function () {
    $("#UnitID").attr("readonly", true);
    $("#ID").attr("readonly", true);
    $("#InventoryName ").attr("disabled", "disabled");

    if ($("#isUpdate").val() == "False") {
        $("#ID").val(parent.getID());
        $("#DetailID").val(createGuid());
        $("#InventoryID").css("width", "90%");
        var btnFrom = '<a id="btSearchFrom" style="border: none !important; z-index:10001; position: absolute; right: 24px; height: 25px; width: 30px;" data-role="button" class="k-button k-button-icontext asf-i-search-24" role="button" aria-disabled="false" tabindex="0" onclick="btnSearchFrom_Click()"><span class="asf-button-text"></span></a>';
        $("#InventoryID").attr("readonly", "readonly");
        $("#InventoryID").after(btnFrom);
    }
    else {
        $("#btnOpenSearch_InventoryID").trigger("click");
    }
});


function btnSearchFrom_Click() {
    var urlChoose = "/PopupSelectData/Index/00/CMNF9001?DivisionID=" + $("#EnvironmentDivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

function receiveResult(result) {
    $("#InventoryID").val(result["InventoryID"]);
    $("#InventoryName").val(result["InventoryName"]);
    $("#UnitID").val(result["UnitID"]);
}



function createGuid() {
    function s4() {
        return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
    }
    return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
}


function Auto_ChangeDynamic(item) {
    if (item != undefined) {
        $("#InventoryName").val(item.InventoryName);
        $("#UnitID").val(item.InventoryUnitID);
    }
}

//function CustomerCheck() {
//    var data = $("#InventoryID").data("kendoAutoComplete").dataSource._data;
//    var value = $("#InventoryID").data("kendoAutoComplete").value();
//    for (i = 0; i < data.length; i++) {
//        if (data[i].InventoryID == value)
//            return false;
//    }
//    var msg = ASOFT.helper.getLabelText("InventoryID", '00ML000064');
//    ASOFT.form.displayError("#CIF1253", msg);
//    $("#InventoryID").addClass('asf-focus-input-error');
//    return true;
//}
function onAfterInsertSuccess(result, action) {
    if (result.Status == 0)
    {
        $("#DetailID").val(createGuid());
    }
}

function clearfieldsCustomer() {
    var data = ASOFT.helper.dataFormToJSON(id);
    $("#InventoryName").val('');
    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox") {
            if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key.indexOf("listRequired") == -1 && key != "CheckInList" && key != "tableNameEdit" && key != "ID") {
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