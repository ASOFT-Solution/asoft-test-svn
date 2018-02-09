var GridAT1338 = null;

function CustomRead() {
    var ct = [];
    ct.push($("#VoucherID").val());
    return ct;
}


$(document).ready(function () {
    $(".line_left_with_grid .asf-table-view").prepend($(".FromQuantity"));
    GridAT1338 = $("#GridEditAT1338").data("kendoGrid");

    if ($("#PromoteTypeID").val() == "1")
    {
        GridAT1338.hideColumn("PromotePercent");
    }
    if ($("#PromoteTypeID").val() == "2") {
        GridAT1338.hideColumn("PromoteQuantity");
    }

    //GridAT1338.bind('dataBound', function (e) {
    //    $("#GridEditAT1338").find('td').on("focusin", function (e) {
    //        var index = e.delegateTarget.cellIndex;
    //        var th = $($("#GridEditAT1338").find('th')[index]).attr("data-field");
    //        if ($("#PromoteTypeID").val() == "1" && th == "PromotePercent")
    //        {
    //            GridAT1338.closeCell();
    //        }
    //        if ($("#PromoteTypeID").val() == "2" && th == "PromoteQuantity") {
    //            GridAT1338.closeCell();
    //        }
    //    })
    //})

    $("#BtnSave").unbind();
    $("#BtnSave").kendoButton({
        "click": CustomSave_Click
    })

    GRID_AUTOCOMPLETE.config({
        gridName: 'GridEditAT1338',
        inputID: 'autocomplete-box',
        NameColumn: "PromoteInventoryID",
        autoSuggest: false,
        serverFilter: true,
        setDataItem: function (selectedRowItem, dataItem) {
            selectedRowItem.model.set("PromoteInventoryID", dataItem.PromoteInventoryID);
            selectedRowItem.model.set("PromoteInventoryName", dataItem.PromoteInventoryName);
        }
    });
})

function CustomSave_Click() {
    actionCustom = 3;
    var data = ASOFT.helper.dataFormToJSON("CIF1244");
    var datagrid;
    var key = [];
    var value = [];

    $(GridAT1338.tbody).find('td').removeClass('asf-focus-input-error');

    if (isInvalid(data)) {
        return false;
    }

    if (isInlistGrid(data)) {
        return false;
    }

    if (!checkExist()) {
        var message = [];
        message.push(ASOFT.helper.getMessage('POSFML000001'));
        ASOFT.form.displayMessageBox("form#CIF1244", message);
        return false;
    }

    datagrid = getListDetailCustom();
    ASOFT.helper.postTypeJson("/CI/CIF1244/UpdateCIF1244", datagrid, onInsertSuccessCustom);
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
    var dataPost = ASOFT.helper.dataFormToJSON("CIF1244");
    dataPost.Detail = GridAT1338.dataSource._data;
    dataPost.IsDataChanged = GridAT1338.dataSource.hasChanges()
    return dataPost;
}

function getListDetailCustom() {
    var data = [];
    var dt = getDetailCustom().Detail;
    for (i = 0; i < dt.length; i++) {
        dt[i]["InventoryID"] = $("#InventoryID").val();
        dt[i]["VoucherID"] = $("#VoucherID").val();
        dt[i]["DivisionID"] = parent.getDivisionID();
        data.push(dt[i]);
    }
    return data;
}


function checkExist() {
    var check = true;
    var wrapper = GridAT1338.wrapper;
    for (var i = 0; i < GridAT1338._data.length; i++) {
        var tr = $(wrapper.find("tbody")).find("tr")[i];
        for (var j = 0; j < GridAT1338._data.length; j++) {
            if (i != j) {
                if (GridAT1338._data[i].PromoteInventoryID == GridAT1338._data[j].PromoteInventoryID) {
                    $($(tr).find("td")).addClass('asf-focus-input-error');
                    check = false;
                    break;
                }
            }
        }
    }
    return check;
}

