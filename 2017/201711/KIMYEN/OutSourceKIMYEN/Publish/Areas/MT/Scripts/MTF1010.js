//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     14/02/2014      Đức Quý      Tạo mới
//####################################################################

$(document).ready(function () {
    MTF1010.MTF1011Popup = ASOFT.asoftPopup.castName("MTF1011Popup");
    MTF1010.MTF1010Grid = $("#MTF1010Grid").data("kendoGrid");

    ASOFT.helper.showErrorSeverOptionFromRedirecting();
    
    MTF1010.MTF1011Popup.bind("refresh", function () {
        $("#LevelID").bind('keypress', ASOFTTextBox.escapeSpecialCharacter);
    });
});

$(window).resize(function () {
    if (MTF1010.MTF1010Grid) {
        ASOFT.asoftGrid.setHeight(MTF1010.MTF1010Grid);
    }
});

MTF1010 = new function () {
    
    //=============================================================================
    // Init Object
    //=============================================================================
    this.formStatus = null;
    this.isSearch = false;
    this.MTF1011Popup = null;
    this.urlUpdate = null;
    this.saveActionType = null; // 1: SaveNext, 2: SaveCopy, 3: SaveClose
    
    // Show popup
    this.showPopup = function (popup, url, data) {
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.show(popup, url, data);
    };

    //Đóng popup
    this.closePopup = function() {
        MTF1010.MTF1011Popup.close();
    };

    //=============================================================================
    // Grid Master
    //=============================================================================
    this.sendDataFilter = function() {
        var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
        datamaster["IsSearch"] = MTF1010.isSearch;
        return datamaster;
    };
    
    // Filter
    this.filterData = function () {
        ASOFT.form.clearMessageBox();
        MTF1010.isSearch = true;
        MTF1010.MTF1010Grid.dataSource.page(1);
    };

    // Reset Filter
    this.resetFormFilter = function () {
        ASOFT.form.clearMessageBox();
        MTF1010.isSearch = false;
        $("#FormFilter input").val('');
        MTF1010.MTF1010Grid.dataSource.page(1);
    };

    this.showHideRecords = function(disabled) {
        var args = [];
        var records = ASOFT.asoftGrid.selectedRecords(MTF1010.MTF1010Grid, 'FormFilter');
        if (records.length == 0) return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].LevelID);
        }

        var url = $("#UpdateRecord").val();
        var data = {
            args: args,
            disabled: disabled
        };

        ASOFT.helper.postTypeJson(url, data, function (result) {
            if (result.Status == 0) {
                MTF1010.MTF1010Grid.dataSource.page(1);
            }
        });
    };
    
    //Hiển thị các dòng được chọn
    this.showRecord = function() {
        MTF1010.showHideRecords(0);
    };

    //Ẩn các dòng được chọn
    this.hideRecord = function() {
        MTF1010.showHideRecords(1);
    };
    
    //=============================================================================
    // CRUD
    //=============================================================================
    // Create
    this.addNew = function() {
        MTF1010.formStatus = 1;
        MTF1010.urlUpdate = $("#UrlInsert").val();
        var urlMtf1011 = $('#UrlMTF1011').val();
        var data = {
            FormStatus: MTF1010.formStatus
        };
        MTF1010.showPopup(MTF1010.MTF1011Popup, urlMtf1011, data);
    };

    // Add new and copy
    this.addNewCopy = function(savedKey) {
        MTF1010.formStatus = 1;
        MTF1010.urlUpdate = $("#UrlInsert").val();
        var urlMtf1011 = $('#UrlMTF1011').val();
        var data = {
            LevelID: savedKey,
            FormStatus: MTF1010.formStatus
        };

        MTF1010.showPopup(MTF1010.MTF1011Popup, urlMtf1011, data);
    };


    // Update
    this.edit = function() {
        MTF1010.formStatus = 2;
        MTF1010.urlUpdate = $("#UrlUpdate").val();
        var urlMtf1011 = $('#UrlMTF1011').val();
        var data = {
            LevelID: $('#Level').val(),
            FormStatus: MTF1010.formStatus
        };
        MTF1010.showPopup(MTF1010.MTF1011Popup, urlMtf1011, data);
    };
    
    //Xóa khóa học
    this.deleted = function() {
        var postUrl = $('#UrlDeleted').val();
        var args = [];
        var data = { };
        if (MTF1010.MTF1010Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(MTF1010.MTF1010Grid, 'FormFilter');
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].LevelID);
            }
        } else {
            // Lấy đối tượng hiện tại nếu đang ở màn hình details
            var id = $('#Level').val();
            args.push(id);
        }

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*'A00ML000002'*/), function () {
            data['args'] = args;
            ASOFT.helper.postTypeJson(postUrl, data, MTF1010.deleteSuccess);
        });
    };

    //Kết quả server trả về sau khi xóa
    this.deleteSuccess = function(result) {
        var formId = null;
        var displayOnRedirecting = null;
        if (document.getElementById('FormFilter')) {
            formId = "FormFilter";
            displayOnRedirecting = false;
        } else if (document.getElementById('ViewMaster')) {
            formId = "ViewMaster";
            displayOnRedirecting = true;
        }

        ASOFT.helper.showErrorSeverOption(1 /*delete*/, result, formId, function () {
            var urlMtf1010 = $('#UrlMTF1010').val();
            // Chuyển hướng hoặc refresh data
            if (urlMtf1010 != null) {
                window.location.href = urlMtf1010; // redirect index
            }
        }, null, null, true, displayOnRedirecting, "FormFilter");

        if (MTF1010.MTF1010Grid) {
            MTF1010.MTF1010Grid.dataSource.page(1); // Refresh grid 
        }
    };
    
    // Save
    this.saveData = function() {
        // Kiểm tra hợp lệ
        if (ASOFT.form.checkRequired("MTF1011")) {
            return;
        }

        // Lấy dữ liệu trên form
        var data = MTF1010.getFormData();

        // Post data
        ASOFT.helper.post(MTF1010.urlUpdate, data, MTF1010.SaveSuccess);
    };

    // Read form data
    this.getFormData = function() {
        //Lấy dữ liệu từ form post lên
        var data = ASOFT.helper.getFormData(null, "MTF1011");
        return data;
    };
    
    //Lưu và nhập tiếp
    this.btnSaveClick = function() {
        MTF1010.saveActionType = 1;
        MTF1010.saveData();
    };

    //Lưu và sao chép
    this.btnSaveCopyClick = function() {
        MTF1010.saveActionType = 2;
        MTF1010.saveData();
    };

    //Lưu và đóng
    this.btnSaveCloseClick = function() {
        MTF1010.saveActionType = 3;
        MTF1010.saveData();
    };

    this.SaveSuccess = function(result) {

        // Save status
        ASOFT.form.updateSaveStatus('MTF1011', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0 /*save*/, result, 'MTF1011', function () {
            // Chuyển hướng xử lý nghiệp vụ
            switch (MTF1010.saveActionType) {
                case 1: // Trường hợp lưu & nhập tiếp
                    MTF1010.addNew();
                    break;
                case 2: // Trường hợp lưu & sao chép
                    MTF1010.addNewCopy(result.Data);
                    break;
                case 3: // Trường hợp lưu và đóng
                    MTF1010.MTF1011Popup.close();
                    break;
                default:
                    break;
            }

            if (MTF1010.MTF1010Grid) {
                MTF1010.MTF1010Grid.dataSource.page(1); // refresh grid
            } else {
                window.location.reload(true);
            }
        }, null, null, true);

    };

    // Đóng popup
    this.btnCloseClick = function() {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'/*'A00ML000001'*/), MTF1010.btnSaveCloseClick, MTF1010.closePopup);
    };

    //Resert form MTF1010
    this.clearFormMTF1010 = function() {
        $('#MTF1011 input[type="text"], textarea').val('');
    };

    // Clear form data
    this.clearFormData = function(formId) {
        $('form#' + formId + ' input').val(''); // reset textbox
        $('form#' + formId + ' textarea').val(''); // reset textarea
    };
};