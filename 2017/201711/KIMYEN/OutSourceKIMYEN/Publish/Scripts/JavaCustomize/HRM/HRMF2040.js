var DivTag2block = "<div class='asf-filter-main' id='divFromToDate'>" +
        "<div class='block-left'>" +
            "<div class='asf-filter-label'></div>" +
            "<div class='asf-filter-input'></div>" +
        "</div>" +
        "<div class='block-right'>" +
            "<div class='asf-filter-label'></div>" +
            "<div class='asf-filter-input'></div>" +
        "</div>" +
    "</div>";
$(document).ready(function () {
    $(".grid_4.omega").prepend(DivTag2block);
    $('#divFromToDate .block-left .asf-filter-label').append($(".FromDate").children()[0]);
    $('#divFromToDate .block-left .asf-filter-input').append($($(".FromDate").children()[0]).children());
    $('#divFromToDate .block-right .asf-filter-label').append($(".ToDate").children()[0]);
    $('#divFromToDate .block-right .asf-filter-input').append($($(".ToDate").children()[0]).children());

    //var btnDelete = $("#BtnDelete").data("kendoButton") || $("#BtnDelete");
    //if (btnDelete)
    //    btnDelete.unbind("click").bind("click", customerDelete_Click);
});

//function customerDelete_Click() {
//    var key = [],
//        $urldeleteCRMF1040 = $("#DeleteHRMF2040").val(),
//        $gridCRMF1040 = $("#GridHRMT2040").data("kendoGrid"),
//        records = ASOFT.asoftGrid.selectedRecords($gridCRMF1040);

//    ASOFT.form.clearMessageBox();
//    if (records.length == 0) return false;
//    var args = $.map(records, function (record) {
//        if (record.APK && record.DivisionID) {
//            return record.DivisionID + ',' + record.APK;
//        }
//    });

//    key.push(tablecontent, pk);

//    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
//        ASOFT.helper.postTypeJson1($urldeleteCRMF1040, key, args, deleteSuccess);
//    });
//    return false;
//}

/**  
* Print custom data
*
* [Kim Vu] Create New [16/12/2017]
**/
function PrintClick(e) {

    var dataDivisionID = [];
    var dataAPK = [];
    var gridCRMF1040 = $("#GridHRMT2040").data("kendoGrid");
    var records = ASOFT.asoftGrid.selectedRecords(gridCRMF1040);
    ASOFT.form.clearMessageBox();
    if (records.length == 0) return;
    records.forEach(function (row) {
        dataDivisionID.push(row.DivisionID);
        dataAPK.push(row.APK);
    });
    var dataFilter = CustomDataPrint();
    dataFilter.dataDivisionID = dataDivisionID;
    dataFilter.dataAPK = dataAPK;
    var url = '/HRM/HRMF2040/DoPrintOrExport';
    isPrint = true;
    ASOFT.helper.postTypeJson(url, dataFilter, ExportSuccess);
}

/**  
* Custom DataPrint
*
* [Kim Vu] Create New [16/12/2017]
**/
function CustomDataPrint() {
    var dataFilter = {};
    dataFilter.DivisionList = $("#DivisionID_HRMF2040").val();
    dataFilter.CandidateID = $("#BoundaryID_HRMF2040").val();
    dataFilter.RecruitPeriodID = $("#RecruitPeriodID_HRMF2040").val();
    dataFilter.DepartmentID = $("#DepartmentID_HRMF2040").val();
    dataFilter.DutyID = $("#DutyID_HRMF2040").val();
    dataFilter.FromDate = kendo.toString($("#FromDate_HRMF2040").data("kendoDatePicker").value(), 'yyyy-MM-dd');
    dataFilter.ToDate = kendo.toString($("#ToDate_HRMF2040").data("kendoDatePicker").value(), 'yyyy-MM-dd');
    dataFilter.Disabled = $("#Disabled_HRMF2040").val();
    dataFilter.RecruitStatus = $("#RecruitStatus_HRMF2040").val();
    dataFilter.IsCheckAll = $("#chkAll").prop('checked') ? 1 : 0;
    return dataFilter;
}