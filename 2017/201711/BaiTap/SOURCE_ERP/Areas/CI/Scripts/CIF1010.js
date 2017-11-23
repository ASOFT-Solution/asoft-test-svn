//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Created         Comment
//#     09/10/2014      Hoàng Tú        Tạo mới
//####################################################################
var ID = 'CIF1010';
var URL_DELETE = '/CI/CIF1010/DeleteMany';
var CIF1010Grid = null;
var FORM_ID = 'FormFilter';
var isSearch = false;
var FORM_ID = 'FormFilter';
var URL_SHOWPOPUP = '/CI/CIF1010/CIF1011';
//Hàm: khởi tạo các đối tượng trong javascript
$(document).ready(function () {
    CIF1010Grid = $('#CIF1010Grid').data('kendoGrid');
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
    var records = ASOFT.asoftGrid.selectedRecords(CIF1010Grid);
    if (records.length == 0) {// nếu record không có dòng nào dc chọn.
        return;
    }
    for (var i = 0; i < records.length; i++) {
        args.push(records[i].TeamID);
    }
    var url = $('#EnableRecord').val();
    var data = {
        args: args,
        disabled: 1,
    };
    ASOFT.helper.postTypeJson(url, data, function (result) {
        if (result.Status == 0) {
            CIF1010Grid.dataSource.page(1);
        }
    });
}
// Xử lý khi click nút Disable
function btnDisable_Click() {
    var args = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(CIF1010Grid);
    if (records.length == 0) {// nếu record không có dòng nào dc chọn.
        return;
    }
    for (var i = 0; i < records.length; i++) {
        args.push(records[i].TeamID);
    }
    var url = $('#DisableRecord').val();
    var data = {
        args: args,
        disabled: 0,
    };
    ASOFT.helper.postTypeJson(url, data, function (result) {
        if (result.Status == 0) {
            CIF1010Grid.dataSource.page(1);
        }
    });
}
function btnDelete_Click() {
    var args = [];
    var data = {};
    ASOFT.form.clearMessageBox();
    if (CIF1010Grid) {
        var records = ASOFT.asoftGrid.selectedRecords(CIF1010Grid);
        if (records.length == 0)
            return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].TeamID);
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
function CIF1010BtnFilter_Click() {
    isSearch = true;
    ASOFT.form.clearMessageBox();
    refreshGrid();
}
function refreshGrid() {
    CIF1010Grid.dataSource.page(1);
}
//Hàm: Đóng mặc định
function popupClose() {
    ASOFT.asoftPopup.hideIframe();
}
function CIF1010BtnClearFilter_Click() {
    isSearch = false;
    ASOFT.form.clearMessageBox();
    $('#DepartmentID').val('');
    $('#TeamID').val('');
    $('#TeamName').val('');
    $('#Notes').val('');
    $('#Notes01').val('');
    var multiComboBox = $('#DivisionIDFilter').data('kendoDropDownList');
    resetDropDown(multiComboBox);
    var comboboxDisabled = $("#Disabled").data("kendoComboBox");
    comboboxDisabled.value('');
    var multiComboBoxBranchID = $('#BranchID').data('kendoDropDownList');
    resetDropDown(multiComboBoxBranchID);
    refreshGrid();
}

//Open CIF1013
function btnEmpToTeam_Click() {
    var postUrl = $("#UrlAddEmp").val();
    var data = {};
    if (CIF1010Grid) {
        record = ASOFT.asoftGrid.selectedRecord(CIF1010Grid);

        if (!record || record == null) return;
        data = {
            TeamID: record.TeamID
        };
    }
    else {
        data.TeamID = $('#TeamID').text();
    }
    CIF1013.showPopup(postUrl, data);
}