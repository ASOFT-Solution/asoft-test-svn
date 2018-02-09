//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     17/02/2014      Đức Quý      Tạo mới
//####################################################################

$(document).ready(function () {
    MTF1030.MTF1031Popup = ASOFT.asoftPopup.castName("MTF1031Popup");
    MTF1030.gridMaster = $("#MTF1030_GridMaster").data("kendoGrid");

    // Display message from cache
    ASOFT.helper.showErrorSeverOptionFromRedirecting();

    if (MTF1030.MTF1031Popup) {
        MTF1030.MTF1031Popup.bind("refresh", function (e) {
            $("#StopReasonID").bind('keypress', ASOFTTextBox.escapeSpecialCharacter);
        });
    }
});


$(window).resize(function () {
    ASOFT.asoftGrid.setHeight(MTF1030.gridMaster);
});

MTF1030 = new function() {
    this.issearch = null;
    this.saveActionType = null;
    this.formStatus = null;
    this.redirectUrl = null;
    this.gridMaster = null;
    this.MTF1031Popup = null;
    
    //hiển thị popup
    this.showPopup = function (popup, urlContent, data) {
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.show(popup, urlContent, data);
    };

    //////////////////////////// Lý do thôi học - MTF1030 ///////////////////////////
    this.btnFilter_Click = function () {
        MTF1030.filterData();
    };

    this.btnResetFilter_Click = function () {
        MTF1030.clearFilterData();
    };

    this.filterData = function () {
        ASOFT.form.clearMessageBox();
        MTF1030.issearch = true;
        MTF1030.gridMaster.dataSource.page(1);
    };

    this.clearFilterData = function () {
        ASOFT.form.clearMessageBox();
        $('#FormFilter input').val('');
        if (MTF1030.gridMaster) {
            MTF1030.gridMaster.dataSource.page(1);
        }
    };

    //Send data grid
    this.sendFilter = function() {
        var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
        datamaster['IsSearch'] = MTF1030.issearch;
        return datamaster;
    };

    //Hiển thị các dòng được chọn
    this.btnShowRecord_Click = function() {
        MTF1030.showHideRecords(0);
    };

    //Ẩn các dòng được chọn
    this.btnHideRecord_Click = function() {
        MTF1030.showHideRecords(1);
    };

    this.showHideRecords = function(disabled) {
        var args = [];
        var records = ASOFT.asoftGrid.selectedRecords(MTF1030.gridMaster, "FormFilter");
        if (records.length == 0) return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].StopReasonID);
        }

        var url = $("#UrlUpdateRecord").val();
        var data = {
            args: args,
            disabled: disabled
        };

        ASOFT.helper.postTypeJson(url, data, function (result) {
            if (result.Status == 0) {
                MTF1030.gridMaster.dataSource.page(1);
            }
        });
    };

    this.clearFormData = function (formId) {
        $('form#' + formId + ' input[type="text"], textarea').val('');
    };
    
    //Xóa 
    this.btnDelete_Click = function() {
        var urlDelete = $('#UrlMTF1031Delete').val();
        var args = [];
        var data = { };

        if (MTF1030.gridMaster) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(MTF1030.gridMaster, "FormFilter");
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].StopReasonID);
            }
        } else {
            // Lấy đối tượng hiện tại nếu đang ở màn hình details
            var stopReasonId = $('input[name="MTF1032MStopReasonID"]').val();
            args.push(stopReasonId);
        }

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*'A00ML000002'*/), function () {
            data['args'] = args;
            ASOFT.helper.postTypeJson(urlDelete, data, MTF1030.deleteSuccess);

        });
    };

    //Kết quả server trả về sau khi xóa
    this.deleteSuccess = function (result) {
        var formId = null;
        var displayOnRedirecting = null;

        if (document.getElementById("FormFilter")) {
            formId = "FormFilter";
            displayOnRedirecting = false;
        } else if (document.getElementById("ViewMaster")) {
            formId = "ViewMaster";
            displayOnRedirecting = true;
        }
        
        ASOFT.helper.showErrorSeverOption(1, result, formId, function() {
            var redirectUrl = $('#UrlMTF1030').val();
            // Chuyển hướng hoặc refresh data
            if (redirectUrl != null) {
                window.location.href = redirectUrl; // redirect index
            } else {
                MTF1030.gridMaster.dataSource.page(1); // Refresh grid 
            }
        }, null, null, true, displayOnRedirecting, "FormFilter");
        
        if (MTF1030.gridMaster) {
            MTF1030.gridMaster.dataSource.read();
        }
    };

    //////////////////////////// Cập nhật lý do thôi học - MTF1031 ///////////////////////////

    this.btnAddNew_Click = function() {
        MTF1030.addNew();
    };

    this.btnEdit_Click = function() {
        MTF1030.editRecord();
    };

    // Cập nhật
    this.editRecord = function() {
        MTF1030.formStatus = 2;
        var stopReasonId = $('#MTF1032MStopReasonID').val();
        var popup = MTF1030.MTF1031Popup;
        var urlMtf1031 = $('#UrlMTF1031').val();
        var data = {
            StopReasonID: stopReasonId,
            FormStatus: MTF1030.formStatus
        };
        MTF1030.showPopup(popup, urlMtf1031, data);
    };


    // Thêm mới
    this.addNew = function() {
        MTF1030.formStatus = 1;
        var popup = MTF1030.MTF1031Popup;
        var data = { FormStatus: MTF1030.formStatus };
        var urlMtf1031 = $('#UrlMTF1031').val();
        MTF1030.showPopup(popup, urlMtf1031, data);
    };

    // Thêm mới và sao chép
    this.addNewCopy = function(savedKey) {
        MTF1030.formStatus = 1;
        var popup = MTF1030.MTF1031Popup;
        var data = {
            StopReasonID: savedKey,
            FormStatus: MTF1030.formStatus
        };
        var urlMtf1031 = $('#UrlMTF1031').val();
        MTF1030.showPopup(popup, urlMtf1031, data);
    };

    this.saveData = function() {
        if (ASOFT.form.checkRequired("MTF1031")) {
            return;
        }

        var urlMtf1031Update = null;
        if (MTF1030.formStatus == 1) {
            urlMtf1031Update = $('#UrlMTF1031Insert').val();
        }
        if (MTF1030.formStatus == 2) {
            urlMtf1031Update = $('#UrlMTF1031Update').val();
        }

        //Lấy dữ liệu từ form post lên
        var data = ASOFT.helper.getFormData(null, "MTF1031");

        ASOFT.helper.post(urlMtf1031Update, data, MTF1030.saveSuccess);
    };
    
    this.saveSuccess = function (result) {

        // Update status
        ASOFT.form.updateSaveStatus('MTF1031', result.Status, result.Data);

        ASOFT.helper.showErrorSeverOption(0, result, "MTF1031", function() {
            switch (MTF1030.saveActionType) {
            case 1:
                // Lưu và nhập tiếp
                MTF1030.addNew();
                break;
            case 2:
                // Lưu và sao chép
                MTF1030.addNewCopy(result.Data);
                break;
            default:
                MTF1030.MTF1031Popup.close();
                break;
            }
            var data;

            if (MTF1030.gridMaster) {
                MTF1030.gridMaster.dataSource.page(1);
            } else {
                var stopReasonId = $('#MTF1032MStopReasonID').val();
                data = { id: stopReasonId };
                var postUrl = $('#UrlMTF1032M').val();
                ASOFT.helper.post(postUrl, data, function(html) {
                    $('#viewPartial').html(html);
                });
            }
        }, null, null, true);
    };

    // Đóng form
    this.btnClose_Click = function() {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016' /*"A00ML000001"*/), MTF1030.saveData, function () {
            MTF1030.MTF1031Popup.close();
        });
    };

    // Lưu và nhập tiếp
    this.btnSaveNext_Click = function() {
        // action savenext
        MTF1030.saveActionType = 1;
        MTF1030.saveData();
    };

    // Lưu và sao chép
    this.btnSaveCopy_Click = function() {
        MTF1030.saveActionType = 2;
        MTF1030.saveData();
    };

    // Luu và đóng
    this.btnSave_Click = function() {
        MTF1030.saveData();
    };

};

