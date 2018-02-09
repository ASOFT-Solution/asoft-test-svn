

function customDataReport() {
    var dtReportCus = {};
    dtReportCus.IsCheckAll = $("#isAll").is(":checked") ? 1 : 0;
    
    if (dtReportCus.IsCheckAll == 0)
    {
        var DesProductIDList = "";
        var data = [];
        //var grid = castName(name);
        var grid = $("#GridCSMT1040").data("kendoGrid");

        grid.tbody.find('.asoftcheckbox:checked').closest('tr')
            .each(function () {
                if (typeof grid.dataItem(this) !== 'undefined') {
                    var dataItem = grid.dataItem(this);
                    DesProductIDList += dataItem.DesProductID + ",";
                }
            });
        DesProductIDList = DesProductIDList.substring(0, DesProductIDList.length - 1);
        dtReportCus.DesProductIDList = DesProductIDList;
        dtReportCus.DesProductIDList_Content_DataType = 7;
        dtReportCus.DesProductIDList_Type_Fields = 4;
    }
    return dtReportCus;
}
