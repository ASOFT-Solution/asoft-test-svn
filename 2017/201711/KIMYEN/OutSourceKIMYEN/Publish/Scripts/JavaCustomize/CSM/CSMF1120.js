

function customDataReport() {
    var dtReportCus = {};
    dtReportCus.IsCheckAll = $("#isAll").is(":checked") ? 1 : 0;
    
    if (dtReportCus.IsCheckAll == 0)
    {
       
        var APKList = "<DATA><APK>{0}</APK></DATA>";
        var data = [];
        //var grid = castName(name);
        var grid = $("#GridCSMT1120").data("kendoGrid");

        grid.tbody.find('.asoftcheckbox:checked').closest('tr')
            .each(function () {
                if (typeof grid.dataItem(this) !== 'undefined') {
                    var dataItem = grid.dataItem(this);
                    APKList += dataItem.APK + ",";
                }
            });
        APKList = APKList(0, StatusErrorIDList.length - 1);
        dtReportCus.StatusErrorIDList = StatusErrorIDList;
        dtReportCus.StatusErrorIDList_Content_DataType = 7;
        dtReportCus.StatusErrorIDListt_Type_Fields = 4;
    }
    return dtReportCus;
}

