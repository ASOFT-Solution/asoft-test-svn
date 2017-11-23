//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/02/2014      Minh Lâm         Tạo mới
//#     04/04/2014      Đam Mơ           Update
//#     12/06/2014      Đam Mơ           Update
//####################################################################

$(document).ready(function () {
    // Shortcut cho các helper của ASOFTVIEW
    var helper = ASOFTVIEW.helpers;
    // Mã form (Lấy theo CSS id)
    var FORM_ID = '#POSF0002';
    // Tên form
    var FORM_NAME = 'POSF0002';
    // Danh sách ID (không #) của các combobox trên màn hình
    var comboBoxIDs = [
        'VoucherType01',
     'VoucherType02',
     'VoucherType03',
     //'VoucherType04',
     'VoucherType05',
     'VoucherType06',
     'VoucherType07',
     'VoucherType08',
     'VoucherType09',
     'VoucherType10',
     'VoucherType11',
     'VoucherType12',
     'VoucherType13'
    ];

    // Xử lý sau khi lưu 
    var afterSaveHandler = function (result) {
        if (result && result.Status != 0) {
            // Xóa các thông báo hiện có
            ASOFT.form.clearMessageBox();
            // Tạo mản chức các giá trị "distinct"
            //  của danh sách mã phiếu nhận được từ server
            var a = [];
            if (result.Data && result.Data.TypesSelected) {
                a = result.Data.TypesSelected.concat();
            }
            for (var i = 0; i < a.length; ++i) {
                for (var j = i + 1; j < a.length; ++j) {
                    if (a[i] === a[j])
                        a.splice(j--, 1);
                }
            }
            var resultData = a;

            // Kết chuỗi các mã phiếu vừa lấy ra, để hiện thông báo lỗi
            var joined = resultData.filter(function (val) { return val !== null; }).join(", ");
            ASOFT.form.displayWarning(FORM_ID,
                ASOFT.helper.getMessage(result.MessageID).format(joined));

            // So sánh từng giá trị trên form và từng giá trị nhận được từ server
            // Để đánh dấu các combox không sửa được
            if (result.Data && result.Data.TypesSelected) {
                var typesSelected = result.Data.TypesSelected;
                var data = ASOFT.helper.dataFormToJSON(FORM_NAME);
                for (var i = 1; i < typesSelected.length; i++) {
                    var itemName = 'VoucherType' + helper.prefixInteger(i, 2);
                    if (typesSelected[i]
                        && data[itemName] != result.Data[i]) {
                        var combo = ASOFT.asoftComboBox.castName(itemName);
                        combo.value(typesSelected[i]);
                        highlightElement("#" + itemName);
                    }
                }
            }
        }
    }

    // Dánh dấu các combobox bị lỗi (do trùng hoặc không sửa được)
    var highlightElement = function (id) {
        var element = $(id);
        if (!element) return;
        var fromWidget = element.closest(".k-widget");
        var widgetElement = element.closest("[data-" + kendo.ns + "role]");
        var widgetObject = kendo.widgetInstance(widgetElement);

        if (widgetObject != undefined && widgetObject.options.name != "TabStrip") {
            fromWidget.addClass('asf-focus-input-error');
            var input = fromWidget.find(">:first-child").find(">:first-child");
            $(input).addClass('asf-focus-combobox-input-error');
        } else {
            element.addClass('asf-focus-input-error');
        }
    }

    var hasDuplicate = function () {
        //debugger
        for (var i = 0, l = comboBoxIDs.length; i < l - 1; i++) {
            for (var j = i+1; j < l; j++) {
                var combo1 = $('#' + comboBoxIDs[i]).data('kendoComboBox');
                var combo2 = $('#' + comboBoxIDs[j]).data('kendoComboBox');

                if (combo1 && combo1
                    && combo1.value() == combo2.value()) {
                    highlightElement('#' + comboBoxIDs[i]);
                    highlightElement('#' + comboBoxIDs[j]);
                    ASOFT.form.displayWarning(FORM_ID, ASOFT.helper.getMessage('POSM000035'));
                    return true;
                }
            }
        }
        return false;
    }

    var hasSomethingElse = function () {
        //debugger
        return false;
    }

    ASOFTVIEW.config(
       {
           // URL để lưu/update dữ liệu
           urlSave: '/POS/POSF0002/Save',
           // Mã form (Lấy theo CSS id)
           formID: FORM_ID,
           // Tên form
           formName: FORM_NAME,
           // Các hàm khác để kiểm tra thay đổi của form
           //additionalChangeDetectors: [],
           // Các dữ liệu mà hàm ASOFT.helper.dataFormToJSON không lấy được như ý muốn
           additionalData: {},
           // Tên (không có dấu #), của các combobox
           remoteDataComboboxIDs: [],
           // Các hàm cần thực thi sau khi lưu dữ liệu
           additionalAfterSaveHandlers: [afterSaveHandler],

           hasLastModifyDate: true,

           allComboboxIDs: comboBoxIDs,

           additionalDataInvalidCheckers: [hasDuplicate, hasSomethingElse],

           breakOnFirstFailedCheck: true,
       });
});

// Xử lý sự kiện click nút đóng
function btnClose_Click() {
    ASOFTVIEW.btnClose_Click();
}

// Xử lý sự kiện click nút lưu
function btnSave_Click() {
    ASOFTVIEW.btnSave_Click();
};
