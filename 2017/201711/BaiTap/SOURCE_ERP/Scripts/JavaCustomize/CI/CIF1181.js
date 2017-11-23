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
    data.push($("#KITID").val());
    ASOFT.helper.postTypeJson("/CI/CIF1180/CheckUsingCommon", data, function (result) {
        if (result == 1) {
            if ($("#IsCommon").is(':checked'))
                $(".IsCommon").hide();
        }
        else {
            $("#KITID").removeAttr("readonly");
        }
    });
}

function onAfterInsertSuccess(result, action) {
    if (action == 3 && result.Status == 0) {
        var url = parent.GetUrlViewMasterDetail();
        var listSp = url.split('&');
        var division = listSp[listSp.length - 1];
        if ($("#IsCommon").is(':checked')) {
            url = url.replace(division, "DivisionID=" + "@@@");
            url = url.replace(parent.getKIDID(), $("#KITID").val());
        }
        else {
            url = url.replace(division, "DivisionID=" + $("#EnvironmentDivisionID").val());
            url = url.replace(parent.getKIDID(), $("#KITID").val());
        }
        window.parent.parent.location = url;
        parent.setReload();
    }
}
