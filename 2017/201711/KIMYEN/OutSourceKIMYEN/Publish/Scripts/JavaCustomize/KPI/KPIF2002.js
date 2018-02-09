function CustomizePanalSelect(tb, gridDT) {
    var GridKPIT20002 = $("#GridKPIT20002").data("kendoGrid");
    GridKPIT20002.hideColumn("TargetsGroupName");
    gridDT.bind('dataBound', function (e) {
        $(".k-grid-footer").remove();

        var lengthGrid = GridKPIT20002.dataSource._data.length;
        for (var i = 0; i < lengthGrid; i++) {
            var items = GridKPIT20002.dataSource._data[i].items;
            GridKPIT20002.dataSource._data[i].aggregates.TargetsPercentage.set("sum", items[0].TargetsGroupPercentage);
        }
    })
}


function CustomerPrint() {
    var URLDoPrintorExport = '/KPI/KPIF2000/DoPrintOrExport?APK=' + $("#PK").val();
    ASOFT.helper.postTypeJson(URLDoPrintorExport, {}, ExportSuccessPrint2);
}

function ExportSuccessPrint2(result) {
    if (result) {
        var urlPrint = '/KPI/KPIF2000/ReportViewer';
        var urlExcel = '/KPI/KPIF2000/ExportReport';
        var urlPost = !isMobile ? urlPrint : urlExcel;
        var options = !isMobile ? '&viewer=pdf' : '';
        // Tạo path full
        var fullPath = urlPost + "?id=" + result.apk + options;

        // Getfile hay in báo cáo
        if (!isMobile)
            window.open(fullPath, "_blank");
        else {
            window.location = fullPath;
        }
    }
}