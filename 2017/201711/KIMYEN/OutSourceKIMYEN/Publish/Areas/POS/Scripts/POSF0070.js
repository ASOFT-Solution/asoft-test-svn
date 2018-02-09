//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/02/2014      Thai Son        Add heading
//####################################################################

var POSF0071 = null;
var POSF0072 = null;
var POSF0073 = null;
var POSF0074 = null;
var POSF0075 = null;
$(document).ready(function () {
    POSF0071 = ASOFT.asoftPopup.castName("POSF0071Popup");
    POSF0072 = ASOFT.asoftPopup.castName("POSF0072Popup");
    POSF0073 = ASOFT.asoftPopup.castName("POSF0073Popup");
    POSF0074 = ASOFT.asoftPopup.castName("POSF0074Popup");
    POSF0075 = ASOFT.asoftPopup.castName("POSF0075Popup");
});

// Show popup
function showPopup(popup, url, data) {
    ASOFT.asoftPopup.show(popup, url, data);
}
/**
* hiện popup POSF0071
*/
function CallPopupPOSF0071() {
    showPopup(POSF0071, "/POS/POSF0070/POSF0071", null);
}
/**
* hiện popup POSF0072
*/
function CallPopupPOSF0072() {
    showPopup(POSF0072, "/POS/POSF0070/POSF0072", null);
}
/**
* hiện popup POSF0073
*/
function CallPopupPOSF0073() {
    showPopup(POSF0073, "/POS/POSF0070/POSF0073", null);
}
/**
* hiện popup POSF0074
*/
function CallPopupPOSF0074() {
    showPopup(POSF0074, "/POS/POSF0070/POSF0074", null);
}

function CallPopupPOSF0075() {
    showPopup(POSF0075, "/POS/POSF0070/POSF0075", null);
}
/**
* xử lý sự kiện nút đóng cho popup POSF0071
*/
function btnClosePOSF0071Click() {
    POSF0071.close();
}
/**
* xử lý sự kiện nút đóng cho popup POSF0072
*/
function btnClosePOSF0072Click() {
    POSF0072.close();
}
/**
* xử lý sự kiện nút đóng cho popup POSF0073
*/
function btnClosePOSF0073Click() {
    POSF0073.close();
}
/**
* xử lý sự kiện nút đóng cho popup POSF0074
*/
function btnClosePOSF0074Click() {
    POSF0074.close();
}

function btnClosePOSF0075Click() {
    POSF0075.close();
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
    ASOFT.helper.registerFunction("POSF0070.exportOrPrintReport");
    window.open(Url + "?reportid=POSR0075", "_blank");
}

function exportOrPrintReport() {
    var data = ASOFT.helper.getObjectData();
    if (data) {
        var urlPost = $('#UrlDoPrintOrExport').val();

        ASOFT.helper.post(urlPost, data, POSF0075.exportOrPrintSuccess);
    }

};
