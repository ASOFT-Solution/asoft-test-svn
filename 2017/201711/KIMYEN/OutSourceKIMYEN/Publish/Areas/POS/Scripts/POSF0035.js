//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Created          Comment
//#     28/06/2014      Hoang Tu         tạo mới
//####################################################################
var ID = 'POSF0035';
var urlInsert = '/POS/POSF0034/Insert';
var urlUpdate = '/POS/POSF0034/Update';
var defaultViewModel = {};
var action = 0; // Action           1:SaveNext    2:SaveCopy     0: SaveClose
var Status = null; // Loai form:       0: true        1:false
this.gridMaster = null;
var popup = null;
var POSF0034Grid = null;
//Hàm: khởi tạo
$(document).ready(function () {
    refreshModel();
    POSF0034Grid = $('#POSF0034Grid').data('kendoGrid');
});
//Hàm:khởi tạo defaultViewModel là một đối tượng kiểu JSon
function refreshModel() {
    defaultViewModel = ASOFT.helper.dataFormToJSON(ID);
}
//Sự kiện: Đóng popup lúc thêm
function popupClose_Click(event) {
    if (isDataChanged()) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
            function () {             
                 checkDataSave();              
                   },
            function () {
                parent.popupClose();
            });
    }
    else {
        parent.popupClose();
    }
}
//Sự kiện : Đóng khi update
function popupClose_ClickA(event) {

    if (isDataChanged()) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
            function () {
                defaultViewModel = ASOFT.helper.dataFormToJSON(ID);                           
                checkDataUpdate();
                window.parent.location.reload();
                 },
            function () {
                parent.popupClose();
            });
    }
    else {
        parent.popupClose();
    }
}
//Sự kiện: Lưu và thêm mới
function posf0035SaveNew_Click() {

    action = 1;
    checkAndSave();
}
//Hàm: Kiểm tra lưu
function checkAndSave() {
    if (isDataChanged()) {
        //Thông báo bạn có muốn Lưu hay không? 
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'), checkDataSave
                                    );
    }
    else {
        checkDataSave();
    }
    
}
// Hàm: Insert
function insert() {
    var data = ASOFT.helper.dataFormToJSON(ID);
    // data.Disabled = ($("#Disabled").attr("checked") == 'checked');
    ASOFT.helper.postTypeJson(urlInsert, data, onInsertSuccess);
}
//Sự kiên: Lưu và copy
function posf0035SaveCopy_Click() {
    action = 2;
    checkAndSave();
}
// Kiểm tra dữ liệu trên form có bị thay đổi hay không
var isDataChanged = function () {
    var dataPost = getFormData();
    var equal = isRelativeEqual(dataPost, defaultViewModel);
    return !equal;
};
var getFormData = function () {
    var dataPost = ASOFT.helper.dataFormToJSON(ID);
    return dataPost;
};
var KENDO_INPUT_SUFFIX = '_input';
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
//Hàm: 
function formIsInvalid() {
    return ASOFT.form.checkRequiredAndInList(ID, []);
}
//Sự kiện: Update
function btnUpdate_Click() {
    action = 2;
    checkAndUpdate();
}
//Hàm: Kiểm tra update
function checkAndUpdate() {
    if (isDataChanged()) {
        //Thông báo bạn có muốn Lưu hay không? 
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'), checkDataUpdate
                                    );
    }
    else {
        checkDataUpdate();
    }
}
//Hàm: Kiểm tra dữ liệu update
function checkDataUpdate() {
    if (formIsInvalid()) {
        return;
    }
    update();
}
function checkDataSave()
{
    if (formIsInvalid())
    {
        return;
    }
    return insert();
}
// Hàm: Lưu thành công
function onInsertSuccess(result) {
    if (result.Status == 0) //Insert: true
    {
        defaultViewModel = ASOFT.helper.dataFormToJSON(ID);
        switch (action) {
            case 1://save new
                ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message));
                parent.POSF0034Grid.dataSource.page(1);
                clearFormPOSF0035();
                break;
            case 2://save copy
                ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message));
                parent.POSF0034Grid.dataSource.page(1);
                defaultViewModel = ASOFT.helper.dataFormToJSON('POSF0035');
                break;
            default:
                window.parent.posf0034BtnFilter_Click();
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
//Hàm: Update
function update() {
    var data = ASOFT.helper.dataFormToJSON(ID);
    data.ShopID = $("input[name='POSF0035ShopID']").val();
    data.DivisionID = $("input[name='POSF0035DivisionID']").val();
    data.Disabled = ($("#Disabled").attr("checked") == 'checked');
    ASOFT.helper.postTypeJson(urlUpdate, data, onUpdateSuccess);

}
//Hàm :Update thành công
function onUpdateSuccess(result)
{
    if (result.Status == 0) //Update: true
    {
        switch (action) {
            case 2:
                ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message));
                if (result.Data != null) {
                    $('#LastModifyDateValue').val(result.Data.LastModifyDateValue);
                }
                window.parent.location.reload();
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
//Hàm :Dọn trắng các textbox khi lưu và thêm mới
function clearFormPOSF0035() {
    $('#AreaID').val('');
    $('#AreaName').val('');
    $('#AreaNameE').val('');
    $('#Description').val('');
}
