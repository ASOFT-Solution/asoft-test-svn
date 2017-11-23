//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     06/05/2014      Dam Mo          tạo mới
//####################################################################

var ID = 'POSF00201';
var urlInsert = '/POS/POSF0020/Insert';
var urlUpdate = '/POS/POSF0020/Update';
var defaultViewModel = {};
var action = 0;//đóng, 1: lưu mới, 2: lưu sao chép
var posViewModel = {};

$(document).ready(function () {
    function makeTextBoxWithSearch(selector) {
        var targetElement = $(selector),
            parent = targetElement.parent(),
            wrapper = $('<span class="textbox-search-wrapper"></span>'),
            asfButtonString = '<span class="asf-button-special"><a id="{0}" class="{0} k-button k-button-icontext asf-button asf-icon-24 asf-i-search-24" style="" data-role="button" role="button" aria-disabled="false" tabindex="0">&nbsp;</a></span>'.format('btnOpenSearch'),
            buttonElement = $(asfButtonString);

        wrapper.append(targetElement.clone().css('width', ''));
        wrapper.append(buttonElement);
        targetElement.remove();
        parent.append(wrapper);

        buttonElement.on('click', function () {
            ASOFT.asoftPopup.showIframe('/POS/POSF0020/POSF00202', {});
        });
    }
    makeTextBoxWithSearch('#MemberID');
    refreshModel();
});

posViewModel.recieveResult = function (result) {
    if (result) {
        $('#MemberID').val(result.MemberID);
        $('#MemberName').val(result.MemberName);
    }
}

// refresh model
function refreshModel() {
    defaultViewModel = ASOFT.helper.dataFormToJSON(ID);
}

/**
* Đóng popup
*/
function popupClose_Click(event) {
    if (isDataChanged()) {// Check data is change or not.
        ASOFT.dialog.confirmDialog(
            ASOFT.helper.getMessage('00ML000016'),
            //yes
            function () {
                defaultViewModel = ASOFT.helper.dataFormToJSON(ID);
                if ($('#FormStatus').val() === "AddNew") {
                    checkData();
                }
                else {
                    checkDataUpdate();
                    parent.POSF0020Grid.dataSource.page(1);
                    parent.popupClose();
                   
                }
                
            },
            //no
            function () {
                parent.popupClose();
            });
    } else {
        //Close popup
        parent.popupClose();
    }
}

// Kiểm tra tính hợp lệ của combobox
function formIsInvalid() {
    return ASOFT.form.checkRequiredAndInList(ID, ['TypeNo']);
}

// Kiểm tra dữ liệu trên form có bị thay đổi hay không
var isDataChanged = function () {
    var dataPost = getFormData();
    var equal = isRelativeEqual(dataPost, defaultViewModel);
    return !equal;
};

var KENDO_INPUT_SUFFIX = '_input';
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

var getFormData = function () {
    var dataPost = ASOFT.helper.dataFormToJSON(ID);

    return dataPost;
};

// Kiểm tra xem dữ liệu trong các control trên form có bị thay đổi không
function isDataChanged() {
    var data = ASOFT.helper.dataFormToJSON(ID);
    var equal = isRelativeEqual(data, defaultViewModel);
    return !equal;    
}

// Kiểm tra dữ liệu
function checkData() {
    if (formIsInvalid()) {
        return;
    }
    insert();
}

// Kiểm tra thay đổi và lưu
function checkAndSave() {
    // Nếu có thay đổi trên combobox
    if (isDataChanged()) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                                      checkData
                                    );
    }
    else {
        checkData();
    }
}

function checkDataUpdate() {
    if (formIsInvalid()) {
        return;
    }
    update();
}

function checkAndUpdate() {
    // Nếu có thay đổi trên combobox
    if (isDataChanged()) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                                      checkDataUpdate
                                    );
    }
    else {
        checkDataUpdate();
    }
}

//Resert form MTF1010
function clearFormPOSF00201() {
    $('#POSF00201 input[type="text"], textarea').val('');
    $('#FormStatus').val('AddNew');
}

function memberIDSearch_Click() {
    ASOFT.asoftPopup.showIframe('/POS/POSF0020/POSF00202', {});
}
function inherit_Close(event) {
    //Close popup
    ASOFT.asoftPopup.hideIframe();
}

// gọi hàm Insert
function insert() {
    var data = ASOFT.helper.dataFormToJSON(ID);
    data.Disabled = $("#Disabled").is(":checked");
    data.Locked = $("#Locked").is(":checked");
    data.IsCommon = $("#IsCommon").is(":checked");
    ASOFT.helper.postTypeJson(urlInsert, data, onSuccess);
}

function update() {
    var data = ASOFT.helper.dataFormToJSON(ID);
    data.Disabled = $("#Disabled").is(":checked");
    data.Locked = $("#Locked").is(":checked");
    data.IsCommon = $("#IsCommon").is(":checked");
    ASOFT.helper.postTypeJson(urlUpdate, data, onUpdateSuccess);
}

// Lưu thành công
function onSuccess(result) {
    if (result.Status == 0) { // Hàm Insert là true
        if (action === 1) {// Lưu và tiếp nhận
            ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message));
            parent.POSF0020Grid.dataSource.page(1);
            clearFormPOSF00201();
        }
        else if (action === 2) {// Lưu và sao chép
            ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message));
            parent.POSF0020Grid.dataSource.page(1);

        } else {
            parent.POSF0020Grid.dataSource.page(1);
            ASOFT.asoftPopup.closeOnly();
        }
        $('#MemberCardID').focus().select();
        refreshModel();
    }
    else {
        var msg = ASOFT.helper.getMessage(result.Message);
        if (result.Data) { // Nếu có Data trong errors
            msg = kendo.format(msg, result.Data);
        }
        ASOFT.form.displayWarning('#' + ID, msg);
    }
}

function onUpdateSuccess(result) {
    if (action == 2) {// Lưu và sao chép
        ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message));
        if (result.Data != null) {
            $('#LastModifyDateValue').val(result.Data.LastModifyDateValue);
        }
        parent.POSF0020Grid.dataSource.page(1);
        refreshModel();
    }
}

// Xử lý sự kiện khi click nút Lưu tiếp nhận
function posf00201SaveNew_Click() {
    action = 1;
    checkAndSave();
}

// Xử lý sự kiện khi click nút Lưu và sao chép
function posf00201SaveCopy_Click() {
    action = 2;
    checkAndSave();
}

// Hiển Thị ShopName theo ShopID
function memberID_Change(e) {
    ASOFT.asoftComboBox.dataBound(e);
    var item = this.dataItem(this.selectedIndex);
    if (item == null) {
        return;
    }
    var typeid = item.MemberName;
    $('#MemberName').val(typeid);
}

function btnUpdate_Click(e) {
    action = 2;
    checkAndUpdate();
}