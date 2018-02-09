$(document).ready(function () {

})

/**  
* Custom Data Report
*
* [Kim Vu] Create New [19/01/2018]
**/
function customDataReport() {
    var dtReportCus = {};
    var grid = $("#GridLMT1001").data('kendoGrid');
    var data = ASOFT.asoftGrid.selectedRecords(grid);
    var creditFormIDList = "";
    dtReportCus.IsCheckAll = $("#isAll").is(":checked") ? 1 : 0;
    if (dtReportCus.IsCheckAll == 0) {
        data.forEach(function (row) {
            creditFormIDList += "," + row.CreditFormID;
        })
        creditFormIDList = creditFormIDList.substring(1, creditFormIDList.length);
    }
    dtReportCus.CreditFormIDList = creditFormIDList;
    dtReportCus.CreditFormIDList_Content_DataType = 7;
    dtReportCus.CreditFormIDList_Type_Fields = 4;
    dtReportCus.IsCheckAll_Content_DataType = 7;
    dtReportCus.IsCheckAll_Type_Fields = 1;
    return dtReportCus;
}