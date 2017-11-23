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

    $("#TableID").val("AT1302");

    $(".line_left").prepend($(".IsAutomatic"));

    if (!$("#IsS1").is(':checked')) {
        $("#S1").data("kendoComboBox").enable(false);
    }
    else {
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
})
function CustomSave_Click() {
    if (ASOFT.form.checkRequiredAndInList("CIF1340", ["S1", "S2", "S3", "OutputOrder"])) {
        return;
    }

    var data = ASOFT.helper.dataFormToJSON("CIF1340");
    if ($("#IsAutomatic").is(':checked')) {
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
    else
        data["IsS3"] = 0;

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
        ASOFT.form.displayInfo('#CIF1340', ASOFT.helper.getMessage(result.Message));
        parent.window.location.reload();
    }
    else {
        ASOFT.form.displayWarning('#CIF1340', AsoftMessage[result.Message]);
    }
}



function CustomClose_Click() {
    ASOFT.dialog.confirmDialog(
       AsoftMessage['00ML000016'],
       function () {
           CustomSave_Click();
       },
       function () {
           ASOFT.asoftPopup.closeOnly();
       })
};

function FormatExemple(Lastcharacter) {
    ASOFT.form.clearMessageBox();

    if (!$("#IsAutomatic").is(':checked'))
        return false;
    if ($("#Length").val() == "" || $("#Length").val() == null)
        return false;

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
        if (result == "false") {
            var msg = ASOFT.helper.getMessage("00ML000099");
            ASOFT.form.displayWarning('#CIF1340', msg);
        }
        else
            $("#Example").val(result);
    });
}

