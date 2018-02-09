//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     04/12/2015      Quang Chiến     Tạo mới
//####################################################################

$(document).ready(function () {
   
});

DRF2004 = new function () {
    this.formStatus = null;
    this.isSaved = false;


    // show popup
    this.showPopup = function (url, data) {
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl(url, data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});
    };

    // Hide Iframes
    this.closePopup = function () {
        ASOFT.asoftPopup.hideIframe(true);
    };

    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        DRF2004.closePopup();
    };

    // Do print or export 
    this.btnPrintExport_Click = function () {
        var data = JSON.parse($('#initData').val(), function (key, value) {
            var a;
            if (typeof value === 'string') {
                a = /\/Date\((\d*)\)\//.exec(value);
                if (a) {
                    return new Date(+a[1]);
                }
            }
            return value;
        });
        
        var value = [];
        value = data;
        if ($('#DoPrintType').val() == 0) {
            value.ReportID = $('#Type').val();
            if ($('#Type').val() == "DRR2010") {
                value.TypePrintDoc = 1;
            } else {
                value.TypePrintDoc = 2;
            }
            var urlPost = window.parent.$('#UrlDoPrintOrExport').val();
            ASOFT.helper.postTypeJson(urlPost, value, DRF2004.exportOrPrintSuccess);
        } else {
            value.DispathTypeName = $('#Type').val();
            var urlPost = window.parent.$('#UrlDoExportHtml').val();
            ASOFT.helper.postTypeJson(urlPost, value, DRF2004.exportSuccess);
        }
    };

    // Do print or export success
    this.exportOrPrintSuccess = function (data) {
        if (data) {
            var urlPost = window.parent.$("#UrlGetReportFile").val();
            var options = "";

            if (data.formStatus == 6) {
                urlPost = window.parent.$("#UrlReportViewer").val();
                options = "&viewer=pdf";
            }

            // Tạo path full
            var fullPath = urlPost + "?id=" + data.apk + "&reportId=" + data.reportId + "&host=" + data.host + options;

            // Getfile hay in báo cáo
            if (options) {
                window.open(fullPath, "_blank");
            } else {
                window.location = fullPath;
            }
        }
    };

    // Do print html success
    this.exportSuccess = function (data) {            
        if (data.checkedEmail) {
            if (data.checkedData) {
                var str = null;
                if (data.type == 0) {
                    str = "&typeDoc=0&templateID=" + data.template + "&checkScreen=1";
                } else {
                    str = "&typeDoc=0&templateID=" + data.template + "&checkScreen=2";
                }

                var urlPost = window.parent.$("#UrlHtml").val();
                var fullPath = urlPost + "?id=" + data.apk + str;
                window.open(fullPath, "_blank");

            } else {
                ASOFT.form.displayMessageBox("#DRF2004", [ASOFT.helper.getMessage('DRFML000039')], null);
            }
        }
        else {
            ASOFT.form.displayMessageBox("#DRF2004", [ASOFT.helper.getMessage('DRFML000042')], null);
        }
    }
}