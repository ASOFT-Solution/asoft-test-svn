function customerDelete_Click() {
    var key = [],

        $urldeleteHRMF2000 = $("#DeleteHRMF2000").val(),

        $gridHRMF2000 = $("#GridHRMT2000").data("kendoGrid"),

        records = ASOFT.asoftGrid.selectedRecords($gridHRMF2000);

    ASOFT.form.clearMessageBox();

    if (records.length == 0) return false;

    var args = $.map(records, function (record) {
        if (typeof record.RecruitPlanID !== "undefined") {
            return record.RecruitPlanID;
        }
    });

    key.push(tablecontent, pk);

    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1($urldeleteHRMF2000, key, args, deleteSuccess);
    });
    return false;
}


function PrintClick() {
    
    var recruitPlanList = [];
    var grid = $("#GridHRMT2000").data("kendoGrid");

    records = ASOFT.asoftGrid.selectedRecords(grid);
    ASOFT.form.clearMessageBox();
    if (records.length == 0) return false;

    var view = grid.dataSource.view();
    for(var i = 0; i < view.length; i++)
    {
        var recruitPlan = {};
        var isCheck = grid.tbody.find("tr[data-uid='" + view[i].uid + "']").find("td input[type=checkbox]").is(":checked");
        if(isCheck)
        {
            var dataRow = grid.dataSource.getByUid(view[i].uid);
            recruitPlan.DivisionID = dataRow.DivisionID;
            recruitPlan.RecruitPlanID = dataRow.RecruitPlanID;
            recruitPlanList.push(recruitPlan);
        }
    }

    var data = {
        isCheckAll: $("#chkAll").is(":checked"),
        divisionList: $("#DivisionID_HRMF2000").data("kendoDropDownList").value() || "",
        recruitPlanID: $("#RecruitPlanID_HRMF2000").val() || "",
        departmentID: $("#DepartmentID_HRMF2000").data("kendoComboBox").value() || "",
        dutyID: $("#DutyID_HRMF2000").data("kendoComboBox").value() || "",
        fromDate: $("#FromDate_HRMF2000").data("kendoDatePicker").value() || "",
        toDate: $("#ToDate_HRMF2000").data("kendoDatePicker").value() || "",
        status: $("#Status_HRMF2000").data("kendoComboBox").value() || "",
        recruitPlanList: recruitPlanList
    };

    ASOFT.helper.postTypeJson("/HRM/HRMF2000/DoPrintOrExport", data, ExportSuccess);
}

function ExportSuccess(result) {

    if (result) {

        var urlPrint = '/HRM/HRMF2000/ReportViewer',

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