//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/02/2014      Minh Lâm         Tạo mới
//####################################################################
// Global
var isSearch = false; // biến Lọc dữ liệu
var formStatus = null; // loại form
var saveActionType = null; // loại lưu dữ liệu
var urlUpdate = null;
var saveActionType = null; // 1: SaveNext, 2: SaveCopy, 3: SaveClose
var isCAFE = false;

$(document).ready(function () {
    var elementIDs = [
       'POSF0010BtnFilter',
       'POSF0010BtnClearFilter',
       'btnSave',
       'btnDelete',
       'btnExport',
       'btnInActive',
       'btnActive',
       'chkAll',
       'btnFilter'
    ];
    // Tạo Grid
    POSF0010Grid = $('#POSF0010Grid').data('kendoGrid');
    //ASOFT.helper.initAutoClearMessageBox(elementIDs, POSF0010Grid);
});
$(window).resize(function () {
    calHeightGrid('POSF0010Grid', 340);
});

function getIsCAFE() {
    return isCAFE;
}

function shopDetail_Click(e) {
    var data1 = [];
    data1.push($(e).text());
    ASOFT.helper.postTypeJson("/POS/POSF0010/GetBusinessArea", data1, function (result) {
        isCAFE = result;
    });

    formStatus = 2;
    urlUpdate = $('#UrlUpdate').val();
    var data = {};
    data['args'] = { 'ShopID': $(e).text(), 'FormStatus': formStatus };
    var url = "";
    ASOFT.form.clearMessageBox();
    //if (ASOFTEnvironment.CustomerIndex.isPhucLong()) 
    if (isCAFE) {
        ASOFT.asoftPopup.showIframe('/POS/POSF0010/POSF00101?FormStatus={0}&ShopID={1}'
        .format(formStatus, $(e).text()), data);
    }
    else {
        ASOFT.asoftPopup.showIframe('/POS/POSF0010/POSF0068?FormStatus={0}&ShopID={1}'
       .format(formStatus, $(e).text()), data);
    }

    return false;
}
// Lưu dữ liệu
function POSF0001Save(event) {
    popup.close();
}

// Đóng Popup
function popupClose1(event) {
    ASOFT.asoftPopup.hideIframe();
}

function btnCloseClick() {
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('AFML000006'), SaveClose, popupClose);
}

// Reset lại Form search.
function resetForm() {
    $('#FormFilter input').val('');
    $('#DivisionIDFilter').val('');
    var multiComboBox = $('#DivisionIDFilter').data('kendoDropDownList');
    resetDropDown(multiComboBox);
    ASOFT.form.clearMessageBox();
    //refreshGrid();
}

// Lọc dữ liệu của lưới
function filterData() {
    isSearch = true;
    ASOFT.form.clearMessageBox();
    POSF0010Grid.dataSource.page(1);

}

//=============================================================================
// Grid Master
//=============================================================================
function sendDataFilter() {
    var from = ASOFT.helper.getFormData(null, 'FormFilter');
    var datamaster = {};
    var isCommon = $('form#FormFilter input:checkbox#IsCommonFilter').prop('checked');
    $.each(from, function () {
        if (datamaster[this.name]) {
            if (!datamaster[this.name].push) {
                datamaster[this.name] = [datamaster[this.name]];
            }
            datamaster[this.name].push(this.value || '');
        } else {
            datamaster[this.name] = this.value || '';
        }
    });
    datamaster['IsSearch'] = isSearch;
    return datamaster;
}

//Hiển thị các dòng được chọn
function showRecord() {
    var args = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(POSF0010Grid);
    if (records.length == 0) {// nếu record không có dòng nào dc chọn.
        return;
    }
    for (var i = 0; i < records.length; i++) {
        args.push(records[i].ShopID);
    }
    var url = $('#UpdateRecord').val();
    var data = {
        args: args,
        disabled: 0,
    };
    ASOFT.helper.postTypeJson(url, data, function (result) {
        if (result.Status == 0) {
            POSF0010Grid.dataSource.page(1);
        }
    });
}

//Ấn các dòng được chọn
function hideRecord() {
    var args = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(POSF0010Grid);
    if (records.length == 0) { // nếu record không có dòng nào dc chọn.
        return;
    }
    for (var i = 0; i < records.length; i++) {
        args.push(records[i].ShopID);
    }
    var url = $('#UpdateRecord').val();
    var data = {
        args: args,
        disabled: 1,
    };
    ASOFT.helper.postTypeJson(url, data, function (result) {
        if (result.Status == 0) {
            POSF0010Grid.dataSource.page(1);
        }
    });
}

//Xóa cửa hàng
function deleted() {
    var urlDeletePOSF0010 = $('#UrlDeleted').val();
    ASOFT.form.clearMessageBox();
    var args = [];
    var data = {};
    if (POSF0010Grid) { // Lấy danh sách các dòng đánh dấu
        var records = ASOFT.asoftGrid.selectedRecords(POSF0010Grid);
        if (records.length == 0) // nếu record không có dòng nào dc chọn.
        {
            return;
        }
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].ShopID);
        }
    }
    else {
        // Lấy đối tượng hiện tại nếu đang ở màn hình details
        var shopID = $('#Shop').val();
        args.push(shopID);
    }
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        data['args'] = args;
        ASOFT.helper.postTypeJson(urlDeletePOSF0010, data, deleteSuccess);
    });
}

//Kết quả server trả về sau khi xóa
function deleteSuccess(result) {
    if (result.Status == 0) {
        var urlPOSF0010 = $('#UrlPOSF0010').val();
        // Chuyển hướng hoặc refresh data
        if (result.MessageID) { // Message isn't null
            if (result.Data != null) {// Nếu có xóa SHOPID môi trường. Load lại menu theo ShopID mới.
                window.location.reload();
            }
            ASOFT.form.displayInfo('#FormFilter', ASOFT.helper.getMessage(result.MessageID));
        }
        if (urlPOSF0010 != null) {
            window.location.href = urlPOSF0010; // redirect index
        }
    }
    else {
        if (result.Params) {
            var msg = ASOFT.helper.getMessage(result.MessageID);
            msg = kendo.format(msg, result.Params);
            ASOFT.form.displayWarning('#FormFilter', msg);
            POSF0010Grid.dataSource.page(1);
        }
        //var errors = result.Data;
        //var msgs = [];
        //for (var j = 0; j < errors.length; j++) {
        //    var error = errors[j];
        //    var msg = ASOFT.helper.getMessage(result.Message);
        //    if (error.Params) { // Nếu có param trong errors
        //        msg = kendo.format(msg, error.Params);
        //    }
        //    msgs.push(msg);
        //}
        ////show message
        //if (msgs.length > 0) {
        //    //msg = kendo.format(msg, error.Params);
        //    ASOFT.form.displayWarning('#FormFilter', msgs);
        //}
        //POSF0010Grid.dataSource.page(1)
    }
    if (POSF0010Grid) {
        POSF0010Grid.dataSource.page(1); // Refresh grid 
    }
}

function insert() {
    formStatus = 1;
    urlUpdate = $('#UrlInsert').val();
    //var url = '';
    //if (ASOFTEnvironment.CustomerIndex.isPhucLong()) {
    //    url = kendo.format('/POS/POSF0010/POSF00101?FormStatus={0}', formStatus);
    //}
    //else {
    //    url = kendo.format('/POS/POSF0010/POSF0068?FormStatus={0}', formStatus);
    //}
    url = '/POS/POSF0010/POSF0070';
    ASOFT.form.clearMessageBox();
    //calHeightGrid('POSF0010Grid', 340);
    ASOFT.asoftPopup.showIframe(url, {});

    return false;
}

// refresh lưới
function refreshGrid() {
    POSF0010Grid.dataSource.page(1);
}

function reloadWindow() {
    window.location.reload();
}


function btnConfig_Click(divisionID, shopID) {
    //posf0010APK = apk;
    var urlPOSF0050 = $('#UrlPOSF0050').val();
    var data = {
        DivisionID: divisionID,
        ShopID: shopID
    }
    var postUrl = ASOFT.helper.renderUrl(urlPOSF0050, data);

    // [2] Render iframe
    ASOFT.asoftPopup.showIframe(postUrl, {});
}

function sendDataSearch() {
    var from = ASOFT.helper.getFormData(null, 'FormFilter');
    var datamaster = {};
    var isCommon = $('form#FormFilter input:checkbox#IsCommonFilter').prop('checked');
    $.each(from, function () {
        if (datamaster[this.name]) {
            if (!datamaster[this.name].push) {
                datamaster[this.name] = [datamaster[this.name]];
            }
            datamaster[this.name].push(this.value || '');
        } else {
            datamaster[this.name] = this.value || '';
        }
    });
    datamaster['IsSearch'] = isSearch;
    return datamaster;
}

function print() {
    var datamaster = sendDataSearch();
    ASOFT.helper.postTypeJson("/POS/POSF0010/DoPrintOrExport", datamaster, ExportSuccess);

}

function ExportSuccess(result) {
    if (result) {
        var urlPrint = '/POS/POSF0010/ReportViewer';
        var options = '&viewer=pdf';
        // Tạo path full
        var fullPath = urlPrint + "?id=" + result.apk + options;

        // Getfile hay in báo cáo
        window.open(fullPath, "_blank");
    }
}







