//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Created         Comment
//#     09/10/2014      Hoàng Tú        Tạo mới
//####################################################################
var ID = 'SF1000';
var SF1000Grid = null;
var FORM_ID = 'FormFilter';
var DepartmentID = null;
var isSearch = false;
var URL_SHOWPOPUP = '/S/SF1000/SF1001';
var URL_DELETE = '/S/SF1000/DeleteMany';
//Hàm: khởi tạo các đối tượng trong javascript
$(document).ready(function () {
    SF1000Grid = $('#SF1000Grid').data('kendoGrid');
    DepartmentID = ASOFT.asoftComboBox.castName('DepartmentID');
});
//Sự kiện: Combobox Department changed
function combo_Changed(e) {
    ASOFT.form.checkItemInListFor(this, ID);
}
//Sự kiện: Thêm
function ShowEditorFrame() {
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(URL_SHOWPOPUP, {});
}
//Sự kiện: Nhấn nút lọc dữ liệu
function SF1000BtnFilter_Click() {
    isSearch = true;
    ASOFT.form.clearMessageBox();
    refreshGrid();
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
    if (datamaster['IsCommon'] == 0) {
        datamaster['IsCommon'] = null;
    }
    else if (datamaster['IsCommon'] == 2) {
        datamaster['IsCommon'] = true;
    } else if (datamaster['IsCommon'] == 1) {
        datamaster['IsCommon'] = false;
    }
    return datamaster;
}
//Hàm: Reset các input
function SF1000BtnClearFilter_Click() {
    isSearch = false;
    ASOFT.form.clearMessageBox();
    $('#FormFilter input').val('');
    var multiComboBox = $('#DivisionIDFilter').data('kendoDropDownList');
    resetDropDown(multiComboBox);
    refreshGrid();
}

//Hàm: Làm mới lưới
function refreshGrid() {
    SF1000Grid.dataSource.page(1);
}
// Xử lý khi click nút Enable
function btnEnable_Click() {
    var args = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(SF1000Grid);
    if (records.length == 0) {
        return;
    }
    for (var i = 0; i < records.length; i++) {
        args.push(records[i].EmployeeID);
    }
    var url = $('#EnableRecord').val();
    var data = {
        args: args,
        disabled: 1,
    };
    ASOFT.helper.postTypeJson(url, data, function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, FORM_ID, function () {
            refreshGrid();
        }, null, function () {
            refreshGrid();
        }, true);
    });

}
// Xử lý khi click nút Disable
function btnDisable_Click() {
    var args = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(SF1000Grid);
    if (records.length == 0) {// nếu record không có dòng nào dc chọn.
        return;
    }
    for (var i = 0; i < records.length; i++) {
        args.push(records[i].EmployeeID);
    }
    var url = $('#DisableRecord').val();
    var data = {
        args: args,
        disabled: 0,
    };
    ASOFT.helper.postTypeJson(url, data, function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, FORM_ID, function () {
            refreshGrid();
        }, null, function () {
            refreshGrid();
        }, true);
    });

}
// Xử lý khi click nút Lock
function btnLockUser_Click() {
    var args = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(SF1000Grid);
    if (records.length == 0) {
        return;
    }
    for (var i = 0; i < records.length; i++) {
        args.push(records[i].EmployeeID);
    }
    var url = $('#LockUser').val();
    var data = {
        args: args
    };
    ASOFT.helper.postTypeJson(url, data, function (result) {
        if (result.Status == 0) {
            SF1000Grid.dataSource.page(1);
        }
    });
}
function btnUnLockUser_Click() {
    var args = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(SF1000Grid);
    if (records.length == 0) {
        return;
    }
    for (var i = 0; i < records.length; i++) {
        args.push(records[i].EmployeeID);
    }
    var url = $('#UnLockUser').val();
    var data = {
        args: args
    };
    ASOFT.helper.postTypeJson(url, data, function (result) {
        if (result.Status == 0) {
            SF1000Grid.dataSource.page(1);
        }
    });
}
function popupClose() {
    ASOFT.asoftPopup.hideIframe();
}
// Xóa nhiều nhân viên
function btnDelete_Click() {
    var args = [];
    var data = {};
    ASOFT.form.clearMessageBox();
    if (SF1000Grid) {
        var records = ASOFT.asoftGrid.selectedRecords(SF1000Grid);
        if (records.length == 0)
            return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].EmployeeID);
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
