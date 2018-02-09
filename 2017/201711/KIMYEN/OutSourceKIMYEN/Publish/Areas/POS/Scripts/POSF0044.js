//#######################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     18/07/2013      Thai Son        Tạo mới
//########################################################################

var POSF0044View = function () {
    // Đối tượng hiện tại là 1 singleton
    //if (arguments.callee._singletonInstance)
    //    return arguments.callee._singletonInstance;
    //arguments.callee._singletonInstance = this;

    var thisParent = this;


    var FORM_ID = '#POSF0044';
    var FORM_NAME = 'POSF0044';
    var URL_SAVE = "/POS/POSF0043/Insert";
    var URL_UPDATE = "/POS/POSF0043/Update";
    var URL_GETNEWID = "/POS/POSF0043/GetNewMemberID";
    var KENDO_INPUT_SUFFIX = '_input';

    var defaultViewModel = postData();

    var url = ($('#FormStatus').val() == 'AddNew') ? URL_SAVE : URL_UPDATE;

    // Đóng cửa sổ
    var closePopup = function () {
        window.parent != window && window.parent.ASOFT.asoftPopup.hideIframe();
    }

    // Tạo data từ form để post về server
    function postData() {
        var data = ASOFT.helper.dataFormToJSON(FORM_NAME);
        //data.DiscountRate = data.DiscountRate.toString().replace(",", ".");
        data.Disabled = ($("#Disabled").attr("checked") == 'checked');
        data.IsMemberID = ($("#IsMemberID").attr("checked") == 'checked');
        console.log(data);
        return data;
    }

    function refreshParentGrid() {
        if (window.parent != window) {
            window.parent.GridScreen.api.refreshGrid();
        }
    }

    // Kiểm tra tính hợp lệ của form
    var formIsInvalid = function () {
        return ASOFT.form.checkRequiredAndInList(FORM_NAME, []);
    }

    // So sánh 2 đối tượng có các thuộc tính tương ứng bằng nhau 
    // (2 trạng thái của form)
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
                    // Nếu giá trị hai thuộc tính không bằng nhau, 
                    // thì data có khác biệt
                    if (data1[prop].valueOf() != data2[prop].valueOf()) {
                        return false;
                    }
                }
            }

            return true;
        }

        return undefined;
    }

    // Trả về true nếu dữ liệu trên form có thay đổi
    var isDataChanged = function () {
        var dataPost = postData();
        return !isRelativeEqual(dataPost, defaultViewModel);        
    }

    var save = function (url, afterSaveSuccessHandlers) {
        // Kiểm tra form hợp lệ
        if (formIsInvalid()) {
            console.log("Member NOT valid");
            return;
        }

        // Chuẩn bị dữ liệu
        var data = postData();

        // Thực hiện các thao tác sau khi lưu thành công
        var afterSaveExecute = function (result) {
            // Nếu lưu thành công
            //(type, result, formId, funcSuccess, funcError, funcWarning,  displaySuccessMessage, showSuccessOnRedirected, displayMessageAtElement)
            ASOFT.helper.showErrorSeverOption(1, result, FORM_NAME, null, null, null, true, true, true);
            if (result.Status == 0) {
                // Thực thi các tác vụ sau khi lưu thành công
                // Nếu chỉ có một thao tác, thi thực hiện ngay
                // ASOFT.form.displayInfo(FORM_ID, ASOFT.helper.getMessage(result.Message));
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

    var resetForm = function () {
        function pad(s) { return (s < 10) ? '0' + s : s; }
        var d = new Date();
        //$('#MemberID').val('');
        $('#MemberName').val('');
        $('#MemberName').focus();
        $('#MemberNameE').val('');
        $('#ShortName').val('');
        $('#Address').val('');
        $('#Identify').val('');
        $('#Birthday').val([pad(d.getDate()), pad(d.getMonth() + 1), d.getFullYear()].join('/'));
        $('#Phone').val('');
        $('#Tel').val('');
        $('#Fax').val('');
        $('#Email').val('');
        $('#Disabled').val(false);
        $('#IsMemberID').val(false);
        $('#Website').val('');
        $('#Mailbox').val('');
        $('#AreaID').val('');
        $('#CountyName').val('');
        $('#WardName').val('');
        //var comboboxAreaID = $("#AreaID").data("kendoComboBox");
        //comboboxAreaID.value('');
        //var comboboxCityID = $("#CityID").data("kendoComboBox");
        //comboboxCityID.value('');
        //var comboboxCountryID = $("#CountryID").data("kendoComboBox");
        //comboboxCountryID.value('');
        //$('#Description').val('');
        refreshDefaultViewModel();
    }

    var loadNewID = function (result) {
        if (result) {
            $('#MemberID').attr('value', result.Data.MemberID);
        }
    }

    var updateLastModifyDate = function (result) {
        $('#LastModifiedDateTicks').attr('value', result.Data.LastModifyDate);
    }

    var refreshDefaultViewModel = function () {
        defaultViewModel = ASOFT.helper.dataFormToJSON(FORM_NAME);
        defaultViewModel.Disabled = ($("#Disabled").attr("checked") == 'checked');
        defaultViewModel.IsMemberID = ($("#IsMemberID").attr("checked") == 'checked');
    }
    
    var SaveContinue = function () {
        save(url, [resetForm, loadNewID]);
        return false;
    }

    var SaveCopy = function () {
        save(url, loadNewID);
        return false;
    }

    var Save = function () {
        save(url, updateLastModifyDate);
        return false;
    }

    var Close = function () {
        // Nếu dữ liệu trên form bị thay đổi
        if (isDataChanged()) {
            ASOFT.dialog.confirmDialog(
               AsoftMessage['00ML000016'],
               function () {
                   save(url);
               },
               closePopup);

        } else {
            //Close popup
            closePopup();
        }
    }

    var GetNewID = function () {
        ASOFT.helper.postTypeJson(
           URL_GETNEWID,
           {},
           function (result) {
               console.log(result);
               // Nếu không có lỗi
               if (result.Status === 0) {
                   // Thông báo msg: 'Bạn đã lưu thành công !'
                   $('#MemberID').attr('value', result.Message);
                   // Nếu có lỗi 
               } else {
                   // Thông báo msg: 'Không được phép sửa vì dữ liệu đã bị thay đổi'
                   // Hoặc           'Không cho phép sửa vì dữ liệu đã bị xóa'
                   ASOFT.form.displayWarning(FORM_ID, ASOFT.helper.getMessage(result.Message));
               }
               return false;
           }
       );
    }

    this.btnSaveCopy_Click = function () {
        return SaveCopy();
    }

    this.btnSaveContinue_Click = function () {
        return SaveContinue();
    }

    this.btnSave_Click = function () {
        return Save();
    }

    this.btnClose_Click = function () {
        Close();
    }

    this.btnGetNewID_Click = function () {
        GetNewID()
    }
};

var view;

$(document).ready(function () {
    view = new POSF0044View();
    $('#DiscountRate').val(kendo.parseFloat($('#DiscountRate').val()))
    //$('#DiscountRate').focus(function () {
        
    //    var element = $(this),
    //        percentage = element.val(),
    //        numberValue = function () {
    //            kendo.culture("de-DE");
    //            return kendo.parseFloat(percentage);
    //        }();
    //    element.val(numberValue);
    //});

    //$('#DiscountRate').focusout(function () {
    //console.log("thuosdif")
    //    var element = $(this),
    //        numberValue = element.val(),
    //        percentage = function () {
    //            kendo.culture("de-DE");
    //            return kendo.toString(numberValue / 100, "p")
    //        }();
    //    console.log(numberValue, percentage)
    //    element.val(percentage);
    //});
});

function btnClose_Click() {
    view.btnClose_Click();
}

function btnSaveClose_Click() {
    view.btnClose_Click();
}

function btnSave_Click() {
    view.btnSave_Click();
}

function btnSaveContinue_Click() {
    view.btnSaveContinue_Click();
}

function btnSaveCopy_Click() {
    view.btnSaveCopy_Click();
}

function btnGetNewID_Click() {
    view.btnGetNewID_Click();
}

function sendCardDetailFilter() {
    return {memberID: $('#MemberID').val()};
}
var rowNumber = 0;
function renderNumber(data) {
    return ++rowNumber;
}

