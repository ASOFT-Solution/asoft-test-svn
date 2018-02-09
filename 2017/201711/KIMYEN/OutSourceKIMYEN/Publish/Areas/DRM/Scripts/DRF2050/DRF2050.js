//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     12/09/2014      Đức Quý         Tạo mới
//####################################################################

DRF2050 = new function () {
    this.DRF2050Grid = null;
    this.isSearch = false;
    this.FromDate = null;
    this.ToDate = null;

    // Filter button events
    this.btnFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        DRF2050.isSearch = true;
        DRF2050.DRF2050Grid.dataSource.page(1);
    };

    // Reset filter button events
    this.btnClearFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        $('#FormFilter input').val('');
        DRF2050.isSearch = false;

        DRF2050.FromDate.value(new Date());
        DRF2050.ToDate.value(new Date());

        DRF2050.DRF2050Grid.dataSource.page(1);
    };

    // Add new button events
    this.btnImport_Click = function () {
        var postUrl = $("#UrlDRF2003").val();
        var data = {
            type: "CloseContract"
        };

        DRF2003.showPopup(postUrl, data);
    };

    // button events import ngân hàng rút về
    this.btnImportBank_Click = function () {
        var postUrl = $("#UrlDRF2003").val();
        var data = {
            type: "BankWithDrawContract"
        };

        DRF2003.showPopup(postUrl, data);
    };

    this.sendDataFilter = function () {
        var dataMaster = ASOFT.helper.dataFormToJSON("FormFilter");
        dataMaster['IsSearch'] = DRF2050.isSearch;
        return dataMaster;
    }

    this.openDRF2051 = function (apk) {
        ASOFT.form.clearMessageBox();
        //Url load dữ liệu lên form
        var postUrl = $("#UrlDRF2051").val();

        //Data load dữ liệu lên form
        var data = {
            apk: apk
        };

        //Hiển thị popup
        DRF2051.showPopup(postUrl, data);
    }

    this.btnCloseResume_Click = function () {
        DRF2050.closeOpenResume(1, 'DRFML000018');
    };

    this.btnOpenResume_Click = function () {
        DRF2050.closeOpenResume(0, 'DRFML000019');
    };

    this.closeOpenResume = function (mode, msg) {
        var urlCloseResume = $('#UrlCloseOpenResume').val();
        var args = [];
        var data = {};
        if (DRF2050.DRF2050Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(DRF2050.DRF2050Grid, 'FormFilter');
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].APK);
            }
        }

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage(msg), function () {
            data['args'] = args;
            data.mode = mode;
            ASOFT.helper.postTypeJson(urlCloseResume, data, DRF2050.coSuccess);
        });
    };

    this.coSuccess = function (result) {
        //ASOFT.helper.showErrorSeverOption(1, result, 'FormFilter');
        var messageID = null;
        if (result.Status == 0) {
            ASOFT.form.displayMultiMessageBox('FormFilter', 0, [ASOFT.helper.getMessage('DRFML000021')]);
        }
        else {
            ASOFT.form.displayMessageBox('#FormFilter', [ASOFT.helper.getMessage('DRFML000022')]);
        }

        if (DRF2050.DRF2050Grid) {
            DRF2050.DRF2050Grid.dataSource.page(1); // Refresh grid 
        }
    };

    this.btnExport_Click = function () {

        // Export excel status
        DRF2050.formStatus = 5;

        // Do print or export action
        DRF2050.doPrintOrExport();
    }

    this.btnPrint_Click = function () {

        // Export excel status
        DRF2050.formStatus = 6;

        // Do print or export action
        DRF2050.doPrintOrExport();
    }

    // Do print or export
    this.doPrintOrExport = function () {
        // Lấy dữ liệu trên form
        var data = ASOFT.helper.dataFormToJSON("FormFilter");
        data.ReportId = "DRR2050";
        data.FormStatus = DRF2050.formStatus;
        var args = [];
        data.IsCheckAll = $('#chkAll').prop('checked');
        if (!data.IsCheckAll)
        if (DRF2050.DRF2050Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(DRF2050.DRF2050Grid, 'FormFilter');
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].APK);
            }
        }
        data.APKList = args;

        if (data) {
            var urlPost = $('#UrlDoPrintOrExport').val();

            ASOFT.helper.postTypeJson(urlPost, data, DRF2050.exportOrPrintSuccess);
        }
    }

    // Do print or export success
    this.exportOrPrintSuccess = function (data) {
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
}

// Xử lý ban đầu
$(document).ready(function () {
    installPeriod(true);
    DRF2050.DRF2050Grid = ASOFT.asoftGrid.castName('DRF2050Grid');
    DRF2050.FromDate = ASOFT.asoftDateEdit.castName('FromDate');
    DRF2050.ToDate = ASOFT.asoftDateEdit.castName('ToDate');

    //var param = window.location.search.substring(1);

    // //array = param.split("&");
    //var array = param.split("=");
    //var data = array[1].toString();
    //if (data) {
    //    DRF2050.openDRF2051(data);
    //}
});
