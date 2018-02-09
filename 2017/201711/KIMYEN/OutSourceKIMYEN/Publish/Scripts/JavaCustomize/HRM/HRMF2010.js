
/**  
* Print custom data
*
* [Kim Vu] Create New [16/12/2017]
**/
function PrintClick(e) {

    var dataRecruitRequireID = [];
    var dataDivisionID = [];
    var gridCRMF1040 = $("#GridHRMT2010").data("kendoGrid");
    var records = ASOFT.asoftGrid.selectedRecords(gridCRMF1040);
    ASOFT.form.clearMessageBox();
    if (records.length == 0) return;
    records.forEach(function (row) {
        dataRecruitRequireID.push(row.RecruitRequireID);
        dataDivisionID.push(row.DivisionID);
    });
    var dataFilter = CustomDataPrint();
    dataFilter.dataRecruitRequireID = dataRecruitRequireID;
    dataFilter.dataDivisionID = dataDivisionID;
    var url = '/HRM/HRMF2010/DoPrintOrExport';
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
    dataFilter.DivisionList = $("#DivisionID_HRMF2010").val();
    dataFilter.RecruitRequireID = $("#RecruitRequireID_HRMF2010").val();
    dataFilter.DutyID = $("#DutyID_HRMF2010").val();
    dataFilter.Disabled = $("#Disabled_HRMF2010").val();
    if (dataFilter.Disabled == undefined || dataFilter.Disabled == "")
        dataFilter.Disabled = "0";
    dataFilter.IsCheckAll = $("#chkAll").prop('checked') ? 1 : 0;
    return dataFilter;
}