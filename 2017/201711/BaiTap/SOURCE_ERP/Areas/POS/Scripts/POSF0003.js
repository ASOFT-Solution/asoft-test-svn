//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     08/04/2014      Thai Son        Tạo mới
//####################################################################



$(document).ready(function () {
    var FORM_ID = '#POSF0003';
    var decimalDigits = 0;
    var VND = 'VND';
    // Định dạng số tiền tệ, 
    // c: số chữ số thập phân
    // d: dấu phân cách phần thập phân
    // t: dấu phân cách hàng nghìn
    // Ví dụ cách dùng --> console.log((123456789.12345).formatMoney(2, '.', ','));
    Number.prototype.formatMoney = function (c, d, t) {
        var n = this,
            c = isNaN(c = Math.abs(c)) ? 2 : c,
            d = d == undefined ? '.' : d,
            t = t == undefined ? ',' : t,
            s = n < 0 ? '-' : '',
            i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + '',
            j = (j = i.length) > 3 ? j % 3 : 0;
        return s + (j ? i.substr(0, j) + t : '') + i.substr(j).replace(/(\d{3})(?=\d)/g, '$1' + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : '');
    };


    // Chuyển số thành dạng tiền tệ
    // value: số cần chuyển
    function toMoneyFormat(value) {
        return Number(value).formatMoney(decimalDigits, '.', ',');
    }

    function addChangeEvents() {
        $('#Point1').data('kendoNumericTextBox').bind('change', change_Handler);
        $('#Money1').data('kendoNumericTextBox').bind('change', change_Handler);
        $('#Point2').data('kendoNumericTextBox').bind('change', change_Handler);
        $('#Money2').data('kendoNumericTextBox').bind('change', change_Handler);

        $('#Point1').keyup(change_Handler);
        $('#Money1').keyup(change_Handler);
        $('#Point2').keyup(change_Handler);
        $('#Money2').keyup(change_Handler);

        $('#Point1').on('focus', focus_Handler);
        $('#Money1').on('focus', focus_Handler);
        $('#Point2').on('focus', focus_Handler);
        $('#Money2').on('focus', focus_Handler);

        $('#Point1').focusout(focusOut_Handler);
        $('#Money1').focusout(focusOut_Handler);
        $('#Point2').focusout(focusOut_Handler);
        $('#Money2').focusout(focusOut_Handler);

        //$('#Money1').data("kendoNumericTextBox").focus();
    }

    function focusOut_Handler() {
        console.log($(this));
        if (!$(this).val()) {
            // Nếu user focus out mà không nhập, thì gán giá trị zero
            $(this).val('0');
        }
    }

    // Xử lý sự kiện khi focus vào control
    function focus_Handler() {
        console.log($(this));
        if (Number($(this).data('kendoNumericTextBox').value()) === 0) {
            $(this).val('');
            this.select();

        }
    }

    // Xử lý sự kiện thay đổi trên 4 textbox
    // Cập nhật nội dung 2 example
    function change_Handler() {
        processExamples();
    }

    // Xử lý hiển thị 2 example khi form vừa load
    function processExamples() {
        var point1 = $('#Point1').val();
        var money1 = $('#Money1').val();
        var point2 = $('#Point2').val();
        var money2 = $('#Money2').val();
        var currencyID = $('#CurrencyID').data('kendoComboBox').value();

        if (currencyID === VND) {
            decimalDigits = 0;
        }
        else {
            decimalDigits = 2;
        }

        var exPointText = $('label[for="ExamplePoint"]').text()
                                                            .format(
                                                                toMoneyFormat(point2),
                                                                toMoneyFormat(money2),
                                                                currencyID
                                                            );
        var exMoneyText = $('label[for="ExampleMoney"]').text()
                                                            .format(
                                                                toMoneyFormat(money1),
                                                                currencyID,
                                                                toMoneyFormat(point1)
                                                            );

        $('#ExamplePointPlaceHolder').text(kendo.format('({0})', exPointText));
        $('#ExampleMoneyPlaceHolder').text(kendo.format('({0})', exMoneyText));

        if (currencyID && currencyID.length > 0) {
            // Nếu đơn vị tiền tệ hợp lệ, thì hiển thị đơn vị tiền tệ
            $('#CurrencyName1').text(currencyID);
            $('#CurrencyName2').text(currencyID);
        }
        else {
            // Nếu không thì hiển thị dấu ...
            $('#CurrencyName1').text('...');
            $('#CurrencyName2').text('...');
        }
    }

    // Load lại dữ liệu vào các control
    // model: là model dữ liệu của form
    function refillControlFromModel(model) {
        $('#Point1').data('kendoNumericTextBox').value(model.Point1);
        $('#Money1').data('kendoNumericTextBox').value(model.Money1);
        $('#Point2').data('kendoNumericTextBox').value(model.Point2);
        $('#Money2').data('kendoNumericTextBox').value(model.Money2);
        $('#CurrencyID').data('kendoComboBox').value(model.CurrencyID);
        $('#UpdateCard').attr('checked', model.AutoUpgradeCard);
        $('#DownCard').attr('checked', model.AutoDecreaseCard);

    }

    function additionalData() {
        var data = {};
        //data['CurrencyID'] = $('#CurrencyID').data('kendoComboBox').value();
        data['UpdateCard'] = ($('#UpdateCard').attr('checked') == 'checked');
        data['DownCard'] = ($('#DownCard').attr('checked') == 'checked');
        return data;
    }

    // Kiểm tra tính hợp lệ của form
    function formInvalid() {
        var arrayMsg = [];
        currencyID = '???',
        errorControls = [],
        point1 = $('#Point1'),
        money1 = $('#Money1'),
        point2 = $('#Point2'),
        money2 = $('#Money2'),
        currency = $('#CurrencyID').data('kendoComboBox'),
        result1 = true,
        result2 = true,
        result3 = true,
        result4 = true,
        result5 = true,
        temp = false;

        // Reset các đánh dấu hiển thị lỗi trên các control
        $(FORM_ID + ' div.asf-text-message-error').empty();
        $(FORM_ID + ' div.asf-panel-warning').remove();
        $(FORM_ID + ' div.asf-panel-info').remove();
        $(FORM_ID + ' .asf-focus-input-error').removeClass('asf-focus-input-error');

        // Nếu giá trị của combobox hợp lệ
        if (!failInListCombobox()) {
            currencyID = $('#CurrencyID').data('kendoComboBox').value();
        }
        // Nếu đơn vị tiền tệ không hợp lệ, thì chuẩn bị thông báo lỗi
        if (currency.value() === '' || currency.value().length === 0) {
            arrayMsg.push(kendo.format(ASOFT.helper.getMessage('POSM000002'), $('label[for="Currency"]').text()));
            errorControls.push(currency);
            highLightErrorControl($('#CurrencyID'));
        }
        else {
            temp = ASOFT.form.checkInListCombobox('POSF0003', ['CurrencyID']);
            // Nếu checkInList CÓ trả về thông báo lỗi
            if (temp.length > 0) {
                arrayMsg.push(kendo.format('[{0}]: {1}', $('label[for="Currency"]').text(), ASOFT.helper.getMessage('POSM000007')));
                errorControls.push($('#CurrencyID'));
                highLightErrorControl($('#CurrencyID'));
                result1 = false;
            }
        }

        // =============== Kiểm tra lần lượt từng control ========================
        if (Number(point1.val()) === 0) {
            arrayMsg.push(ASOFT.helper.getMessage('POSM000018').format($('label[for="Point1"]').text(), $('label[for="ChangePoint"]').text()));
            errorControls.push(point1);
            result2 = false;
        }

        if (Number(money1.val()) === 0) {
            arrayMsg.push(ASOFT.helper.getMessage('POSM000018').format($('label[for="Money1"]').text(), $('label[for="ChangePoint"]').text()));
            errorControls.push(money1);
            result3 = false;
        }

        if (Number(point2.val()) === 0) {
            arrayMsg.push(ASOFT.helper.getMessage('POSM000018').format($('label[for="Point2"]').text(), $('label[for="ChangeMoney"]').text()));
            errorControls.push(point2);
            result4 = false;
        }

        if (Number(money2.val()) === 0) {
            arrayMsg.push(ASOFT.helper.getMessage('POSM000018').format($('label[for="Money2"]').text(), $('label[for="ChangeMoney"]').text()));
            errorControls.push(money2);
            result5 = false;
        }

        var result = (result1 && result2 && result3 && result4 && result5);

        if (!result) {
            // Nếu CÓ lỗi, thì hiện (các) thông báo lỗi
            ASOFT.form.displayError(FORM_ID, arrayMsg);
            $.each(errorControls, function (index, control) {
                var kWidget = $(control).closest('.k-widget');
                var widgetElement = $(control).closest('[data-' + kendo.ns + 'role]');
                var widgetObject = kendo.widgetInstance(widgetElement);

                if (widgetObject != undefined && widgetObject.options.name != 'TabStrip') {
                    kWidget.addClass('asf-focus-input-error');
                } else {
                    $(control).addClass('asf-focus-input-error');
                }
            });
        }
        return !result;
    }

    // Highlight các control có giá trị invalid
    function highLightErrorControl(control) {
        var kWidget = control.closest('.k-widget');
        var widgetElement = control.closest('[data-' + kendo.ns + 'role]');
        var widgetObject = kendo.widgetInstance(widgetElement);

        if (widgetObject != undefined && widgetObject.options.name != 'TabStrip') {
            kWidget.addClass('asf-focus-input-error');
        } else {
            control.addClass('asf-focus-input-error');
        }
    }

    // Kiểm tra "in list" của combobox
    // formId: là ID của form
    // itemIds: là ID của combobox cần kiểm tra
    function failInListCombobox() {
        var formId = '#POSF0003';
        var itemIds = ['CurrencyID'];
        var result = true;
        for (var i = 0; i < itemIds.length; i++) {
            var combo = ASOFT.asoftComboBox.castName(itemIds);
            if (combo.input.attr('aria-disabled') && combo.input.attr('disabled') == 'disabled') {
                continue;
            }
            var itemValue = combo.input.val();
            if (itemValue && (itemValue != null || itemValue != '')) {
                if ((combo.selectedIndex == -1 && combo.dataSource._data.length > 0 && combo.input.val() != '') // Có data mà chưa chọn
                    || (combo.selectedIndex == -1 && combo.dataSource._data.length == 0 && combo.input.val() != '')) { // Không có data mà nhập value
                    result = false;
                }
            }
        }

        return !result;
    }

    // Cấu hình màn hình hiện tại
    ASOFTVIEW.config({
        // URL để lưu/update dữ liệu
        urlSave: '/POS/POSF0003/Save',
        // Mã form (Lấy theo CSS id)
        formID: '#POSF0003',
        // Tên form
        formName: 'POSF0003',
        // Các hàm khác để kiểm tra thay đổi của form
        //additionalChangeDetectors: [],
        // Các dữ liệu mà hàm ASOFT.helper.dataFormToJSON không lấy được như ý muốn
        additionalData: additionalData,
        // Tên (không có dấu #), của các combobox
        allComboboxIDs: ['CurrencyID'],
        // Các hàm cần thực thi sau khi lưu dữ liệu
        additionalAfterSaveHandlers: [],
        additionalDataInvalidCheckers: [formInvalid, failInListCombobox],
        hasLastModifyDate: true
    });

    processExamples();
    addChangeEvents();

    ASOFTVIEW.processExamples = processExamples;
    ASOFTVIEW.failInListCombobox = failInListCombobox;
});

// Xử lý sự kiện click nút đóng
var btnClose_Click = ASOFTVIEW.btnClose_Click;

// Xử lý sự kiện click nút lưu
var btnSave_Click = ASOFTVIEW.btnSave_Click;

// Xử lý sự kiện thay thổi trên combo Đơn vị tiền tệ
function cbCurrencyID_Change(e) {
    if (!ASOFTVIEW.failInListCombobox()) {
        // Nếu dữ liệu combobox hợp lệ, thì cập nhật text example
        ASOFTVIEW.processExamples(e);
    }

}
