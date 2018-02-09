$(document).ready(function () {
    //$(".line_left").remove();
    if ($("#isUpdate").val() == "False") {
        GetObjectID("AT1202");
        $(".Disabled").after("<input type='text' hidden=true value='0' id='Disabled' Name='Disabled'/>");
    }
    if ($("#isUpdate").val() == "True") {
        CheckUsingCommon();
    }

    $("#S1").change(function () {
        GetObjectID("AT1202");
    })

    $("#S2").change(function () {
        GetObjectID("AT1202");
    })

    $("#S3").change(function () {
        GetObjectID("AT1202")
    })

    if ($("#IsCustomer").is(':checked')) {
        if ($("#IsRePayment").is(':checked')) {
            disableControlIsRePayment(false);
        }
        else {
            disableControlIsRePayment(true);
        }
    }
    else {
        $("#IsRePayment").attr("disabled", true);
        disableControlIsRePayment(true);
    }
    if ($("#IsSupplier").is(':checked')) {
        if ($("#IsPaPayment").is(':checked')) {
            disableControlIsPaPayment(false);
        }
        else {
            disableControlIsPaPayment(true);
        }
    }
    else {
        $("#IsPaPayment").attr("disabled", true);
        disableControlIsPaPayment(true);
    }

    $("#IsRePayment").bind("click", function () {
        if ($("#IsRePayment").is(':checked')) {
            disableControlIsRePayment(false);
        }
        else {
            disableControlIsRePayment(true);
        }
    })

    $("#IsPaPayment").bind("click", function () {
        if ($("#IsPaPayment").is(':checked')) {
            disableControlIsPaPayment(false);
        }
        else {
            disableControlIsPaPayment(true);
        }
    })

    $("#IsCustomer").bind("click", function () {
        if (!$("#IsCustomer").is(':checked')) {
            $("#IsRePayment").attr("disabled", true);
            $("#IsRePayment").attr("checked", false);
            disableControlIsRePayment(true);
        }
        else {
            $("#IsRePayment").attr("disabled", false);
        }
    })

    $("#IsSupplier").bind("click", function () {
        if (!$("#IsSupplier").is(':checked')) {
            $("#IsPaPayment").attr("disabled", true);
            $("#IsPaPayment").attr("checked", false);
            disableControlIsPaPayment(true);
        }
        else {
            $("#IsPaPayment").attr("disabled", false);
        }
    })
});

function GetObjectID(S, action) {
    if (action != 1)
        ASOFT.form.clearMessageBox();
    var data = [];
    data.push(S);
    data.push($("#S1").val());
    data.push($("#S2").val());
    data.push($("#S3").val());

    ASOFT.helper.postTypeJson("/CI/CIF1150/GetObjectID", data, function (result) {
        if (!result.check)
        {
            var objectIDMsg = $($("label[for='ObjectID']")[0]).text().toLowerCase();
            var msg = ASOFT.helper.getMessage("00ML000092");
            msg = kendo.format(msg, objectIDMsg);

            ASOFT.form.displayWarning('#CIF1151', msg);
        }
        $("#ObjectID").val(result.ObjectID);
    });
}

function disableControlIsRePayment(disable) {
    $("#ReCreditLimit").attr("disabled", disable);
    $("#ReDueDays").attr("disabled", disable);
    $("#DeAddress").attr("disabled", disable);
    $("#ReDays").attr("disabled", disable);
    $("#IsLockedOver").attr("disabled", disable);
    $("#RePaymentTermID").data("kendoComboBox").enable(!disable);
    $("#ReAccountID").data("kendoComboBox").enable(!disable);
}

function disableControlIsPaPayment(disable) {
    $("#PaCreditLimit").attr("disabled", disable);
    $("#PaDiscountPercent").attr("disabled", disable);
    $("#PaDueDays").attr("disabled", disable);
    $("#PaDiscountDays").attr("disabled", disable);
    $("#ReAddress").attr("disabled", disable);
    $("#PaPaymentTermID").data("kendoComboBox").enable(!disable);
    $("#PaAccountID").data("kendoComboBox").enable(!disable);
}


function CheckUsingCommon() {
    var data = [];
    data.push($("#ObjectID").val());
    ASOFT.helper.postTypeJson("/CI/CIF1150/CheckUsingCommon", data, function (result) {
        if (result == 1) {
            if ($("#IsCommon").is(':checked'))
                $(".IsCommon").hide();
            if ($("#S1").data("kendoComboBox") != undefined)
                $("#S1").data("kendoComboBox").readonly(true);
            if ($("#S2").data("kendoComboBox") != undefined)
                $("#S2").data("kendoComboBox").readonly(true);
            if ($("#S3").data("kendoComboBox") != undefined)
                $("#S3").data("kendoComboBox").readonly(true);
        }
        else {
            $("#ObjectID").removeAttr("readonly");
        }
    });
}

function CustomSavePopupLayout() {
    var data = ASOFT.helper.dataFormToJSON("CIF1151");
    var customData = [];
    var key1 = [];;
    var value1 = [];;
    var cb = $("input[type='checkbox']");
    $(cb).each(function () {
        var temp = $(this).is(':checked');
        var id = $(this).attr("id");
        if (temp) {
            data[id] = "1";
        }
        else {
            data[id] = "0";
        }
    })


    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox" && key != "Unique") {
            if (key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key != "CheckInList" && key != "IsPaPayment" && key != "IsRePayment" && key != "AutoInList") {
                key1.push(key);
                var vl = Array();
                if (value == "false")
                    value = "0";
                if (value == "true")
                    value = "1";
                vl.push(data[key + "_Content_DataType"], value);
                value1.push(vl);
            }
        }
    })
    customData.push(key1);
    customData.push(value1);
    return customData;
}

function onAfterInsertSuccess(result, action) {
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

    if (result.Status == 0 && (action == 2 || action == 1)) {
        GetObjectID("AT1202", 1);
    }

    if (result.Message == "00ML000053") {
        GetObjectID("AT1202", 1);
    }
}

