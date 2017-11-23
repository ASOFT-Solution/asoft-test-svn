var ID = 'SF1051';
var urlInsert = '/S/SF1050/Insert';
var urlUpdate = '/S/SF1050/Update';
var defaultViewModel = {};
var action = 0;      // 1:SaveNext     2:SaveCopy   3:Update     0: SaveClose
var Status = null;   // Lưu trạng thái form từ server trả về: Status=0 : Lưu mới, lưu sao chép
var SF1050Grid = null;
var SF1051Grid = null;
var rowNum = 0;

$(document).ready(function () {
    refreshModel();
    SF1051Grid = $('#SF1051Grid').data('kendoGrid');

    $(SF1051Grid.tbody).on("change", "td", function (e) {
        var column = e.target.id;
        var selectitem = SF1051Grid.dataItem($(e.target).parent().parent().parent().parent().parent());
        if (selectitem == null) {
            selectitem = SF1051Grid.dataItem($(e.target).parent().parent().parent());
        }
        var comboType = $("#TypeName").data("kendoComboBox");
        var dataType = comboType.dataItem(comboType.select());

        selectitem.set("TypeID", dataType.ID);
        selectitem.set("TypeName", dataType.Description);
    })
});

renderNumber = function () {
    return ++rowNum;
}

function gridSendDataEdit() {
    var datamaster = ASOFT.helper.dataFormToJSON(ID);
    return datamaster;
}

function refreshModel() {
    defaultViewModel = ASOFT.helper.dataFormToJSON(ID);
}

function refreshGrid() {
    parent.refreshGrid();
}

function SF1051SaveNew_Click() {
    action = 1;
    checkDataSave(urlInsert);
}

function SF1051SaveCopy_Click() {
    action = 2;
    checkDataSave(urlInsert);
}
//Sự kiện: Update
function SF1051btnUpdate_Click() {
    action = 3;
    checkDataSave(urlUpdate);

}

//Sự kiện : Đóng lúc Update
function popupClose_ClickA(event) {
    if (isDataChanged() || SF1051Grid.dataSource.hasChanges()) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
            function () {
                action = 0
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
    if (isDataChanged() || SF1051Grid.dataSource.hasChanges()) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
            function () {
                action = 0
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

function checkDataSave(url) {
    if (formIsInvalid()) {
        return;
    }

    if (SF1051Grid.dataSource.data().length <= 0) {
        $('#SF1051Grid').addClass('asf-focus-input-error');
        msg = ASOFT.helper.getMessage('00ML000061');
        ASOFT.form.displayError('#SF1051', msg);
        return;
    } else {
        if (ASOFT.asoftGrid.editGridValidate(SF1051Grid)) {
            msg = ASOFT.helper.getMessage('00ML000060');
            ASOFT.form.displayError('#SF1051', msg);
            return;
        }
    }

    insert(url);
}

function insert(url) {
    var combo = $("#ParentRoleID").data('kendoComboBox').dataItem($("#ParentRoleID").data('kendoComboBox').select());
    var data = ASOFT.helper.dataFormToJSON(ID);
    data.IsDefualtRoleID = $("#IsDefualtRoleID").is(':checked');
    data.ListData = SF1051Grid.dataSource._data;
    data.LevelRoleID = data.ParentRoleID != "" ? (combo.LevelParentRoleID + 1) : 1;
    data.RoleOld = defaultViewModel.RoleID;
    data.UpdateRoleID = defaultViewModel.RoleID != data.RoleID;
    ASOFT.helper.postTypeJson(url, data, onInsertSuccess);
}

function formIsInvalid() {
    return ASOFT.form.checkRequiredAndInList(ID, ['ParentRoleID']);
}

function clearFormSF1051() {
    rowNum = 0;
    $('#RoleName').val('');
    $('#RoleID').val('');
    $('#ParentRoleID').data("kendoComboBox").value('');
    $("#IsDefualtRoleID").removeAttr("checked");

    ASOFT.helper.postTypeJson('/S/SF1050/GetGridNew', { RoleID: $("#RoleID").val() }, function (result) {
        if (result.length > 0)
            SF1051Grid.dataSource.data(result);
        else
        {
            SF1051Grid.dataSource.data([]);
            SF1051Grid.addRow();
        }
    });
}


function onInsertSuccess(result) {
    if (result.Status == 0) {
        switch (action) {
            case 1://save new
                ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message));
                refreshGrid();
                $('#ParentRoleID').data('kendoComboBox').dataSource.read();
                clearFormSF1051();
                refreshModel();
                break;
            case 2://save copy
                ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message));
                $('#ParentRoleID').data('kendoComboBox').dataSource.read();
                refreshGrid();
                refreshModel();
                break;
            case 3://save copy
                ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message));
                window.parent.location.reload();
                break;
            case 0://save close, Lưu xong và đóng lại  
                window.parent.SF1050BtnFilter_Click();
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