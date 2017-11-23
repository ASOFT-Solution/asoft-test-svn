var ID = 'SF1052';
var urlInsert = '/S/SF1052/InsertAndUpdate';
var defaultViewModel = {};
var action = 0;      // 1:SaveNext     2:SaveCopy   3:Update     0: SaveClose
var Status = null;   // Lưu trạng thái form từ server trả về: Status=0 : Lưu mới, lưu sao chép
var SF1052GridGroup = null;
var SF1052GridUser = null;
var rowNumGroup = 0;
var rowNumUser = 0;

$(document).ready(function () {
    refreshModel();
    SF1052GridUser = $('#SF1052UserGrid').data('kendoGrid');
    SF1052GridGroup = $('#SF1052GroupGrid').data('kendoGrid');

    $(SF1052GridUser.tbody).on("change", "td", function (e) {
        var column = e.target.id;
        var selectitem = SF1052GridUser.dataItem($(e.target).parent().parent().parent().parent().parent());
        if (selectitem == null) {
            selectitem = SF1052GridUser.dataItem($(e.target).parent().parent().parent());
        }
        var comboType = $("#RoleName").data("kendoComboBox");
        var dataType = comboType.dataItem(comboType.select());

        selectitem.set("RoleID", dataType.RoleID);
        selectitem.set("RoleName", dataType.RoleName);
    })

    $(SF1052GridGroup.tbody).on("change", "td", function (e) {
        var column = e.target.id;
        var selectitem = SF1052GridGroup.dataItem($(e.target).parent().parent().parent().parent().parent());
        if (selectitem == null) {
            selectitem = SF1052GridGroup.dataItem($(e.target).parent().parent().parent());
        }
        var comboType = $("#RoleName").data("kendoComboBox");
        var dataType = comboType.dataItem(comboType.select());

        selectitem.set("RoleID", dataType.RoleID);
        selectitem.set("RoleName", dataType.RoleName);
    })
});

renderNumberGroup = function () {
    return ++rowNumGroup;
}

renderNumberUser = function () {
    return ++rowNumUser;
}

function gridSendDataEditGroup() {
    var datamaster = ASOFT.helper.dataFormToJSON(ID);
    var data = {};
    data.DivisionID = datamaster.DivisionID;
    data.GroupID = datamaster.GroupID;
    data.GroupName = datamaster.GroupName;
    data.IsUserOrGroup = 0;
    return data;
}

function gridSendDataEditUser() {
    var datamaster = ASOFT.helper.dataFormToJSON(ID);
    var data = {};
    data.DivisionID = datamaster.DivisionID;
    data.UserID = datamaster.UserID;
    data.UserName = datamaster.UserName;
    data.IsUserOrGroup = 1;
    return data;
}

function SF1052GridGroup_Click() {
    var datamaster = ASOFT.helper.dataFormToJSON(ID);
    var data = {};
    data.DivisionID = datamaster.DivisionID;
    data.GroupID = datamaster.GroupID;
    data.GroupName = datamaster.GroupName;
    data.IsUserOrGroup = 0;

    ASOFT.helper.postTypeJson("/S/SF1052/GetGridDetail2", data, function (dtRead) {
        rowNumGroup = 0;
        SF1052GridGroup.dataSource.data([]);
        if (dtRead.length > 0) {
            SF1052GridGroup.dataSource.data(dtRead);
        }
    })
}

function SF1052GridUser_Click() {
    var datamaster = ASOFT.helper.dataFormToJSON(ID);
    var data = {};
    data.DivisionID = datamaster.DivisionID;
    data.UserID = datamaster.UserID;
    data.UserName = datamaster.UserName;
    data.IsUserOrGroup = 1;

    ASOFT.helper.postTypeJson("/S/SF1052/GetGridDetail2", data, function (dtRead) {
        rowNumUser = 0;
        SF1052GridUser.dataSource.data([]);
        if (dtRead.length > 0)
            SF1052GridUser.dataSource.data(dtRead);
    })
}

function SF1052GroupClearFilter_Click() {
    $("#GroupID").val('');
    $("#GroupName").val('');
    SF1052GridGroup_Click();
}


function SF1052UserClearFilter_Click() {
    $("#UserID").val('');
    $("#UserName").val('');
    SF1052GridUser_Click();
}



function refreshModel() {
    defaultViewModel = ASOFT.helper.dataFormToJSON(ID);
}

function SF1052btnUpdate_Click() {
    action = 1;
    checkDataSave(urlInsert);
}

function popupClose_Click(event) {
    if (isDataChanged() || SF1052GridUser.dataSource.hasChanges() || SF1052GridGroup.dataSource.hasChanges()) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
            function () {
                action = 0
                checkDataSave();
            },
            function () {
                ASOFT.asoftPopup.closeOnly();
            });
    }
    else {
        ASOFT.asoftPopup.closeOnly();
    }
}


function checkDataSave(url) {

    if (SF1052GridGroup.dataSource.data().length <= 0 || SF1052GridUser.dataSource.data().length <= 0) {
        $('#SF1052UserGrid').addClass('asf-focus-input-error');
        $('#SF1052GroupGrid').addClass('asf-focus-input-error');
        msg = ASOFT.helper.getMessage('00ML000061');
        ASOFT.form.displayError('#SF1052', msg);
        return;
    } else {
        if (ASOFT.asoftGrid.editGridValidate(SF1052GridGroup) || ASOFT.asoftGrid.editGridValidate(SF1052GridUser)) {
            msg = ASOFT.helper.getMessage('00ML000060');
            ASOFT.form.displayError('#SF1052', msg);
            return;
        }
    }

    insert(url);
}

function insert(url) {
    var data = {};
    data.ListGroup = SF1052GridGroup.dataSource._data;
    data.ListUser = SF1052GridUser.dataSource._data;
    ASOFT.helper.postTypeJson(url, data, onInsertSuccess);
}

function onInsertSuccess(result) {
    if (result.Status == 0) {
        switch (action) {
            case 1://save new
                ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message));
                refreshModel();
                break;
            case 0://save close, Lưu xong và đóng lại  
                ASOFT.asoftPopup.closeOnly();
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
