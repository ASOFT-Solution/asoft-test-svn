function ExportSuccess(result) {
    if (result) {
        var urlPost = '/ContentMaster/ReportViewer';
        var options = '&viewer=pdf';
        var RM = '&Module=HRM&ScreenID=HRMF2072';
        // Tạo path full
        var fullPath = urlPost + "?id=" + result.apk + options + RM;
        // Getfile hay in báo cáo
        window.open(fullPath, "_blank");
    }
}

/**
 * Click Button Print
 * @returns {} 
 * @since [Thanh Trong] Created [14/12/2017]
 */
function CustomerPrint() {
    var urlview = new URL(window.location.href);
    var pk = urlview.searchParams.get("PK");
    var URLDoPrintorExport = '/HRM/Common/DoPrintOrExport?sceenid=HRMF2072&pk=' + pk;
    ASOFT.helper.postTypeJson(URLDoPrintorExport, {}, ExportSuccess);
}