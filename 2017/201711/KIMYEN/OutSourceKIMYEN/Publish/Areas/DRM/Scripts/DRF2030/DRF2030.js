//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     11/09/2014      Đức Quý         Tạo mới
//####################################################################

DRF2030 = new function () {
    this.isSearch = false;
    this.DRF2030Grid = null;
    this.urlUpdate = null;

    // Filter button events
    this.btnFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        DRF2030.isSearch = true;
        DRF2030.DRF2030Grid.dataSource.page(1);
    };

    // Reset filter button events
    this.btnClearFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        $('#FormFilter input').val('');
        $('#rdbIsPeriod').prop('checked', 'checked');
        $('#rdbIsPeriod').trigger('change');
        DRMPeriodFilter.isDate = 0;
        DRF2030.isSearch = false;

        //$('#rdbIsDate').prop('checked', 'checked');

        DRMPeriodFilter.fromMonth = null;
        DRMPeriodFilter.fromYear = null;
        DRMPeriodFilter.toMonth = null;
        DRMPeriodFilter.ToYear = null;

        DRMPeriodFilter.fromDate.value(new Date());
        DRMPeriodFilter.toDate.value(new Date());

        DRF2030.DRF2030Grid.dataSource.page(1);
    };

    this.sendDataFilter = function () {
        var dataMaster = ASOFT.helper.dataFormToJSON("FormFilter");
        dataMaster['IsSearch'] = DRF2030.isSearch;
        dataMaster.IsDate = DRMPeriodFilter.isDate;
        dataMaster.FromMonth = DRMPeriodFilter.fromMonth;
        dataMaster.FromYear = DRMPeriodFilter.fromYear;
        dataMaster.ToMonth = DRMPeriodFilter.toMonth;
        dataMaster.ToYear = DRMPeriodFilter.toYear;
        return dataMaster;
    };

    // Add new button events
    this.btnAddNew_Click = function () {
        // [1] Tạo form status : Add new
        DRF2030.formStatus = 1;
        DRF2030.urlUpdate = $('#UrlInsert').val();
        // [2] Url load dữ liệu lên form
        var url = $("#UrlDRF2031").val();

        // [3] Data load dữ liệu lên form
        var data = {
            FormStatus: DRF2030.formStatus
        };

        var postUrl = ASOFT.helper.renderUrl(url, data);
        ASOFT.asoftPopup.showIframe(postUrl, {});

        //// [4] Hiển thị popup
        //DRF2031.showPopup(url, data);
    };

    this.btnEdit_Click = function () {
        // [1] Tạo form status : Edit
        DRF2030.formStatus = 2;
        DRF2030.urlUpdate = $('#UrlUpdate').val();
        var apk = $('#apkEdit').val();
        var debtorName = $('#DebtorName').text();
        
        ASOFT.helper.post($('#UrlCheckEdit').val(), { apk: apk }, function (result) {
            if (result.length == 0) {
                // [2] Url load dữ liệu lên form
                var url = $("#UrlDRF2031").val();

                // [3] Data load dữ liệu lên form
                var data = {
                    FormStatus: DRF2030.formStatus,
                    APK: apk,
                    DebtorName: debtorName
                };

                //// [4] Hiển thị popup
                //DRF2031.showPopup(url, data);
                var postUrl = ASOFT.helper.renderUrl(url, data);
                ASOFT.asoftPopup.showIframe(postUrl, {});
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
        if (DRF2030.DRF2030Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(DRF2030.DRF2030Grid, 'FormFilter');
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
            ASOFT.helper.postTypeJson(urlDelete, data, DRF2030.deleteSuccess);
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
            var urlDRF2030 = $('#UrlDRF2030').val();
            // Chuyển hướng hoặc refresh data
            if (urlDRF2030 != null) {
                window.location.href = urlDRF2030; // redirect index
            }
        }, null, null, true, displayOnRedirecting, "FormFilter");

        if (DRF2030.DRF2030Grid) {
            DRF2030.DRF2030Grid.dataSource.page(1); // Refresh grid 
        }
    }
}

// Xử lý ban đầu
$(document).ready(function () {
    if (typeof (installPeriod) !== 'undefined') {
        installPeriod(true);
    }
    DRF2030.DRF2030Grid = ASOFT.asoftGrid.castName('DRF2030Grid');
});
