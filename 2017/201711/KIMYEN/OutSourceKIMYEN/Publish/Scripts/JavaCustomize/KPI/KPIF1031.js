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
    ASOFT.helper.postTypeJson("/KPI/KPIF0000/CheckUsingCommon", { KeyValues: $("#SourceID").val(), TableID: "KPIT10301" }, function (result) {
        if (result == 1) {  
            $("#IsCommon").attr("disabled", "disabled");
        }
        else {
            $("#SourceID").removeAttr("readonly");
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
