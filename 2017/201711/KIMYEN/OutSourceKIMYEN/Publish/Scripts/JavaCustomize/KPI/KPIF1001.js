$(document).ready(function () {
    //$(".line_left").remove();
    $(".grid_6").addClass("form-content");
    $(".grid_6").removeClass();
    if ($("#isUpdate").val() == "False") {
        $(".Disabled").after("<input type='text' hidden=true value='0' id='Disabled' Name='Disabled'/>");
    }

    if ($("#isUpdate").val() == "True") {
        CheckUsingCommon();
    }

    $("#BonusRate").attr("style", "text-align: right;width:100%;height:22px;");

    $("#BonusRate").val(formatPercent(kendo.parseFloat($("#BonusRate").val())));
    $("#BonusRate").focusout(function (e) {
        var value = $(this).val();
        value = formatPercent(kendo.parseFloat(value));
        $(this).val(value);
    });
});

function formatPercent(value) {
    var format = ASOFTEnvironment.NumberFormat.KendoPercentDecimalsFormatString;
    return kendo.toString(value, format);
}


function CheckUsingCommon() {
    ASOFT.helper.postTypeJson("/KPI/KPIF0000/CheckUsingCommon", { KeyValues: $("#Classification").val(), TableID: "KPIT10001" }, function (result) {
        if (result == 1) {
            $("#IsCommon").attr("disabled", "disabled");
        }
        else {
            $("#Classification").removeAttr("readonly");
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
        }
        else {
            url = url.replace(division, "DivisionID=" + $("#EnvironmentDivisionID").val());
        }
        window.parent.parent.location = url;
        parent.setReload();
    }
}
