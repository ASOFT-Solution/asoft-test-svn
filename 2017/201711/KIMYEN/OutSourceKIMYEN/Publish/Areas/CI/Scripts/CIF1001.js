﻿
//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Created          Comment
//#     13/10/2014      Hoàng Tú        tạo mới
//####################################################################
var ID = 'CIF1001';
var urlInsert = '/CI/CIF1000/Insert';
var urlUpdate = '/CI/CIF1000/Update';
var defaultViewModel = {};
var action = 0;      // 1:SaveNext     2:SaveCopy   3:Update     0: SaveClose
var Status = null;   // Lưu trạng thái form từ server trả về: Status=0 : Lưu mới, lưu sao chép
var DivisionID = null;
var AccountID = null;
var CIF1000Grid = null;

//Hàm: khởi tạo
$(document).ready(function () {
    refreshModel();
    CIF1000Grid = $('#CIF1000Grid').data('kendoGrid');
    AccountID =  ASOFT.asoftComboBox.castName('AccountID');
});
//Hàm:khởi tạo defaultViewModel là một đối tượng kiểu JSon
function refreshModel() {
    defaultViewModel = ASOFT.helper.dataFormToJSON(ID);
}
function combo_Changed(e) {
    ASOFT.form.checkItemInListFor(this, ID);
}
//Sự kiện: Lưu và thêm mới
function CIF1001SaveNew_Click(){
    action = 1;
    checkAndSave();
}
function checkDataSave() {
    if (formIsInvalid()) {
        return;
    }   
    insert();
}
// Hàm: Insert
function insert() {
    var data = ASOFT.helper.dataFormToJSON(ID);
    data.IsCommon = $("#IsCommon").is(":checked");
    data.Disabled = $("#Disabled").is(":checked");
    data.IsOrganizationDiagram = $("#IsOrganizationDiagram").is(":checked");
    ASOFT.helper.postTypeJson(urlInsert, data, onInsertSuccess);
}
// Hàm: Lưu thành công
function onInsertSuccess(result) {
    if (result.Status == 0) //Insert: true
    {
        switch (action) {
            case 1://save new
                ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message));
                refreshGrid();
                clearFormCIF1001();
                refreshModel();
                break;
            case 2://save copy
                ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message));
                refreshGrid();
                refreshModel();
                break;
            default:
                window.parent.CIF1000BtnFilter_Click();
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
//Hàm: Kiểm tra lưu
function checkAndSave() {
    checkDataSave();
}
function CIF1001SaveCopy_Click(){
    action = 2;
    checkAndSave();
}
function CIF1001btnUpdate_Click()
{    action = 3;
    checkAndUpdate();
}
//Hàm: Kiểm tra update
function checkAndUpdate() {
    checkDataUpdate();
}
//Hàm: Kiểm tra dữ liệu update
function checkDataUpdate() {
    if (formIsInvalid()) {
        return;
    }   
    update();
}
//Sự kiện đóng: Update
function popupClose_ClickA(){

    if (!ASOFT.form.formClosing('CIF1001')) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
            function () {
                checkDataUpdate();
            },
            function () {
                parent.popupClose();
            });
    }
    else {
        parent.popupClose();
    }
}
//Hàm: Làm mới lưới
function refreshGrid() {
    parent.CIF1000Grid.dataSource.page(1);
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
//Hàm:  formIsvalid
function formIsInvalid() {
    return ASOFT.form.checkRequiredAndInList(ID, ['ContactPerson']);
}
//Hàm: Update
function update() {
    var data = ASOFT.helper.dataFormToJSON(ID);
    data.IsCommon = $("#IsCommon").is(":checked");
    data.Disabled = $("#Disabled").is(":checked");
    data.IsOrganizationDiagram = $("#IsOrganizationDiagram").is(":checked");
    ASOFT.helper.postTypeJson(urlUpdate, data, onUpdateSuccess);
}
//Hàm :Update thành công
function onUpdateSuccess(result) {
    if (action == 3) //Update khi bấm Save
    {
        ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message));
        if (result.Data != null) {
            $('#LastModifyDateValue').val(result.Data.LastModifyDateValue);
        }
        window.parent.location.reload();
    } else if (action == 0)  //Update khi nhập dữ liệu, bấm Close, chọn Yes
    {

        ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message));
        if (result.Data != null) {
            $('#LastModifyDateValue').val(result.Data.LastModifyDateValue);
        }
        window.parent.location.reload();
    }
}
//Hàm :Dọn trắng các textbox khi lưu và thêm mới
function clearFormCIF1001() {
    $('#DepartmentID').val('');
    $('#DepartmentName').val('');
    var comboboxAccountID = $("#AccountID").data("kendoComboBox");
    comboboxAccountID.value('');
    $("#Disabled").removeAttr("checked");
    $("#IsCommon").removeAttr("checked");
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
function divisionID_Change(e) {
    ASOFT.asoftComboBox.dataBound(e);
    var item = this.dataItem(this.selectedIndex);
    if (item == null) {
        return;
    }  
    $('#DivisionName').val(item.DivisionName);
} 
function accountID_Change(e) {
    ASOFT.asoftComboBox.dataBound(e);
    var item = this.dataItem(this.selectedIndex);
    if (item == null) {
        return;
    } 
    $('#AccountName').val(item.AccountName);
}