
function CustomerPrint() {
    var URLDoPrintorExport = '/HRM/HRMF2110/DoPrintOrExport?APK=' + $("#PK").val();
    ASOFT.helper.postTypeJson(URLDoPrintorExport, {}, ExportSuccessPrint2);
}

function ExportSuccessPrint2(result) {
    if (result) {
        var urlPrint = '/HRM/HRMF2110/ReportViewer';
        var urlExcel = '/HRM/HRMF2110/ExportReport';
        var urlPost = !isMobile ? urlPrint : urlExcel;
        var options = !isMobile ? '&viewer=pdf' : '&mobile=true';
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