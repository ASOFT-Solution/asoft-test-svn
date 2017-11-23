////####################################################################
////# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
////#
////# History:
////#     Date Time       Created         Comment
////#     21/07/2014      Hoàng Tú        Tạo mới
////####################################################################
//var ID = 'POSF0034';
//var URL_DELETE = '/POS/POSF0034/Delete';
//var popup = null;
//var POSF0034Grid = null;
//var FORM_ID = 'FormFilter';
//var isSearch = false;
////Hàm: khởi tạo các đối tượng trong javascript
//$(document).ready(function () {
//    POSF0034Grid = $('#POSF0034Grid').data('kendoGrid');
//});
////Sự kiện: Lọc
//function posf0034BtnFilter_Click() {
//    isSearch = true;
//    ASOFT.form.clearMessageBox();
//    refreshGrid();    
//}
//// Hàm: Gởi dữ liệu từ FormFilter
//function sendDataFilter() {
//    var datamaster = ASOFT.helper.dataFormToJSON('FormFilter');
//    datamaster['IsSearch'] = isSearch;
//    return datamaster;
//    return false;
//}
////Sự kiện:Xóa trắng các field lọc
//function posf0034BtnClearFilter_Click() {
//    isSearch = false;
//    ASOFT.form.clearMessageBox();
//    // Reset business combobox
//    var multiComboBox1 = $('#DivisionIDFilter').data('kendoDropDownList');
//    resetDropDown(multiComboBox1);
//    var multiComboBox2 = $('#ShopID').data('kendoDropDownList');
//    resetDropDown(multiComboBox2);
//    // Clear các field
//    $('#AreaID').val('');
//    $('#AreaName').val('');
//    refreshGrid();
//}
////Sự kiện: Thêm
//function ShowEditorFrame()
//{
//    ASOFT.form.clearMessageBox();
//    ASOFT.asoftPopup.showIframe('/POS/POSF0034/POSF0035', {});
//}
////Sự kiện: Xóa
//function btnDelete_Click() {
//    var args = [];
//    var data = {};
//    ASOFT.form.clearMessageBox();
//    if (POSF0034Grid) {
//        var records = ASOFT.asoftGrid.selectedRecords(POSF0034Grid);
//        if (records.length == 0)
//            return;
//        for (var i = 0; i < records.length; i++) {
//            args.push(records[i].AreaID);
//        }
//    }
//    //Bạn có muốn xóa không?
//    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
//    data['args'] = args;        
//        ASOFT.helper.postTypeJson(
//                    '/POS/POSF0034/DeleteMany',
//                    data,
//                    function (result) {
//                        ASOFT.helper.showErrorSeverOption(1, result, 'FormFilter', function () {
//                            refreshGrid();                       
//                        }, null, function () {
//                            refreshGrid();                          
//                        }, true);
//                    });
//    });
//}
////Sự kiện: Disable
//function btnDisable_Click() {
//    var args = [];
//    var data = {};
//    ASOFT.form.clearMessageBox();
//    if (POSF0034Grid) {
//        var records = ASOFT.asoftGrid.selectedRecords(POSF0034Grid);
//        if (records.length == 0)
//            return;
//        for (var i = 0; i < records.length; i++) {
//            args.push(records[i].AreaID);
//        }
//    }
//    data['args'] = args;
//    ASOFT.helper.postTypeJson(
//                    '/POS/POSF0034/Disabled',
//                    data,
//                    function (result) {
//                        ASOFT.helper.showErrorSeverOption(1, result, 'FormFilter', function () {
//                            refreshGrid();                           
//                        }, null, function () {
//                            refreshGrid();                            
//                        },false);
//                    });  
    
//}
////Sự kiện: Enable
//function btnEnable_Click() {
//    var args = [];
//    var data = {};
//    ASOFT.form.clearMessageBox();
//    if (POSF0034Grid) {
//        var records = ASOFT.asoftGrid.selectedRecords(POSF0034Grid);
//        if (records.length == 0)
//            return;
//        for (var i = 0; i < records.length; i++) {
//            args.push(records[i].AreaID);
//        }
//    }
//    data['args'] = args;  
//    ASOFT.helper.postTypeJson(
//                    '/POS/POSF0034/Enabled',
//                    data,
//                    function (result) {
//                        ASOFT.helper.showErrorSeverOption(1, result, 'FormFilter', function () {
//                            refreshGrid();                       
//                        }, null, function () {
//                            refreshGrid();                           
//                        }, false);
//                    });

//}
////Hàm: Làm mới lưới
//function refreshGrid() {
//    POSF0034Grid.dataSource.page(1);
//}
////Hàm: Đóng mặc định
//function popupClose() {

//    ASOFT.asoftPopup.hideIframe();

//}


//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Created         Comment
//#     21/07/2014      Hoàng Tú        Tạo mới
//####################################################################
var ID = 'POSF0034';
var URL_DELETE = '/POS/POSF0034/Delete';
var popup = null;
var POSF0034Grid = null;
var FORM_ID = 'FormFilter';
var isSearch = false;
//Hàm: khởi tạo các đối tượng trong javascript
$(document).ready(function () {
    POSF0034Grid = $('#POSF0034Grid').data('kendoGrid');
});
//Sự kiện: Lọc
function posf0034BtnFilter_Click() {
    isSearch = true;
    ASOFT.form.clearMessageBox();
    refreshGrid();
}
// Hàm: Gởi dữ liệu từ FormFilter
function sendDataFilter() {
    var datamaster = ASOFT.helper.dataFormToJSON('FormFilter');
    datamaster['IsSearch'] = isSearch;
    return datamaster;
    return false;
}
//Sự kiện:Xóa trắng các field lọc
function posf0034BtnClearFilter_Click() {
    isSearch = false;
    ASOFT.form.clearMessageBox();
    // Reset business combobox
    var multiComboBox1 = $('#DivisionIDFilter').data('kendoDropDownList');
    resetDropDown(multiComboBox1);
    var multiComboBox2 = $('#ShopID').data('kendoDropDownList');
    resetDropDown(multiComboBox2);
    // Clear các field
    $('#AreaID').val('');
    $('#AreaName').val('');
    refreshGrid();
}
//Sự kiện: Thêm
function ShowEditorFrame() {
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe('/POS/POSF0034/POSF0035', {});
}
//Sự kiện: Xóa
function btnDelete_Click() {
    var args = [];
    var data = {};
    ASOFT.form.clearMessageBox();
    if (POSF0034Grid) {
        var records = ASOFT.asoftGrid.selectedRecords(POSF0034Grid);
        if (records.length == 0)
            return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].AreaID);
        }
    }
    //Bạn có muốn xóa không?
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        data['args'] = args;
        ASOFT.helper.postTypeJson(
                    '/POS/POSF0034/DeleteMany',
                    data,
                    function (result) {
                        ASOFT.helper.showErrorSeverOption(1, result, 'FormFilter', function () {
                            refreshGrid();
                        }, null, function () {
                            refreshGrid();
                        }, true);
                    });
    });
}
//Sự kiện: Disable
function btnDisable_Click() {
    var args = [];
    var data = {};
    ASOFT.form.clearMessageBox();
    if (POSF0034Grid) {
        var records = ASOFT.asoftGrid.selectedRecords(POSF0034Grid);
        if (records.length == 0)
            return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].AreaID);
        }
    }
    data['args'] = args;
    ASOFT.helper.postTypeJson(
                    '/POS/POSF0034/Disabled',
                    data,
                    function (result) {
                        ASOFT.helper.showErrorSeverOption(1, result, 'FormFilter', function () {
                            refreshGrid();
                        }, null, function () {
                            refreshGrid();
                        }, false);
                    });

}
//Sự kiện: Enable
function btnEnable_Click() {
    var args = [];
    var data = {};
    ASOFT.form.clearMessageBox();
    if (POSF0034Grid) {
        var records = ASOFT.asoftGrid.selectedRecords(POSF0034Grid);
        if (records.length == 0)
            return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].AreaID);
        }
    }
    data['args'] = args;
    ASOFT.helper.postTypeJson(
                    '/POS/POSF0034/Enabled',
                    data,
                    function (result) {
                        ASOFT.helper.showErrorSeverOption(1, result, 'FormFilter', function () {
                            refreshGrid();
                        }, null, function () {
                            refreshGrid();
                        }, false);
                    });

}
//Hàm: Làm mới lưới
function refreshGrid() {
    POSF0034Grid.dataSource.page(1);
}
//Hàm: Đóng mặc định
function popupClose() {

    ASOFT.asoftPopup.hideIframe();

}

function btnPrint_Click() {
    var datamaster = sendDataFilter();
    ASOFT.helper.postTypeJson("/POS/POSF0034/DoPrintOrExport", datamaster, ExportSuccess);

}

function ExportSuccess(result) {
    if (result) {
        var urlPrint = '/POS/POSF0034/ReportViewer';
        var options = '&viewer=pdf';
        // Tạo path full
        var fullPath = urlPrint + "?id=" + result.apk + options;

        // Getfile hay in báo cáo
        window.open(fullPath, "_blank");
    }
}



