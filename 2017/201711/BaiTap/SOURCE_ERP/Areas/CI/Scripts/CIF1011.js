
//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Created          Comment
//#     09/10/2014      Hoàng Tú        tạo mới
//####################################################################
var ID = 'CIF1011';
var urlInsert = '/CI/CIF1010/Insert';
var urlUpdate = '/CI/CIF1010/Update';
var defaultViewModel = {};
var action = 0;      // 1:SaveNext     2:SaveCopy   3:Update     0: SaveClose
var Status = null;   // Lưu trạng thái form từ server trả về: Status=0 : Lưu mới, lưu sao chép
var DivisionID = null;
var AccountID = null;
var DepartmentID = null;
var BranchID = null;
var CIF1010Grid = null;
//Hàm: Khởi tạo chung
$(document).ready(function () {
    refreshModel();
    CIF1010Grid = $('#CIF1010Grid').data('kendoGrid');
    AccountID = ASOFT.asoftComboBox.castName('AccountID');
    DepartmentID = ASOFT.asoftComboBox.castName('DepartmentID');
    //BranchID = ASOFT.asoftComboBox.castName('BranchID');
});
//Hàm:khởi tạo defaultViewModel là một đối tượng kiểu JSon
function refreshModel() {
    defaultViewModel = ASOFT.helper.dataFormToJSON(ID);
}
function combo_Changed(e) {
    ASOFT.form.checkItemInListFor(this, ID);
}
//Sự kiện: Lưu và thêm mới
function CIF1011btnSaveNew_Click(){
    action = 1;
    checkAndSave();
}
//Hàm : checkDataSave
function checkDataSave() {
    if (formIsInvalid()) {
        return;
    }
   insert();
}
// Hàm: Insert
function insert() {
    var data = ASOFT.helper.dataFormToJSON(ID);
    data.Disabled = ($("#Disabled").attr("checked") == 'checked');
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
                clearFormCIF1011();
                refreshModel();
                break;
            case 2://save copy
                ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message));
                refreshGrid();
                refreshModel();
                break;
            default:
                window.parent.CIF1010BtnFilter_Click();
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
//Sự kiện: Lưu sao chép
function CIF1011SaveCopy_Click() {
    action = 2;
    checkAndSave();

}
function CIF1011btnUpdate_Click(){
    action = 3;
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
function popupClose_ClickA() {

    if (!ASOFT.form.formClosing('CIF1011')) {
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
//Hàm: Làm mới lưới
function refreshGrid() {
    parent.CIF1010Grid.dataSource.page(1);
}
// Kiểm tra dữ liệu trên form có bị thay đổi hay không
var isDataChanged = function () {
    var dataPost = getFormData();
    var equal = isRelativeEqual(dataPost, defaultViewModel);
    return !equal;
};
//Hàm: getFormData:
var getFormData = function () {
    var dataPost = ASOFT.helper.dataFormToJSON(ID);
    return dataPost;
};
// Kiểm tra bằng nhau giữa hai trạng thái của form
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
//Hàm:      formInvalid
function formIsInvalid() {
    return ASOFT.form.checkRequiredAndInList(ID, ['DepartmentID']);//,'BranchID']);
}
//Hàm: Update
function update() {
    var data = ASOFT.helper.dataFormToJSON(ID);   
    data.Disabled = ($("#Disabled").attr("checked") == 'checked');
    data.IsCommon = ($("#IsCommon").attr("checked") == 'checked');
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
function clearFormCIF1011() {
    $('#TeamID').val('');
    $('#TeamName').val('');
    $('#Notes').val('');
    $('#Notes01').val('');
    $("#Disabled").removeAttr("checked");
    $("#IsCommon").removeAttr("checked");
    $('#DepartmentName').val('');
    var comboboxDepartmentID = $("#DepartmentID").data("kendoComboBox");
    comboboxDepartmentID.value('');
    var comboboxBranchID = $("#BranchID").data("kendoComboBox");
    comboboxBranchID.value('');
}
// Hiển Thị DivisionName theo DivisionID
function divisionID_Change(e) {
    ASOFT.asoftComboBox.dataBound(e);
    var item = this.dataItem(this.selectedIndex);
    if (item == null) {
        return;
    }
    $('#DivisionName').val(item.DivisionName);
}
// Hiển Thị DepartmentName theo DepartmentID 
function derpartmentID_Change(e) {
    ASOFT.asoftComboBox.dataBound(e);
    var item = this.dataItem(this.selectedIndex);
    if (item == null) {
        return;
    }
    $('#DepartmentName').val(item.DepartmentName);
}
// Hiển Thị AccountName theo AccountID
function accountID_Change(e) {
    ASOFT.asoftComboBox.dataBound(e);
    var item = this.dataItem(this.selectedIndex);
    if (item == null) {
        return;
    }   
    $('#AccountName').val(item.AccountName);
}

