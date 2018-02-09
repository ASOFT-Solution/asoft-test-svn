

function customDataReport() {
    var dtReportCus = {};
    dtReportCus.IsCheckAll = $("#isAll").is(":checked") ? 1 : 0;
    
    if (dtReportCus.IsCheckAll == 0)
    {
        var ServiceTypeIDList = "";
        var data = [];
        //var grid = castName(name);
        var grid = $("#GridCSMT1060").data("kendoGrid");

        grid.tbody.find('.asoftcheckbox:checked').closest('tr')
            .each(function () {
                if (typeof grid.dataItem(this) !== 'undefined') {
                    var dataItem = grid.dataItem(this);
                    ServiceTypeIDList += dataItem.ServiceTypeID + ",";
                }
            });
        ServiceTypeIDList = ServiceTypeIDList.substring(0, ServiceTypeIDList.length - 1);
        dtReportCus.ServiceTypeIDList = ServiceTypeIDList;
        dtReportCus.ServiceTypeIDList_Content_DataType = 7;
        dtReportCus.ServiceTypeIDList_Type_Fields = 4;
    }
    return dtReportCus;
}
