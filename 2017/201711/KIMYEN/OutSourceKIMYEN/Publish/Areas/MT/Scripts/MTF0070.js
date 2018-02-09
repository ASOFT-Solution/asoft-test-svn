

$(document).ready(function () {
    MTF0070.setwidth();
    MTF0070.GridStudent = $("#MTF0070_GridStudent").data("kendoGrid");
    MTF0070.GridExpenses = $("#MTF0070_GridExpenses").data("kendoGrid");
    
    MTF0060.MTF0061Popup = ASOFT.asoftPopup.castName("MTF0061Popup");
    MTF0060.initStateMTF0061(); // after bound MTF0061 popup.
});

MTF0070 = new function() {
    this.GridStudent = null;
    this.GridExpenses = null;
    
    // Show popup
    this.showPopup = function(popup, url, data) {
        ASOFT.asoftPopup.show(popup, url, data);
    };

    this.setwidth = function() {
        var width = $("#contentMaster").width();
        var percentage = (((width - 20) / 2) / width) * 100;
        $(".block-left").css({ width: percentage + "%" });
        $(".block-right").css({ width: percentage + "%" });
    };

    // ref 0: Student, 1: Expenses
    this.showPopupMTF0061 = function (ref) {
        
        var urlMtf0061 = $('#UrlMTF0061').val();

        var itemFocused = (ref == 0) ? ASOFT.asoftGrid.selectedRecord(MTF0070.GridStudent)
            : ASOFT.asoftGrid.selectedRecord(MTF0070.GridExpenses);

        // xóa cache
        MTF0060.fromMonth = null;
        MTF0060.toMonth = null;
        MTF0060.fromYear = null;
        MTF0060.toYear = null;

        var data = {
            ReportID: itemFocused.ReportID,
            ExportAndPrint: true,
        };

        MTF0070.showPopup(MTF0060.MTF0061Popup, urlMtf0061, data);
    };

    this.btnCallPopupMTF0061_Click = function (ref) {
        MTF0070.showPopupMTF0061(ref);
        ASOFT.helper.registerFunction("MTF0070.exportOrPrintReport");
    };

    this.exportOrPrintReport = function() {
        var data = ASOFT.helper.getObjectData();
        if (data) {
            var urlPost = $('#UrlDoPrintOrExport').val();

            ASOFT.helper.post(urlPost, data, MTF0070.exportOrPrintSuccess);
        }

    };

    this.exportReport = function () {
    
    }

    this.exportOrPrintSuccess = function(data) {
        if (data) {
            var urlPost = $("#UrlGetReportFile").val();
            var options = "";

            if (data.formStatus == 6) {
                urlPost = $("#UrlReportViewer").val();
                options = "&viewer=pdf";
            }

            // Tạo path full
            var fullPath = urlPost + "?id=" + data.apk + "&reportId=" + data.reportId + options;

            // Getfile hay in báo cáo
            if (options) {
                window.open(fullPath, "_blank");
            } else {
                window.location = fullPath;
            }
        }
    };
    
};










