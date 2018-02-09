function CustomizePanalSelect(tb, gridDT) {
    var GridPAT20002 = $("#GridPAT20002").data("kendoGrid");
    GridPAT20002.hideColumn("AppraisalGroupName");
    gridDT.bind('dataBound', function (e) {
        $(".k-grid-footer").remove();

        var lengthGrid = GridPAT20002.dataSource._data.length;
        for (var i = 0; i < lengthGrid; i++) {
            var items = GridPAT20002.dataSource._data[i].items;
            GridPAT20002.dataSource._data[i].aggregates.Benchmark.set("sum", items[0].AppraisalGroupGoal);

            var sumPerformPoint = GridPAT20002.dataSource._data[i].aggregates.PerformPoint.sum;
            if (sumPerformPoint == 0) {
                GridPAT20002.dataSource._data[i].aggregates.Note.set("count", 0);
            }
            else {
                var AppraisalGroupNote = sumPerformPoint / items[0].AppraisalGroupGoal;
                GridPAT20002.dataSource._data[i].aggregates.Note.set("count", AppraisalGroupNote);
            }
        }
    })
}


function CustomerPrint() {
    var URLDoPrintorExport = '/PA/PAF2000/DoPrintOrExport?APK=' + $("#PK").val();
    ASOFT.helper.postTypeJson(URLDoPrintorExport, {}, ExportSuccessPrint2);
}

function ExportSuccessPrint2(result) {
    if (result) {
        var urlPrint = '/PA/PAF2000/ReportViewer';
        var urlExcel = '/PA/PAF2000/ExportReport';
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