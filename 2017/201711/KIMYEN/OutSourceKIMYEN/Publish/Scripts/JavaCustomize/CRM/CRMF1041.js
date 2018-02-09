

var changeLengthFieldGroup = function () {
    var $classGrid_6 = $("body").find(".grid_6");

    if (typeof $classGrid_6 !== "undefined") {
        $classGrid_6.removeClass().addClass("grid_12");
    }

    return false;
},

k_NumericTextBox_Rate_Change = function (e) {
    var sender = e.sender;
    //e.preventDefault();
    (sender.value() == null || sender.value() == "") ? sender.value(0) : sender.value();
}

formatForNumericTextBox = function (id, stringFormat, min, max, objDefault, changeFunction) {
    var kendoNumTxtBx = "kendoNumericTextBox",
        k_NumericTextBox = $("#" + id).data(kendoNumTxtBx);

    if (typeof k_NumericTextBox !== "undefined") {
        stringFormat !== null ? (k_NumericTextBox.setOptions({ format: stringFormat, decimals: ASOFTEnvironment.NumberFormat.PercentDecimals }), k_NumericTextBox.value(k_NumericTextBox.value())) : false;

        k_NumericTextBox.min(min);

        k_NumericTextBox.max(max);

        if (objDefault !== null && objDefault.isDefault) {
            k_NumericTextBox.value() === null || k_NumericTextBox.value() == "" ? k_NumericTextBox.value(objDefault.Value) : false;
        }

        typeof changeFunction === "function" ? k_NumericTextBox.bind("change", changeFunction) : false;
    }

    return false;
},

setDefaultValue = function () {

    var isSystem = $("#IsSystem");
    typeof isSystem !== "undefined" ? (
        isSystem.val() == null || isSystem.val() == "" ? isSystem.val(0) : isSystem.val(isSystem.val())
    ): false;
}

$(document).ready(function () {
    setDefaultValue();
    changeLengthFieldGroup();
    formatForNumericTextBox("Rate", ASOFTEnvironment.NumberFormat.KendoPercentDecimalsFormatString, 0, 100, { isDefault: true, Value: 0 }, k_NumericTextBox_Rate_Change);
    formatForNumericTextBox("OrderNo", null, 0, null, null, null);
    if ($("#isUpdate").val() == "False") {
        refreshModel();
    }
    else {
        if ($("#IsSystem").val() == "1") {
            $("#StageType").data("kendoComboBox").enable(false);
            $("#StageName").attr("disabled", "disabled");
            $("#StageID").attr("disabled", "disabled");
            $("#IsCommon").attr("disabled", "disabled");
            $("#Disabled").attr("disabled", "disabled");
            $("#Rate").data("kendoNumericTextBox").enable(false);
        }
    }
})

function onAfterInsertSuccess(result, action) {
    setDefaultValue();
    if (action == 3 && result.Status == 0) {
        var url = parent.GetUrlContentMaster();
        var listSp = url.split('&');
        var division = listSp[listSp.length - 1];
        if ($("#IsCommon").is(':checked')) {
            url = url.replace(division, "DivisionID=" + "@@@");
        }
        else {
            url = url.replace(division, "DivisionID=" + $("#EnvironmentDivisionID").val());
        }
        window.parent.parent.location = url;
        parent.setReload();
    }
}

function AddValueComboboxCustom() { // set value thêm nhanh của combo nguồn đầu mối
    localStorage.setItem("ValueCombobox", $("#StageID").val());
}