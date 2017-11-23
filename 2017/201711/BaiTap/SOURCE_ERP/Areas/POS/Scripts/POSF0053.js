//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Created          Comment
//#     24/07/2014      Hoang Tu         tạo mới
//####################################################################
var ID ='POSF0053';
var urlInsert = '/POS/POSF0052/Insert';
var urlUpdate = '/POS/POSF0052/Update';
var defaultViewModel = {};
var action = 0;     // Action          1:SaveNext    2:SaveCopy     0: SaveClose
var Status = null; // Loai form:       0: true        1:false
var posViewModel = null;
var POSF0052Grid = null;
//Hàm: khởi tạo
$(document).ready(function ()
{
    refreshModel();
    POSF0052Grid = $('#POSF0052Grid').data('kendoGrid');
});
//Hàm: khởi tạo defaultViewModel là một đối tượng kiểu JSon
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
//Sự kiện đóng lúc sửa
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
//Sự kiện: Thêm mới
function posf0053SaveNew_Click() {
    action = 1;
    checkAndSave();
}
//Hàm: Kiểm tra lưu
function checkAndSave() {
    if (isDataChanged()) {
        //Thông báo bạn có muốn Lưu hay không? 
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'), checkDataSave
                                    );
    }
    else

    {
        checkDataSave();

    }
}
///Hàm: Kiểm tra dữ liệu lưu
function checkDataSave() {
    if (formIsInvalid()) {
        return;
    }
    return insert();
}
//Hàm: Insert
function insert() {
    var data = ASOFT.helper.dataFormToJSON(ID);
   // data.Disabled = ($("#Disabled").attr("checked") == 'checked');
    ASOFT.helper.postTypeJson(urlInsert, data, onInsertSuccess);
}
//Hàm: Lưu thành công
function onInsertSuccess(result)
{
    if (result.Status == 0)    //Insert: true
    {
        defaultViewModel = ASOFT.helper.dataFormToJSON(ID);
        switch (action)
        {
            case 1:
                ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message));
                parent.POSF0052Grid.dataSource.page(1);
                clearFormPOSF0053();
                break;
            case 2:
                ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message));
                parent.POSF0052Grid.dataSource.page(1);
                defaultViewModel = ASOFT.helper.dataFormToJSON('POSF0053');
                break;
            default:             
                window.parent.posf0052BtnFilter_Click();
                parent.popupClose();
        }
    }
    else
    {
        var msg = ASOFT.helper.getMessage(result.Message);
        if (result.Data) {
            msg = kendo.format(msg, result.Data);
        }
        ASOFT.form.displayWarning('#' + ID, msg);
    }
}
//Sự kiện: Lưu sao chép
function posf0053SaveCopy_Click() {
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
function formIsInvalid() {
    return ASOFT.form.checkRequiredAndInList('POSF0053', []);
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
//Hàm: kiểm tra dữ liệu update
function checkDataUpdate()
{
    if (formIsInvalid())
    {
        return;
    }
    update();
}
//Hàm: update
function update()
{
    var data = ASOFT.helper.dataFormToJSON(ID);
    data.ShopID = $("input[name='POSF0053ShopID']").val();
    data.DivisionID = $("input[name='POSF0053DivisionID']").val();
    data.Disabled = ($("#Disabled").attr("checked") == 'checked');   
    ASOFT.helper.postTypeJson(urlUpdate, data, onUpdateSuccess);
}
//Hàm: update thành công
function onUpdateSuccess(result) {
    switch (action) {
        case 2:
            ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message));
            if (result.Data != null) {
                $('#LastModifyDateValue').val(result.Data.LastModifyDateValue);
            }        
            window.parent.location.reload();
    }
}
//Hàm: dọn trắng các textbox khi lưu và thêm mới
function clearFormPOSF0053()
{  
    $('#AreaID').val('');
    $('#TableID').val('');
    $('#TableName').val('');
    $('#TableNameE').val('');
    $('#Description').val('');
    var comboboxAreaID = $("#AreaID").data("kendoComboBox");
    comboboxAreaID.value('');
}

