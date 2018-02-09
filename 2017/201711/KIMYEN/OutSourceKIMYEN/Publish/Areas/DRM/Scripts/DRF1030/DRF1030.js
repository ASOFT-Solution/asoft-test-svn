//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     20/02/2017      Quang Chiến         Tạo mới
//####################################################################

DRF1030 = new function () {
    this.isSearch = false;
    this.DRF1030Grid = null;
    this.urlUpdate = null;
    this.formStatus = null;

    // Filter button events
    this.btnFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        DRF1030.isSearch = true;
        DRF1030.DRF1030Grid.dataSource.page(1);
    };

    // Reset filter button events
    this.btnClearFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        $('#FormFilter input').val('');
        DRF1030.isSearch = false;
        DRF1030.DRF1030Grid.dataSource.page(1);
    };

    this.sendDataFilter = function () {
        var dataMaster = ASOFT.helper.dataFormToJSON("FormFilter");
        dataMaster['IsSearch'] = DRF1030.isSearch;
        return dataMaster;
    }

    // Add new button events
    this.btnAddNew_Click = function () {
        // [1] Tạo form status : Add new
        DRF1030.formStatus = 1;
        DRF1030.urlUpdate = $('#UrlInsert').val();

        // [2] Url load dữ liệu lên form
        var postUrl = $("#UrlDRF1031").val();

        // [3] Data load dữ liệu lên form
        var data = {
            FormStatus: DRF1030.formStatus
        };

        // [4] Hiển thị popup
        DRF1031.showPopup(postUrl, data);
    };

    // Edit button events
    this.btnEdit_Click = function () {
        // [1] Tạo form status : Edit
        DRF1030.formStatus = 2;
        DRF1030.urlUpdate = $('#UrlUpdate').val();
        var PortID = $('td#PortID').text();

        ASOFT.helper.post($('#UrlCheckEdit').val(), { PortID: PortID }, function (result) {
            if (result.length == 0) {
                // [2] Url load dữ liệu lên form
                var postUrl = $("#UrlDRF1031").val();

                // [3] Data load dữ liệu lên form
                var data = {
                    FormStatus: DRF1030.formStatus,
                    PortID: PortID
                };

                // [4] Hiển thị popup
                DRF1031.showPopup(postUrl, data);
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
        var data = {};
        if (DRF1030.DRF1030Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(DRF1030.DRF1030Grid, 'FormFilter');
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].PortID);
            }
        } else {
            // Lấy đối tượng hiện tại nếu đang ở màn hình details
            var PortID = $('td#PortID').text();
            args.push(PortID);
        }

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*A00ML000002*/), function () {
            data['args'] = args;
            data['ScreenID'] = $('#ScreenID').val();
            ASOFT.helper.postTypeJson(urlDelete, data, DRF1030.deleteSuccess);
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
            var urlDRF1030 = $('#UrlDRF1030').val();
            // Chuyển hướng hoặc refresh data
            if (urlDRF1030 != null) {
                window.location.href = urlDRF1030; // redirect index
            }
        }, null, null, true, displayOnRedirecting, "FormFilter");

        if (DRF1030.DRF1030Grid) {
            DRF1030.DRF1030Grid.dataSource.page(1); // Refresh grid 
        }
    }

    //Hiển thị các dòng được chọn
    this.showRecord = function () {
        DRF1030.showHideRecords(0);
    };

    //Ẩn các dòng được chọn
    this.hideRecord = function () {
        DRF1030.showHideRecords(1);
    };

    this.showHideRecords = function (disabled) {
        var args = [];
        var records = ASOFT.asoftGrid.selectedRecords(DRF1030.DRF1030Grid, 'FormFilter');
        if (records.length == 0) return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].PortID);
        }

        var url = $("#UpdateRecord").val();
        var data = {
            args: args,
            disabled: disabled
        };

        ASOFT.helper.postTypeJson(url, data, function (result) {
            if (result.Status == 0) {
                DRF1030.DRF1030Grid.dataSource.page(1);
            }
        });
    };
}

$(document).ready(function () {
    DRF1030.DRF1030Grid = ASOFT.asoftGrid.castName('DRF1030Grid');
})