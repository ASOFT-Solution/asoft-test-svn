//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     09/10/2014      Chánh Thi        Tạo mới
//####################################################################

var isSearch = false;
var formStatus = null;
var urlUpdate = null;

$(document).ready(function () {
    // Tạo Grid
    SF1010Grid = $('#SF1010Grid').data('kendoGrid');
    //ASOFT.helper.initAutoClearMessageBox(elementIDs, POSF0010Grid);
});
$(window).resize(function () {
    calHeightGrid('SF1010Grid', 340);
});

function sendDataFilterSearch() {
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

function clearData() {
    $('#FormFilter input').val('');
    $('#DivisionIDFilter').val('');
    var multiComboBox = $('#DivisionIDFilter').data('kendoDropDownList');
    resetDropDown(multiComboBox);
    isSearch = false;

    // Reload grid
    ASOFT.form.clearMessageBox();
    SF1010Grid.dataSource.page(1);
}

function filterData() {
    isSearch = true;
    ASOFT.form.clearMessageBox();
    SF1010Grid.dataSource.page(1);

}

function insert() {
    formStatus = 1;
    urlUpdate = $('#UrlInsert').val();
    var url = '';
    
    url = kendo.format('/S/SF1010/SF1011?FormStatus={0}', formStatus);
    
    ASOFT.form.clearMessageBox();
    //calHeightGrid('POSF0010Grid', 340);
    ASOFT.asoftPopup.showIframe(url, {});

    return false;
}

function btn_delete() {
    var args = [];
    var data = {};
    var grid = ASOFT.asoftGrid.castName("SF1010Grid");
    ASOFT.form.clearMessageBox();
    if (grid) {
        var records = ASOFT.asoftGrid.selectedRecords(grid);
        if (records.length == 0)
            return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].GroupID);
        }
    }
    //Bạn có muốn xóa không?
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        data['args'] = args;
        ASOFT.helper.postTypeJson(
                    '/S/SF1010/DeleteMany',
                    data,
                    deleteSuccess);
    });
}

function deleteSuccess (result) {
    ASOFT.helper.showErrorSeverOption(1, result, 'FormFilter', function () {
        refreshGrid();
    }, null, function () {
        refreshGrid();
    }, true);
}

function groupDetail_Click(e) {
    formStatus = 2;
    var data = {};
    data['args'] = { 'GroupID': $(e).text(), 'FormStatus': formStatus };
    var url = "";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe('/S/SF1010/SF1012?FormStatus={0}&GroupID={1}'
       .format(formStatus, $(e).text()), data);
}

function refreshGrid() {
    SF1010Grid.dataSource.page(1);
}

function popupClose(event) {
    ASOFT.asoftPopup.hideIframe();
}

//Hiển thị các dòng được chọn
function showRecord() {
    var args = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(SF1010Grid);
    if (records.length == 0) {// nếu record không có dòng nào dc chọn.
        return;
    }
    for (var i = 0; i < records.length; i++) {
        args.push(records[i].GroupID);
    }
    var url = $('#UpdateRecord').val();
    var data = {
        args: args,
        disabled: 0,
    };
    ASOFT.helper.postTypeJson(url, data, function (result) {
        if (result.Status == 0) {
            SF1010Grid.dataSource.page(1);
        }
    });
}

// Ẩn các dòng được chọn
function hideRecord() {
    var args = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(SF1010Grid);
    if (records.length == 0) { // nếu record không có dòng nào dc chọn.
        return;
    }
    for (var i = 0; i < records.length; i++) {
        args.push(records[i].GroupID);
    }
    var url = $('#UpdateRecord').val();
    var data = {
        args: args,
        disabled: 1,

    };
    ASOFT.helper.postTypeJson(url, data, function (result) {
        if (result.Status == 0) {
            SF1010Grid.dataSource.page(1);
        }
    });
}

//thêm người dùng vào nhóm
function btn_AddUserToGroup()
{
    var grid = ASOFT.asoftGrid.castName("SF1010Grid");
    var record = ASOFT.asoftGrid.selectedRecord(grid);
    var url = '';
    var data = {
        GroupID: record.GroupID
    };
    url = ASOFT.helper.renderUrl('/S/SF1010/SF1013', data);
    ASOFT.asoftPopup.showIframe(url, {});
}

//thêm division vào nhóm
function btn_AddDivisionToGroup()
{
    var grid = ASOFT.asoftGrid.castName("SF1010Grid");
    var record = ASOFT.asoftGrid.selectedRecord(grid);
    var url = '';
    var data = {
        GroupID: record.GroupID
    };
    url = ASOFT.helper.renderUrl('/S/SF1010/SF1015', data);
    ASOFT.asoftPopup.showIframe(url, {});
}