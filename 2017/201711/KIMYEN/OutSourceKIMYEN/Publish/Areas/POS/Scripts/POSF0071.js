//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/02/2014      Thai Son        Add heading
//####################################################################

$(document).ready(function () {
    POSF0075.POSF00751Popup = ASOFT.asoftPopup.castName("POSF00751Popup");
    POSF0075.initStatePOSF00751();
});

// Show popup
function showPopup(popup, url, data) {
    ASOFT.asoftPopup.show(popup, url, data);
}

function CallPopupPOSF0075() {

    var urlposf00751 = $('#UrlPOSF00751').val();

    var data = {
        ReportID: "POSExample",
        ExportAndPrint: true,
    };
    showPopup(POSF0075.POSF00751Popup, urlposf00751, data);
    ASOFT.helper.registerFunction("exportOrPrintReport");
}


/**
* xử lý sự kiện click vào nút xuất báo cáo
*/
function ViewReportPOSF0001() {
    var Url = $('#UrlReportViewer').val();
    window.open(Url + "?reportid=POSR0001&option=viewer", "_blank");
}
/**
* xử lý sự kiện click vào nút xuất báo cáo
*/
function ViewReportPOSF0002() {
    var Url = $('#UrlReportViewer').val();
    window.open(Url + "?reportid=POSR0002&option=viewer", "_blank");
}
/**
* xử lý sự kiện click vào nút xuất báo cáo
*/
function ViewReportPOSF0003() {
    var Url = $('#UrlReportViewer').val();
    window.open(Url + "?reportid=POSR0003&option=viewer", "_blank");
}
/**
* xử lý sự kiện click vào nút xuất báo cáo
*/
function ViewReportPOSF0004() {
    var Url = $('#UrlReportViewer').val();
    window.open(Url + "?reportid=POSR0004&option=viewer", "_blank");
}

/**
* xử lý sự kiện click vào nút in
*/
function btnPrintPOSF0071Click() {
    var Url = $('#UrlReport').val();
    window.open(Url + "?reportid=POSR0001", "_blank");
}
/**
* xử lý sự kiện click vào nút in
*/
function btnPrintPOSF0072Click() {
    var Url = $('#UrlReport').val();
    window.open(Url + "?reportid=POSR0002", "_blank");
}
/**
* xử lý sự kiện click vào nút in
*/
function btnPrintPOSF0073Click() {
    var Url = $('#UrlReport').val();
    window.open(Url + "?reportid=POSR0003", "_blank");
}

/**
* xử lý sự kiện click vào nút in
*/
function btnPrintPOSF0074Click() {
    var Url = $('#UrlReport').val();
    window.open(Url + "?reportid=POSR0004", "_blank");
}

/**
* xử lý sự kiện click vào nút in
*/
function btnPrintPOSF0075Click() {
    var Url = $('#UrlReport').val();
    ASOFT.helper.registerFunction("exportOrPrintReport");
    window.open(Url + "?reportid=POSR0075", "_blank");
}

function exportOrPrintReport() {
    var data = ASOFT.helper.getObjectData();
    if (data) {
        var urlPost = $('#UrlDoPrintOrExport').val();

        ASOFT.helper.post(urlPost, data, exportOrPrintSuccess);
    }

function exportOrPrintSuccess(data) {
        if (data) {
            var urlPost = $("#UrlGetReportFile").val();
            var options = "";

            if (data.formStatus == 6) {
                urlPost = $("#UrlReportViewer").val();
                options = "&viewer=pdf";
            }

            // Tạo path full
            //var fullPath = urlPost + "?id=" + data.apk + "&reportId=" + data.reportId + options;

            var fullPath = urlPost;

            // Getfile hay in báo cáo
            if (options) {
                window.open(fullPath, "_blank");
            } else {
                window.location = fullPath;
            }
        }
    };

};
