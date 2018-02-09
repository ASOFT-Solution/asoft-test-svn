//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     17/02/2014      Đức Quý         Tạo mới
//#     02/04/2014      Trí Thiện       Format code JS to namespace function
//####################################################################

$(document).ready(function() {
    MTF1040.MTF1041Popup = ASOFT.asoftPopup.castName("MTF1041Popup");
    MTF1040.MTF1043Popup = ASOFT.asoftPopup.castName("MTF1043Popup");

    MTF1040.MTF1040Grid = $("#MTF1040GridMaster").data("kendoGrid");
    MTF1040.MTF1042Grid = $("#MTF1042Grid").data("kendoGrid");

    ASOFT.helper.showErrorSeverOptionFromRedirecting();

    //Bắt sự kiện khi popup đã hiện lên tất cả nội dung
    MTF1040.MTF1041Popup.bind("refresh", function() {
        $("#ClassID").bind('keypress', function (e) {
            ASOFTTextBox.escapeSpecialCharacter(e);
        });
    });

    if (MTF1040.MTF1042Grid) {
        ASOFT.asoftGrid.setHeight(MTF1040.MTF1042Grid);
        ASOFT.helper.setAutoHeight($('.asf-panel-view-master-detail'));
    }

});

$(window).resize(function() {
    if (MTF1040.MTF1040Grid) {
        ASOFT.asoftGrid.setHeight(MTF1040.MTF1040Grid);
    }

    if (MTF1040.MTF1042Grid) {
        ASOFT.asoftGrid.setHeight(MTF1040.MTF1042Grid);
        ASOFT.helper.setAutoHeight($('.asf-panel-view-master-detail'));
    }
});

MTF1040 = new function() {

    // Properties
    this.formStatus = null; // 1: SaveNext, 2: SaveCopy, 3: SaveClose
    this.saveActionType = null;
    this.urlUpdate = null;
    this.isSearch = false;
    this.allowSaving = true; //biến kiểm tra xem được phép lưu không
    this.previousPrefix = null;
    
    // Objects
    this.MTF1040Grid = null;
    this.MTF1041Popup = null;
    this.MTF1043Popup = null;
    this.MTF1042Grid = null;
    
    // Show popup
    this.showPopup = function (popup, url, data) {
        ASOFT.asoftPopup.show(popup, url, data);
        ASOFT.form.clearMessageBox();
    };
    
    /********************FORM FILTER*********************/
    // Filter form
    this.filterData = function () {
        ASOFT.form.clearMessageBox();
        MTF1040.isSearch = true;
        MTF1040.MTF1040Grid.dataSource.page(1);
    };
    // Clear filter form data
    this.clearFilterData = function () {
        ASOFT.form.clearMessageBox();
        MTF1040.isSearch = false;
        $("#FormFilter input").val('');
        MTF1040.MTF1040Grid.dataSource.page(1);
    };

    /********************FORM FILTER*********************/
    
    /********************GRID MASTER*********************/
    //Send data grid
    this.sendFilter = function() {
        var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
        datamaster['IsSearch'] = MTF1040.isSearch;
        return datamaster;
    };

    //Xóa lop hoc
    this.deleted = function() {
        var postUrl = $('#UrlMTF1040Delete').val();
        var args = [];
        var data = { };
        if (MTF1040.MTF1040Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(MTF1040.MTF1040Grid, 'FormFilter');
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].ClassID);
            }
        } else {
            // Lấy đối tượng hiện tại nếu đang ở màn hình details
            var classId = $('#ClassID').val();
            args.push(classId);
        }

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*'A00ML000002'*/), function() {
            data['args'] = args;
            ASOFT.helper.postTypeJson(postUrl, data, MTF1040.deleteSuccess);
        });
    };

    //Kết quả server trả về sau khi xóa lớp học
    this.deleteSuccess = function (result) {
        var formId = null;
        var displayOnRedirecting = null;
        if (document.getElementById('FormFilter')) {
            formId = "FormFilter";
            displayOnRedirecting = false;
        } else if (document.getElementById('mtf1042-viewmastercontent')) {
            formId = "mtf1042-viewmastercontent";
            displayOnRedirecting = true;
        }

        ASOFT.helper.showErrorSeverOption(1, result, formId, function () {
            var redirectUrl = $('#UrlMTF1040').val();
            // Chuyển hướng hoặc refresh data
            if (redirectUrl != null) {
                window.location.href = redirectUrl;// redirect index
            }
        }, null, null, true, displayOnRedirecting, "FormFilter");

        if (MTF1040.MTF1040Grid != null || MTF1040.MTF1040Grid != undefined) {
            MTF1040.MTF1040Grid.dataSource.page(1);
        }
    };

    //Hiển thị các dòng được chọn
    this.btnShowRecord_Click = function() {
        MTF1040.showHideRecord(0);
    };

    //Ẩn các dòng được chọn
    this.btnHideRecord_Click = function() {
        MTF1040.showHideRecord(1);
    };

    // Show hide records
    this.showHideRecord = function(disabled) {
        var args = [];
        var records = ASOFT.asoftGrid.selectedRecords(MTF1040.MTF1040Grid, 'FormFilter');
        if (records.length == 0) return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].ClassID);
        }

        var url = $("#UrlUpdateRecord").val();
        var data = {
            args: args,
            disabled: disabled
        };

        ASOFT.helper.postTypeJson(url, data, function(result) {
            if (result.success) {
                MTF1040.MTF1040Grid.dataSource.page(1);
            }
        });
    };
    
    /********************GRID MASTER*********************/

    /********************FORM MASTER*********************/
    // Add new
    this.addNew = function() {
        MTF1040.formStatus = 1;
        MTF1040.urlUpdate = $("#UrlMTF1041Insert").val();
        var urlMtf1041 = $('#UrlMTF1041').val();
        var data = {
            FormStatus: MTF1040.formStatus
        };
        MTF1040.showPopup(MTF1040.MTF1041Popup, urlMtf1041, data);
    };

    // Read form data
    this.getFormData = function() {
        //Lấy dữ liệu từ form post lên
        var data = ASOFT.helper.getFormData(null, "MTF1041");
        var cboSClassify = ASOFT.asoftComboBox.castName("S");
        if (cboSClassify) {
            data.unshift({ name: "S", value: cboSClassify.value() });
        }
        return data;
    };

    // Save
    this.saveData = function() {
        // Kiểm tra hợp lệ
        if (ASOFT.form.checkRequiredAndInList("MTF1041", ["S", "LevelID", "CourseID", "SchoolTimeID"])) {
            return;
        }

        // Lấy dữ liệu trên form
        var data = MTF1040.getFormData();

        // Post data
        ASOFT.helper.post(MTF1040.urlUpdate, data, MTF1040.saveSuccess);
    };
    
    //Save thong tin lop hoc
    this.saveSuccess = function (result) {
        //ASOFT.form.updateSaveStatusOption("MTF1041", result);
        
        ASOFT.helper.showErrorSeverOption(0, result, 'MTF1041', function () {
            // Chuyển hướng xử lý nghiệp vụ
            switch (MTF1040.saveActionType) {
                case 1:
                    // Trường hợp lưu & đóng popup
                    MTF1040.MTF1041Popup.close();
                    break;
                case 2:
                    // Trường hợp lưu & chuyển sang màn hình nhập chi tiết
                    var redirectUrl = $('#UrlMTF1042').val();

                    window.location.href = redirectUrl + "/?ClassID=" + result.Data;
                    //MTF1040.showPopup(MTF1041Popup, urlMTF1043, result.Data);
                    break;
                case 3:
                    // Trường hợp lưu và đóng
                    MTF1040.MTF1041Popup.close();
                    break;
                default:
                    break;
            }
            if (MTF1040.MTF1040Grid) {
                MTF1040.MTF1040Grid.dataSource.page(1); // refresh grid
            } else {
                window.location.reload(true);
            }
        }, null, null, true);
    };

    // Close form
    this.btnCloseClick = function() {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016' /*'A00ML000001'*/),
            MTF1040.btnSaveCloseClick, MTF1040.closePopup);
    };
    
    //Lưu và đóng
    this.btnSaveCloseClick = function() {
        MTF1040.saveActionType = 3;
        MTF1040.saveData();
    };

    //Đóng popup
    this.closePopup = function() {
        if (MTF1040.MTF1041Popup) {
            MTF1040.MTF1041Popup.close();
        }
        if (MTF1040.MTF1043Popup) {
            MTF1040.MTF1043Popup.close();
        }
    };
    
    //Lưu và nhập chi tiết
    this.btnSaveDetails = function() {
        MTF1040.saveActionType = 2;
        MTF1040.saveData();
    };

    //Lưu và đóng popup
    this.btnSaveClick = function() {
        MTF1040.saveActionType = 1;
        MTF1040.saveData();
    };

    // Update
    this.btnEditMTF1042_Click = function() {
        MTF1040.formStatus = 2;
        MTF1040.urlUpdate = $('#UrlMTF1041Update').val();
        var classId = $('input[name="ClassID"]').val();
        var popup = MTF1040.MTF1041Popup;
        var postUrl = $('#UrlMTF1041').val();
        var data = {
            ClassID: classId,
            FormStatus: MTF1040.formStatus
        };
        MTF1040.showPopup(popup, postUrl, data);
    };

    this.s_PostData = function() {
        return {
            //FromS: 'A01',
            //ToS: 'A99'
            FromS: null,
            ToS: null
        };
    };
    // Combobox phân loại changed
    this.s_Changed = function() {
        ASOFT.form.checkItemInListFor(this, "MTF1041");

        var dataItem = this.dataItem(this.selectedIndex);
        if (dataItem == null) {
            MTF1040.previousPrefix = null;
            return;
        }

        // Append contents
        var prefix = dataItem.S;
        var input = $('input#ClassID');
        if (input.val() == null || input.val() == "") {
            input.val(prefix);
        } else {
            input.val(input.val().replace(MTF1040.previousPrefix, prefix));
        }

        // Save prefix
        MTF1040.previousPrefix = prefix;

        MTF1040.bindPrefixClass(prefix);
    };

    // add prefix to textbox class
    this.bindPrefixClass = function(prefix) {
        var input = $('input#ClassID');

        // update events blur to check input
        input.unbind("blur");
        input.blur(function () {
            // Check match prefix
            if (!(this.value.match('^' + prefix))) {
                this.value = prefix + this.value;
            }
        });
    };

    // Check in list
    this.checkDataCombobox = function() {
        ASOFT.form.checkItemInListFor(this, "MTF1041");
    };
    
    /********************FORM MASTER*********************/

    /********************GRID DETAILS*********************/
    // send data filter grid
    this.gridClassDetail_callback = function () {
        var classid = $('#ClassID').val();
        var data = { ClassID: classid };
        return data;
    };

    //Xoa giao vien
    this.deleteTeacher = function() {
        var postUrl = $('#UrlMTF1042DeleteTeacher').val();
        var args = [];
        var data = { };
        if (MTF1040.MTF1042Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(MTF1040.MTF1042Grid, 'MTF1042Tab-1');
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].TeacherID);
            }
        }

        // Lấy đối tượng hiện tại nếu đang ở màn hình details
        var classId = $('#ClassID').val();
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*'A00ML000002'*/), function() {
            data['args'] = args;
            data['ClassID'] = classId;
            ASOFT.helper.postTypeJson(postUrl, data, MTF1040.deleteSuccessTeacher);
        });
    };

    //Kết quả server trả về sau khi xóa
    this.deleteSuccessTeacher = function(result) {
        ASOFT.helper.showErrorSeverOption(1, result, 'MTF1042Tab-1', function () {
            if (MTF1040.MTF1042Grid != null || MTF1040.MTF1042Grid != undefined) {
                MTF1040.MTF1042Grid.dataSource.read();
            }
        }, null, null, true);
    };

    /********************GRID DETAILS*********************/

    /********************FORM DETAILS*********************/
    // Read form data teacher
    this.getFormDataTeacher = function() {
        //Lấy dữ liệu từ form post lên
        var data = ASOFT.helper.getFormData(null, "MTF1043");
        return data;
    };

    // Save
    this.saveDataTeacher = function() {
        // Kiểm tra hợp lệ
        if (ASOFT.form.checkRequiredAndInList("MTF1043", ["TeacherID"])) {
            return;
        }

        //Kiểm tra ngày bắt đầu và ngày kết thúc
        var beginDate = ASOFT.asoftDateEdit.castName("BeginDate");
        var endDate = ASOFT.asoftDateEdit.castName("EndDate");

        if (beginDate.value() > endDate.value()) {
             var message = [ASOFT.helper.getMessage('HFML000290')];
            ASOFT.form.displayMessageBox("form#MTF1043", message, null);
            return;
        }

        // Lấy dữ liệu trên form
        var data = MTF1040.getFormDataTeacher();

        // Post data
        ASOFT.helper.post(MTF1040.urlUpdate, data, MTF1040.SaveSuccessTeacher);
    };

    // Save teacher success
    this.SaveSuccessTeacher = function (result) {
        ASOFT.form.updateSaveStatusOption('MTF1043', result);
        ASOFT.helper.showErrorSeverOption(0, result, 'MTF1043', function () {
            // Chuyển hướng xử lý nghiệp vụ
            switch (MTF1040.saveActionType) {
                case 1: // Trường hợp lưu & nhập tiếp
                    MTF1040.addNewTeacher();
                    break;
                case 2: // Trường hợp lưu & sao chép
                    MTF1040.addNewTeacherCopy(
                        {
                            ClassID: $("#ClassID").val(),
                            TeacherID: result.Data
                        }
                    );
                    break;
                case 3: // Trường hợp lưu và đóng
                    MTF1040.MTF1043Popup.close();
                    break;
                default:
                    break;
            }
            if (MTF1040.MTF1042Grid) {
                MTF1040.MTF1042Grid.dataSource.read(); // refresh grid
            }
        }, null, null, true);
    };

    // Add new teacher
    this.addNewTeacher = function() {
        MTF1040.formStatus = 1;
        var classId = $('input[name="ClassID"]').val();
        var beginDate = $('input[name="Begin"]').val();
        var endDate = $('input[name="End"]').val();
        MTF1040.urlUpdate = $("#UrlMTF1043Insert").val();
        var urlMtf1043 = $('#UrlMTF1043').val();
        var data = {
            ClassID: classId,
            BeginDate: beginDate,
            EndDate: endDate,
            FormStatus: MTF1040.formStatus
        };
        MTF1040.showPopup(MTF1040.MTF1043Popup, urlMtf1043, data);
    };

    // Add new and copy previous objects
    this.addNewTeacherCopy = function(savedKey) {
        MTF1040.formStatus = 1;
        MTF1040.urlUpdate = $("#UrlMTF1043Insert").val();
        var urlMtf1043 = $('#UrlMTF1043').val();

        var data = {
            ClassID: savedKey.ClassID,
            FormStatus: MTF1040.formStatus,
            TeacherID: savedKey.TeacherID
        };
        MTF1040.showPopup(MTF1040.MTF1043Popup, urlMtf1043, data);
    };

    // close form
    this.btnCloseTeacherClick = function() {
        ASOFT.dialog.confirmDialog(
            ASOFT.helper.getMessage('00ML000016' /*'A00ML000001'*/),
            MTF1040.btnSaveCloseTeacherClick,
            MTF1040.closePopup
        );
    };

    // Save copy
    this.btnSaveCopyTeacherClick = function() {
        MTF1040.saveActionType = 2;
        MTF1040.saveDataTeacher();
    };

    // Save and next
    this.btnSaveTeacherClick = function() {
        MTF1040.saveActionType = 1;
        MTF1040.saveDataTeacher();
    };

    // Save and close
    this.btnSaveCloseTeacherClick = function() {
        MTF1040.saveActionType = 3;
        MTF1040.saveDataTeacher();
    };

    // Edit teacher grid
    this.btnEditGridTeacher_Click = function() {
        MTF1040.formStatus = 2;
        var classId = $('input[name="ClassID"]').val();
        MTF1040.urlUpdate = $("#UrlMTF1042UpdateTeacher").val();
        var urlMtf1043 = $('#UrlMTF1043').val();
        var mtf1042Grid = ASOFT.asoftGrid.selectedRecord(MTF1040.MTF1042Grid);

        var data = {
            ClassID: classId,
            FormStatus: MTF1040.formStatus,
            TeacherID: mtf1042Grid.TeacherID
        };
        MTF1040.showPopup(MTF1040.MTF1043Popup, urlMtf1043, data);
    };

    // Check in list
    this.checkDataTeacherID = function() {
        ASOFT.form.checkItemInListFor(this, "MTF1043");
    };
    
    /********************FORM DETAILS*********************/
    
};