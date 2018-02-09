
//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/09/2015      Quang Chiến     Tạo mới
//####################################################################

DRF2080 = new function () {
    this.DRF2080Grid = null;
    this.isSearch = false;
    this.FromDate = null;
    this.ToDate = null;

    // Filter button events
    this.btnFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        DRF2080.isSearch = true;
        DRF2080.DRF2080Grid.dataSource.page(1);
    };

    // Reset filter button events
    this.btnClearFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        $('#FormFilter input').val('');
        DRF2080.isSearch = false;

        DRF2080.FromDate.value(new Date());
        DRF2080.ToDate.value(new Date());

        DRF2080.DRF2080Grid.dataSource.page(1);
    };

    this.sendDataFilter = function () {
        var dataMaster = ASOFT.helper.dataFormToJSON("FormFilter");
        dataMaster['IsSearch'] = DRF2080.isSearch;
        return dataMaster;
    }

    this.btnPrint_Click = function () {

        // Do print or export action
        var urlPost = $('#UrlGetDataCV').val();
        var data = {};
        ASOFT.helper.postTypeJson(urlPost, data, DRF2080.doPrintOrExport);

    }

    // Do print or export
    this.doPrintOrExport = function (data) {
        if (data.checkEmail) {
            // Lấy dữ liệu trên form
            var data = ASOFT.helper.dataFormToJSON("FormFilter");
            data.ReportId = "DRR2080";
            data.FormStatus = DRF2080.formStatus;
            data.isSearch = DRF2080.isSearch;
            var args = [];
            data.IsCheckAll = $('#chkAll').prop('checked') ? 1 : 0;
            if (data.IsCheckAll == 0) {
                if (DRF2080.DRF2080Grid) { // Lấy danh sách các dòng đánh dấu
                    var records = ASOFT.asoftGrid.selectedRecords(DRF2080.DRF2080Grid, 'FormFilter');
                    if (records.length == 0) return;
                    for (var i = 0; i < records.length; i++) {
                        args.push(records[i].APK);
                    }
                }
            }
            data.APKList = args;
            

            if (data) {
                var urlPost = $('#UrlDoExportHtml').val();

                ASOFT.helper.postTypeJson(urlPost, data, DRF2080.exportOrPrintSuccess);
            }
        } else {
            ASOFT.form.displayMessageBox("#FormFilter", [ASOFT.helper.getMessage('DRFML000042')], null);
        }
    }

    // Do print or export success
    this.exportOrPrintSuccess = function (data) {
        if (data.checkedData) {
            if (data.checkedXR1) {
                var urlPost = $("#UrlHtml").val();
                var fullPath = urlPost + "?id=" + data.apkCVXR1 + "&typeDoc=0&templateID=XR1&checkScreen=0";
                window.open(fullPath, "_blank");
            }
            if (data.checkedXR2) {
                var urlPost = $("#UrlHtml").val();
                var fullPath = urlPost + "?id=" + data.apkCVXR2 + "&typeDoc=0&templateID=XR2&checkScreen=0";
                window.open(fullPath, "_blank");
            }
            if (data.checkedVPL) {
                var urlPost = $("#UrlHtml").val();
                var fullPath = urlPost + "?id=" + data.apkCVVPL + "&typeDoc=0&templateID=VPL&checkScreen=0";
                window.open(fullPath, "_blank");
            }
            if (data.checkedCA) {
                var urlPost = $("#UrlHtml").val();
                var fullPath = urlPost + "?id=" + data.apkCVCA + "&typeDoc=0&templateID=BC-CA&checkScreen=0";
                window.open(fullPath, "_blank");
            }
        } else {
            ASOFT.form.displayMessageBox("#FormFilter", [ASOFT.helper.getMessage('DRFML000040')], null);
        }
    };
    // button events import Công văn trả về
    this.btnImport_Click = function () {
        var postUrl = $("#UrlDRF2003").val();
        var data = {
            type: "DispatchReturnContract"
        };

        DRF2003.showPopup(postUrl, data);
    };
}

// Xử lý ban đầu
$(document).ready(function () {
    installPeriod(true);
    DRF2080.DRF2080Grid = ASOFT.asoftGrid.castName('DRF2080Grid');
    DRF2080.FromDate = ASOFT.asoftDateEdit.castName('FromDate');
    DRF2080.ToDate = ASOFT.asoftDateEdit.castName('ToDate');

});
