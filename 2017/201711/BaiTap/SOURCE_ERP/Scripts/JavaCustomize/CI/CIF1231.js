$(document).ready(function () {
    //$(".line_left").remove();
    $(".grid_6").addClass("form-content");
    $(".grid_6").removeClass();
    if ($("#isUpdate").val() == "False") {
        $("#FromInventoryID").css("width", "90%");
        $("#ToInventoryID").css("width", "90%");
        var btnFrom = '<a id="btSearchFrom" style="border: none !important; z-index:10001; position: absolute; right: 27px; height: 25px; width: 27px;" data-role="button" class="k-button k-button-icontext asf-i-search-24"  role="button" aria-disabled="false" tabindex="0" onclick="btnSearchFrom_Click()"><span class="asf-button-text"></span></a>';
        $("#FromInventoryID").after(btnFrom);

        var btnTo = '<a id="btSearchTo" style="border: none !important; z-index:10001; position: absolute; right: 27px; height: 25px; width: 27px;" data-role="button" class="k-button k-button-icontext asf-i-search-24"  role="button" aria-disabled="false" tabindex="0" onclick="btnSearchTo_Click()"><span class="asf-button-text"></span></a>';
        $("#ToInventoryID").after(btnTo);

    }
    else {
        var index = $("#NormID").data("kendoComboBox").selectedIndex;
        var comboNormID = $("#NormID").data("kendoComboBox").dataSource._data[index];
        if (comboNormID.MaxQuantity != null)
            $("#MaxQuantity").val(formatDecimal(kendo.parseFloat(comboNormID.MaxQuantity)));
        else
            $("#MaxQuantity").val(0);
        if (comboNormID.MinQuantity != null)
            $("#MinQuantity").val(formatDecimal(kendo.parseFloat(comboNormID.MinQuantity)));
        else
            $("#MinQuantity").val(0);
        if (comboNormID.ReOrderQuantity != null)
            $("#ReOrderQuantity").val(formatDecimal(kendo.parseFloat(comboNormID.ReOrderQuantity)));
        else
            $("#ReOrderQuantity").val(0);
    }

    $("#FromInventoryID").attr("readonly", "readonly");
    $("#ToInventoryID").attr("readonly", "readonly");

    $("#NormID").change(function (e) {
        var index = $("#NormID").data("kendoComboBox").selectedIndex;
        var comboNormID = $("#NormID").data("kendoComboBox").dataSource._data[index];
        if (comboNormID.MaxQuantity != null)
            $("#MaxQuantity").val(comboNormID.MaxQuantity);
        else
            $("#MaxQuantity").val(0);
        if (comboNormID.MinQuantity != null)
            $("#MinQuantity").val(comboNormID.MinQuantity);
        else
            $("#MinQuantity").val(0);
        if (comboNormID.ReOrderQuantity != null)
            $("#ReOrderQuantity").val(comboNormID.ReOrderQuantity);
        else
            $("#ReOrderQuantity").val(0);
    })
});

function formatDecimal(value) {
    var format = ASOFTEnvironment.NumberFormat.KendoPercentDecimalsFormatString;
    return kendo.toString(value, format);
}



function btnSearchFrom_Click() {
    var urlChoose = "/PopupSelectData/Index/00/CMNF9001?DivisionID=" + $("#EnvironmentDivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChoose, {});
    action = 1;
}

function btnSearchTo_Click() {
    var urlChoose = "/PopupSelectData/Index/00/CMNF9001?DivisionID=" + $("#EnvironmentDivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChoose, {});
    action = 2;
}

function receiveResult(result) {
    if (action == 1) {
        $("#FromInventoryID").val(result["InventoryID"]);
    }
    if (action == 2) {
        $("#ToInventoryID").val(result["InventoryID"]);
    }
}


function onInsertSuccessCustomer(result) {
    if (result.Status == 0) {
        switch (action) {
            case 1://save new
                if (result.Data == undefined) {
                    ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
                }
                else {
                    ASOFT.form.displayInfo('#' + id, kendo.format(ASOFT.helper.getMessage("00ML000107"), result.Data));
                }

                if (typeof parent.refreshGrid === "function") {
                    parent.refreshGrid(tbPopup);
                }
                if (typeof clearfieldsCustomer === "function") {
                    clearfieldsCustomer();
                }
                else
                    clearfields();
                break;
            case 2://save new
                if (result.Data == undefined) {
                    ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
                }
                else {
                    ASOFT.form.displayInfo('#' + id, kendo.format(ASOFT.helper.getMessage("00ML000107"), result.Data));
                }
                if (typeof parent.refreshGrid === "function") {
                    parent.refreshGrid(tbPopup);
                }
                break;
            case 3://save copy
                updateSuccess = 1;
                ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
                //refreshModel();
                break;
            case 4:
                if (typeof parent.refreshGrid === "function") {
                    parent.refreshGrid(tbPopup);
                }
                parent.popupClose();
            case 0://save close, Lưu xong và đóng lại  
                window.parent.BtnFilter_Click();
                parent.popupClose();
        }
    }
    else {
        if (result.Message != 'Validation') {
            var msg = ASOFT.helper.getMessage(result.Message);
            if (result.Data) {
                if (jQuery.type(result.Data) === "array") {
                    msg = kendo.format(msg, result.Data[0], result.Data[1], result.Data[2]);
                }
                else {
                    msg = kendo.format(msg, result.Data);
                }
            }
            ASOFT.form.displayWarning('#' + id, msg);
        }
        else {
            var msgData = new Array();
            $.each(result.Data, function (index, value) {
                var child = value.split(',');
                var msg = ASOFT.helper.getMessage(child[0]);
                msg = kendo.format(msg, child[1], child[2], child[3], child[4]);
                msgData.push(msg);
            });
            ASOFT.form.displayMultiMessageBox(id, 1, msgData);
        }
    }
}