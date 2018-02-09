//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Created         Comment
//#     09/10/2014      Hoàng Tú        Tạo mới
//####################################################################
var ID = 'CIF1000';
var URL_DELETE =    '/CI/CIF1000/DeleteMany';
var URL_SHOWPOPUP = '/CI/CIF1000/CIF1001';
var CIF1000Grid = null;
var FORM_ID = 'FormFilter';
var isSearch = false;
//Hàm: khởi tạo các đối tượng trong javascript
$(document).ready(function () {
    CIF1000Grid = $('#CIF1000Grid').data('kendoGrid');
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
//Xóa nhiều phòng ban
function btnDelete_Click() {
    var args = [];
    var data = {};
    ASOFT.form.clearMessageBox();
    if (CIF1000Grid) {
        var records = ASOFT.asoftGrid.selectedRecords(CIF1000Grid);
        if (records.length == 0)
            return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].DepartmentID);
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
function CIF1000BtnFilter_Click() {
        isSearch = true;
        ASOFT.form.clearMessageBox();
        refreshGrid();
    }
    function CIF1000BtnClearFilter_Click()
{
        isSearch = false;
        ASOFT.form.clearMessageBox();     
        $('#DepartmentID').val('');
        $('#DepartmentName').val('');
        var multiComboBox = $('#DivisionIDFilter').data('kendoDropDownList');
        resetDropDown(multiComboBox);
        var comboboxDisabled = $("#Disabled").data("kendoComboBox");
        comboboxDisabled.value('');
        var comboboxIsCommon= $("#IsCommon").data("kendoComboBox");
        comboboxIsCommon.value('');
        refreshGrid();
    }
     //Hàm: Làm mới lưới
    function refreshGrid() {
        CIF1000Grid.dataSource.page(1);
    }
   // Xử lý khi click nút Enable
    function btnEnable_Click() {
        var args = [];
        ASOFT.form.clearMessageBox();
        var records = ASOFT.asoftGrid.selectedRecords(CIF1000Grid);
        if (records.length == 0) {// nếu record không có dòng nào dc chọn.
            return;
        }
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].DepartmentID);
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
        var records = ASOFT.asoftGrid.selectedRecords(CIF1000Grid);
        if (records.length == 0) {// Nếu record không có dòng nào dc chọn.
            return;
        }
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].DepartmentID);
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
    //Hàm: Đóng mặc định
    function popupClose() {
        ASOFT.asoftPopup.hideIframe();
    }
    //Hàm: Làm mới lưới
    function refreshGrid() {
        CIF1000Grid.dataSource.page(1);
    }

    function btnPrint_Click() {
        var datamaster = sendDataFilter();
        ASOFT.helper.postTypeJson("/CI/CIF1000/DoPrintOrExport", datamaster, ExportSuccess);
    }

    function ExportSuccess(result) {
        if (result) {
            var urlPrint = '/CI/CIF1000/ReportViewer';
            var urlExcel = '/CI/CIF1000/ExportReport';
            var urlPost = !isMobile ? urlPrint : urlExcel;
            var options = !isMobile ? '&viewer=pdf' : '';
            // Tạo path full
            var fullPath = urlPost + "?id=" + result.apk + options;

            // Getfile hay in báo cáo
            if (!isMobile)
                window.open(fullPath, "_blank");
            else {
                window.location = fullPath;
            }
        }
    }