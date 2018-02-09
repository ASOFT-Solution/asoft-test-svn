$(document).ready(function () {
    CSMF2050.Layout();
});

/**  
* Object CSMF2050
*
* [Kim Vu] Create New [30/01/2018]
**/
var CSMF2050 = new function () {

    /**  
    * Layout control
    *
    * [Kim Vu] Create New [30/01/2018]
    **/
    this.Layout = function () {
        $(".FromReceiveDate").parent().append($(".ToReceiveDate"));
    }

    /**  
    * Export success
    *
    * [Kim Vu] Create New [05/02/2018]
    **/
    this.ExportSuccess = function (apk) {
        if (apk) {
            var urlPrint = '/ContentMaster/ReportViewer';
            var urlPost;
            var options = '';
            urlPost = urlPrint;
            options = '&viewer=pdf';

            var RM = '&Module=' + $("#Module" + $("#sysScreenID").val()).val() + '&ScreenID=' + screen;
            // Tạo path full
            var fullPath = urlPost + "?id=" + apk + options + RM;

            // Getfile hay in báo cáo
            window.open(fullPath, "_blank");
        }
    }
}

/**  
* Customize btnPrint
*
* [Kim Vu] Create New [05/02/2018]
**/
function PrintClick(e) {
    var APKlist = [];
    GridKendo = $('#GridCSMT2050').data('kendoGrid');
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
    if (records.length == 0) return;
    records.forEach(function (row) {
        APKlist.push(row.APK);
    });

    var url = "/CSM/CSMF2050/DoPrintOrExport";        
    ASOFT.helper.postTypeJson(url, { APKList: APKlist }, function (result) {
        for (var i = 0; i < result.length; i++) {
            CSMF2050.ExportSuccess(result[i]);
        }
    });
}