var arr1 = ["11", "12"];
var arr2 = ["0", "13", "25", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "98"];
var arr3 = ["14", "15"];
var arr4 = ["21"];
var arr5 = ["22", "23"];
var arr6 = ["31"];
var arr7 = ["32"];
var arr8 = ["33"];
var arr9 = ["99"];


$(document).ready(function () {
    //$("#Tabs-2 .grid_6").removeClass();
    $($("#Tabs-1 .line_left").find("tbody")).prepend($(".IsDefault"));
    $($("#Tabs-2 .line_left").find("tbody")).prepend($(".WareHouseID"));
    $($("#Tabs-2 .line_left").find("tbody")).prepend($(".ExWareHouseID"));
    $($("#Tabs-2 .line_left").find("tbody")).prepend($(".CurrencyID"));
    $("#Tabs-2 .line_left").find("tr").hide();

    var buttonSearchObjec = '<span class="asf-button-special"><a id="btnOpenObject" class="btnOpenSearch k-button k-button-icontext asf-button asf-icon-24 asf-i-search-24" style="width: 25px; height: 25px" data-role="button" role="button" aria-disabled="false" onclick="OpenPopup()" tabindex="0">&nbsp;</a></span>';
    $($(".ObjectID").find('td')[1]).append(buttonSearchObjec);
    $(".ObjectID").find('input').css("width", "85%");
    $("#ObjectID").attr("readonly", "readonly");

    enbaleArr($("#VoucherGroupID").val());
    $("#S1").attr("readonly", "readonly");
    $("#S2").attr("readonly", "readonly");
    $("#S3").attr("readonly", "readonly");
    $(".S1 td")[0].remove();
    $(".S2 td")[0].remove();
    $(".S3 td")[0].remove();

    $($($("#Tabs-3 .grid_6")[0]).find("tbody")).append($(".OutputOrder"));
    $($($("#Tabs-3 .grid_6")[0]).find("tbody")).append($(".OutputLength"));
    $("#Tabs-3 .asf-filter-main").prepend($(".Auto"));

    var checked1 = ""
    var checked2 = ""
    var checked3 = ""
    var disabled = "disabled = 'disabled'";
    if ($("#Auto").is(':checked')) {
        if ($("#Enabled1").is(':checked')) {
            $("#S1Type").data("kendoComboBox").readonly(false);
        }
        if ($("#Enabled2").is(':checked')) {
            $("#S2Type").data("kendoComboBox").readonly(false);
        }
        if ($("#Enabled3").is(':checked')) {
            $("#S3Type").data("kendoComboBox").readonly(false);
        }
    }
    else {
        $("#Enabled1").attr("disabled", "disabled");
        $("#Enabled2").attr("disabled", "disabled");
        $("#Enabled3").attr("disabled", "disabled");
        $("#S1Type").data("kendoComboBox").value("");
        $("#S2Type").data("kendoComboBox").value("");
        $("#S3Type").data("kendoComboBox").value("");
        $("#separator").val("");
        $("#OutputLength").val("");
        $("#OutputOrder").data("kendoComboBox").value("");
        $("#S1").val("");
        $("#S2").val("");
        $("#S3").val("");

        $("#S1Type").data("kendoComboBox").readonly(true);
        $("#S2Type").data("kendoComboBox").readonly(true);
        $("#S3Type").data("kendoComboBox").readonly(true);
        $("#separator").attr("readonly", "readonly");
        $("#OutputLength").attr("readonly", "readonly");
        $("#OutputOrder").data("kendoComboBox").readonly(true);
    }

    $("#Auto").bind("click", function () {
        if (!$("#Auto").is(':checked')) {
            if ($("#Enabled1").is(':checked')) {
                $("#Enabled1").trigger("click");
            }
            if ($("#Enabled2").is(':checked')) {
                $("#Enabled2").trigger("click");
            }
            if ($("#Enabled3").is(':checked')) {
                $("#Enabled3").trigger("click");
            }

            $("#Enabled1").attr("disabled", "disabled");
            $("#Enabled2").attr("disabled", "disabled");
            $("#Enabled3").attr("disabled", "disabled");
            $("#S1Type").data("kendoComboBox").readonly(true);
            $("#S2Type").data("kendoComboBox").readonly(true);
            $("#S3Type").data("kendoComboBox").readonly(true);
            $("#separator").attr("readonly", "readonly");
            $("#OutputLength").attr("readonly", "readonly");
            $("#OutputOrder").data("kendoComboBox").readonly(true);

            $("#S1Type").data("kendoComboBox").value("");
            $("#S2Type").data("kendoComboBox").value("");
            $("#S3Type").data("kendoComboBox").value("");
            $("#separator").val("");
            $("#S1").val("");
            $("#S2").val("");
            $("#S3").val("");
            $("#OutputLength").val("");
            $("#OutputOrder").data("kendoComboBox").value("");
        }
        else {
            $("#Enabled1").removeAttr("disabled");
            $("#Enabled2").removeAttr("disabled");
            $("#Enabled3").removeAttr("disabled");

            if (!$("#Enabled1").is(':checked')) {
                $("#Enabled1").trigger("click");
            }
            if (!$("#Enabled2").is(':checked')) {
                $("#Enabled2").trigger("click");
            }
            if (!$("#Enabled3").is(':checked')) {
                $("#Enabled3").trigger("click");
            }

            $("#S1Type").data("kendoComboBox").readonly(false);
            $("#S2Type").data("kendoComboBox").readonly(false);
            $("#S3Type").data("kendoComboBox").readonly(false);
            $("#separator").removeAttr("readonly");
            $("#OutputLength").removeAttr("readonly");
            $("#OutputOrder").data("kendoComboBox").readonly(false);
        }
    })


    $($(".S1Type").find('td')[0]).prepend($(".Enabled1 input"));
    $($(".S2Type").find('td')[0]).prepend($(".Enabled2 input"));
    $($(".S3Type").find('td')[0]).prepend($(".Enabled3 input"));
    $(".Enabled1").remove();
    $(".Enabled2").remove();
    $(".Enabled3").remove();

    if (!$("#Enabled").is(':checked')) {
        $("#Separated").attr("readonly", "readonly");
    }

    $("#Enabled").bind("click", function () {
        if (!$("#Enabled").is(':checked')) {
            $("#Separated").attr("readonly", "readonly");
            $("#Separated").val("");
        }
        else {
            $("#Separated").removeAttr("readonly");
            $("#Separated").focus();
        }
    })

    $("#Enabled1").bind("click", function () {
        if (!$("#Enabled1").is(':checked')) {
            $("#S1Type").data("kendoComboBox").readonly(true);
        }
        else {
            $("#S1Type").data("kendoComboBox").readonly(false);
        }
    })

    $("#Enabled2").bind("click", function () {
        if (!$("#Enabled2").is(':checked')) {
            $("#S2Type").data("kendoComboBox").readonly(true);
        }
        else {
            $("#S2Type").data("kendoComboBox").readonly(false);
        }
    })


    $("#Enabled3").bind("click", function () {
        if (!$("#Enabled3").is(':checked')) {
            $("#S3Type").data("kendoComboBox").readonly(true);
        }
        else {
            $("#S3Type").data("kendoComboBox").readonly(false);
        }
    })



    if ($("#isUpdate").val() == "False") {
        $(".Disabled").after("<input type='text' hidden=true value='0' id='Disabled' Name='Disabled'/>");
    }
    if ($("#isUpdate").val() == "True") {
        CheckUsingCommon();
    }

    if (!$("#IsDefault").is(':checked')) {
        DisableTabDefault(false);
    }
    if ($("#IsBDescription").is(':checked')) {
        $("#BDescription").attr("readonly", true);
    }
    if ($("#IsTDescription").is(':checked')) {
        $("#TDescription").attr("readonly", true);
    }


    $("#IsDefault").bind("click", function () {
        if (!$("#IsDefault").is(':checked')) {
            DisableTabDefault(false);
        }
        else {
            DisableTabDefault(true);
        }
    })

    $("#IsBDescription").bind("click", function () {
        if ($("#IsBDescription").is(':checked')) {
            $("#BDescription").attr("readonly", true);
            $("#BDescription").val($("#VDescription").val());
        }
        else {
            $("#BDescription").attr("readonly", false);
        }
    })

    $("#IsTDescription").bind("click", function () {
        if ($("#IsTDescription").is(':checked')) {
            $("#TDescription").attr("readonly", true);
            $("#TDescription").val($("#VDescription").val());
        }
        else {
            $("#TDescription").attr("readonly", false);
        }
    })

    $("#VoucherGroupID").change(function () {
        $("#Tabs-2 .line_left").find("tr").hide();
        enbaleArr($(this).val());
    })


    $("#S1Type").change(function () {
        var valueS = $(this).val();
        Schange(valueS, "S1");
    })

    $("#S2Type").change(function () {
        var valueS = $(this).val();
        Schange(valueS, "S2");
    })

    $("#S3Type").change(function () {
        var valueS = $(this).val();
        Schange(valueS, "S3");
    })

    $("#VoucherTypeID").bind("focusout", function () {
        if ($("#S1Type").val() == 3) {
            $("#S1").val($(this).val());
        }
        if ($("#S2Type").val() == 3) {
            $("#S2").val($(this).val());
        }
        if ($("#S3Type").val() == 3) {
            $("#S3").val($(this).val());
        }
    })
});

function Schange(val, txt) {
    $("#" + txt).attr("readonly", "readonly");
    $("#" + txt).val("");
    switch (val) {
        case "1":
            var date = new Date();
            if (date.getMonth() < 10 && date.getMonth() > 0)
                $("#" + txt).val("0" + date.getMonth());
            else
                $("#" + txt).val(date.getMonth());
            break;
        case "2":
            var date = new Date();
            $("#" + txt).val(date.getFullYear());
            break;
        case "3":
            $("#" + txt).val($("#VoucherTypeID").val());
            break;
        case "4":
            $("#" + txt).val($("#EnvironmentDivisionID").val());
            break;
        case "5":
            $("#" + txt).removeAttr("readonly");
            $("#" + txt).focus();
            break;
        case "6":
            var date = new Date();
            var length = date.getFullYear().toString().length;
            $("#" + txt).val(date.getFullYear().toString()[length - 2] + date.getFullYear().toString()[length - 1]);
            break;
    }
}

function DisableTabDefault(enable)
{
    var tab = $("#Tabs").data("kendoTabStrip");
    var item = $("#Tabs").data("kendoTabStrip").items()[1];
    if (!enable)
        tab.disable(item);
    else
        tab.enable(item);
}

function CheckUsingCommon() {
    var data = [];
    data.push($("#VoucherTypeID").val());
    ASOFT.helper.postTypeJson("/CI/CIF1320/CheckUsingCommon", data, function (result) {
        if (result == 1) {
            if ($("#IsCommon").is(':checked'))
                $(".IsCommon").hide();
        }
        else {
            $("#VoucherTypeID").removeAttr("readonly");
        }
    });
}

function enbaleArr(value) {
    if (jQuery.inArray(value, arr1) != -1)
    {
        $(".CurrencyID").show();
        $(".DebitAccountID").show();
        $(".CreditAccountID").show();
        $(".VATTypeID").show();
        return;
    }
    if (jQuery.inArray(value, arr3) != -1) {
        $(".BankAccountID").show();
        $(".VATTypeID").show();
        return;
    }
    if (jQuery.inArray(value, arr4) != -1) {
        $(".CreditAccountID").show();
        $(".VATTypeID").show();
        $(".IsVAT").show();
        return;
    }
    if (jQuery.inArray(value, arr5) != -1) {
        $(".DebitAccountID").show();
        $(".VATTypeID").show();
        $(".IsVAT").show();
        return;
    }
    if (jQuery.inArray(value, arr6) != -1) {
        $(".ObjectID").show();
        $(".CreditAccountID").show();
        $(".WareHouseID").show();
        return;
    }
    if (jQuery.inArray(value, arr7) != -1) {
        $(".ObjectID").show();
        $(".DebitAccountID").show();
        $(".WareHouseID").show();
        return;
    }
    if (jQuery.inArray(value, arr8) != -1) {
        $(".ObjectID").show();
        $(".WareHouseID").show();
        $(".ExWareHouseID").show();
        return;
    }
    if (jQuery.inArray(value, arr9) != -1) {
        $(".CreditAccountID").show();
        return;
    }
}

function OpenPopup() {
    var url = "/PopupSelectData/Index/00/CMNF9004?DivisionID=" + $("#DivisionID").val() + "&Mode=" + 0;
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(url, {});
}

function receiveResult(result) {
    $("#ObjectID").val(result["ObjectID"]);
}