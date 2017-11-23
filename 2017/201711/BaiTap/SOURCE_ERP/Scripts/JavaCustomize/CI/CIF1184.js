var GridAT1326 = null;

function CustomRead() {
    var ct = [];
    ct.push($("#KITID").val());
    ct.push($("#InventoryID").val());
    return ct;
}

$(document).ready(function () {
    $(".line_left_with_grid .asf-table-view").prepend($(".InventoryID"));
    $("#BtnSave").unbind();
    $("#BtnSave").kendoButton({
        "click": CustomSave_Click
    });

    GridAT1326 = $("#GridEditAT1326").data("kendoGrid");

    GRID_AUTOCOMPLETE.config({
        gridName: 'GridEditAT1326',
        inputID: 'autocomplete-box',
        NameColumn: "ItemID",
        autoSuggest: false,
        serverFilter: true,
        setDataItem: function (selectedRowItem, dataItem) {
            selectedRowItem.model.set("ItemID", dataItem.ItemID);
            selectedRowItem.model.set("ItemName", dataItem.ItemName);
            selectedRowItem.model.set("ItemUnitID", dataItem.ItemUnitID);
            selectedRowItem.model.set("ItemQuantity", dataItem.ItemQuantity);
        }
    });
})

function CustomSave_Click() {
    actionCustom = 3;
    var data = ASOFT.helper.dataFormToJSON("CIF1184");
    var datagrid;
    var key = [];
    var value = [];

    $(GridAT1326.tbody).find('td').removeClass('asf-focus-input-error');

    if (isInvalid(data)) {
        return false;
    }

    if (isInlistGrid(data)) {
        return false;
    }

    if (!checkExist())
    {
        var message = [];
        message.push(ASOFT.helper.getMessage('POSFML000001'));
        ASOFT.form.displayMessageBox("form#CIF1184", message);
        return false;
    }

    datagrid = getListDetailCustom();
    ASOFT.helper.postTypeJson("/CI/CIF1180/UpdateCIF1184", datagrid, onInsertSuccessCustom);
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
    var dataPost = ASOFT.helper.dataFormToJSON("CIF1175");
    dataPost.Detail = GridAT1326.dataSource._data;
    dataPost.IsDataChanged = GridAT1326.dataSource.hasChanges()
    return dataPost;
}

function getListDetailCustom() {
    var data = [];
    var dt = getDetailCustom().Detail;
    for (i = 0; i < dt.length; i++) {
        dt[i]["InventoryID"] = $("#InventoryID").val();
        dt[i]["KITID"] = $("#KITID").val();
        data.push(dt[i]);
    }
    return data;
}

function checkExist() {
    var check = true;
    var wrapper = GridAT1326.wrapper;
    for(var i = 0; i < GridAT1326._data.length; i ++)
    {
        var tr = $(wrapper.find("tbody")).find("tr")[i];
        for (var j = 0; j < GridAT1326._data.length; j++)
        {
            if (i != j)
            {
                if (GridAT1326._data[i].ItemID == GridAT1326._data[j].ItemID)
                {
                    $($(tr).find("td")).addClass('asf-focus-input-error');
                    check = false;
                    break;
                }
            }
        }
    }
    return check;
}
