//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Created         Comment
//#     10/10/2014      Hoàng Tú        Tạo mới
//####################################################################

var ID = 'CIF1020';
var URL_DELETE = '/CI/CIF1020/DeleteMany';
var popup = null;
var CIF1020Grid = null;
var FORM_ID = 'FormFilter';
var isSearch = false;
var URL_SHOWPOPUP = '/CI/CIF1020/CIF1021';
//Hàm: khởi tạo các đối tượng trong javascript
$(document).ready(function () {
    CIF1020Grid = $('#CIF1020Grid').data('kendoGrid');
});
//Sự kiện: Thêm
function ShowEditorFrame() {
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(URL_SHOWPOPUP, {});
}
// Hàm: Gởi dữ liệu từ FormFilter
function sendDataFilter() {
    var datamaster = ASOFT.helper.dataFormToJSON(FORM_ID);
    datamaster['IsSearch'] = isSearch;
    if (datamaster['Disabled'] == 0) {
        datamaster['Disabled'] = null;
    }
    else if (datamaster['Disabled'] == 2) {
        datamaster['Disabled'] = true;
    } else if (datamaster['Disabled'] == 1) {
        datamaster['Disabled'] = false;
    }
    return datamaster;
}
// Xử lý khi click nút Enable
function btnEnable_Click() { 
    var args = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(CIF1020Grid);
    if (records.length == 0) {// nếu record không có dòng nào dc chọn.
        return;
    }
    for (var i = 0; i < records.length; i++) {
        args.push(records[i].DutyID);
    }
    var url = $('#EnableRecord').val();
    var data = {
        args: args,
        disabled: 1,
    };
    ASOFT.helper.postTypeJson(url, data, function (result) {
        if (result.Status == 0) {
            CIF1020Grid.dataSource.page(1);
        }
    });
}

// Xử lý khi click nút Disable
function btnDisable_Click() {
    var args = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(CIF1020Grid);
    if (records.length == 0) {// nếu record không có dòng nào dc chọn.
        return;
    }
    for (var i = 0; i < records.length; i++) {
        args.push(records[i].DutyID);
    }
    var url = $('#DisableRecord').val();
    var data = {
        args: args,
        disabled: 0,
    };
    ASOFT.helper.postTypeJson(url, data, function (result) {
        if (result.Status == 0) {
            CIF1020Grid.dataSource.page(1);
        }
    });
}
function btnDelete_Click() {
    var args = [];
    var data = {};
    ASOFT.form.clearMessageBox();
    if (CIF1020Grid) {
        var records = ASOFT.asoftGrid.selectedRecords(CIF1020Grid);
        if (records.length == 0)
            return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].DutyID);
        }
    }
    //Bạn có muốn xóa không?
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
    data['args'] = args;
        ASOFT.helper.postTypeJson(
                    URL_DELETE,
                    data,
                    function (result) {
                        ASOFT.helper.showErrorSeverOption(1, result, FORM_ID, function () {
                            refreshGrid();
                        }, null, function () {
                            refreshGrid();
                        }, true);
                    });
    });
}
//Sự kiện: Lọc
function CIF1020BtnFilter_Click() {
    isSearch = true;
    ASOFT.form.clearMessageBox();
    refreshGrid();
}
function CIF1020BtnClearFilter_Click() {
    isSearch = false;
    ASOFT.form.clearMessageBox();  
    $('#DutyRate').val('');
    $('#DutyID').val('');
    $('#DutyName').val('');
    var multiComboBox = $('#DivisionIDFilter').data('kendoDropDownList');
    resetDropDown(multiComboBox);
    var comboboxDisabled = $("#Disabled").data("kendoComboBox");
    comboboxDisabled.value('');
    refreshGrid();
}
//Hàm: Đóng mặc định
function popupClose() {
    ASOFT.asoftPopup.hideIframe();
}
//Hàm: Làm mới lưới
function refreshGrid() {
    CIF1020Grid.dataSource.page(1);
}

