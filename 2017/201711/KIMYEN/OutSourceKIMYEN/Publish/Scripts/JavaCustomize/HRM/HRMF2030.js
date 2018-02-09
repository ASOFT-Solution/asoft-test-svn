function customerDelete_Click() {
    var key = [],

        $urldeleteHRMF2030 = $("#DeleteHRMF2030").val(),

        $gridHRMF2030 = $("#GridHRMT2030").data("kendoGrid"),

        records = ASOFT.asoftGrid.selectedRecords($gridHRMF2030);

    ASOFT.form.clearMessageBox();

    if (records.length == 0) return false;

    var args = $.map(records, function (record) {
        if (typeof record.InterviewScheduleID !== "undefined" && typeof record.DivisionID !== "undefined") {
            return (record.InterviewScheduleID + "," + record.DivisionID);
        }
    });

    key.push(tablecontent, pk);

    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1($urldeleteHRMF2030, key, args, deleteSuccess);
    });
    return false;
}

function PrintClick() {

    var interviewScheduleList = [];
    var grid = $("#GridHRMT2030").data("kendoGrid");

    records = ASOFT.asoftGrid.selectedRecords(grid);
    ASOFT.form.clearMessageBox();
    if (records.length == 0) return false;

    var view = grid.dataSource.view();
    for (var i = 0; i < view.length; i++) {
        var interviewSchedule = {};
        var isCheck = grid.tbody.find("tr[data-uid='" + view[i].uid + "']").find("td input[type=checkbox]").is(":checked");
        if (isCheck) {
            var dataRow = grid.dataSource.getByUid(view[i].uid);
            interviewSchedule.DivisionID = dataRow.DivisionID;
            interviewSchedule.InterviewScheduleID = dataRow.InterviewScheduleID;
            interviewScheduleList.push(interviewSchedule);
        }
    }

    var data = {
        isCheckAll: $("#chkAll").is(":checked"),
        divisionList: $("#DivisionID_HRMF2030").data("kendoDropDownList").value() || "",
        interviewScheduleID: $("#InterviewScheduleID_HRMF2030").val() || "",
        departmentID: $("#DepartmentID_HRMF2030").data("kendoComboBox").value() || "",
        dutyID: $("#DutyID_HRMF2030").data("kendoComboBox").value() || "",
        interviewFromDate: $("#InterviewFromDate_HRMF2030").data("kendoDatePicker").value() || "",
        interviewToDate: $("#InterviewToDate_HRMF2030").data("kendoDatePicker").value() || "",
        candidateID: $("#CandidateID_HRMF2030").val() || "",
        candidateName: $("#CandidateName_HRMF2030").val() || "",
        interviewLevel: $("#InterviewLevel_HRMF2030").val() || "",
        interviewScheduleList: interviewScheduleList
    };


    ASOFT.helper.postTypeJson("/HRM/HRMF2030/DoPrintOrExport", data, ExportSuccess);
}


function ExportSuccess(result) {

    if (result) {

        var urlPrint = '/HRM/HRMF2030/ReportViewer',

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