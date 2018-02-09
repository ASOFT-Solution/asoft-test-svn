//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     12/09/2014      Đức Quý         Tạo mới
//####################################################################

DRF2040 = new function () {
    this.isSearch = false;
    this.DRF2040Grid = null;
    this.urlUpdate = null;

    // Filter button events
    this.btnFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        DRF2040.isSearch = true;
        DRF2040.DRF2040Grid.dataSource.page(1);
    };

    // Reset filter button events
    this.btnResetFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        $('#FormFilter input').val('');
        DRF2040.isSearch = false;
        DRF2040.DRF2040Grid.dataSource.page(1);
    };

    //Send data grid
    this.sendDataFilter = function () {
        var dataMaster = ASOFT.helper.dataFormToJSON("FormFilter");
        dataMaster['IsSearch'] = DRF2040.isSearch;
        return dataMaster;
    };

    // Add new button events
    this.btnAddNew_Click = function () {
        // [1] Tạo form status : Add new
        DRF2040.formStatus = 1;
        DRF2040.urlUpdate = $('#UrlInsert').val();
        // [2] Url load dữ liệu lên form
        var postUrl = $("#UrlDRF2041").val();

        // [3] Data load dữ liệu lên form
        var data = {
            FormStatus: DRF2040.formStatus
        };

        // [4] Hiển thị popup
        DRF2041.showPopup(postUrl, data);
    };

    //Edit
    this.btnEdit_Click = function () {
        // [1] Tạo form status : Edit
        DRF2040.formStatus = 2;
        DRF2040.urlUpdate = $('#UrlUpdate').val();
        var apk = $('#apkEdit').val();
        
        ASOFT.helper.post($('#UrlCheckEdit').val(), { apk: apk }, function (result) {
            if (result.length == 0) {
                // [2] Url load dữ liệu lên form
                var postUrl = $("#UrlDRF2041").val();

                // [3] Data load dữ liệu lên form
                var data = {
                    FormStatus: DRF2040.formStatus,
                    APK: apk,
                    EmployeeName: $('#EmployeeName').text()
                };

                // [4] Hiển thị popup
                DRF2041.showPopup(postUrl, data);
            }
            else {
                ASOFT.form.displayMessageBox('#ViewMaster', [ASOFT.helper.getMessage(result[0].MessageID)]);
            }
        });
    }

    // Add new button events
    this.btnImport_Click = function () {

        // [2] Url load dữ liệu lên form
        var postUrl = $("#UrlDRF2003").val();

        // [3] Data load dữ liệu lên form
        var data = {
            type: "SalaryFile"
        };

        // [4] Hiển thị popup
        DRF2003.showPopup(postUrl, data);
    };

    // Add new button events
    this.btnInherit_Click = function () {

        // [2] Url load dữ liệu lên form
        var postUrl = $("#UrlDRF2043").val();

        // [3] Data load dữ liệu lên form
        var data = {};

        // [4] Hiển thị popup
        DRF2043.showPopup(postUrl, data);
    };

    // Delete button events
    this.btnDelete_Click = function () {
        var urlDelete = $('#UrlDelete').val();
        var args = [];
        var data = {};
        if (DRF2040.DRF2040Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(DRF2040.DRF2040Grid, 'FormFilter');
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
            ASOFT.helper.postTypeJson(urlDelete, data, DRF2040.deleteSuccess);
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
            var urlDRF2040 = $('#UrlDRF2040').val();
            // Chuyển hướng hoặc refresh data
            if (urlDRF2040 != null) {
                window.location.href = urlDRF2040; // redirect index
            }
        }, null, null, true, displayOnRedirecting, "FormFilter");

        if (DRF2040.DRF2040Grid) {
            DRF2040.DRF2040Grid.dataSource.page(1); // Refresh grid 
        }
    };
}

// Xử lý ban đầu
$(document).ready(function () {
    DRF2040.DRF2040Grid = ASOFT.asoftGrid.castName('DRF2040Grid');
});
