//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     03/09/2014      Đức Quý         Tạo mới
//####################################################################

DRF1000 = new function () {
    this.isSearch = false;
    this.urlUpdate = null;
    this.DRF1000Grid = null;
    this.formStatus = null;

    // Filter button events
    this.btnFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        DRF1000.isSearch = true;
        var query = new kendo.data.Query(DRF1000.DRF1000Grid.dataSource.data());
        DRF1000.DRF1000Grid.dataSource.page(1);
    };

    // Reset filter button events
    this.btnClearFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        $('#FormFilter input').val('');
        DRF1000.isSearch = false;
        DRF1000.DRF1000Grid.dataSource.page(1);
    };

    //Send data grid
    this.sendDataFilter = function () {
        var dataMaster = ASOFT.helper.dataFormToJSON("FormFilter");
        dataMaster['IsSearch'] = DRF1000.isSearch;
        return dataMaster;
    };

    // Add new button events
    this.btnAddNew_Click = function () {
        // [1] Tạo form status : Add new
        DRF1001.formStatus = 1;
        DRF1000.urlUpdate = $('#urlInsert').val();

        // [2] Url load dữ liệu lên form
        var postUrl = $("#UrlDRF1001").val();

        // [3] Data load dữ liệu lên form
        var data = {
            FormStatus: DRF1001.formStatus
        };

        // [4] Hiển thị popup
        DRF1001.showPopup(postUrl, data);
    };

    // Edit button events
    this.btnEdit_Click = function () {
        // [1] Tạo form status : Edit
        DRF1000.formStatus = 2;
        DRF1000.urlUpdate = $('#urlUpdate').val();
        var employeeID = $('#employee').val();

        ASOFT.helper.post($('#UrlCheckEdit').val(), { EmployeeID: employeeID }, function (result) {
            if (result.length == 0) {
                // [2] Url load dữ liệu lên form
                var postUrl = $("#UrlDRF1001").val();

                // [3] Data load dữ liệu lên form
                var data = {
                    FormStatus: DRF1000.formStatus,
                    EmployeeID: employeeID
                };

                // [4] Hiển thị popup
                DRF1001.showPopup(postUrl, data);
            }
            else {
                ASOFT.form.displayMessageBox('#ViewMaster', [ASOFT.helper.getMessage(result[0].MessageID)]);
            }
        });
    };

    // Delete button events
    this.btnDelete_Click = function () {
        var urlDelete = $('#UrlDelete').val();
        var args = [];
        var data = { };
        if (DRF1000.DRF1000Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(DRF1000.DRF1000Grid, 'FormFilter');
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].EmployeeID);
            }
        } else {
            // Lấy đối tượng hiện tại nếu đang ở màn hình details
            var employeeID = $('#employee').val();
            args.push(employeeID);
        }

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*A00ML000002*/), function () {
            data['args'] = args;
            data['ScreenID'] = $('#ScreenID').val();
            ASOFT.helper.postTypeJson(urlDelete, data, DRF1000.deleteSuccess);
        });
    };

    //Kết quả server trả về sau khi xóa
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
            var urlDRF1000 = $('#UrlDRF1000').val();
            // Chuyển hướng hoặc refresh data
            if (urlDRF1000 != null) {
                window.location.href = urlDRF1000; // redirect index
            }
        }, null, null, true, displayOnRedirecting, "FormFilter");

        if (DRF1000.DRF1000Grid) {
            DRF1000.DRF1000Grid.dataSource.page(1); // Refresh grid 
        }
    };

    //Hiển thị các dòng được chọn
    this.showRecord = function () {
        DRF1000.showHideRecords(0);
    };

    //Ẩn các dòng được chọn
    this.hideRecord = function () {
        DRF1000.showHideRecords(1);
    };

    this.showHideRecords = function (disabled) {
        var args = [];
        var records = ASOFT.asoftGrid.selectedRecords(DRF1000.DRF1000Grid, 'FormFilter');
        if (records.length == 0) return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].EmployeeID);
        }

        var url = $("#UpdateRecord").val();
        var data = {
            args: args,
            disabled: disabled
        };

        ASOFT.helper.postTypeJson(url, data, function (result) {
            if (result.Status == 0) {
                DRF1000.DRF1000Grid.dataSource.page(1);
            }
        });
    };
}

$(document).ready(function () {
    DRF1000.DRF1000Grid = ASOFT.asoftGrid.castName('DRF1000Grid');
    //DRF1000.DRF1000Grid.bind('dataBound', function () {
    //    //var query = new kendo.data.Query(DRF1000.DRF1000Grid.dataSource.data());
    //    //var dataPage2 = DRF1000.DRF1000Grid.dataSource.query({ page: 2, pageSize: 25 });
    //})
})