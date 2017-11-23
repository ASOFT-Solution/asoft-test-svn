//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     28/04/2014      Đam Mơ          Tạo Mới
//####################################################################

var POSF0020Grid = null;
var FORM_ID = 'FormFilter';
// Biến kiểm tra lọc dữ liệu
var isSearch = false;
var formStatus = null; // loại form
var urlUpdate = null;
$(document).ready(function () {
    var 
        FORM_ID = 'FormFilter',
        // Biến kiểm tra lọc dữ liệu
        isSearch = false,
        formStatus = null,
        urlUpdate = null,
        datepicker = $("#ReleaseDate").data("kendoDatePicker"),
        value = datepicker.value(''),
        datepicker = $("#ExpireDate").data("kendoDatePicker"),
        value = datepicker.value(''),
        element = $('#POSF0020Grid'),
        grid = element.data('kendoGrid');

    POSF0020Grid = $('#POSF0020Grid').data('kendoGrid');

    grid.bind('dataBound', function () {
        var length = grid.dataSource.data().length;
        $('#POSF0020Grid').find('td:nth-child(11n)').addClass('asf-cols-align-center');
        initEventOnTableCell();
    });

    // Khởi tạo sự kiện click lên một ô chứa checkbox "chọn"
    function initEventOnTableCell() {
        var td_Click = function (index) {
            var checkBox = $($(this).children()[0]);
            checkBox.attr('checked', !checkBox.attr('checked'));
        };

        var ckb_Click = function (e) {
            e.stopPropagation();
        }

        $('td').has('input[type="checkbox"]:not([disabled])').on('click', td_Click);
        $('input[type="checkbox"]').on('click', ckb_Click);
    }
       
    // Load lại lưới
    function refreshGrid() {
        POSF0020Grid.dataSource.page(1);
    }

    // Hiển thị popup thêm 
    function showEditorFrame() {
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.showIframe('/POS/POSF0020/POSF00201', {});
    }

    function voucherDetail_Click(e) {
        formStatus = 2;
        //urlUpdate = $('#UrlUpdate').val();
        var data = {};
        data['args'] = { 'MemberCardID': $(e).text(), 'FormStatus': formStatus };
        var url = "";
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.showIframe('/POS/POSF0020/POSF00201?FormStatus={0}&MemberCardID={1}'
           .format(formStatus, $(e).text()), data);
        return false;
    }

    // Xử lý sự kiện click nút lưu
    function POSF0020Save(event) {
        ASOFT.asoftPopup.hideIframe();
    }

    // Xử lý sự kiện click nút đóng
    function popupClose(event) {
        ASOFT.asoftPopup.hideIframe();
    }

    // Xử lý khi click nút Enable
    function btnEnable_Click() {

        var args = [];
        ASOFT.form.clearMessageBox();
        var records = ASOFT.asoftGrid.selectedRecords(POSF0020Grid);
        if (records.length == 0) {// nếu record không có dòng nào dc chọn.
            return;
        }
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].MemberCardID);
        }
        var url = $('#EnableRecord').val();
        var data = {
            args: args,
            disabled: 1,
        };
        ASOFT.helper.postTypeJson(url, data, function (result) {
            if (result.Status == 0) {
                POSF0020Grid.dataSource.page(1);
            }
        });
    }

    // Xử lý khi click nút Disable
    function btnDisable_Click() {
        var args = [];
        ASOFT.form.clearMessageBox();
        var records = ASOFT.asoftGrid.selectedRecords(POSF0020Grid);
        if (records.length == 0) {// nếu record không có dòng nào dc chọn.
            return;
        }
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].MemberCardID);
        }
        var url = $('#DisableRecord').val();
        var data = {
            args: args,
            disabled: 0,
        };
        ASOFT.helper.postTypeJson(url, data, function (result) {
            if (result.Status == 0) {
                POSF0020Grid.dataSource.page(1);
            }
        });
    }

    // Xử lý khi click nút Xóa
    function btnDelete_Click() {
        var args = [];
        var data = {};
        ASOFT.form.clearMessageBox();
        if (POSF0020Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(POSF0020Grid);
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].MemberCardID);
            }
        }
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
            var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
            data['args'] = args;
            ASOFT.helper.postTypeJson('/POS/POSF0020/Delete', data, deleteSuccess);
        });
    }

    // Xử lý kết quả từ server trả về sau khi xóa thành công
    function deleteSuccess(result) {
        // Nếu xóa thành công
        if (result.Message.length == 0 || result.Message == null) {
            // Thông báo msg: 'Xóa thành công.'
            ASOFT.form.displayInfo('#' + FORM_ID, ASOFT.helper.getMessage('00ML000057').format(result.Data.join(', ')));
            refreshGrid(); // Refresh grid 

        }
        else {
            if (POSF0020Grid) {
                POSF0020Grid.dataSource.read();
            }
            ASOFT.form.clearMessageBox();
            ASOFT.form.displayWarning('#' + FORM_ID, ASOFT.helper.getMessage("00ML000052").format(result.Message));
        }
        refreshGrid();
    }

    // Hàm gởi dữ liệu từ FormFilter
    function sendDataFilter() {
        var datamaster = ASOFT.helper.dataFormToJSON('FormFilter');
        datamaster['IsSearch'] = isSearch;
        if (datamaster['Disabled'] == 1) {
            datamaster['Disabled'] = null;
        }
        else if (datamaster['Disabled'] == 1) {
            datamaster['Disabled'] = true;
        } else if (datamaster['Disabled'] == 2) {
            datamaster['Disabled'] = false;
        }

        return datamaster;
    }

    // Xử lý button search
    function posf0020BtnFilter_Click() {
        isSearch = true;
        ASOFT.form.clearMessageBox();
        refreshGrid();
    }

    // Xử lý button clearsearch
    function posf0020BtnClearFilter_Click() {
        isSearch = false;
        ASOFT.form.clearMessageBox();
        // Reset business combobox
        var multiComboBox = $('#DivisionID').data('kendoDropDownList');
        resetDropDown(multiComboBox);
        var comboboxTypeNo = $("#TypeNo").data("kendoComboBox");
        comboboxTypeNo.value('');
        var comboboxDisabled = $("#Disabled").data("kendoComboBox");
        comboboxDisabled.value('');
        // Reset các field còn lại
        $('#MemberCardID').val('');
        $('#MemberCardName').val('');
        $('#ReleaseDate').val('');
        $('#ExpireDate').val('');
    }

});

// Load lại lưới
function refreshGrid() {
    POSF0020Grid.dataSource.page(1);
}

// Hiển thị popup thêm 
function ShowEditorFrame() {
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe('/POS/POSF0020/POSF00201', {});
}

/**
* detail popup
*/
function voucherDetail_Click(e) {
    formStatus = 2;
    //urlUpdate = $('#UrlUpdate').val();
    var data = {};
    data['args'] = { 'MemberCardID': $(e).text(), 'FormStatus': formStatus };
    var url = "";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe('/POS/POSF0020/POSF00201?FormStatus={0}&MemberCardID={1}'
       .format(formStatus, $(e).text()), data);
    return false;
}

// Xử lý sự kiện click nút lưu
function POSF0020Save(event) {
    ASOFT.asoftPopup.hideIframe();
}

// Xử lý sự kiện click nút đóng
function popupClose(event) {
    ASOFT.asoftPopup.hideIframe();
}

// Xử lý khi click nút Enable
function btnEnable_Click() {

    var args = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(POSF0020Grid);
    if (records.length == 0) {// nếu record không có dòng nào dc chọn.
        return;
    }
    for (var i = 0; i < records.length; i++) {
        args.push(records[i].MemberCardID);
    }
    var url = $('#EnableRecord').val();
    var data = {
        args: args,
        disabled: 1,
    };
    ASOFT.helper.postTypeJson(url, data, function (result) {
        if (result.Status == 0) {
            POSF0020Grid.dataSource.page(1);
        }
    });
}

// Xử lý khi click nút Disable
function btnDisable_Click() {
    var args = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(POSF0020Grid);
    if (records.length == 0) {// nếu record không có dòng nào dc chọn.
        return;
    }
    for (var i = 0; i < records.length; i++) {
        args.push(records[i].MemberCardID);
    }
    var url = $('#DisableRecord').val();
    var data = {
        args: args,
        disabled: 0,
    };
    ASOFT.helper.postTypeJson(url, data, function (result) {
        if (result.Status == 0) {
            POSF0020Grid.dataSource.page(1);
        }
    });
}

// Xử lý khi click nút Xóa
function btnDelete_Click() {
    var args = [];
    var data = {};
    ASOFT.form.clearMessageBox();
    if (POSF0020Grid) { // Lấy danh sách các dòng đánh dấu
        var records = ASOFT.asoftGrid.selectedRecords(POSF0020Grid);
        if (records.length == 0) return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].MemberCardID);
        }
    }
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
        data['args'] = args;
        ASOFT.helper.postTypeJson('/POS/POSF0020/Delete', data, deleteSuccess);
    });
}

// Xử lý kết quả từ server trả về sau khi xóa thành công
function deleteSuccess(result) {
    // Nếu xóa thành công
    if (result.Message.length == 0 || result.Message == null) {
        // Thông báo msg: 'Xóa thành công.'
        ASOFT.form.displayInfo('#' + FORM_ID, ASOFT.helper.getMessage('00ML000057').format(result.Data.join(', ')));
        refreshGrid(); // Refresh grid 

    }
    else {
        if (POSF0020Grid) {
            POSF0020Grid.dataSource.read();
        }
        ASOFT.form.clearMessageBox();
        ASOFT.form.displayWarning('#' + FORM_ID, ASOFT.helper.getMessage("00ML000052").format(result.Message));
    }
    refreshGrid();
}

// Hàm gởi dữ liệu từ FormFilter
function sendDataFilter() {
    var datamaster = ASOFT.helper.dataFormToJSON('FormFilter');
    datamaster['IsSearch'] = isSearch;
    if (datamaster['Disabled'] == 1) {
        datamaster['Disabled'] = null;
    }
    else if (datamaster['Disabled'] == 1) {
        datamaster['Disabled'] = true;
    } else if (datamaster['Disabled'] == 2) {
        datamaster['Disabled'] = false;
    }

    return datamaster;
}

// Xử lý button search
function posf0020BtnFilter_Click() {
    isSearch = true;
    ASOFT.form.clearMessageBox();
    refreshGrid();
}

// Xử lý button clearsearch
function posf0020BtnClearFilter_Click() {
    isSearch = false;
    ASOFT.form.clearMessageBox();
    // Reset business combobox
    var multiComboBox = $('#DivisionID').data('kendoDropDownList');
    resetDropDown(multiComboBox);
    var comboboxTypeNo = $("#TypeNo").data("kendoComboBox");
    comboboxTypeNo.value('');
    var comboboxDisabled = $("#Disabled").data("kendoComboBox");
    comboboxDisabled.value('');
    // Reset các field còn lại
    $('#MemberCardID').val('');
    $('#MemberCardName').val('');
    $('#ReleaseDate').val('');
    $('#ExpireDate').val('');
}

function btnPrint_Click() {
    var datamaster = sendDataFilter();
    ASOFT.helper.postTypeJson("/POS/POSF0020/DoPrintOrExport", datamaster, ExportSuccess);

}

function ExportSuccess(result) {
    if (result) {
        var urlPrint = '/POS/POSF0020/ReportViewer';
        var options = '&viewer=pdf';
        // Tạo path full
        var fullPath = urlPrint + "?id=" + result.apk + options;

        // Getfile hay in báo cáo
        window.open(fullPath, "_blank");
    }
}
