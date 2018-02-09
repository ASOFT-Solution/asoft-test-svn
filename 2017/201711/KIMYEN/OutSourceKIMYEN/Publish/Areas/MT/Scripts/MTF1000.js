//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     17/12/2013       Đức Quý        Tạo mới
//#     05/03/2013       Huy Cường      Update
//####################################################################

$(document).ready(function () {
    MTF1000.MTF1001Popup = ASOFT.asoftPopup.castName("MTF1001Popup");
    MTF1000.MTF1000Grid = ASOFT.asoftGrid.castName('MTF1000Grid');

    ASOFT.helper.showErrorSeverOptionFromRedirecting();

    MTF1000.MTF1001Popup.bind("refresh", function () {
        $("#CourseID").bind('keypress', ASOFTTextBox.escapeSpecialCharacter);
        MTF1000.StartDate = ASOFT.asoftDateEdit.castName("BeginDate");
        MTF1000.EndDate = ASOFT.asoftDateEdit.castName("EndDate");
    });
});

$(window).resize(function () {
    if (MTF1000.MTF1000Grid) {
        ASOFT.asoftGrid.setHeight(MTF1000.MTF1000Grid);
    }
});

var MTF1000 = new function() {
    this.formStatus = 1;
    this.isSearch = false;
    this.MTF1001Popup = null; // Biến đối tượng
    this.MessageErrorPopup = null; // Biến đối tượng
    this.MTF1000Grid = null; // Biến đối tượng
    this.saveActionType = null; // 1: SaveNext, 2: SaveCopy, 3: SaveClose
    this.urlUpdate = null;
    this.StartDate = null;
    this.EndDate = null;

    // Show popup
    this.showPopup = function (popup, url, data) {
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.show(popup, url, data);
    };
    
    //Tìm kiếm
    this.filterData = function () {
        ASOFT.form.clearMessageBox();
        MTF1000.isSearch = true;
        MTF1000.MTF1000Grid.dataSource.page(1);
    };

    //Reset form tìm kiếm
    this.clearFilterData = function () {
        ASOFT.form.clearMessageBox();
        MTF1000.isSearch = false;
        $('#FormFilter input').val('');
        MTF1000.MTF1000Grid.dataSource.page(1);
    };

    //Hiển thị các dòng được chọn
    this.showRecord = function() {
        MTF1000.showHideRecords(0);
    };

    //Ẩn các dòng được chọn
    this.hideRecord = function() {
        MTF1000.showHideRecords(1);
    };

    this.showHideRecords = function(disabled) {
        var args = [];
        var records = ASOFT.asoftGrid.selectedRecords(MTF1000.MTF1000Grid, 'FormFilter');
        if (records.length == 0) return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].CourseID);
        }

        var url = $("#UpdateRecord").val();
        var data = {
            args: args,
            disabled: disabled
        };

        ASOFT.helper.postTypeJson(url, data, function (result) {
            if (result.Status == 0) {
                MTF1000.MTF1000Grid.dataSource.page(1);
            }
        });
    };

    //Send data grid
    this.sendFilter = function() {
        var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
        datamaster['IsSearch'] = MTF1000.isSearch;
        return datamaster;
    };

    //=============================================================================
    // Màn hình truy vấn MTF1000
    //=============================================================================
    // Create
    this.addNew = function() {
        MTF1000.formStatus = 1;
        MTF1000.urlUpdate = $("#UrlInsert").val();
        var urlMtf1001 = $('#UrlMTF1001').val();
        var popup = MTF1000.MTF1001Popup;
        var data = { FormStatus: MTF1000.formStatus };
        MTF1000.showPopup(popup, urlMtf1001, data);
    };

    // Add new and Copy
    this.addNewCopy = function(savedKey) {
        MTF1000.formStatus = 1;
        MTF1000.urlUpdate = $("#UrlInsert").val();
        var data = {
            CourseID: savedKey,
            FormStatus: MTF1000.formStatus
        };
        var urlMtf1001 = $('#UrlMTF1001').val();
        MTF1000.showPopup(MTF1000.MTF1001Popup, urlMtf1001, data);
    };
    
    // Update
    this.edit = function() {
        MTF1000.formStatus = 2;
        MTF1000.urlUpdate = $("#UrlUpdate").val();
        var courseId = $('input[name="Course"]').val();
        var data = {
            CourseID: courseId,
            FormStatus: MTF1000.formStatus
        };
        var urlMtf1001 = $('#UrlMTF1001').val();
        MTF1000.showPopup(MTF1000.MTF1001Popup, urlMtf1001, data);
    };
    
    //Xóa khóa học
    this.deleted = function() {
        var urlDeleteMtf1001 = $('#UrlDelete').val();
        var args = [];
        var data = { };
        if (MTF1000.MTF1000Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(MTF1000.MTF1000Grid, 'FormFilter');
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].CourseID);
            }
        } else {
            // Lấy đối tượng hiện tại nếu đang ở màn hình details
            var courseId = $('input[name="Course"]').val();
            args.push(courseId);
        }

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*A00ML000002*/), function () {
            data['args'] = args;
            ASOFT.helper.postTypeJson(urlDeleteMtf1001, data, MTF1000.deleteSuccess);

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
            var urlMtf1000 = $('#UrlMTF1000').val();
            // Chuyển hướng hoặc refresh data
            if (urlMtf1000 != null) {
                window.location.href = urlMtf1000; // redirect index
            }
        }, null, null, true, displayOnRedirecting, "FormFilter");

        if (MTF1000.MTF1000Grid) {
            MTF1000.MTF1000Grid.dataSource.page(1); // Refresh grid 
        }
    };
    
    //=============================================================================
    // Màn hình cập nhật MTF1001
    //=============================================================================
    
    //Lấy dữ liệu từ form
    this.getFormData = function() {
        //Lấy dữ liệu từ form post lên
        var data = ASOFT.helper.getFormData(null, "MTF1001");
        return data;
    };

    // Xử lý lưu dữ liệu
    this.btnSaveClick = function() {
        ASOFT.asoftLoadingPanel.show();
        MTF1000.saveActionType = 1;
        //Validate form
        if (ASOFT.form.checkRequired("MTF1001")) {
            ASOFT.asoftLoadingPanel.hide();
            return;
        }

        //Kiểm tra ngày bắt đầu và ngày kết thúc
        if (MTF1000.StartDate.value() > MTF1000.EndDate.value()) {
            var message = null;
            message = [ASOFT.helper.getMessage('HFML000290')];
            ASOFT.form.displayMessageBox("form#MTF1001", message, null);
            ASOFT.asoftLoadingPanel.hide();
            return;
        }

        var data = MTF1000.getFormData();
        ASOFT.helper.post(MTF1000.urlUpdate, data, MTF1000.saveSuccess); //post dữ liệu lên server
    };

    // Xử lý lưu dữ liệu
    this.btnSaveCopyClick = function() {
        ASOFT.asoftLoadingPanel.show();
        MTF1000.saveActionType = 2;
        //Validate form
        if (ASOFT.form.checkRequired("MTF1001")) {
            ASOFT.asoftLoadingPanel.hide();
            return;
        }

        //Kiểm tra ngày bắt đầu và ngày kết thúc
        if (MTF1000.StartDate.value() > MTF1000.EndDate.value()) {
            var message = null;
            message = [ASOFT.helper.getMessage('HFML000290')];
            ASOFT.form.displayMessageBox("form#MTF1001", message, null);
            ASOFT.asoftLoadingPanel.hide();
            return;
        }

        var data = MTF1000.getFormData();
        ASOFT.helper.post(MTF1000.urlUpdate, data, MTF1000.saveSuccess); //post dữ liệu lên server
    };

    this.btnSaveCloseClick = function() {
        ASOFT.asoftLoadingPanel.show();
        MTF1000.saveActionType = 3;
        //Validate form
        if (ASOFT.form.checkRequired("MTF1001")) {
            ASOFT.asoftLoadingPanel.hide();
            return;
        }

        //Kiểm tra ngày bắt đầu và ngày kết thúc
        if (MTF1000.StartDate.value() > MTF1000.EndDate.value()) {
            var message = null;
            message = [ASOFT.helper.getMessage('HFML000290')];
            ASOFT.form.displayMessageBox("form#MTF1001", message, null);
            ASOFT.asoftLoadingPanel.hide();
            return;
        }

        var data = MTF1000.getFormData();
        ASOFT.helper.post(MTF1000.urlUpdate, data, MTF1000.saveSuccess); //post dữ liệu lên server
    };

    // Đóng popup
    this.btnCloseClick = function() {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016' /*A00ML000001*/), MTF1000.btnSaveCloseClick, function() {
            MTF1000.MTF1001Popup.close();
        });
    };

    //Kết quả trả về
    this.saveSuccess = function(result) {

        // Update Save status
        ASOFT.form.updateSaveStatus('MTF1001', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'MTF1001', function () {
            // Chuyển hướng xử lý nghiệp vụ
            switch (MTF1000.saveActionType) {
                case 1: // Trường hợp lưu & nhập tiếp
                    MTF1000.addNew();
                    break;
                case 2: // Trường hợp lưu & sao chép
                    MTF1000.addNewCopy(result.Data);
                    break;
                case 3: // Trường hợp lưu và đóng
                    MTF1000.MTF1001Popup.close();
                    break;
                default:
                    break;
            }

            // Refresh data
            if (MTF1000.MTF1000Grid) {
                // Reload grid
                MTF1000.MTF1000Grid.dataSource.page(1);
            } else {
                window.location.reload(true);
            }
        }, null, null, true);
    };
};

//function clearFormMTF1001() {
//    $('#MTF1001 input[type="text"], textarea').val('');
//}

