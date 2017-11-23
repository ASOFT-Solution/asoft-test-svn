//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     07/11/2014      Như Huyên       Tạo mới
//####################################################################

CIF1030 = new function () {
    this.isSearch = false;
    this.CIF1030Grid = null;
    this.urlUpdate = null;

    // Filter button events
    this.btnFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        CIF1030.isSearch = true;
        CIF1030.CIF1030Grid.dataSource.page(1);
    };

    // Reset filter button events
    this.btnClearFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        $('#FormFilter input').val('');
        CIF1030.isSearch = false;
        CIF1030.CIF1030Grid.dataSource.page(1);
    };

    this.sendDataFilter = function () {
        var dataMaster = ASOFT.helper.dataFormToJSON("FormFilter");
        dataMaster['IsSearch'] = CIF1030.isSearch;
        return dataMaster;
    };

    // Delete button events
    this.btnDelete_Click = function () {
        var urlDelete = $('#UrlDelete').val();
        var args = [];
        var data = {};
        if (CIF1030.CIF1030Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(CIF1030.CIF1030Grid, 'FormFilter');
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].AnaID);
            }
        } else {
            // Lấy đối tượng hiện tại nếu đang ở màn hình details
            var anaID = $('#anaEdit').val();
            args.push(anaID);
        }

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*A00ML000002*/), function () {
            data['args'] = args;
            ASOFT.helper.postTypeJson(urlDelete, data, CIF1030.deleteSuccess);
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
            var urlCIF1030 = $('#UrlCIF1030').val();
            // Chuyển hướng hoặc refresh data
            if (urlCIF1030) {
                window.location.href = urlCIF1030; // redirect index
            }
        }, null, null, true, displayOnRedirecting, "FormFilter");

        if (CIF1030.CIF1030Grid) {
            CIF1030.CIF1030Grid.dataSource.page(1); // Refresh grid 
        }
    }

    //Hiển thị các dòng được chọn
    this.btnEnable_Click = function () {
        var args = [];
        ASOFT.form.clearMessageBox();
        var records = ASOFT.asoftGrid.selectedRecords(CIF1030.CIF1030Grid);
        if (records.length == 0) {// nếu record không có dòng nào dc chọn.
            return;
        }
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].AnaID);
        }
        var url = $('#UpdateRecord').val();
        var data = {
            args: args,
            disabled: 0,
        };
        ASOFT.helper.postTypeJson(url, data, function (result) {
            if (result.Status == 0) {
                CIF1030.CIF1030Grid.dataSource.page(1);
            }
        });
    }

    // Ẩn các dòng được chọn
    this.btnDisable_Click = function () {
        var args = [];
        ASOFT.form.clearMessageBox();
        var records = ASOFT.asoftGrid.selectedRecords(CIF1030.CIF1030Grid, FormFilter);
        if (records.length == 0) { // nếu record không có dòng nào dc chọn.
            return;
        }
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].AnaID);
        }
        var url = $('#UpdateRecord').val();
        var data = {
            args: args,
            disabled: 1,
        };
        ASOFT.helper.postTypeJson(url, data, function (result) {
            if (result.Status == 0) {
                CIF1030.CIF1030Grid.dataSource.page(1);
            }
        });
    }

    //Add new button events
    this.btnAddNew_Click = function () {
        // [1] Tạo form status : Add new
        CIF1030.formStatus = 1;
        CIF1030.urlUpdate = $('#UrlInsert').val();
        // [2] Url load dữ liệu lên form
        //var postUrl = $("#UrlCIF1031").val();

        // [3] Data load dữ liệu lên form
        var data = {
            FormStatus: CIF1030.formStatus
        };

        var postUrl = ASOFT.helper.renderUrl($("#UrlCIF1031").val(), data);

        ASOFT.asoftPopup.showIframe(postUrl, {});
        //// [4] Hiển thị popup
        //CIF1031.showPopup(postUrl, data);
    }

    this.btnEdit_Click = function () {
        // [1] Tạo form status : Edit
        CIF1030.formStatus = 2;
        CIF1030.urlUpdate = $('#UrlUpdate').val();
        var anaID = $('#anaEdit').val();
        var anaTypeID = $('#anaTypeEdit').val();
        ASOFT.helper.post($('#UrlCheckEdit').val(), { AnaID: anaID}, function (result) {
            if (result.length == 0) {
                // [2] Data load dữ liệu lên form
                var data = {
                    FormStatus: CIF1030.formStatus,
                    AnaID: anaID,
                    AnaTypeID: anaTypeID
                };

                // [3] Url load dữ liệu lên form
                var postUrl = ASOFT.helper.renderUrl($("#UrlCIF1031").val(), data);

                // [4] Render iframe
                ASOFT.asoftPopup.showIframe(postUrl, {});
            }
            else {
                ASOFT.form.displayMessageBox('#ViewMaster', [ASOFT.helper.getMessage(result[0].MessageID)]);
            }
        });
    }
}



// Xử lý ban đầu
$(document).ready(function () {
    CIF1030.CIF1030Grid = ASOFT.asoftGrid.castName('CIF1030Grid');
});
