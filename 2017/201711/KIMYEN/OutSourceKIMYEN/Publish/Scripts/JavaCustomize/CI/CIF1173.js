var GridAT1312 = null;
var accountID = null;
var groupID = null;
var actionCustom = null;
$(document).ready(function () {
    $("#BtnSave").unbind();
    $("#BtnSave").kendoButton({
        "click": CustomSave_Click
    });

    GridAT1312 = $("#GridEditAT1312").data("kendoGrid");
    //GridAT1312.hideColumn("APK");

    $(GridAT1312.tbody).on("change", "td", function (e) {
        var column = e.target.id;
        var selectitem = GridAT1312.dataItem(GridAT1312.select());

        if (column == "cbbAccountID")
        {
            GetCombobox(e.target.value, "AccountID", accountID, selectitem);
        }
        if (column == "cbbGroupID") {
            GetCombobox(e.target.value, "GroupID", groupID, selectitem);
            selectitem.set("AccountID", "");
            selectitem.set("AccountName", "");
            accountID = null;
        }
    })

    $(GridAT1312.tbody).on("focusin", "td", function (e) {
        var column = e.target.name;
        if (column.indexOf("AccountID") != -1) {
            var selectitem = GridAT1312.dataItem(GridAT1312.select());
            if (selectitem.AccountID == "") {
                //$("#cbbAccountID").data("kendoComboBox").value('');
                $("#cbbAccountID").data("kendoComboBox").selectedIndex = -1;
            }
        }
    })
})

function GetCombobox(data, column, ana, selectitem) {
    if (data != "" && data != undefined) {
        selectitem.set(column, data);
        if (column == "AccountID") {
            var accountName = $("#cbb" + column).data("kendoComboBox").text();
            selectitem.set("AccountName", accountName);
        }
    }
    else {
        selectitem.set(column, ana);
    }
}

function Grid_SaveCustom(e) {
    if (e.values == undefined || e.values == null) {
        return true;
    }
    if (e.values.AccountID == "") {
        accountID = e.model.AccountID;
    }
    if (e.values.GroupID == "") {
        groupID = e.model.GroupID;
    }   
}

function CustomSave_Click() {
    actionCustom = 3;
    var data = ASOFT.helper.dataFormToJSON("CIF1173");
    var datagrid;
    var key = [];
    var value = [];

    if (isInvalid(data)) {
        return false;
    }

    if (isInlistGrid(data)) {
        return false;
    }

    datagrid = getListDetailCustom();

    ASOFT.helper.postTypeJson("/CI/CIF1170/Update", datagrid, onInsertSuccessCustom);
}

function onInsertSuccessCustom(result) {

    if (result.Status == 0) {
        switch (actionCustom) {
            case 1://save new                
                ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
                //
                refreshModel();
                clearfields();
                break;
            case 2://save copy
                ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
                refreshModel();
                //refreshModel();
                break;
            case 3:
                ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
                refreshModel();
                window.parent.location.reload();

                //refreshModel();
            case 4:
                updateSuccess = 1;
                ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
                break;
        }
    }
    else {
        updateSuccess = 0;
        if (result.Message != 'Validation') {
            var msg = ASOFT.helper.getMessage(result.Message);
            if (result.Data) {
                msg = kendo.format(msg, result.Data);
            }
            ASOFT.form.displayWarning('#' + id, msg);
        }
        else {
            var msgData = new Array();
            $.each(result.Data, function (index, value) {
                var child = value.split(',');
                var msg = ASOFT.helper.getMessage(child[0]);
                msg = kendo.format(msg, child[1], child[2], child[3], child[4]);
                msgData.push(msg);
            });
            ASOFT.form.displayMultiMessageBox(id, 1, msgData);
        }
    }
}


function getDetailCustom() {
    var dataPost = ASOFT.helper.dataFormToJSON(id);
    dataPost.Detail = GridAT1312.dataSource._data;
    dataPost.IsDataChanged = GridAT1312.dataSource.hasChanges()
    return dataPost;
}

function getListDetailCustom() {
    var data = [];
    var dt = getDetailCustom().Detail;
    for (i = 0; i < dt.length; i++) {
        dt[i]["InventoryID"] = $("#InventoryID").val();
        dt[i]["DivisionID"] = parent.getDivisionID();
        data.push(dt[i]);
    }
    return data;
}
