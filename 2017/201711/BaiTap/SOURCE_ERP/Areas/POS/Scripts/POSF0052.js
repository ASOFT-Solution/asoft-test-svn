////####################################################################
////# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
////#
////# History:
////#     Date Time       Created         Comment
////#     21/07/2014      Hoàng Tú        Tạo mới
////####################################################################
//var URL_DELETE = '/POS/POSF0052/Delete';
//var popup = null;
//var POSF0052Grid = null;
//var FORM_ID = 'FormFilter';
//var isSearch = false;
//var formStatus = null;
//var urlUpdate = null;
////Hàm: khởi tạo các đối tượng trong javascript
//$(document).ready(function () {
//    POSF0052Grid = $('#POSF0052Grid').data('kendoGrid');
//});
////Sự kiện: Lọc
//function posf0052BtnFilter_Click() {
//    isSearch = true;
//    ASOFT.form.clearMessageBox();
//    refreshGrid();
//}
//// Hàm: gởi dữ liệu từ FormFilter
//function sendDataFilter() {
//    var datamaster = ASOFT.helper.dataFormToJSON('FormFilter');
//    datamaster['IsSearch'] = isSearch;
//    return datamaster;
//}
////Sự kiện: Xóa trăng các field lọc
//function posf0052BtnClearFilter_Click() {
//    isSearch = false;
//    ASOFT.form.clearMessageBox();
//    var multiComboBox1 = $('#DivisionIDFilter').data('kendoDropDownList');
//    resetDropDown(multiComboBox1);
//    var multiComboBox2 = $('#ShopID').data('kendoDropDownList');
//    resetDropDown(multiComboBox2);   
//    var multiComboBox3= $('#AreaID').data('kendoDropDownList');
//    resetDropDown(multiComboBox3);
//    $('#TableName').val('');
//    $('#TableID').val('');
//    refreshGrid();
//}
////Sự kiện: Thêm mới
//function ShowEditorFrame() {
//    ASOFT.form.clearMessageBox();
//    ASOFT.asoftPopup.showIframe('/POS/POSF0052/POSF0053', {});
//}
////Sự kiện: Sửa
//function Detail_Click(e) {
//    formStatus = 2;
//    var data = {};
//    data['args'] = { 'TableID': $(e).text(), 'FormStatus': formStatus };
//    var url = "";
//    ASOFT.form.clearMessageBox();
//    ASOFT.asoftPopup.showIframe('/POS/POSF0052/POSF0053?FormStatus={0}&TableID={1}'
//    .format(formStatus, $(e).text()), data);
//    return false;
//}
////Sự kiện: Xóa
//function btnDelete_Click() {
//    var args = [];
//    var data = {};
//    ASOFT.form.clearMessageBox();
//    if (POSF0052Grid) {
//        var records = ASOFT.asoftGrid.selectedRecords(POSF0052Grid);
//        if (records.length == 0)
//            return;
//        for (var i = 0; i < records.length; i++) {
//            args.push(records[i].TableID);
//        }
//    }
//    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
//        data['args'] = args;        
//        ASOFT.helper.postTypeJson(
//                    '/POS/POSF0052/DeleteMany',
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
////Hàm: Làm mới lưới
//function refreshGrid() {
//    POSF0052Grid.dataSource.page(1);
//}
////Sự kiện: Disable
//function btnDisable_Click() {
//    var args = [];
//    var data = {};
//    ASOFT.form.clearMessageBox();

//    if (POSF0052Grid) {
//        var records = ASOFT.asoftGrid.selectedRecords(POSF0052Grid);
//        if (records.length == 0)
//            return;
//        for (var i = 0; i < records.length; i++) {
//            args.push(records[i].TableID);
//        }
//    }
//    data['args'] = args;    
//    ASOFT.helper.postTypeJson(
//                    '/POS/POSF0052/Disabled',
//                    data,
//                    function (result) {
//                        ASOFT.helper.showErrorSeverOption(1, result, 'FormFilter', function () {
//                            refreshGrid();
                            
//                        }, null, function () {
//                            refreshGrid();
                           
//                        }, false);
//                    });

//}
////Sự kiện Enable
//function btnEnable_Click() {
//    var args = [];
//    var data = {};
//    ASOFT.form.clearMessageBox();

//    if (POSF0052Grid) {
//        var records = ASOFT.asoftGrid.selectedRecords(POSF0052Grid);
//        if (records.length == 0)
//            return;
//        for (var i = 0; i < records.length; i++) {
//            args.push(records[i].TableID);
//        }
//    }
//    data['args'] = args;
//    ASOFT.helper.postTypeJson(
//                    '/POS/POSF0052/Enabled',
//                    data,
//                    function (result) {
//                        ASOFT.helper.showErrorSeverOption(1, result, 'FormFilter', function () {
//                            refreshGrid();
                        
//                        }, null, function () {
//                            refreshGrid();
                          
//                        }, false);
//                    });
//}
////Hàm: Đóng mặc định
//function popupClose()
//{
//    ASOFT.asoftPopup.hideIframe();
//}



//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Created         Comment
//#     21/07/2014      Hoàng Tú        Tạo mới
//####################################################################
var URL_DELETE = '/POS/POSF0052/Delete';
var popup = null;
var POSF0052Grid = null;
var FORM_ID = 'FormFilter';
var isSearch = false;
var formStatus = null;
var urlUpdate = null;
//Hàm: khởi tạo các đối tượng trong javascript
$(document).ready(function () {
    POSF0052Grid = $('#POSF0052Grid').data('kendoGrid');
});
//Sự kiện: Lọc
function posf0052BtnFilter_Click() {
    isSearch = true;
    ASOFT.form.clearMessageBox();
    refreshGrid();
}
// Hàm: gởi dữ liệu từ FormFilter
function sendDataFilter() {
    var datamaster = ASOFT.helper.dataFormToJSON('FormFilter');
    datamaster['IsSearch'] = isSearch;
    return datamaster;
}
//Sự kiện: Xóa trăng các field lọc
function posf0052BtnClearFilter_Click() {
    isSearch = false;
    ASOFT.form.clearMessageBox();
    var multiComboBox1 = $('#DivisionIDFilter').data('kendoDropDownList');
    resetDropDown(multiComboBox1);
    var multiComboBox2 = $('#ShopID').data('kendoDropDownList');
    resetDropDown(multiComboBox2);
    var multiComboBox3 = $('#AreaID').data('kendoDropDownList');
    resetDropDown(multiComboBox3);
    $('#TableName').val('');
    $('#TableID').val('');
    refreshGrid();
}
//Sự kiện: Thêm mới
function ShowEditorFrame() {
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe('/POS/POSF0052/POSF0053', {});
}
//Sự kiện: Sửa
function Detail_Click(e) {
    formStatus = 2;
    var data = {};
    data['args'] = { 'TableID': $(e).text(), 'FormStatus': formStatus };
    var url = "";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe('/POS/POSF0052/POSF0053?FormStatus={0}&TableID={1}'
    .format(formStatus, $(e).text()), data);
    return false;
}
//Sự kiện: Xóa
function btnDelete_Click() {
    var args = [];
    var data = {};
    ASOFT.form.clearMessageBox();
    if (POSF0052Grid) {
        var records = ASOFT.asoftGrid.selectedRecords(POSF0052Grid);
        if (records.length == 0)
            return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].TableID);
        }
    }
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        data['args'] = args;
        ASOFT.helper.postTypeJson(
                    '/POS/POSF0052/DeleteMany',
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
//Hàm: Làm mới lưới
function refreshGrid() {
    POSF0052Grid.dataSource.page(1);
}
//Sự kiện: Disable
function btnDisable_Click() {
    var args = [];
    var data = {};
    ASOFT.form.clearMessageBox();

    if (POSF0052Grid) {
        var records = ASOFT.asoftGrid.selectedRecords(POSF0052Grid);
        if (records.length == 0)
            return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].TableID);
        }
    }
    data['args'] = args;
    ASOFT.helper.postTypeJson(
                    '/POS/POSF0052/Disabled',
                    data,
                    function (result) {
                        ASOFT.helper.showErrorSeverOption(1, result, 'FormFilter', function () {
                            refreshGrid();

                        }, null, function () {
                            refreshGrid();

                        }, false);
                    });

}
//Sự kiện Enable
function btnEnable_Click() {
    var args = [];
    var data = {};
    ASOFT.form.clearMessageBox();

    if (POSF0052Grid) {
        var records = ASOFT.asoftGrid.selectedRecords(POSF0052Grid);
        if (records.length == 0)
            return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].TableID);
        }
    }
    data['args'] = args;
    ASOFT.helper.postTypeJson(
                    '/POS/POSF0052/Enabled',
                    data,
                    function (result) {
                        ASOFT.helper.showErrorSeverOption(1, result, 'FormFilter', function () {
                            refreshGrid();

                        }, null, function () {
                            refreshGrid();

                        }, false);
                    });
}
//Hàm: Đóng mặc định
function popupClose() {
    ASOFT.asoftPopup.hideIframe();
}


function btnPrint_Click() {
    var datamaster = sendDataFilter();
    ASOFT.helper.postTypeJson("/POS/POSF0052/DoPrintOrExport", datamaster, ExportSuccess);

}

function ExportSuccess(result) {
    if (result) {
        var urlPrint = '/POS/POSF0052/ReportViewer';
        var options = '&viewer=pdf';
        // Tạo path full
        var fullPath = urlPrint + "?id=" + result.apk + options;

        // Getfile hay in báo cáo
        window.open(fullPath, "_blank");
    }
}
