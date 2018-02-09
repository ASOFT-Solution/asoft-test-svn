function customerDelete_Click() {
    var key = [],

        $urldeleteHRMF2050 = $("#DeleteHRMF2050").val(),

        $gridHRMF2050 = $("#GridHRMT2050").data("kendoGrid"),

        records = ASOFT.asoftGrid.selectedRecords($gridHRMF2050);

    ASOFT.form.clearMessageBox();

    if (records.length == 0) return false;

    var args = $.map(records, function (record) {
        if (typeof record.RecDecisionID !== "undefined" && typeof record.DivisionID !== "undefined") {
            return (record.RecDecisionID + "," + record.DivisionID);
        }
    });

    key.push(tablecontent, pk);

    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1($urldeleteHRMF2050, key, args, deleteSuccess);
    });
    return false;
}

function PrintClick() {

    var recDecisionList = [];
    var grid = $("#GridHRMT2050").data("kendoGrid");

    records = ASOFT.asoftGrid.selectedRecords(grid);
    ASOFT.form.clearMessageBox();
    if (records.length == 0) return false;

    var view = grid.dataSource.view();
    for (var i = 0; i < view.length; i++) {
        var recDecision = {};
        var isCheck = grid.tbody.find("tr[data-uid='" + view[i].uid + "']").find("td input[type=checkbox]").is(":checked");
        if (isCheck) {
            var dataRow = grid.dataSource.getByUid(view[i].uid);
            recDecision.divisionID = dataRow.DivisionID;
            recDecision.recDecisionID = dataRow.RecDecisionID;
            recDecisionList.push(recDecision);
        }
    }

    var data = {
        divisionList: $("#DivisionID_HRMF2050").data("kendoDropDownList").value() || "",
        reDecisionNo: $("#ReDecisionNo_HRMF2050").val() || "",
        candidateID: $("#CandidateID_HRMF2050").val() || "",
        recruitPeriodID: $("#RecruitPeriodID_HRMF2050").val() || "",
        departmentID: $("#DepartmentID_HRMF2050").data("kendoComboBox").value() || "",
        dutyID: $("#DutyID_HRMF2050").data("kendoComboBox").value() || "",
        fromDate: $("#FromDate_HRMF2050").data("kendoDatePicker").value() || "",
        toDate: $("#ToDate_HRMF2050").data("kendoDatePicker").value() || "",
        status: $("#Status_HRMF2050").data("kendoComboBox").value() || "",
        isCheckAll: $("#chkAll").is(":checked"),
        recDecisionList: recDecisionList
    };


    ASOFT.helper.postTypeJson("/HRM/HRMF2050/DoPrintOrExport", data, ExportSuccess);
}

function ExportSuccess(result) {

    if (result) {

        var urlPrint = '/HRM/HRMF2050/ReportViewer',

            urlPost = urlPrint;

        options = !isMobile ? '&viewer=pdf' : '',

        fullPath = urlPost + "?id=" + result.apk + options;

        // Getfile hay in báo cáo
        if (!isMobile)
            window.open(fullPath, "_blank");
        else {
            window.location = fullPath;
        }

    }
}

$(document).ready(function () {

    var $btnDelete = $("#BtnDelete").data("kendoButton") || $("#BtnDelete");

    var $btnPrint = $("#BtnPrint").data("kendoButton") || $("#BtnPrint");


    if (typeof $btnPrint !== "undefined") {
        $btnPrint.unbind("click").bind("click", function () {
            PrintClick();
            return false;
        });
    }

    if (typeof $btnDelete !== "undefined")
        $btnDelete.unbind("click").bind("click", customerDelete_Click);
});