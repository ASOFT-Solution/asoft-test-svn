
//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Created          Comment
//#     09/10/2014      Hoàng Tú        tạo mới
//####################################################################
var ID = 'SF1001';
var urlInsert = '/S/SF1000/Insert';
var urlUpdate = '/S/SF1000/Update';
var defaultViewModel = {};
var action = 0;      // 1:SaveNext     2:SaveCopy   3:Update     0: SaveClose
var Status = null;   // Lưu trạng thái form từ server trả về: Status=0 : Lưu mới, lưu sao chép
var SF1000Grid = null;
var DepartmentID = null;
var fileUploaded = {};

//Hàm: khởi tạo
$(document).ready(function () {
    refreshModel();
    SF1000Grid = $('#SF1000Grid').data('kendoGrid');
    DepartmentID = ASOFT.asoftComboBox.castName('DepartmentID');
});

//Hàm:khởi tạo defaultViewModel là một đối tượng kiểu JSon
//Khởi tạo model này cho TH nút đóng lúc thêm mới
function refreshModel() {
    defaultViewModel = ASOFT.helper.dataFormToJSON(ID);
}
//Hàm: Làm mới lưới
//Chú ý: Lưới này là lưới phân trang
function refreshGrid() {
    parent.SF1000Grid.dataSource.page(1);
}
//Sự kiện: Lưu và thêm mới
function SF1001SaveNew_Click() {
    action = 1;
    checkAndSave();
}
//Hàm: checkDataSave
function checkDataSave() {
    if (formIsInvalid()) {
        return;
    }
    insert();
}
// Hàm: Insert
function insert() {

    var data = ASOFT.helper.dataFormToJSON(ID);
    data.Signature = $("#editor").data("kendoEditor").value();
    data.IsCommon = ($("#IsCommon").is(':checked'));
    ASOFT.helper.postTypeJson(urlInsert, data, onInsertSuccess);
}
// Hàm: Lưu thành công
function onInsertSuccess(result) {
    if (result.Status == 0) {
        switch (action) {
            case 1://save new
                ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message));
                refreshGrid();
                clearFormSF1001();
                refreshModel();
                break;
            case 2://save copy
                ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message));
                refreshGrid();
                refreshModel();
                break;
            case 0://save close, Lưu xong và đóng lại  
                window.parent.SF1000BtnFilter_Click();
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
    data.EmployeeID = $('#EmployeeID').val();
    data.Signature = $("#editor").data("kendoEditor").value();
    data.Disabled = ($("#Disabled").is(':checked'));
    data.IsCommon = ($("#IsCommon").is(':checked'));
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
//Hàm: Kiểm tra lưu
function checkAndSave() {
    checkDataSave();
}
//Sự kiện: Lưu sao chép
function SF1001SaveCopy_Click() {
    action = 2;
    checkAndSave();
}
//Sự kiện: Update
function SF1001btnUpdate_Click() {
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
//Sự kiện : Đóng lúc Update
function popupClose_ClickA(event) {
    if (!ASOFT.form.formClosing('SF1001')) {
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
//Sự kiện: Đóng popup lúc thêm,thêm mới
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
//Hàm: Kiểm tra mà phòng ban có trong ComboBox hiện tại không? 
function formIsInvalid() {
    return ASOFT.form.checkRequiredAndInList(ID, ['DepartmentID']);
}
function combo_Changed() {
    ASOFT.form.checkItemInListFor(this, ID);
}
//Hàm: Hiển Thị DepartmentName theo DepartmentID
//Sử dụng: Khi bound cho textbox bên cạnh
function derpartmentID_Change(e) {
    ASOFT.asoftComboBox.dataBound(e);
    var item = this.dataItem(this.selectedIndex);
    if (item == null) {
        return;
    }
    $('#DepartmentName').val(item.DepartmentName);
}
//Hàm :Dọn trắng các textbox khi lưu và thêm mới
function clearFormSF1001() {
    $('#EmployeeID').val('');
    $('#FullName').val('');
    $('#PassWord').val('');
    $('#RePassWord').val('');
    var comboboxDepartmentID = $("#DepartmentID").data("kendoComboBox");
    comboboxDepartmentID.value('');
    $('#DepartmentName').val('');
    $('#Address').val('');
    $('#Phone').val('');
    $('#Tel').val('');
    $('#Email').val('');
    $('#Fax').val('');
    $("#Disabled").removeAttr("checked");
    $("#IsCommon").removeAttr("checked");
    $("#editor").data("kendoEditor").value('');
}

function OpenAdd(Src) {
    var urlAdd;
    var idElm;
    if (Src == "CIF1001") {
        urlAdd = "/CI/CIF1000/" + Src;
        idElm = "DepartmentID"
    }
    if (Src == "CIF1021") {
        urlAdd = "/CI/CIF1020/" + Src;
        idElm = "DutyID"
    }
    if (Src = "CIF1211") {
        urlAdd = "/Popuplayout/Index/CI/" + Src;
        idElm = "CountryID"
    }

    localStorage.setItem("IDCommbox", idElm);

    ASOFT.asoftPopup.showIframe(urlAdd, {});
}

function AddValueCombobox() {
    if (localStorage.getItem("IDCommbox") != null) {
        if (localStorage.getItem("IDCommbox") == "CountryID") {
            $("#Nationality").data("kendoComboBox").dataSource.read();
            $("#Nationality").data("kendoComboBox").value(localStorage.getItem("ValueCombobox"));
        }
        else {
            $("#" + localStorage.getItem("IDCommbox")).data("kendoComboBox").dataSource.read();
            $("#" + localStorage.getItem("IDCommbox")).data("kendoComboBox").value(localStorage.getItem("ValueCombobox"));
        }
    }
}

function popupClose() {
    localStorage.removeItem("IDCommbox");
    localStorage.removeItem("ValueCombobox");
    ASOFT.asoftPopup.hideIframe();
}


function onImageSuccess(data) {
    //if (data && data.response.counter > 0) {

    //    DRF1001.fieldName = data.response.array[0];
    //}
    var url = '/S/SF1000/Avatar?id=' + data.response.ImageLogo;
    $('#SF1001 img').attr('src', url);
    $("#SF1001 .k-progress").css("top", "50px");
}


function onImageUpload(data) {
    if (fileUploaded[data.sender.element[0].id] == undefined)
        fileUploaded[data.sender.element[0].id] = 0;

    if (fileUploaded[data.sender.element[0].id] > 0) {
        $('.k-upload-files .k-file:first').remove();
    }

    fileUploaded[data.sender.element[0].id] = fileUploaded[data.sender.element[0].id] + 1;
}

function btnDeleteImages_Click(e) {
    ASOFT.helper.postTypeJson("/S/SF1000//DeleteImages", {}, function () {
        $($("#SF1001").find('td img')).attr("src", "/Content/Images/noimages.png")
    });
}

