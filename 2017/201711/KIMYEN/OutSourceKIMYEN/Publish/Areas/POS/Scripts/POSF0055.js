//#######################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     19/07/2014      thai Son        Tạo mới
//########################################################################

var POSVIEW = POSVIEW || {};
var rowNumber1 = 0;
var posGrid = null;
var isCountinue = 0;

$(document).ready(function () {
    posGrid = $('#POSF0055Grid').data('kendoGrid');
    if (posGrid != undefined) {
        posGrid.bind('dataBound', function (e) {
            rowNumber1 = 0;
        });
    }

    var
        global = this,
        FORM_ID = '#POSF0055',
        FORM_NAME = 'POSF0055',
        URL_SAVE = "/POS/POSF0054/Insert",
        URL_UPDATE = "/POS/POSF0054/Update",
        URL_GETNEWID = "/POS/POSF0011/GetNewMemberID",
        KENDO_INPUT_SUFFIX = '_input',
        defaultViewModel = postData(true),

        url = ($('#FormStatus').val() == 'AddNew') ? URL_SAVE : URL_UPDATE;

    isLoadForm = 0;
    isCountinue = 0;

    if ($("#isCLOUD").val() == "True") {
        $("#EmployeeID").attr("readonly", "readonly");
        $("#EmployeeID").css("width", "98%");
        $("#Description").css("width", "98%");
        var log = console.log;
        GRID_AUTOCOMPLETE.config({
            gridName: 'POSF0055Grid',
            inputID: 'autocomplete-box',
            autoSuggest: false,
            serverFilter: true,
            actionName: 'POSF0015',
            controllerName: "GetInventories",
            grid: $('#POSF0055Grid').data('kendoGrid'),
            setDataItem: function (selectedRowItem, dataItem) {
                //log(dataItem);
                selectedRowItem.model.set('InventoryID', dataItem.InventoryID);
                selectedRowItem.model.set('InventoryName', dataItem.InventoryName);
                selectedRowItem.model.set('UnitID', dataItem.UnitID);
                selectedRowItem.model.set('UnitName', dataItem.UnitName);
                selectedRowItem.model.set('UnitPrice', dataItem.UnitPrice);
            }
        });
    }
    else {
        $("#EmployeeID").attr("readonly", "readonly");
        $("#EmployeeID").css("width", "90%");
    }

    // Tạo data từ form để post về server
    function postData(isDf) {
        var data = ASOFT.helper.dataFormToJSON(FORM_NAME);
        data.isPOSCLOUD = $("#isCLOUD").val() == "True";
        data.EmployeeID = $('#EmployeeID').data('kendoComboBox') != undefined ? $('#EmployeeID').data('kendoComboBox').value() : $('#EmployeeID').val();
        if ($("#isCLOUD").val() == "True" && !isDf) {
            data.DetailList = posGrid.dataSource.data();
            data.IsDataChanged = posGrid.dataSource.hasChanges();
        }
        return data;
    }

    function refreshParentGrid() {
        if (window.parent != global) {
            window.parent.POSVIEW.refreshGrid();
        }
    }

    // Kiểm tra tính hợp lệ của form
    function formIsInvalid() {
        var Check = ['EmployeeID'];
        if ($("#isCLOUD").val() == "True") {
            Check = [];
        }

        var check = ASOFT.form.checkRequiredAndInList(FORM_NAME, Check)

        if (!check && $("#isCLOUD").val() == "True") {
            if (posGrid.dataSource.data().length <= 0) {
                $('#POSF0055Grid').addClass('asf-focus-input-error');
                //display message
                msg = ASOFT.helper.getMessage('00ML000061');
                ASOFT.form.displayError('#POSF0055', msg);
                check = true;
            } else {
                //show quantity
                if (ASOFT.asoftGrid.editGridValidate(posGrid, ['Description'])) {
                    msg = ASOFT.helper.getMessage('00ML000060');
                    ASOFT.form.displayError('#POSF0055', msg);
                    check = true;
                }
                //[MinhLam - 06/06/2014] : Không kiểm tra chêch lệch số lượng
                /*else if (this.checkQuantity()) {
                    msg = ASOFT.helper.getMessage('00ML000072');
                    ASOFT.form.displayWarning('#POSF00151', msg);
                    check = true;
                }*/
            }
        }

        return check;
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

    // Kiểm tra trạng thái thay đổi của form
    // Trả về true nếu dữ liệu trên form có thay đổi
    function isDataChanged() {
        var dataPost = postData();
        return !isRelativeEqual(dataPost, defaultViewModel);
    }

    // 
    function save(url, afterSaveSuccessHandlers) {
        // Kiểm tra form hợp lệ
        if (formIsInvalid()) {
            return;
        }

        // Chuẩn bị dữ liệu
        var data = postData();
        data.APK = $('#APK').val();

        // Thực hiện các thao tác sau khi lưu thành công
        var afterSaveExecute = function (result) {
            // Nếu lưu thành công
            //(type, result, formId, funcSuccess, funcError, funcWarning,  displaySuccessMessage, showSuccessOnRedirected, displayMessageAtElement)
            ASOFT.helper.showErrorSeverOption(1, result, FORM_NAME, null, null, null, true, true, true);
            if (result.Status == 0) {
                // Thực thi các tác vụ sau khi lưu thành công
                // Nếu chỉ có một thao tác, thi thực hiện ngay
                ASOFT.form.displayInfo(FORM_ID, ASOFT.helper.getMessage(result.Message));
                if (isLoadForm == 2) {
                    window.parent.location.reload();
                }
                else {
                    window.parent.POSVIEW.refreshGrid();
                    if (isCountinue == 1) {
                        $("#VoucherNo").val(result.Data);
                    }
                }
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
        $('#Description').val('');
        $('#VoucherDate').val([pad(d.getDate()), pad(d.getMonth() + 1), d.getFullYear()].join('/'));
        refreshDefaultViewModel();
    }

    function updateLastModifyDate(result) {
        $('#LastModifiedDateTicks').attr('value', result.Data.LastModifyDate);
    }

    function refreshDefaultViewModel() {
        defaultViewModel = ASOFT.helper.dataFormToJSON(FORM_NAME);
    }

    function saveContinue() {
        isLoadForm = 1;
        isCountinue = 1;
        save(url, [resetForm]);
        return false;
    }

    function saveCopy() {
        isLoadForm = 1;
        isCountinue = 1;
        save(url, null);
        return false;
    }

    function saveUpdate() {
        isLoadForm = 2;
        save(url, updateLastModifyDate);
        return false;
    }

    // Xử lý sự kiện đóng 
    function close() {
        var
            // Lấy ra trạng thái thay đổi của form
            changed = true;//isDataChanged()
        ;
        // Nếu dữ liệu trên form bị thay đổi
        // thì hiện thông báo hỏi 'lưu hay không?' (00ML000016)
        // Nếu 'Có', thì tiếng hành lưu, nếu 'Không', thì đóng màn hình
        if (changed) {
            ASOFT.dialog.confirmDialog(
               AsoftMessage['00ML000016'],
               function () {
                   save(url);
               },
               closePopup);

        } else {
            //Nếu dữ liệu không bị thay đổi, thì đóng màn hình
            closePopup();
        }
    }

    // Đóng cửa sổ
    function closePopup() {
        ASOFT.asoftPopup.closeOnly();
    }

    // Gán các hàm xử lý cho đối tượng POSVIEW
    // để interface với các sự kiện được gán cho nút
    POSVIEW.btnSaveCopy_Click = saveCopy;
    POSVIEW.btnSaveContinue_Click = saveContinue;
    POSVIEW.btnSaveClose_Click = close;
    POSVIEW.btnSave_Click = saveUpdate;
    POSVIEW.btnClose_Click = close;
});

//function btnClose_Click(e) {
//    POSVIEW.btnClose_Click(e);
//}

//function btnSaveClose_Click(e) {
//    POSVIEW.btnClose_Click(e);
//}

//function btnSave_Click(e) {
//    POSVIEW.btnSave_Click(e);
//}

function btnSaveContinue_Click(e) {
    POSVIEW.btnSaveContinue_Click(e);
}

function btnSaveCopy_Click(e) {
    POSVIEW.btnSaveCopy_Click(e);
}

function employeeID_Change(e) {
    ASOFT.asoftComboBox.dataBound(e);
    var item = this.dataItem(this.selectedIndex);
    if (item == null) {
        return;
    }
    var typeid = item.Name;
    $('#EmployeeName').val(typeid);
}

function renderNumber1(data) {
    return ++rowNumber1;
}

function genDeleteBtn(data) {
    return '<a href="\\#" onclick="return deleteVoucher_Click(this);" class="asf-i-delete-24 asf-icon-24"><span>Del</span></a>';
}

function deleteVoucher_Click(e) {
    if (posGrid.dataSource.data().length == 1) {
        posGrid.dataSource.data([]);
        posGrid.addRow();
        $("#POSF0055Grid").removeAttr("AddNewRowDisabled");
        return false;
    }
    var tagA = $(e).parent();
    ASOFT.dialog.confirmDialog(
        ASOFT.helper.getMessage('00ML000024'),
        //yes
        function () {
            ASOFT.asoftGrid.removeEditRow(tagA, $('#POSF0055Grid').data('kendoGrid'), null);
        },
        function () {

        }
    );
    return false;

}

function btnChooseEmployeeID_Click() {
    var urlChooseEmployee = "/PopupSelectData/Index/POS/CMNF9003?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseEmployee, {});
}

function receiveResult(result) {
    $("#EmployeeID").val(result["EmployeeID"]);
    $("#EmployeeName").val(result["EmployeeName"]);
}

function sendDataFilterEdit() {
    var data = {};
    data.APK = $('#APK').val();
    return data;
}
