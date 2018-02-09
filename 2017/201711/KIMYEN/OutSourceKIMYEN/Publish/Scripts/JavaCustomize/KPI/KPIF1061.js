$(document).ready(function () {
    $(".ToDate").before($(".FromDate"));
    if ($("#isUpdate").val() == "True") {
        CheckUsingCommon();
    }
    else {
        $("#FromDate").data("kendoDatePicker").value(new Date());
        $("#ToDate").data("kendoDatePicker").value(new Date());
    }
});

function CheckUsingCommon() {
    ASOFT.helper.postTypeJson("/KPI/KPIF0000/CheckUsingCommon", { KeyValues: $("#EvaluationPhaseID").val(), TableID: "KPIT10601" }, function (result) {
        if (result == 1) {  
            $("#IsCommon").attr("disabled", "disabled");
        }
        else {
            $("#EvaluationPhaseID").removeAttr("readonly");
        }
    });
}


function onAfterInsertSuccess(result, action) {
    if (result.Status == 0 && action == 1) {
        $("#FromDate").data("kendoDatePicker").value(new Date());
        $("#ToDate").data("kendoDatePicker").value(new Date());
    }

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
