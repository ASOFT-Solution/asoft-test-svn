//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     24/12/2013       Đức Quý        Tạo mới
//####################################################################

$(document).ready(function () {
    MTF1020.MTF1021Popup = ASOFT.asoftPopup.castName("MTF1021Popup");
    MTF1020.MTF1023Popup = ASOFT.asoftPopup.castName("MTF1023Popup");
    MTF1020.MTF1020DivisionID = ASOFT.asoftComboBox.castName("MTF1020DivisionID");
    MTF1020.gridMaster = $("#MTF1020Grid").data("kendoGrid");
    MTF1020.gridDetails = $("#MTF1022Grid").data("kendoGrid");
    if (MTF1020.MTF1021Popup) {
        MTF1020.MTF1021Popup.bind("refresh", function () {
            $("#SchoolTimeID").bind('keypress', ASOFTTextBox.escapeSpecialCharacter);
        });
    }
    
    // Display message from cache
    ASOFT.helper.showErrorSeverOptionFromRedirecting();
    
    $(window).resize(function () {
        if (MTF1020.gridMaster) { // Resize grid master
            ASOFT.asoftGrid.setHeight(MTF1020.gridMaster);
        }
        if (MTF1020.gridDetails) { // Resize grid details
            ASOFT.asoftGrid.setHeight(MTF1020.gridDetails);
        }
    });
    
    if (MTF1020.MTF1023Popup) {
        MTF1020.MTF1023Popup.bind("refresh", function () {
            //ASOFT.asoftPopup.activedButton(e);
            $(":input").inputmask();
        });
    }
    
});

MTF1020 = new function() {
    this.formStatus = 1;
    this.isMaster = 1;
    this.urlUpdate = null;
    this.urlUpdateDetail = null;
    this.isSearch = null;
    this.schoolTimeID = null;
    this.gridMaster = null;
    this.gridDetails = null;
    this.saveActionType = null; // 1: SaveNext, 2: SaveCopy, 3: SaveClose
    this.MTF1021Popup = null;
    this.MTF1023Popup = null;
    this.MTF1020DivisionID = null;
    
    //hiển thị popup
    this.showPopup = function (popup, urlContent, data) {
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.show(popup, urlContent, data);
    };
    
    //Chuyển tới trang master detail
    this.openWindowWithPost = function(url, params) {
        var form = document.createElement("form");
        form.setAttribute("method", "Post");
        form.setAttribute("action", url);
        form.setAttribute("target", name);

        for (var i = 0; i < params.length; i++) {
            if (params.hasOwnProperty(i)) {
                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = params[i].name;
                input.value = params[i].value;
                form.appendChild(input);
            }
        }

        document.body.appendChild(form);
        window.open(form.action, '_parent');

        form.submit();

        document.body.removeChild(form);
    };
    
    //=============================================================================
    // Màn hình danh mục giờ học - MTF1020
    //=============================================================================
    //Tìm kiếm
    this.filterData = function() {
        MTF1020.isSearch = true;
        ASOFT.form.clearMessageBox();
        MTF1020.gridMaster.dataSource.page(1);
    };

    //Reset form tìm kiếm
    this.clearFilterData = function() {
        $('#FormFilter input').val('');
        ASOFT.form.clearMessageBox();
        MTF1020.gridMaster.dataSource.page(1);
    };

    //Send data grid
    this.sendFilter = function() {
        var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
        datamaster['IsSearch'] = MTF1020.isSearch;
        return datamaster;
    };
    
    //Xóa 
    this.btnDelete_Click = function() {
        var urlDelete = $('#UrlDelete').val();
        var args = [];
        var data = { };

        if (MTF1020.gridMaster) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(MTF1020.gridMaster, "FormFilter");
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].SchoolTimeID);
            }
        } else {
            // Lấy đối tượng hiện tại nếu đang ở màn hình details
            var schoolTimeId = $('input[name="SchoolTime"]').val();
            args.push(schoolTimeId);
        }

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*'A00ML000002'*/), function () {
            data['args'] = args;
            ASOFT.helper.postTypeJson(urlDelete, data, MTF1020.deleteSuccess);

        });
    };
    
    //Kết quả server trả về sau khi xóa
    this.deleteSuccess = function (result) {
        var formId = null;
        var displayOnRedirecting = null;
        
        if (document.getElementById("FormFilter")) {
            formId = "FormFilter";
            displayOnRedirecting = false;
        } else if (document.getElementById("mtf1022-viewmaster")) {
            formId = "mtf1022-viewmaster";
            displayOnRedirecting = true;
        }
        
        ASOFT.helper.showErrorSeverOption(1, result, formId, function() {
            var redirectUrl = $('#UrlMTF1020').val();
            // Chuyển hướng hoặc refresh data
            if (redirectUrl != null) {
                window.location.href = redirectUrl; // redirect index
            } else {
                MTF1020.gridMaster.dataSource.page(1); // Refresh grid 
            }
        }, null, null, true, displayOnRedirecting, "FormFilter");
        
        if (MTF1020.gridMaster) {
            MTF1020.gridMaster.dataSource.read();
        }
    };


    //=============================================================================
    // Màn hình cập nhật danh mục giờ học - MTF1021
    //=============================================================================

    //Lấy dữ liệu từ form
    this.postDataMaster = function() {
        //Lấy dữ liệu từ form post lên
        var data = ASOFT.helper.getFormData(null, "MTF1021");
        var id = $('input[name="SchoolTime"]').val();

        if (MTF1020.formStatus == 2) {
            data.unshift({ name: "schoolTimeID", value: id });
        }
        return data;
    };
    
    // Thêm mới Master
    this.btnAddNew_Click = function() {
        MTF1020.formStatus = 1;
        MTF1020.urlUpdate = $('#UrlInsert').val();
        var postUrl = $('#UrlMTF1021').val();
        var data = {
            FormStatus: MTF1020.formStatus
        };

        showPopup(MTF1020.MTF1021Popup, postUrl, data);
    };
    
    //Lưu và nhập chi tiết
    this.btnSaveAndDetailMTF1021_Click = function() {
        //Validate form
        if (ASOFT.form.checkRequired("MTF1021")) {
            return;
        }
        
        MTF1020.isMaster = 2;
        var data = MTF1020.postDataMaster();
        ASOFT.helper.post(MTF1020.urlUpdate, data, MTF1020.MTF1021Save_Success);
    };
    
    //Lưu và đóng
    this.btnSaveMTF1021_Click = function() {
        //Validate form
        if (ASOFT.form.checkRequired("MTF1021")) {
            return;
        }
        MTF1020.isMaster = 1;
        var data = MTF1020.postDataMaster();
        ASOFT.helper.post(MTF1020.urlUpdate, data, MTF1020.MTF1021Save_Success);
    };

    //Hiển thị các dòng được chọn
    this.btnShowRecord_Click = function() {
        MTF1020.showHideRecords(0);
    };

    this.MTF1021Save_Success = function(result) {

        ASOFT.helper.showErrorSeverOption(0, result, "MTF1021", function() {
            var data = [];
            data.push({ name: "SchoolTimeID", value: result.Data });
            if (MTF1020.isMaster == 1 || MTF1020.isMaster == 3) {
                MTF1020.MTF1021Popup.close();
                if (MTF1020.gridMaster) {
                    MTF1020.gridMaster.dataSource.page(1);
                } else {
                    var postUrl = $('#UrlMTF1022M').val();
                    ASOFT.helper.post(postUrl, data, function(html) {
                        $('#ViewMaster').html(html);
                    });
                }
            } else if (MTF1020.isMaster == 2) {
                var redirectUrl = $('#UrlMTF1022').val();
                window.location.href = redirectUrl + "?schoolTimeID=" + result.Data;
            }
        }, null, null, true);
    };

    this.btnClose_Click = function() {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016' /*'A00ML000001'*/), MTF1020.btnSaveMTF1021_Click, function () {
            MTF1020.MTF1021Popup.close();
        });
    };

    //Ẩn các dòng được chọn
    this.btnHideRecord_Click = function() {
        MTF1020.showHideRecords(1);
    };

    this.showHideRecords = function(disabled) {
        var args = [];
        var records = ASOFT.asoftGrid.selectedRecords(MTF1020.gridMaster, "FormFilter");
        if (records.length == 0) return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].SchoolTimeID);
        }

        var url = $("#UrlUpdateRecord").val();
        var data = {
            args: args,
            disabled: disabled
        };

        ASOFT.helper.postTypeJson(url, data, function(result) {
            if (result.Status == 0) {
                MTF1020.gridMaster.dataSource.page(1);
            }
        });
    };

    this.checkInList = function() {
        ASOFT.form.checkItemInListFor(this, "MTF1023");
    };

    //Sửa master 
    this.btnEditMTF1021_Click = function() {
        MTF1020.formStatus = 2;
        MTF1020.isMaster = 3;
        MTF1020.urlUpdate = $('#UrlUpdate').val();
        MTF1020.schoolTimeID = $('input[name="SchoolTime"]').val();
        var popup = MTF1020.MTF1021Popup;
        var postUrl = $('#UrlMTF1021').val();
        var data = {
            SchoolTimeID: MTF1020.schoolTimeID,
            FormStatus: MTF1020.formStatus
        };
        MTF1020.showPopup(popup, postUrl, data);
    };
    
    //=============================================================================
    // Màn hình xem chi tiết danh mục giờ học - MTF1022
    //=============================================================================
    //Grid detail callback
    this.MTF1022Grid_CallBack = function() {
        MTF1020.schoolTimeID = $('input[name="SchoolTime"]').val();
        var data = { schoolTimeID: MTF1020.schoolTimeID };
        return data;
    };
    
    //Lấy dữ liệu từ form
    this.postDataDetails = function() {
        //Lấy dữ liệu từ form post lên
        MTF1020.schoolTimeID = $('input[name="SchoolTime"]').val();
        var data = ASOFT.helper.getFormData(null, "MTF1023");
        var record = ASOFT.asoftGrid.selectedRecord(MTF1020.gridDetails);
        var apk = (record == undefined || MTF1020.formStatus == 1) ? null : record.APK;
        data.push({ name: "APK", value: apk });
        data.unshift({ name: "schoolTimeID", value: MTF1020.schoolTimeID });
        return data;
    };
    
    //Xóa 
    this.btnDeleteDetails_Click = function() {
        var urlDelete = $('#UrlDeleteDetail').val();
        var args = [];
        if (MTF1020.gridDetails) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(MTF1020.gridDetails, "MTF1022Grid");
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].APK);
            }
        }

        // Lấy đối tượng hiện tại nếu đang ở màn hình details
        var schoolTimeId = $('input[name="SchoolTime"]').val();

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*'A00ML000002'*/), function () {
            var data = {
                args: args,
                schoolTimeID: schoolTimeId
            };
            ASOFT.helper.postTypeJson(urlDelete, data, MTF1020.deleteDetailsSuccess);

        });

    };

    this.deleteDetailsSuccess = function (result) {
        ASOFT.helper.showErrorSeverOption(1, result, "MTF1022Grid", function() {
            MTF1020.gridDetails.dataSource.page(1);
        }, null, null, true);
    };
    
    //=============================================================================
    // Màn hình cập nhật chi tiết danh mục giờ học - MTF1023
    //=============================================================================
    this.btnAddNewDetails_Click = function() {
        MTF1020.addNewDetails();
    };

    // Add new details
    this.addNewDetails = function () {
        MTF1020.formStatus = 1;
        MTF1020.urlUpdateDetail = $('#UrlInsertDetail').val();
        var popup = MTF1020.MTF1023Popup;
        MTF1020.schoolTimeID = $('input[name="SchoolTime"]').val();
        var data = {
            SchoolTimeID: MTF1020.schoolTimeID,
            APK: null,
            FormStatus: MTF1020.formStatus
        };
        var postUrl = $('#UrlMTF1023').val();
        MTF1020.showPopup(popup, postUrl, data);
    };
    

    // Add new details and copy
    this.addNewDetailsCopy = function(savedKey) {
        MTF1020.formStatus = 1;
        MTF1020.urlUpdateDetail = $('#UrlInsertDetail').val();
        var popup = MTF1020.MTF1023Popup;
        MTF1020.schoolTimeID = $('input[name="SchoolTime"]').val();
        var data = {
            SchoolTimeID: MTF1020.schoolTimeID,
            APK: savedKey,
            FormStatus: MTF1020.formStatus
        };
        var postUrl = $('#UrlMTF1023').val();
        MTF1020.showPopup(popup, postUrl, data);
    };

    //Edit detail
    this.btnEditDetails_Click = function() {
        MTF1020.formStatus = 2;
        MTF1020.urlUpdateDetail = $('#UrlUpdateDetail').val();
        var popup = MTF1020.MTF1023Popup;
        MTF1020.schoolTimeID = $('input[name="SchoolTime"]').val();

        var record = ASOFT.asoftGrid.selectedRecord(MTF1020.gridDetails);
        if (record) {
            var data = {
                SchoolTimeID: MTF1020.schoolTimeID,
                APK: record.APK,
                FormStatus: MTF1020.formStatus
            };
            var postUrl = $('#UrlMTF1023').val();
            MTF1020.showPopup(popup, postUrl, data);
        }

    };

    //Lưu và nhập tiếp
    this.btnSaveNewMTF1023_Click = function() {
        MTF1020.saveActionType = 1;
        //Validate form
        MTF1020.saveDetailsData();
    };

    //Lưu và copy
    this.btnSaveCopyMTF1023_Click = function() {
        MTF1020.saveActionType = 2;
        //Validate form
        MTF1020.saveDetailsData();
    };

    this.saveDetailsClose = function() {
        MTF1020.saveActionType = 3;
        MTF1020.saveDetailsData();
    };

    this.btnSaveMTF1023_Click = function() {
        MTF1020.saveDetailsClose();
    };

    this.saveDetailsData = function() {
        if (ASOFT.form.checkRequiredAndInList("MTF1023", ['DayID'])) {
            return;
        }
        var data = MTF1020.postDataDetails();
        MTF1020.urlUpdateDetail = (MTF1020.formStatus == 1) ? $('#UrlInsertDetail').val() : $('#UrlUpdateDetail').val();
        ASOFT.helper.post(MTF1020.urlUpdateDetail, data, MTF1020.detailsSaveSuccess);
    };

    this.detailsSaveSuccess = function(result) {

        // Save status form
        ASOFT.form.updateSaveStatusOption('MTF1023', result, true /*Skip param - none display param from message*/);
        ASOFT.helper.showErrorSeverOption(0, result, "MTF1023", function() {
            // Chuyển hướng xử lý nghiệp vụ
            switch (MTF1020.saveActionType) {
            case 1:
                // Trường hợp lưu & nhập tiếp
                MTF1020.addNewDetails();
                break;
            case 2:
                // Trường hợp lưu & sao chép
                MTF1020.addNewDetailsCopy(result.Data);
                break;
            default:
                MTF1020.MTF1023Popup.close();
                break;
            }

            // Refresh data
            if (MTF1020.gridDetails) {
                MTF1020.gridDetails.dataSource.page(1);
            }
        }, null, null, true);

    };

    // Đóng form details
    this.btnCloseDeltails_Click = function() {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016' /*'A00ML000001'*/), MTF1020.saveDetailsClose, function () {
            MTF1020.MTF1023Popup.close();
        });
    };

};



