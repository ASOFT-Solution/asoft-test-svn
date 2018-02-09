$(document).ready(function () {
    if ($("#isUpdate").val() == "True") {
        CheckUsingCommon();
    }
    $(".Note").parent().prepend($(".SourceID"))
    $(".Note").parent().prepend($(".FrequencyID"))

    $("#Percentage").focusout(function () {
        var value = $(this).val();
        value = formatPercent(kendo.parseFloat(value));
        $(this).val(value);
    })

    $("#Percentage").val(formatPercent(kendo.parseFloat($("#Percentage").val())));

    $("#Revenue").keydown(function (e) { keydowCustom(e, this) });
});

function keydowCustom(e, element) {
    if (e.keyCode < 48 || (e.keyCode > 57 && e.keyCode < 96) || e.keyCode > 105) {
        if (e.keyCode != 9 && e.keyCode != 13 && e.keyCode != 37 && e.keyCode != 39 && e.keyCode != 8 && ((e.keyCode != 190 && e.keyCode != 110) || ($(element).val()).indexOf('.') != -1)) {
            e.preventDefault()
        }
    }
}

function formatPercent(value) {
    var format = ASOFTEnvironment.NumberFormat.KendoPercentDecimalsFormatString;
    return kendo.toString(value, format);
}

function CheckUsingCommon() {
    ASOFT.helper.postTypeJson("/KPI/KPIF0000/CheckUsingCommon", { KeyValues: $("#TargetsDictionaryID").val(), TableID: "KPIT10201" }, function (result) {
        if (result == 1) {  
            $("#IsCommon").attr("disabled", "disabled");
        }
        else {
            $("#TargetsDictionaryID").removeAttr("readonly");
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
