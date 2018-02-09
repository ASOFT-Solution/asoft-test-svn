//#######################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/02/2014      Minh Lâm         Tạo mới
//#     02/04/2014      Thai Son         Thêm các hàm liên quan tới CRUD
//#     04/04/2014      Thai Son         Edit: code cho các luồng xử lý
//#     05/06/2014      Thai Son         Edit: code cho các luồng xử lý
//########################################################################

var POSVIEW = function (View) {
    // Đối tượng hiện tại là 1 singleton
    //if (arguments.callee._singletonInstance)
    //    return arguments.callee._singletonInstance;
    //arguments.callee._singletonInstance = this;
    var v = View || {},
        global = this,

        FORM_ID = '#POSF0057',
        FORM_NAME = 'POSF0057',
        URL_SAVE = "/POS/POSF0054/InsertDetail",
        URL_UPDATE = "/POS/POSF0054/UpdateDetail",
        URL_GETNEWID = "/POS/POSF0011/GetNewMemberID",
        KENDO_INPUT_SUFFIX = '_input',

        defaultViewModel = postData(),

        url = ($('#FormStatus').val() == 'AddNew') ? URL_SAVE : URL_UPDATE;

    // Đóng cửa sổ
    function closePopup() {
        window.parent != window && window.parent.ASOFT.asoftPopup.hideIframe();
    }

    // Tạo data từ form để post về server
    function postData() {
        var data = ASOFT.helper.dataFormToJSON(FORM_NAME);
        return data;
    }

    function refreshParentGrid() {
        if (global.parent != global) {
            global.parent.view.refreshGrid();
        }
    }

    // Kiểm tra tính hợp lệ của form
    function formIsInvalid() {
        return ASOFT.form.checkRequiredAndInList(FORM_NAME, ['WareHouseID']);
    }

    // So sánh 2 đối tượng có các thuộc tính tương ứng bằng nhau 
    // (2 trạng thái của form)
    function isRelativeEqual(data1, data2) {
        if (data1 && data2
            && typeof data1 === "object"
            && typeof data2 === "object") {
            for (var prop in data1) {
                // So sánh thuộc tính của 2 data
                if (data2.hasOwnProperty(prop)) {
                    if (data1[prop] !== data2[prop]) {
                        return false;
                    }
                }

            }

            return true;
        }

        //return undefined;
        return;
    }

    // Trả về true nếu dữ liệu trên form có thay đổi
    function isDataChanged() {
        var dataPost = postData();
        return !isRelativeEqual(dataPost, defaultViewModel);
    }

    function save(url, afterSaveSuccessHandlers) {
        // Kiểm tra form hợp lệ
        if (formIsInvalid()) {
            //console.log("Member NOT valid");
            return;
        }

        // Chuẩn bị dữ liệu
        var data = postData();
        data.APK = $('#APK').val();
        data.Quantity = $('#Quantity').val();
        data.WarehouseName = data.WareHouseID_input;

        // Thực hiện các thao tác sau khi lưu thành công
        var afterSaveExecute = function (result) {
            // Nếu lưu thành công
            //(type, result, formId, funcSuccess, funcError, funcWarning,  displaySuccessMessage, showSuccessOnRedirected, displayMessageAtElement)
            ASOFT.helper.showErrorSeverOption(1, result, FORM_NAME, null, null, null, true, true, true);
            if (result.Status == 0) {
                // Thực thi các tác vụ sau khi lưu thành công
                // Nếu chỉ có một thao tác, thi thực hiện ngay
                ASOFT.form.displayInfo(FORM_ID, ASOFT.helper.getMessage(result.Message));
                window.parent.POSVIEW.refreshGrid();
                if (afterSaveSuccessHandlers) {
                    if (typeof afterSaveSuccessHandlers === 'function') {
                        afterSaveSuccessHandlers(result);
                    } // nếu là một array nhiều tác vụ, thi duyệt và thực hiện từng cái
                    else if (Object.prototype.toString.call(afterSaveSuccessHandlers) === '[object Array]') {
                        while (afterSaveSuccessHandlers.length > 0) {
                            var handler = afterSaveSuccessHandlers.pop();
                            if (handler && typeof handler === 'function') {
                                handler(result);
                            }
                        }
                    }
                }
                refreshDefaultViewModel();
                refreshParentGrid();
            }
        }

        // Tiếng hành lưu
        ASOFT.helper.postTypeJson(
            url,
            data,
            afterSaveExecute
        );
    }

    function resetForm() {
        function pad(s) { return (s < 10) ? '0' + s : s; }
        var d = new Date();
        //$('#MemberID').val('');
        $('#InventoryID').val('');
        $('#InventoryName').val('');
        $('#UnitID').val('');
        $('#VoucherDate').val([pad(d.getDate()), pad(d.getMonth() + 1), d.getFullYear()].join('/'));
        $('#Quantity').val('');
        $('#Description').val('');
        //var comboboxAreaID = $("#WareHouseID").data("kendoComboBox");
        //comboboxAreaID.value('');
        refreshDefaultViewModel();
    }

    function updateLastModifyDate(result) {
        $('#LastModifiedDateTicks').attr('value', result.Data.LastModifyDate);
    }

    function refreshDefaultViewModel() {
        defaultViewModel = ASOFT.helper.dataFormToJSON(FORM_NAME);
    }

    function saveContinue() {
        save(URL_SAVE, [resetForm]);
        return false;
    }

    function saveCopy() {
        //save(URL_SAVE, loadNewID);
        save(URL_SAVE);
        return false;
    }

    function saveUpdate() {
        //save(URL_UPDATE, updateLastModifyDate);
        save(URL_UPDATE);
        return false;
    }

    function close() {
        // Nếu dữ liệu trên form bị thay đổi
        if (isDataChanged()) {
            ASOFT.dialog.confirmDialog(
               AsoftMessage['00ML000016'],
               function () {
                   save(URL_SAVE);
               },
               closePopup);

        } else {
            //Close popup
            closePopup();
        }
    }

    v.btnSaveCopy_Click = function () {
        return saveCopy();
    }

    v.btnSaveContinue_Click = function () {
        return saveContinue();
    }

    v.btnSaveClose_Click = function () {
        return close();
    }

    v.btnSave_Click = function () {
        return saveUpdate();
    }

    v.btnClose_Click = function () {
        close();
    }

    return v;
}(POSVIEW);

var view;

function btnClose_Click() {
    POSVIEW.btnClose_Click();
}

function btnSaveClose_Click() {
    POSVIEW.btnClose_Click();
}

function btnSave_Click() {
    POSVIEW.btnSave_Click();
}

function btnSaveContinue_Click() {
    POSVIEW.btnSaveContinue_Click();
}

function btnSaveCopy_Click() {
    POSVIEW.btnSaveCopy_Click();
}


$(document).ready(function () {
    //function makeTextBoxWithSearch(selector) {
    //    var targetElement = $(selector),
    //        parent = targetElement.parent(),
    //        wrapper = $('<span class="textbox-search-wrapper"></span>'),
    //        asfButtonString = '<span class="asf-button-special"><a id="{0}" class="{0} k-button k-button-icontext asf-button asf-icon-24 asf-i-search-24" style="" data-role="button" role="button" aria-disabled="false" tabindex="0">&nbsp;</a></span>'.format('btnOpenSearch'),
    //        buttonElement = $(asfButtonString);

    //    wrapper.append(targetElement.clone().css('width', ''));
    //    wrapper.append(buttonElement);
    //    targetElement.remove();
    //    parent.append(wrapper);

    //    buttonElement.on('click', function () {
    //        ASOFT.asoftPopup.showIframe('/POS/POSF0054/POSF0057M', {});
    //    });
    //}
    //makeTextBoxWithSearch('#InventoryID');
    var asfButtonString = '<span class="asf-button-special"><a id="{0}" class="{0} k-button k-button-icontext asf-button asf-icon-24 asf-i-search-24" style="" data-role="button" role="button" aria-disabled="false" onclick="btnOpenSearch_Click()" tabindex="0">&nbsp;</a></span>'.format('btnOpenSearch')
    $("#InventoryID").after(asfButtonString);

    $("#InventoryID").bind("focusout", function (e) {
        setTimeout(function () {
            var autoInventory = $("#InventoryID").data("kendoAutoComplete");
            var item = autoInventory.dataItem(0);
            if (item != undefined) {
                if ($("#InventoryID").val() == item.InventoryID || $("#InventoryID").val() == item.Barcode) {
                    $("#InventoryName").val(item.InventoryName);
                    $("#UnitID").val(item.UnitID);
                    $("#UnitName").val(item.UnitName);
                    $("#InventoryID").val(item.InventoryID);
                }
            }
        }, 500)
    });
});

function btnOpenSearch_Click() {
    ASOFT.asoftPopup.showIframe('/POS/POSF0054/POSF0057M', {});
}

function recieveResult(result) {
    if (result) {
        $('#InventoryID').val(result.InventoryID);
        $('#InventoryName').val(result.InventoryName);
        $('#UnitID').val(result.UnitID);
        $('#UnitName').val(result.UnitName);
    }
}

function wareHouseID_Change(e) {
    ASOFT.asoftComboBox.dataBound(e);
    var item = this.dataItem(this.selectedIndex);
    if (item == null) {
        return;
    }
    var typeid = item.DivisionName;
    $('#WarehouseName').val(typeid);
}

function InventoryID_Change(e) {
    var item = this.dataItem(e.item.index());
    if (item != undefined) {
        $("#InventoryName").val(item.InventoryName);
        $("#UnitID").val(item.UnitID);
        $("#UnitName").val(item.UnitName);
    }
    return false;
}