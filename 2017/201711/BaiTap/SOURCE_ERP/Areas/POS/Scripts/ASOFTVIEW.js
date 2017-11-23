
//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/06/2014      Thai Son        Update
//####################################################################

// ============================== PRIMARY ==================================
// Object chung cho các màn hình thiết lập
var ASOFTVIEW = (function (view) {
    // phần đuôi của ID trong các control kendo
    var KENDO_INPUT_SUFFIX = '_input';
    // Đối tượng chứa trạng thái(ban đầu) của form
    var defaultViewModel = null;
    // Gán các sự kiện ban đầu cho các control
    var initEvents = function () {
        console.log('init Event');
    };
    // Cập nhật lại trạng thái mới của form
    var refreshModel = function () {
        console.log('refreshModel');
        defaultViewModel = getFormData();
    };
    // Khơi tạo giá trị cho các biến
    var initData = function () {
        refreshModel();
    };
    // Kiểm tra biến truyền vào là một array
    var isArray = function (obj) {
        return obj && Object.prototype.toString.call(obj) === '[object Array]';
    };
    // Kiểm tra biến truyền vào là một function
    var isFunction = function (obj) {
        return obj && Object.prototype.toString.call(obj) == '[object Function]';
    }
    // Kiểm tra dữ liệu trên form có bị thay đổi hay không
    var isDataChanged = function () {
        var dataPost = getFormData();
        var equal = isRelativeEqual(dataPost, defaultViewModel);
        return !equal;
    };

    // Kiểm tra bằng nhau giữa hai trạng thái của form
    var isRelativeEqual = function (data1, data2) {
        if (data1 && data2
            && typeof data1 === "object"
            && typeof data2 === "object") {
            for (var prop in data1) {
                // So sánh thuộc tính của 2 data
                if (!data2.hasOwnProperty(prop)) {
                    return false;
                }
                else {
                    if (prop.indexOf(KENDO_INPUT_SUFFIX) != -1) {
                        continue;
                    }
                    // Nếu giá trị hai thuộc tính không bằng nhau, thì data có khác biệt
                    if (data1[prop].valueOf() != data2[prop].valueOf()) {
                        return false;
                    }
                }
            }
            return true;
        }
        return undefined;
    };

    // Kiểm tra form có hợp lệ hay không?
    var isDataValid = function () {
        var isInvalid = ASOFT.form.checkRequiredAndInList(
            configAttrs.formName,
            configAttrs.allComboboxIDs);

        if (isInvalid) {
            return false;
        }

        var additionalFailedCheck = false;
        var checkers = configAttrs.additionalDataInvalidCheckers;


        if (isArray(checkers)) {
            for (var i = 0; i < checkers.length; i++) {
                var checker = checkers[i];
                if (isFunction(checker)) {
                    additionalFailedCheck = additionalFailedCheck || checker();
                    //debugger
                    if (additionalFailedCheck && configAttrs.breakOnFirstFailedCheck) break
                }
            }
        }
        return !additionalFailedCheck;
    };

    var formWidgets = [];

    // Đóng cửa sổ
    var closeWindow = ASOFT.asoftPopup.closeOnly;

    // Xứ lý Sự kiện đóng, theo luồng thông thường
    // (Cụ thể là nếu dữ liệu có thay đổi thì hỏi có lưu hay không)
    var close = function () {
        if (remoteComboboxCount > 0) {
            closeWindow();
        }
        if (isDataChanged()) {
            ASOFT.dialog.confirmDialog(
                ASOFT.helper.getMessage('00ML000016'),
                //yes
                function () {
                    save();
                    //closeWindow();
                },
                //no
                function () {
                    closeWindow();
                });
        } else {
            //Close popup
            closeWindow();
        }
    };

    // Xử lý khi người dùng ấn nút lưu
    var save = function () {
        if (remoteComboboxCount > 0) {
            return false;
        }
        if (!isDataValid()) {
            return false;
        }

        ASOFT.helper.postTypeJson(
            configAttrs.urlSave,
            getFormData(),
            handleSuccess);
    };

    // Xử lý sau khi nhận dữ liệu từ server
    // result: Dữ liệu nhận được từ server (Định dạng JSON theo ErrorMsgModel)
    var handleSuccess = function (result) {
        if (result.Status === 0) {
            ASOFT.form.clearMessageBox();

            result.Message = result.Message ? result.Message : result.MessageID;
            result.MessageID = result.MessageID ? result.MessageID : result.Message;

            ASOFT.form.displayInfo(
                configAttrs.formID,
                ASOFT.helper.getMessage(result.Message));

            if (configAttrs.hasLastModifyDate) {
                if (result.Data.LastModifyDateTicks) {
                    $('#LastModifyDateTicks').attr('value', result.Data.LastModifyDateTicks);
                }
            }
            // Cập nhật lại model (để so sánh khi kiểm tra thay đổi)
            refreshModel();

        } else {
            ASOFT.form.clearMessageBox();
            var messageBoxParameter = configAttrs.getMessageParameter(result);
            ASOFT.form.displayWarning(
                configAttrs.formID,
                ASOFT.helper.getMessage(result.Message).format(messageBoxParameter));
        }

        if (configAttrs.additionalAfterSaveHandlers
            && isArray(configAttrs.additionalAfterSaveHandlers)) {
            for (var i = 0; i < configAttrs.additionalAfterSaveHandlers.length; i++) {
                var handler = configAttrs.additionalAfterSaveHandlers[i];
                if (isFunction(handler)) handler(result);
            }
        }
    }

    // TODO: Reset form widget
    var reset = function () {

    }

    // Lấy dữ liệu từ form, trả về đối tượng JS
    var getFormData = function () {
        var dataPost = ASOFT.helper.dataFormToJSON(configAttrs.formName);
        if (isFunction(configAttrs.additionalData)) {
            var additionalData = configAttrs.additionalData();
            for (var attrname in additionalData) {
                dataPost[attrname] = additionalData[attrname];
            }
        }
        return dataPost;
    };

    var remoteComboboxCount = 0;

    // Đối tượng chứa các tham số của màn hình hiện tại
    var configAttrs = {
        formName: "",
        formID: "",
        urlSave: "",
        additionalData: function () { return {}; },
        remoteDataComboboxIDs: [],
        allComboboxIDs: [],
        hasLastModifyDate: false,
        additionalChangeDetectors: [],
        additionalAfterSaveHandlers: [],
        additionalDataInvalidCheckers: [],
        breakOnFirstFailedCheck: false,
        getMessageParameter: function () { return "" },
        excludeKendoInputTextWidget: false

    }

    // Cấu hình cho màn hình hiện tại
    view.config = function (attrs) {
        //debugger
        if (attrs && typeof attrs == "object") {
            for (var prop in attrs) {
                // Những thuộc tính nào có khai báo 
                // thì gán vào đối tượng configAttrs
                if (configAttrs.hasOwnProperty(prop)) {
                    configAttrs[prop] = attrs[prop];
                }
            }
        }

        remoteComboboxCount = configAttrs.remoteDataComboboxIDs.length;
        applyConfig();
    }

    // Áp dụng các thiết lập lên các đối tượng của màn hình
    var applyConfig = function () {
        if (remoteComboboxCount === 0) {
            refreshModel();
        }
        else {
            // Gán sự kiện nhân được dữ liệu cho các combobox remote
            for (var i = 0; i < remoteComboboxCount; i++) {
                var comboboxID = configAttrs.remoteDataComboboxIDs[i];
                var kComboBox = $("#" + comboboxID).data("kendoComboBox");

                var tryRefreshViewModel = function () {
                    remoteComboboxCount--
                    if (remoteComboboxCount == 0) {
                        refreshModel();
                    }
                }
                kComboBox.bind("dataBound", tryRefreshViewModel);
            }
        }
    }

    // Xử lý khi click nút đóng, chỉ đóng form, không kiểm tra gì khác
    view.btnCloseOnly_Click = function () {
        closeWindow();
    };
    // Xứ lý Sự kiện đóng, theo luồng thông thường
    // (Cụ thể là nếu dữ liệu có thay đổi thì hỏi có lưu hay không)
    view.btnClose_Click = function () {
        close();
    };

    // Sự kiện ấn nút lưu
    view.btnSave_Click = function () {
        //console.log('btnSave_Click');
        //console.log(this);
        save();
    };

    view.closeOnly = ASOFT.asoftPopup.closeOnly;


    return view;
}(ASOFTVIEW || {}));


// ============================== HELPERS ==================================
var ASOFTVIEW = (function (view) {
    view.helpers = (function (helpers) {
        // Kiểm tra một chuỗi truyền vào có giá trị hay không
        helpers.isNullEmptyWhiteSpace = function (val) {
            return (val === undefined
                || val == null
                || val.length <= 0
                || val.match(/^ *$/) !== null);
        };

        // Kiểm tra biến truyền vào là một array
        helpers.isArray = function (obj) {
            return obj && Object.prototype.toString.call(obj) === '[object Array]';
        };

        // Kiểm tra biến truyền vào là một function
        helpers.isFunction = function (obj) {
            return obj && Object.prototype.toString.call(obj) == '[object Function]';
        };

        // Thêm số 0 vào phía trước số nguyên cho đủ chiều dài quy định
        helpers.prefixInteger = function (num, length) {
            //return ("0000000000000000" + num).substr(-length);
            return (Array(length).join('0') + num).slice(-length);
        }

        return helpers;
    })(view.helpers || {});
    return view;

}(ASOFTVIEW || {}));


// ============================ INTERFACE EVENT ============================
var ASOFTVIEW = (function (view) {



    return view;
}(ASOFTVIEW || {}));
