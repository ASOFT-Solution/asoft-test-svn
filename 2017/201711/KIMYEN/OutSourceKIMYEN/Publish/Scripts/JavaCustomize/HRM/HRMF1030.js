
function CustomBtnImport_Click() {
    var urlImport = "/Import?type=RecruitFileID";
    ASOFT.asoftPopup.showIframe(urlImport);
}

/**  
* Print custom data
*
* [Kiều Nga] Create New [18/01/2018]
**/
function PrintClick(e) {
    var dataCandidateID = [];
    var gridCRMF1030 = $("#GridHRMT1030").data("kendoGrid");
    var records = ASOFT.asoftGrid.selectedRecords(gridCRMF1030);
    ASOFT.form.clearMessageBox();
    if (records.length == 0) return;
    records.forEach(function (row) {
        dataCandidateID.push(row.CandidateID);
    });
    var dataFilter = CustomDataPrint();
    dataFilter.dataCandidateID = dataCandidateID;
    var url = '/HRM/HRMF1030/DoPrintOrExport';
    isPrint = true;
    ASOFT.helper.postTypeJson(url, dataFilter, ExportSuccess);
}

/**  
* Custom DataPrint
*
* [Kiều Nga] Create New [18/01/2018]
**/
function CustomDataPrint() {
    var dataFilter = {};
    dataFilter.DivisionList = $("#DivisionID_HRMF1030").val();
    dataFilter.CandidateID = $("#CandidateID_HRMF1030").val();
    dataFilter.CandidateName = $("#CandidateName_HRMF1030").val();
    dataFilter.DepartmentID = $("#DepartmentID_HRMF1030").val();
    dataFilter.DutyID = $("#DutyID_HRMF1030").val();
    dataFilter.Gender = $("#Gender_HRMF1030").val();
    dataFilter.RecruitStatus = $("#RecruitStatus_HRMF1030").val();
    dataFilter.IsCheckAll = $("#chkAll").prop('checked') ? 1 : 0;
    return dataFilter;
}