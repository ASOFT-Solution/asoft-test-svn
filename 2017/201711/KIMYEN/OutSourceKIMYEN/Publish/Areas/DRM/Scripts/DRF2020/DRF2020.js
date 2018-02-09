//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     11/09/2014      Đức Quý         Tạo mới
//####################################################################

DRF2020 = new function () {
    this.isSearch = false;
    this.DRF2020Grid = null;
    this.urlUpdate = null;

    // Filter button events
    this.btnFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        DRF2020.isSearch = true;
        DRF2020.DRF2020Grid.dataSource.page(1);
    };

    // Reset filter button events
    this.btnClearFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        $('#FormFilter input').val('');
        $('#rdbIsPeriod').prop('checked', 'checked');
        $('#rdbIsPeriod').trigger('change');
        DRMPeriodFilter.isDate = 0;
        DRF2020.isSearch = false;

        DRMPeriodFilter.fromMonth = null;
        DRMPeriodFilter.fromYear = null;
        DRMPeriodFilter.toMonth = null;
        DRMPeriodFilter.ToYear = null;

        DRMPeriodFilter.fromDate.value(new Date());
        DRMPeriodFilter.toDate.value(new Date());

        DRF2020.DRF2020Grid.dataSource.page(1);
    };

    this.sendDataFilter = function () {
        var dataMaster = ASOFT.helper.dataFormToJSON("FormFilter");
        dataMaster['IsSearch'] = DRF2020.isSearch;
        
        dataMaster.IsDate = DRMPeriodFilter.isDate;

        var FromPeriodFilter = $('#FromPeriodFilter').val().split('/');
        dataMaster.FromMonth = FromPeriodFilter[0];
        dataMaster.FromYear = FromPeriodFilter[1];

        var ToPeriodFilter = $('#ToPeriodFilter').val().split('/');
        dataMaster.ToMonth = ToPeriodFilter[0];
        dataMaster.ToYear = ToPeriodFilter[1];
        return dataMaster;
    };

    // Add new button events
    this.btnAddNew_Click = function () {
        // [1] Tạo form status : Add new
        DRF2020.formStatus = 1;
        DRF2020.urlUpdate = $('#UrlInsert').val();
        // [2] Url load dữ liệu lên form
        var postUrl = $("#UrlDRF2021").val();

        // [3] Data load dữ liệu lên form
        var data = {
            FormStatus: DRF2020.formStatus
        };

        // [4] Hiển thị popup
        DRF2021.showPopup(postUrl, data);
    };

    this.btnEdit_Click = function () {
        // [1] Tạo form status : Edit
        DRF2020.formStatus = 2;
        DRF2020.urlUpdate = $('#UrlUpdate').val();
        var apk = $('#apkEdit').val();
        var debtorName = $('#DebtorName').text();

        ASOFT.helper.post($('#UrlCheckEdit').val(), { apk: apk }, function (result) {
            if (result.length == 0) {
                // [2] Url load dữ liệu lên form
                var postUrl = $("#UrlDRF2021").val();

                // [3] Data load dữ liệu lên form
                var data = {
                    FormStatus: DRF2020.formStatus,
                    APK: apk,
                    DebtorName: debtorName,
                    IsSendXR: $("#IsSendXR").val(),
                    IsSendVPL: $("#IsSendVPL").val(),
                    IsClose: $("#IsClose").val(),
                    IsClosed: $("#IsClosed").val(),
                    TeamID: $("#TeamID").val(),
                    TableName: $("#TableName").val()
                };

                // [4] Hiển thị popup
                DRF2021.showPopup(postUrl, data);
            } else {
                ASOFT.form.displayMessageBox('#ViewMaster', [ASOFT.helper.getMessage(result[0].MessageID)]);
            }
        });
    };

    // Add new button events
    this.btnImport_Click = function () {

        // [2] Url load dữ liệu lên form
        var postUrl = $("#UrlDRF2003").val();

        // [3] Data load dữ liệu lên form
        var data = {
            type: "DebtRecoveryData"
        };

        // [4] Hiển thị popup
        DRF2003.showPopup(postUrl, data);
    };

    // Delete button events
    this.btnDelete_Click = function () {
        var urlDelete = $('#UrlDelete').val();
        var args = [];
        var data = {};
        if (DRF2020.DRF2020Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(DRF2020.DRF2020Grid, 'FormFilter');
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].APK);
            }
        } else {
            // Lấy đối tượng hiện tại nếu đang ở màn hình details
            var apk = $('#apkEdit').val();
            args.push(apk);
        }

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*A00ML000002*/), function () {
            data['args'] = args;
            data['ScreenID'] = $('#ScreenID').val();
            ASOFT.helper.postTypeJson(urlDelete, data, DRF2020.deleteSuccess);
        });
    };

    this.deleteSuccess = function (result) {
        var formId = null;
        var displayOnRedirecting = null;

        if (document.getElementById('FormFilter')) {
            formId = "FormFilter";
            displayOnRedirecting = false;
        } else if (document.getElementById('ViewMaster')) {
            formId = "ViewMaster";
            displayOnRedirecting = true;
        }

        ASOFT.helper.showErrorSeverOption(1, result, formId, function () {
            var urlDRF2020 = $('#UrlDRF2020').val();
            // Chuyển hướng hoặc refresh data
            if (urlDRF2020 != null) {
                window.location.href = urlDRF2020; // redirect index
            }
        }, null, null, true, displayOnRedirecting, "FormFilter");

        if (DRF2020.DRF2020Grid) {
            DRF2020.DRF2020Grid.dataSource.page(1); // Refresh grid 
        }
    }

    // In báo cáo
    this.btnPrint_Click = function () {

        // Export excel status
        DRF2020.formStatus = 6;
        // Do print or export action
        DRF2020.doPrintOrExport();
    }

    this.btnExport_Click = function () {

        // Export excel status
        DRF2020.formStatus = 5;
        // Do print or export action
        DRF2020.doPrintOrExport();
    }

    // Do print or export
    this.doPrintOrExport = function () {
        // Lấy dữ liệu trên form
        var data = ASOFT.helper.dataFormToJSON("FormFilter");
        data['IsSearch'] = DRF2020.isSearch;

        data.IsDate = DRMPeriodFilter.isDate;
        var FromPeriodFilter = $('#FromPeriodFilter').val().split('/');
        data.FromMonth = FromPeriodFilter[0];
        data.FromYear = FromPeriodFilter[1];

        var ToPeriodFilter = $('#ToPeriodFilter').val().split('/');
        data.ToMonth = ToPeriodFilter[0];
        data.ToYear = ToPeriodFilter[1];

        data.ReportId = "DRR2020";
        data.FormStatus = DRF2020.formStatus;
        var args = [];
        data.IsCheckAll = $('#chkAll').prop('checked') ? 1 : 0;
        if (data.IsCheckAll == 0) {
            if (DRF2020.DRF2020Grid) { // Lấy danh sách các dòng đánh dấu
                var records = ASOFT.asoftGrid.selectedRecords(DRF2020.DRF2020Grid, 'FormFilter');
                if (records.length == 0) return;
                for (var i = 0; i < records.length; i++) {
                    args.push(records[i].ProcessingID);
                }
            }
        }
        data.ProcessingIDList = args.join("','");

        if (data) {
            var urlPost = $('#UrlDoPrintOrExport').val();

            ASOFT.helper.postTypeJson(urlPost, data, DRF2020.exportOrPrintSuccess);
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
    if (typeof (installPeriod) !== 'undefined') {
        installPeriod(true);
    }
    DRF2020.DRF2020Grid = ASOFT.asoftGrid.castName('DRF2020Grid');
});
