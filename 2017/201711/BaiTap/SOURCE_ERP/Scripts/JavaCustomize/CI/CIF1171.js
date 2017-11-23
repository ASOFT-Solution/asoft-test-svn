$(document).ready(function () {

    if ($("#isUpdate").val() == "False") {
        $(".Disabled").after("<input type='text' hidden=true value='0' id='Disabled' Name='Disabled'/>");
        $("#IsStocked").attr("checked", "checked");
        GetObjectID("AT1302");
    }
    if ($("#isUpdate").val() == "True") {
        CheckUsingCommon();
    }
    else {
        $("#NormMethod").val(0);
    }

    $("#S1").change(function () {
        GetObjectID("AT1302");
    })

    $("#S2").change(function () {
        GetObjectID("AT1302");
    })

    $("#S3").change(function () {
        GetObjectID("AT1302")
    })

    $("#VATGroupID").change(function () {
        var VATGroupID = $("#VATGroupID").data("kendoComboBox");
        var index = VATGroupID.selectedIndex;
        var float = kendo.parseFloat(VATGroupID.dataSource._data[index].VATRate);
        $("#VATPercent").val(formatDecimal(float));
    })

    $("#ETaxID").change(function () {
        var ETaxID = $("#ETaxID").data("kendoComboBox");
        var index = ETaxID.selectedIndex;
        var float = kendo.parseFloat(ETaxID.dataSource._data[index].ETaxAmount);
        $("#ETaxConvertedUnit").val(formatDecimal(float));
    })

    $("#VATImGroupID").change(function () {
        var VATImGroupID = $("#VATImGroupID").data("kendoComboBox");
        var index = VATImGroupID.selectedIndex;
        var float = kendo.parseFloat(VATImGroupID.dataSource._data[index].VATRate);
        $("#VATImPercent").val(formatDecimal(float));
    })
});

function formatDecimal(value) {
    var format = ASOFTEnvironment.NumberFormat.KendoPercentDecimalsFormatString;
    return kendo.toString(value, format);
}


function GetObjectID(S, action) {
    if (action != 1)
        ASOFT.form.clearMessageBox();
    var data = [];
    data.push(S);
    data.push($("#S1").val());
    data.push($("#S2").val());
    data.push($("#S3").val());

    ASOFT.helper.postTypeJson("/CI/CIF1150/GetObjectID", data, function (result) {
        if (!result.check) {
            var InventoryIDMsg = $($("label[for='InventoryID']")[0]).text().toLowerCase();
            var msg = ASOFT.helper.getMessage("00ML000092");
            msg = kendo.format(msg, InventoryIDMsg);

            ASOFT.form.displayWarning('#CIF1171', msg);
        }
        $("#InventoryID").val(result.ObjectID);
    });
}

function CheckUsingCommon() {
    var data = [];
    data.push($("#InventoryID").val());
    ASOFT.helper.postTypeJson("/CI/CIF1170/CheckUsingCommon", data, function (result) {
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
            $("#InventoryID").removeAttr("readonly");
        }
    });
}

function onAfterInsertSuccess(result, action) {
    if (action == 3 && result.Status == 0) {
        var url = parent.GetUrlContentMaster();
        var listSp = url.split('&');
        var division = listSp[listSp.length - 1];
        if ($("#IsCommon").is(':checked')) {
            url = url.replace(division, "DivisionID=" + "@@@");
            url = url.replace(parent.getInventoryID(), $("#InventoryID").val());
        }
        else {
            url = url.replace(division, "DivisionID=" + $("#EnvironmentDivisionID").val());
            url = url.replace(parent.getInventoryID(), $("#InventoryID").val());
        }
        window.parent.parent.location = url;
        parent.setReload();
    }

    if (result.Status == 0 && (action == 2 || action == 1)) {
        GetObjectID("AT1202", 1);
        $("#NormMethod").val(0);
    }

    if (result.Message == "00ML000053") {
        GetObjectID("AT1302", 1);
    }
}