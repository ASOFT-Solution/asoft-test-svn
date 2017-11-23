//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     24/07/2014      Đức Quý         Tạo mới
//####################################################################
// Global
var isSearch = false; // biến Lọc dữ liệu
var formStatus = null; // loại form
var urlUpdate = null;
var saveActionType = null; // 1: SaveNext, 2: SaveCopy, 3: SaveClose
var formStatus = 0;
var posf0060Grid = null;

$(document).ready(function () {
    // Tạo Grid
    posf0060Grid = ASOFT.asoftGrid.castName('POSF0060Grid');
});
$(window).resize(function () {
    calHeightGrid('POSF0060Grid', 340);
});


// Đóng Popup
function popupClose(event) {
    ASOFT.asoftPopup.hideIframe(true);
}

function btnClose_Click() {
    //ASOFT.asoftPopup.hideIframe(true);
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('AFML000006'), btnSave_Click, popupClose);
}

function addNew() {
    formStatus = 1;
    var data = {
        FormStatus: formStatus
    };
    //urlUpdate = window.parent.$('#UrlInsert').val();
    var urlPOSF0061 = $('#UrlPOSF0061').val();
    url = ASOFT.helper.renderUrl(urlPOSF0061, data);
    ASOFT.form.clearMessageBox();
    //calHeightGrid('POSF0010Grid', 340);
    ASOFT.asoftPopup.showIframe(url, {});
}

function addNewCopy (savedKey) {
    formStatus = 1;

    var data = {
        FormStatus: formStatus,
        TimeID: savedKey
    };
    urlUpdate = $('#UrlInsert').val();
    var urlPOSF0061 = window.parent.$('#UrlPOSF0061').val();
    url = ASOFT.helper.renderUrl(urlPOSF0061, data);
    ASOFT.form.clearMessageBox();
    //calHeightGrid('POSF0010Grid', 340);
    ASOFT.asoftPopup.showIframe(url, {});
}

function edit() {
    formStatus = 2;
    var timeID = $('#TimeID').val();
    var data = {
        FormStatus: formStatus,
        TimeID: timeID
    };
    //urlUpdate = window.parent.$('#UrlInsert').val();
    //urlUpdate = window.parent.$('#UrlUpdate').val();
    var urlPOSF0061 = $('#UrlPOSF0061').val();
    url = ASOFT.helper.renderUrl(urlPOSF0061, data);
    ASOFT.form.clearMessageBox();
    //calHeightGrid('POSF0010Grid', 340);
    ASOFT.asoftPopup.showIframe(url, {});
}

// Reset lại Form search.
function resetForm() {
    isSearch = 0;
    $('#FormFilter input').val('');
    var multiComboBox = $('#DivisionID').data('kendoDropDownList');
    var multiShopComboBox = $('#ShopID').data('kendoDropDownList');
    resetDropDown(multiComboBox);
    resetDropDown(multiShopComboBox);
    ASOFT.form.clearMessageBox();
    refreshGrid();
}

function resetFormPOSF0061() {
    var comboBeginHour = ASOFT.asoftComboBox.castName('BeginHour');
    var comboEndHour = ASOFT.asoftComboBox.castName('EndHour');
    var comboBeginMinute = ASOFT.asoftComboBox.castName('BeginMinute');
    var comboEndMinute = ASOFT.asoftComboBox.castName('EndMinute');

    $('#TimeID').val('');
    $('#TimeName').val('');
    $('#TimeNameE').val('');
    $('#Description').val('');
    comboBeginHour.value(0);
    comboBeginMinute.value(0);
    comboEndHour.value(0);
    comboEndMinute.value(0);
}

// Lọc dữ liệu của lưới
function filterData() {
    isSearch = true;
    ASOFT.form.clearMessageBox();
    posf0060Grid.dataSource.page(1);

}

//=============================================================================
// Grid Master
//=============================================================================
function sendDataFilter() {
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    datamaster['IsSearch'] = isSearch;
    return datamaster;
}

//Hiển thị các dòng được chọn
function showRecord() {
    var args = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(posf0060Grid);
    if (records.length == 0) {// nếu record không có dòng nào dc chọn.
        return;
    }
    for (var i = 0; i < records.length; i++) {
        args.push(records[i].TimeID);
    }
    var url = $('#UpdateRecord').val();
    var data = {
        args: args,
        mode : 2,
    };
    ASOFT.helper.postTypeJson(url, data, function (result) {
        ASOFT.helper.showErrorSeverOption(1, result, 'FormFilter', function () {
           
        }, null, null, true, false, 'FormFilter');

        if (posf0060Grid) {
            refreshGrid(); // Refresh grid 
        }
    });
}

//Ấn các dòng được chọn
function hideRecord() {
    var args = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(posf0060Grid);
    if (records.length == 0) { // nếu record không có dòng nào dc chọn.
        return;
    }
    for (var i = 0; i < records.length; i++) {
        args.push(records[i].TimeID);
    }
    var url = $('#UpdateRecord').val();
    var data = {
        args: args,
        mode: 1,
    };
    ASOFT.helper.postTypeJson(url, data, function (result) {
        ASOFT.helper.showErrorSeverOption(1, result, 'FormFilter', function () {
            refreshGrid();
        }, null, null, true, false, 'FormFilter');

        if (posf0060Grid) {
            refreshGrid(); // Refresh grid 
        }
    });
}

//Xóa cửa hàng
function deleted() {
    var urlDeletePOSF0060 = $('#UrlDelete').val();
    var args = [];
    var data = {};
    if (posf0060Grid) { // Lấy danh sách các dòng đánh dấu
        isDetail = false;
        var records = ASOFT.asoftGrid.selectedRecords(posf0060Grid, 'FormFilter');
        if (records.length == 0) return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].TimeID);
        }
    } else {
        isDetail = true;
        // Lấy đối tượng hiện tại nếu đang ở màn hình details
        var timeID = $('input[name="TimeID"]').val();
        args.push(timeID);
    }

    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024' /*A00ML000002*/), function () {
        data['args'] = args;
        data['isDetail'] = isDetail;
        ASOFT.helper.postTypeJson(urlDeletePOSF0060, data, deleteSuccess);

    });
}

//Kết quả server trả về sau khi xóa
function deleteSuccess(result) {
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
        var urlPOSF0060 = window.parent.$('#UrlPOSF0060').val();
        // Chuyển hướng hoặc refresh data
        if (urlPOSF0060 != null) {
            window.location.href = urlPOSF0060; // redirect index
        }
    }, null, null, true, displayOnRedirecting, "FormFilter");

    if (posf0060Grid) {
        refreshGrid(); // Refresh grid 
    }
}

function checkInList() {
    ASOFT.form.checkItemInListFor(this, 'POSF0061');
}

function getData() {
    //Lấy dữ liệu từ form post lên
    var data = ASOFT.helper.getFormData(null, "POSF0061");
    return data;
}

function btnSave_Click() {
    urlUpdate = formStatus == 1 ? window.parent.$('#UrlInsert').val() : window.parent.$('#UrlUpdate').val();
    saveActionType = 3;
    SaveData();
}

function btnSaveCopy_Click() {
    urlUpdate = window.parent.$('#UrlInsert').val();
    saveActionType = 2;
    SaveData();
}

function btnSaveNew_Click() {
    urlUpdate = window.parent.$('#UrlInsert').val();
    saveActionType = 1;
    SaveData();
}

function SaveData() {
    if (ASOFT.form.checkRequiredAndInList("POSF0061", ['BeginHour', 'BeginMinute', 'EndHour', 'EndMinute'])) {
        return;
    }

    var data = getData();
    ASOFT.helper.post(urlUpdate, data, saveSuccess);
}

function saveSuccess(result) {
    // Update status
    ASOFT.form.updateSaveStatus('POSF0061', result.Status, result.Data);
    ASOFT.helper.showErrorSeverOption(0, result, "POSF0061", function () {
        switch (saveActionType) {
            case 1:
                //$('form#POSF0061').val('');
                formStatus = 1;
                ASOFT.form.displayInfo('#POSF0061', ASOFT.helper.getMessage(result.MessageID).format(result.Data));
                resetFormPOSF0061();
                break;
            case 2:
                formStatus = 1;
                ASOFT.form.displayInfo('#POSF0061', ASOFT.helper.getMessage(result.MessageID).format(result.Data));
                break;
            case 3:
                //formStatus = 2;
                if (typeof(posf0060Grid) !== 'undefined') {
                    window.parent.posf0060Grid.dataSource.page(1);
                }
                else {
                    window.parent.location.reload();
                }
                popupClose();
                break;
        }
    });

    if (window.parent.posf0060Grid) {
        window.parent.posf0060Grid.dataSource.page(1);
    }
}

// refresh lưới
function refreshGrid() {
    posf0060Grid.dataSource.page(1);
}

function reloadWindow() {
    window.location.reload();
}


function btnPrint_Click() {
    var datamaster = sendDataFilter();
    ASOFT.helper.postTypeJson("/POS/POSF0060/DoPrintOrExport", datamaster, ExportSuccess);

}

function ExportSuccess(result) {
    if (result) {
        var urlPrint = '/POS/POSF0060/ReportViewer';
        var options = '&viewer=pdf';
        // Tạo path full
        var fullPath = urlPrint + "?id=" + result.apk + options;

        // Getfile hay in báo cáo
        window.open(fullPath, "_blank");
    }
}







