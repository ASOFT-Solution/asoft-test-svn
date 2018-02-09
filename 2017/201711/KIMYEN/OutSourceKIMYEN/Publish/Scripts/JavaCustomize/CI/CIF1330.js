var isClose = false;

$(document).ready(function () {
    $("#Example").attr("disabled", "disabled");
    $("#IsLastKey").attr("checked", false);
    $("#IsSeparator").val(1);


    $("#Save").unbind();
    $("#Save").kendoButton({
        "click": CustomSave_Click
    })
    $("#Close").unbind();
    $("#Close").kendoButton({
        "click": CustomClose_Click,
    });

    $("#TypeID").change(function () {
        var cbb = $("#TypeID").data('kendoComboBox').dataItem($("#TypeID").data('kendoComboBox').select());
        $("#TableID").val(cbb.TableID);
        ReloadPopup(cbb.TableID, cbb.TypeID);
    });

    $(".line_left").prepend($(".IsAutomatic"));

    if (!$("#IsS1").is(':checked'))
    {
        $("#S1").data("kendoComboBox").enable(false);
    }
    else
    {
        $("#S1").data("kendoComboBox").enable(true);
    }

    if (!$("#IsS2").is(':checked')) {
        $("#S2").data("kendoComboBox").enable(false);
    }
    else {
        $("#S2").data("kendoComboBox").enable(true);
    }

    if (!$("#IsS3").is(':checked')) {
        $("#S3").data("kendoComboBox").enable(false);
    }
    else {
        $("#S3").data("kendoComboBox").enable(true);
    }


    if (!$("#IsAutomatic").is(':checked')) {
        $("#OutputOrder").data("kendoComboBox").enable(false);
        $("#Separator").attr("disabled", "disabled");
        $("#Length").attr("disabled", "disabled");
        $("#IsLastKey").attr("disabled", "disabled");
        $("#LastKey").attr("disabled", "disabled");
    }
    else {
        $("#OutputOrder").data("kendoComboBox").enable(true);
        $("#Separator").removeAttr("disabled");
        $("#Length").removeAttr("disabled");
        $("#IsLastKey").removeAttr("disabled");
        if ($("#IsLastKey").is(':checked'))
            $("#LastKey").removeAttr("disabled");
        else
            $("#LastKey").attr("disabled", "disabled");
    }


    $("#IsS1").bind("click", function () {
        if (!$("#IsS1").is(':checked')) {
            $("#S1").data("kendoComboBox").enable(false);
        }
        else {
            $("#S1").data("kendoComboBox").enable(true);
        }
        FormatExemple();
    })

    $("#IsS2").bind("click", function () {
        if (!$("#IsS2").is(':checked')) {
            $("#S2").data("kendoComboBox").enable(false);
        }
        else {
            $("#S2").data("kendoComboBox").enable(true);
        }
        FormatExemple();
    })

    $("#IsS3").bind("click", function () {
        if (!$("#IsS3").is(':checked')) {
            $("#S3").data("kendoComboBox").enable(false);
        }
        else {
            $("#S3").data("kendoComboBox").enable(true);
        }
        FormatExemple();
    })

    $("#IsLastKey").bind("click", function () {
        if (!$("#IsLastKey").is(':checked')) {
            $("#LastKey").attr("disabled", "disabled");
        }
        else {
            $("#LastKey").removeAttr("disabled");
        }
        FormatExemple();
    })

    $("#IsAutomatic").bind("click", function () {
        if (!$("#IsAutomatic").is(':checked')) {
            $("#OutputOrder").data("kendoComboBox").enable(false);
            $("#Separator").attr("disabled", "disabled");
            $("#Length").attr("disabled", "disabled");
            $("#IsLastKey").attr("disabled", "disabled");
            $("#LastKey").attr("disabled", "disabled");
        }
        else {
            $("#OutputOrder").data("kendoComboBox").enable(true);
            $("#Separator").removeAttr("disabled");
            $("#Length").removeAttr("disabled");
            $("#IsLastKey").removeAttr("disabled");
            if ($("#IsLastKey").is(':checked'))
                $("#LastKey").removeAttr("disabled");
            else
                $("#LastKey").attr("disabled", "disabled");
        }
        FormatExemple();
    })

    $("#LastKey").bind("keyup", function () {
        $(this).val(kendo.parseInt($(this).val()))
        FormatExemple();
    })

    $("#Separator").bind("keyup", function () {
        FormatExemple();
    })

    $("#Length").bind("keyup", function () {
        FormatExemple();
    })

    $("#S1").bind("change", function () {
        FormatExemple();
    })
    $("#S2").bind("change", function () {
        FormatExemple();
    })
    $("#S3").bind("change", function () {
        FormatExemple();
    })
    $("#OutputOrder").bind("change", function () {
        FormatExemple();
    })

    FormatExemple();

    $(".IsS1").prepend($(".IsS1").find(".asf-td-field").removeClass("asf-td-field"));
    $(".IsS2").prepend($(".IsS2").find(".asf-td-field").removeClass("asf-td-field"));
    $(".IsS3").prepend($(".IsS3").find(".asf-td-field").removeClass("asf-td-field"));
    $(".IsAutomatic").prepend($(".IsAutomatic").find(".asf-td-field").removeClass("asf-td-field"));
    $(".IsS1").find(".asf-td-caption").removeClass("asf-td-caption")
    $(".IsS2").find(".asf-td-caption").removeClass("asf-td-caption")
    $(".IsS3").find(".asf-td-caption").removeClass("asf-td-caption")
    $(".IsAutomatic").find(".asf-td-caption").removeClass("asf-td-caption")
})
function CustomSave_Click() {

    if (ASOFT.form.checkRequiredAndInList("CIF1330", ["S1", "S2", "S3", "OutputOrder"])) {
        return;
    }

    var data = ASOFT.helper.dataFormToJSON("CIF1330");
    if ($("#IsAutomatic").is(':checked'))
    {
        data["IsAutomatic"] = 1;
    }
    else
        data["IsAutomatic"] = 0;

    if ($("#IsS1").is(':checked')) {
        data["IsS1"] = 1;
    }
    else
        data["IsS1"] = 0;

    if ($("#IsS2").is(':checked')) {
        data["IsS2"] = 1;
    }
    else
        data["IsS2"] = 0;

    if ($("#IsS3").is(':checked')) {
        data["IsS3"] = 1;
    }
    else {
        data["IsS3"] = 0;
    }

    if ($("#IsLasKey").is(':checked')) {
        ASOFT.helper.postTypeJson("/CI/CIF1330/Update?LASTKEY=" + $("#LastKey").val(), data, onInsertSuccess);
    }
    else {
        ASOFT.helper.postTypeJson("/CI/CIF1330/Update", data, onInsertSuccess);
    }
}

function onInsertSuccess(result) {
    if (result.Status == 0)//Khong co loi
    {
        ASOFT.form.displayInfo('#CIF1330', ASOFT.helper.getMessage(result.Message));
        if(isClose)
            ASOFT.asoftPopup.closeOnly();
    }
    else {
        ASOFT.form.displayWarning('#CIF1330', AsoftMessage[result.Message]);
    }
}



function CustomClose_Click() {
    ASOFT.dialog.confirmDialog(
       AsoftMessage['00ML000016'],
       function () {
           isClose = true;
           CustomSave_Click();
       },
       function () {
           ASOFT.asoftPopup.closeOnly();
       })
};

function FormatExemple(Lastcharacter) {
    ASOFT.form.clearMessageBox();

    if (!$("#IsAutomatic").is(':checked'))
    {
        $("#Example").val("");
        return false;
    }
    if ($("#Length").val() == "" || $("#Length").val() == null)
    {
        $("#Example").val("");
        return false;
    }


    var args = new Object();
    if (!$("#IsS1").is(':checked')) {
        args["IsS1"] = false;
    }
    else {
        args["IsS1"] = true;
    }

    if (!$("#IsS2").is(':checked')) {
        args["IsS2"] = false;
    }
    else {
        args["IsS2"] = true;
    }

    if (!$("#IsS3").is(':checked')) {
        args["IsS3"] = false;
    }
    else {
        args["IsS3"] = true;
    }
    args["S1"] = $("#S1").val();
    args["S2"] = $("#S2").val();
    args["S3"] = $("#S3").val();
    args["LastKey"] = $("#LastKey").val();
    args["Length"] = $("#Length").val();
    args["Separator"] = $("#Separator").val();
    args["OutputOrder"] = $("#OutputOrder").val();


    ASOFT.helper.postTypeJson("/CI/CIF1330/Example", { data: args }, function (result) {
        if (result == "false")
        {
            var msg = ASOFT.helper.getMessage("00ML000098");
            ASOFT.form.displayWarning('#CIF1330', msg);
        }
        else
            $("#Example").val(result);
    });
}

function ReloadPopup(TableID, TypeID) {
    ASOFT.helper.postTypeJson("/CI/CIF1330/ReloadPopup", { TableID: TableID, TypeID: TypeID }, function (result) {
        OpenComboDynamic($("#S1").data("kendoComboBox"));
        OpenComboDynamic($("#S2").data("kendoComboBox"));
        OpenComboDynamic($("#S3").data("kendoComboBox"));
        $("#IsS1").prop('checked', result.IsS1 == 1);
        $("#S1").data("kendoComboBox").enable(result.IsS1 == 1);
        $("#IsS2").prop('checked', result.IsS2 == 1);
        $("#S2").data("kendoComboBox").enable(result.IsS2 == 1);
        $("#IsS3").prop('checked', result.IsS3 == 1);
        $("#S3").data("kendoComboBox").enable(result.IsS3 == 1);
        $("#S1").data("kendoComboBox").value(result.S1 ? result.S1 : "");
        $("#S2").data("kendoComboBox").value(result.S2 ? result.S2 : "");
        $("#S3").data("kendoComboBox").value(result.S3 ? result.S3 : "");
        $("#TypeID").data("kendoComboBox").value(result.TypeID);

        $("#IsAutomatic").prop('checked', result.IsAutomatic == 1);
        $("#IsLastKey").prop('checked', result.IsLastKey == 1);
        $("#OutputOrder").data("kendoComboBox").value(result.OutputOrder ? result.OutputOrder : "");
        $("#Separator").val(result.Separator);
        $("#Length").data('kendoNumericTextBox').value(result.Length ? result.Length : "");
        $("#LastKey").val(result.LastKey);

        $("#OutputOrder").data("kendoComboBox").enable(result.IsAutomatic == 1);
        $("#Separator").attr("disabled", result.IsAutomatic != 1);
        $("#Length").attr("disabled", result.IsAutomatic != 1);
        $("#IsLastKey").attr("disabled", result.IsAutomatic != 1);
        $("#LastKey").attr("disabled", (result.IsAutomatic != 1 || result.IsLastKey != 1));
        FormatExemple();
    })
}
