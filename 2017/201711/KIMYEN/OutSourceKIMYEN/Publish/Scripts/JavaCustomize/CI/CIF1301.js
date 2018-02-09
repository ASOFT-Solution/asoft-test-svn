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
});

function CheckUsingCommon() {
    var data = [];
    data.push($("#NormID").val());
    ASOFT.helper.postTypeJson("/CI/CIF1300/CheckUsingCommon", data, function (result) {
        if (result == 1) {
            if ($("#IsCommon").is(':checked'))
                $(".IsCommon").hide();
        }
        else {
            $("#NormID").removeAttr("readonly");
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

function CustomerCheck() {
    var max = parseFloat($("#MaxQuantity").val());
    var min = parseFloat($("#MinQuantity").val());
    var Re = parseFloat($("#ReOrderQuantity").val());
    if (!$.isNumeric(max))
        max = 0;
    if (!$.isNumeric(min))
        min = 0;
    if (!$.isNumeric(Re))
        Re = 0;

    if (min > max) {
        var msg = ASOFT.helper.getMessage("CFML000005");
        ASOFT.form.displayError("#CIF1301", msg);
        $("#MinQuantity").addClass('asf-focus-input-error');
        $("#MaxQuantity").addClass('asf-focus-input-error');
        return true;
    }
    if (min <= Re) {
        if (Re <= max)
            return false;
    }
    var msg = ASOFT.helper.getMessage("CFML000006");
    $("#MinQuantity").addClass('asf-focus-input-error');
    $("#MaxQuantity").addClass('asf-focus-input-error');
    $("#ReOrderQuantity").addClass('asf-focus-input-error');
    ASOFT.form.displayError("#CIF1301", msg);
    return true;
}
