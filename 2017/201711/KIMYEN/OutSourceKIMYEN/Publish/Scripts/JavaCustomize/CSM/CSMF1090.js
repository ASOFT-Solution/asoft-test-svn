

function customDataReport() {
    var dtReportCus = {};
    dtReportCus.IsCheckAll = $("#chkAll").is(":checked") ? 1 : 0;
    
    if (dtReportCus.IsCheckAll == 0)
    {
        var ErrorDetailIDList = "";
        var data = [];
        var grid = $("#GridCSMT1090").data("kendoGrid");

        grid.tbody.find('.asoftcheckbox:checked').closest('tr')
            .each(function () {
                if (typeof grid.dataItem(this) !== 'undefined') {
                    var dataItem = grid.dataItem(this);
                    ErrorDetailIDList += dataItem.ErrorDetailID + ",";
                }
            });
        ErrorDetailIDList = ErrorDetailIDList.substring(0, ErrorDetailIDList.length - 1);
        dtReportCus.ErrorDetailIDList = ErrorDetailIDList;
        dtReportCus.ErrorDetailIDList_Content_DataType = 7;
        dtReportCus.ErrorDetailIDList_Type_Fields = 4;
    }
    return dtReportCus;
}

