//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Created         Comment
//#     21/10/2014      Hoàng Tú        Tạo mới
//####################################################################
var SF0002Grid1 = null;
var SF0002Grid2 = null;
var rowNumber1 = 0;
var rowNumber2 = 0;
var action = 0;
var userID = null;
var userName = null;
var ID = 'SF0002';
var defaultViewModel = {};
var KENDO_INPUT_SUFFIX = '_input';
var AdminUserID = null;


//Hàm: Khởi tạo các đối tượng
$(document).ready(function () {
    //Khởi tạo lưới bên trái và lưới bên phải
    SF0002Grid1 = $("#SF0002Grid1").data("kendoGrid");
    SF0002Grid2 = $("#SF0002Grid2").data("kendoGrid");
    //Khởi tạo defaultViewModel: Lấy data mặc định của form
    defaultViewModel = ASOFT.helper.dataFormToJSON(ID);
    //Thông báo lỗi theo tên khi nhập không đúng cho combobox
    AdminUserID = ASOFT.asoftComboBox.castName('AdminUserID'); 
    //Bind dữ liệu cho lưới bên phải
    SF0002Grid2.bind('dataBound', function (e) {
        if (typeof SF0002Grid2.dataSource.data()[0] !== 'undefined') {
            $('#Notes').val(SF0002Grid2.dataSource.data()[0].Notes);
        }
    }); 
});
function filterNewTable() {
    var data = {
        divisionID: 'DivisionID'
    };
    return data;
}
//Hàm: Post dữ liệu từ lưới bên trái lên server
function sendDataPost1() {
    var data = ASOFT.helper.dataFormToJSON(ID);
    return data;
}
//Hàm: Post dữ liệu từ lưới bên phải lên server
function sendDataPost2() {
    var data = ASOFT.helper.dataFormToJSON(ID);
    return data;
}
//Hàm: Bind dữ liệu từ UserID sang UserName
function userID_Change(e) {
    //Kiểm tra mã người dùng có trong danh sách hay không
    var checkIs = ASOFT.form.checkItemInListFor(this, ID);
    ASOFT.asoftComboBox.dataBound(e);
        var item = this.dataItem(this.selectedIndex);
        if (item == null) {
            return;
        }
        $('#UserName').val(item.UserName);
    if (checkIs) {
        e.sender.focus();
        SF0002Grid2.dataSource.read();
        SF0002Grid1.dataSource.read();
    }
}
//Hàm: Thêm một phần tử sang lưới khác
function addItemToDataSource(newItem, ds) {
    ds.add($.extend({}, newItem));
}
//Sự kiện: Chuyển sang 1 dòng
function changeSingle() {
    var ds = SF0002Grid1.dataSource;
    var ds2 = SF0002Grid2.dataSource;
    SF0002Grid1.select().each(function () {
        var _item = SF0002Grid1.dataItem($(this));
        addItemToDataSource(_item, ds2);
        ds.remove(_item);
        return;
    });
}
//Sự kiện: Chuyển về 1 dòng
function returnSingle() {
    var ds = SF0002Grid1.dataSource;
    var ds2 = SF0002Grid2.dataSource;
    SF0002Grid2.select().each(function () {
        var _item = SF0002Grid2.dataItem($(this));
        ds2.remove(_item);
        addItemToDataSource(_item, ds);
        return;
    });
}
//Chuyển tất cả các dòng sang
function ChangeAll() {
    var data = SF0002Grid1.dataSource.data();
    var data2 = SF0002Grid2.dataSource.data();
    var totalNumber = data.length;
    var totalNumber2 = data2.length;
    for (var i = 0; i < totalNumber ;) {
        var currentDataItem = data[i];
        SF0002Grid2.dataSource.add(currentDataItem);
        SF0002Grid1.dataSource.remove(currentDataItem);
        --totalNumber;
    }
}
//Chuyển về tất cả:
function ReturnAll() {
    var data = SF0002Grid1.dataSource.data();
    var data2 = SF0002Grid2.dataSource.data();
    var totalNumber = data.length;
    var totalNumber2 = data2.length;
    for (var i = 0; i < totalNumber2 ;) {
        var currentDataItem = data2[i];
        SF0002Grid1.dataSource.add(currentDataItem);
        SF0002Grid2.dataSource.remove(currentDataItem);
        --totalNumber2;
    }
}
//Hàm: Lưu thành công
function SaveSuccess(result) {
    if (result.Status == 0) //Insert: true
    {
        defaultViewModel = ASOFT.helper.dataFormToJSON(ID);
        switch (action) {
            case 1://save new
                ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message));
                defaultViewModel = ASOFT.helper.dataFormToJSON(ID);
            default:
                parent.popupClose();
        }
    }
    else {
        var msg = ASOFT.helper.getMessage(result.Message);
             if (result.Data) {
                                    msg = kendo.format(msg, result.Data);
                              }
        ASOFT.form.displayWarning('#' + ID, msg);
    }
}
//Hàm: checkDataSave
function checkDataSave() {
    if (formIsInvalid()) {
        return;
    }
    return insert();
}
//Hàm: formIsInvalid
function formIsInvalid() {
    return ASOFT.form.checkRequiredAndInList(ID, ['AdminUserID']);
}
//Sự kiện; Lưu
function SF0002Save_Click() {
    action = 1;
    checkDataSave();
}
//Hàm: Insert
function insert() {
    var data = ASOFT.helper.dataFormToJSON(ID);
    var url = $('#UrlInsert').val();
    data.List2 = SF0002Grid2.dataSource.data();
    ASOFT.helper.postTypeJson(url, data, SaveSuccess);
}
//Sự kiện: Đóng popup
function popupClose_Click(event) {
    if (isDataChanged()) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
            function () {
                SF0002Save_Click();
            },
            function () {
                ASOFT.asoftPopup.closeOnly();
            });
    }
    else {
        ASOFT.asoftPopup.closeOnly();
    }
}
// Kiểm tra dữ liệu trên form có bị thay đổi hay không: Kiểm tra dữ liệu tại form hiện tại vs dữ liệu form khởi tạo
var isDataChanged = function () {
    var dataPost = getFormData();
    var equal = isRelativeEqual(dataPost, defaultViewModel);
    return !equal;
};
//Hàm: getFormData
var getFormData = function () {
    var dataPost = ASOFT.helper.dataFormToJSON(ID);
    return dataPost;
};
// Kiểm tra bằng nhau giữa hai trạng thái của form
var isRelativeEqual = function (data1, data2) {
    if (data1 && data2
        && typeof data1 === "object"
        && typeof data2 === "object") {
        for (var prop in data1) {
            // So sánh thuộc tính của 2 data
            if (!data2.hasOwnProperty(prop)) {
                return false;
            }
            else {
                if (prop.indexOf(KENDO_INPUT_SUFFIX) != -1) {
                    continue;
                }
                // Nếu giá trị hai thuộc tính không bằng nhau, thì data có khác biệt
                if (data1[prop].valueOf() != data2[prop].valueOf()) {
                    return false;
                }
            }
        }
        return true;
    }
    return undefined;
};
